package com.webank.cmdb.stateTransition;

import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import javax.persistence.EntityManager;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.google.common.base.Strings;
import com.webank.cmdb.constant.CmdbConstants;
import com.webank.cmdb.constant.InputType;
import com.webank.cmdb.constant.StateOperation;
import com.webank.cmdb.domain.AdmBasekeyCat;
import com.webank.cmdb.domain.AdmBasekeyCode;
import com.webank.cmdb.domain.AdmCiType;
import com.webank.cmdb.domain.AdmCiTypeAttr;
import com.webank.cmdb.domain.AdmStateTransition;
import com.webank.cmdb.dynamicEntity.DynamicEntityHolder;
import com.webank.cmdb.support.exception.InvalidArgumentException;
import com.webank.cmdb.support.exception.ServiceException;
import com.webank.cmdb.repository.AdmBasekeyCatRepository;
import com.webank.cmdb.repository.AdmBasekeyCodeRepository;
import com.webank.cmdb.repository.AdmCiTypeAttrRepository;
import com.webank.cmdb.repository.AdmCiTypeRepository;
import com.webank.cmdb.repository.AdmStateTransitionRepository;
import com.webank.cmdb.service.CiService;
import com.webank.cmdb.util.ClassUtils;

@Service
public class Engine {
    private static Logger logger = LoggerFactory.getLogger(Engine.class);

    @Autowired
    private AdmStateTransitionRepository stateTransitionRepository;
    @Autowired
    private AdmBasekeyCatRepository catRepository;
    @Autowired
    private AdmBasekeyCodeRepository codeRepository;
    @Autowired
    private AdmCiTypeRepository ciTypeRepository;
    @Autowired
    private AdmCiTypeAttrRepository ciTypeAttrRepository;
    @Autowired
    private CiService ciService;
    public Map<String, Object> process(EntityManager entityManager, int ciTypeId, String guid, String operation, Map<String, Object> ciData, DynamicEntityHolder entityHolder) {
        return process(entityManager, ciTypeId, guid, operation, ciData, entityHolder, null);
        
    }
    public Map<String, Object> process(EntityManager entityManager, int ciTypeId, String guid, String operation, Map<String, Object> ciData, DynamicEntityHolder entityHolder, Date date) {
        Optional<AdmCiType> optCiType = ciTypeRepository.findById(ciTypeId);
        if (!optCiType.isPresent()) {
            throw new InvalidArgumentException(String.format("The given Ci Type [%d] is not found.", ciTypeId));
        }

        DynamicEntityHolder ciHolder = null;
        if (!Strings.isNullOrEmpty(guid)) {
            ciHolder = ciService.getCiHolder(ciTypeId, guid);
        }

        validateOperation(operation);

        int catId = getCatId(ciTypeId);
        validateCat(ciTypeId, catId);

        boolean needProcess = shouldBeProcessed(operation, ciHolder);

        if (needProcess) {
            AdmStateTransition stateTransition = findStateTransition(ciHolder, operation, catId);

            Optional<AdmBasekeyCode> optActionCode = codeRepository.findById(stateTransition.getAction());
            if (!optActionCode.isPresent()) {
                throw new ServiceException(String.format("Can not find out corresponding action code [%s]", stateTransition.getAction()))
                .withErrorCode("3088", stateTransition.getAction());
            }

            Action action = ActionRegistry.getInstance().getAction(optActionCode.get().getCode());
            if (action == null) {
                throw new ServiceException(String.format("Can not find out corresponding action [%s].", optActionCode.get().getCode()))
                .withErrorCode("3089", optActionCode.get().getCode());
            }
            return action.perform(entityManager, ciTypeId, guid, stateTransition, ciData, entityHolder, date);
        } else {
            return ClassUtils.convertBeanToMap(ciHolder.getEntityObj(), ciHolder.getEntityMeta(), false);
        }
    }

    private boolean shouldBeProcessed(String operation, DynamicEntityHolder ciHolder) {
        if (StateOperation.Confirm.getCode().equals(operation)) {
            String fixedDate = (String) ciHolder.get("fixed_date");
            if (!Strings.isNullOrEmpty(fixedDate)) {
                return false;
            }
        }
        return true;
    }

    private AdmStateTransition findStateTransition(DynamicEntityHolder ciHolder, String operation, int catId) {
        AdmStateTransition stateTransition = null;
        if ("insert".equals(operation)) {
            List<AdmStateTransition> transitions = stateTransitionRepository.findByOperationCode_codeAndTargetStateCode_catId("insert", catId);
            if (transitions == null) {
                throw new ServiceException(String.format("There is not transition recode found [insert, catId:%s].", catId)).withErrorCode("3090", catId);
            } else if (transitions.size() != 1) {
                throw new ServiceException(String.format("There are more than 1 state transition recode found [insert, catId:%s].", catId))
                .withErrorCode("3091", catId);
            }
            stateTransition = transitions.get(0);
        } else {
            if(ciHolder == null) {
                throw new ServiceException("3092", "ciHolder should not be null.");
            }
            Integer stateId = (Integer) ciHolder.get("state");
            if (stateId == null) {
                throw new ServiceException(String.format("Can not find out state field for Ci [%s]", ciHolder.get(CmdbConstants.DEFAULT_FIELD_GUID)))
                .withErrorCode("3093", ciHolder.get(CmdbConstants.DEFAULT_FIELD_GUID));
            }

            String fixedDate = (String) ciHolder.get("fixed_date");
            List<AdmStateTransition> transitions = stateTransitionRepository.findTargetTransition(stateId, Strings.isNullOrEmpty(fixedDate) ? 0 : 1, operation);
            if (transitions == null || transitions.size() == 0) {
                Optional<AdmBasekeyCode> codeOpt = codeRepository.findById(stateId);
                throw new InvalidArgumentException(String.format("Can not find out state transition. [stateId:%d(%s),fixedDate:%s,operation:%s]", stateId, codeOpt.isPresent() ? codeOpt.get().getCode() : "", fixedDate, operation));
            } else if (transitions.size() != 1) {
                if ("discard".equals(operation)) {
                    Integer action = null;
                    for (AdmStateTransition transition : transitions) {
                        if (action == null) {
                            action = transition.getAction();
                        } else {
                            if (!action.equals(transition.getAction())) {
                                throw new ServiceException(String.format("Action is different for discard operation [stateId:%d,fixedDate:%s,operation:%s]", stateId, fixedDate, operation))
                                .withErrorCode("3094", stateId, fixedDate, operation);
                            }
                        }
                    }
                } else {
                    Optional<AdmBasekeyCode> codeOpt = codeRepository.findById(stateId);
                    throw new InvalidArgumentException(
                            String.format("There are more than 1 state transition recode found [stateId:%d(%s),fixedDate:%s,operation:%s]", stateId, codeOpt.isPresent() ? codeOpt.get().getCode() : "", fixedDate, operation));
                }
            }
            stateTransition = transitions.get(0);
        }
        return stateTransition;
    }

    private void validateCat(int ciTypeId, int catId) {
        Optional<AdmBasekeyCat> optCat = catRepository.findById(catId);
        if (!optCat.isPresent()) {
            throw new ServiceException(String.format("Can not find out corresponding state cat [%d] for Ci Type [%d].", catId, ciTypeId)).withErrorCode("3109", catId, ciTypeId);
        }
    }

    private int getCatId(int ciTypeId) {
        AdmCiTypeAttr stateAttr = ciTypeAttrRepository.findFirstByCiTypeIdAndPropertyName(ciTypeId, "state");
        if (stateAttr == null) {
            throw new ServiceException(String.format("Can not find out state attribute for CiType [%d]", ciTypeId))
            .withErrorCode("3095", ciTypeId);
        }
        if (!InputType.Droplist.equals(InputType.fromCode(stateAttr.getInputType()))) {
            throw new ServiceException(String.format("State attribute [%d] is not configured properly.", stateAttr.getIdAdmCiTypeAttr()))
            .withErrorCode("3096", stateAttr.getIdAdmCiTypeAttr());
        }

        int catId = stateAttr.getReferenceId();
        return catId;
    }

    private void validateOperation(String operation) {
        AdmBasekeyCode operationCode = codeRepository.findFirstByAdmBasekeyCat_catNameAndCode("state_transition_operation", operation);
        if (operationCode == null) {
            throw new InvalidArgumentException(String.format("Can not find out transition operation [%s].", operation));
        }
    }
}
