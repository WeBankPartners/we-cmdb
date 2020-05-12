package com.webank.cmdb.controller.ui.helper;

import com.google.common.collect.Lists;
import com.google.common.collect.Sets;
import com.webank.cmdb.config.log.OperationLogPointcut;
import com.webank.cmdb.constant.CmdbConstants;
import com.webank.cmdb.constant.InputType;
import com.webank.cmdb.domain.AdmMenu;
import com.webank.cmdb.domain.AdmRoleMenu;
import com.webank.cmdb.dto.*;
import com.webank.cmdb.exception.CmdbException;
import com.webank.cmdb.repository.AdmMenusRepository;
import com.webank.cmdb.repository.UserRepository;
import com.webank.cmdb.service.RoleCiTypeAccessCtrlService;
import com.webank.cmdb.service.StaticDtoService;
import com.webank.cmdb.util.BeanMapUtils;
import com.webank.cmdb.util.CmdbThreadLocal;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import static com.webank.cmdb.config.log.OperationLogPointcut.Operation.Modification;
import static com.webank.cmdb.controller.ui.helper.CollectionUtils.asMap;
import static com.webank.cmdb.dto.QueryRequest.defaultQueryObject;
import static java.util.stream.Collectors.toList;
import static org.apache.commons.collections4.CollectionUtils.isEmpty;
import static org.apache.commons.collections4.CollectionUtils.isNotEmpty;

@Service
@Slf4j
@Transactional
public class UIUserManagerService {

    private static final String CONSTANT_CREATION_PERMISSION = "creationPermission";
    private static final String CONSTANT_REMOVAL_PERMISSION = "removalPermission";
    private static final String CONSTANT_MODIFICATION_PERMISSION = "modificationPermission";
    private static final String CONSTANT_ENQUIRY_PERMISSION = "enquiryPermission";
    private static final String CONSTANT_GRANT_PERMISSION = "grantPermission";
    private static final String CONSTANT_EXECUTION_PERMISSION = "executionPermission";
    private static final String CONSTANT_ROLE_CI_TYPE_CTRL_ATTR_ID = "roleCiTypeCtrlAttrId";
    private static final String CONSTANT_CALLBACK_ID = "callbackId";

    @Autowired
    private AdmMenusRepository admMenusRepository;

    @Autowired
    private StaticDtoService staticDtoService;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private UIWrapperService uiWrapperService;

    @Autowired
    private RoleCiTypeAccessCtrlService roleCiTypeAccessCtrlService;


    public void deleteRole(int roleId) {
        List<UserDto> users = uiWrapperService.getUsersByRoleId(roleId);
        if (isNotEmpty(users))
            throw new CmdbException(String.format("Failed to delete role[%d] because it is used for User: %s", roleId, users.stream().map(UserDto::getUsername).collect(Collectors.joining(","))));
        List<String> menus = getMenuDtosByRoleId(roleId);
        if (isNotEmpty(menus))
            throw new CmdbException(String.format("Failed to delete role[%d] because it is used for Menu: %s", roleId, menus));
        List<RoleCiTypeDto> roleCiTypes = getRoleCiTypesByRoleId(roleId);
        if (isNotEmpty(roleCiTypes))
            throw new CmdbException(String.format("Failed to delete role[%d] because it is used for CiType: %s", roleId, roleCiTypes.stream().map(p -> String.valueOf(p.getCiTypeId())).collect(Collectors.joining(","))));
        uiWrapperService.deleteRoles(roleId);
    }

    public List<MenuDto> getAllMenus() {
        List<MenuDto> menuDtos = new ArrayList<>();
        List<AdmMenu> menus = admMenusRepository.findAll();
        menus.forEach(menu -> {
            menuDtos.add(MenuDto.from(menu, false));
        });
        return menuDtos;
    }

    public List<String> getMenuDtosByRoleId(int roleId) {
        return admMenusRepository.findAdmMenusByRoles(roleId).stream().map(AdmMenu::getName).collect(Collectors.toList());
    }

    public List<String> getMenuDtoCodesByUsername(String username) {
        return getMenuDtosByUsername(username, false).stream().map(MenuDto::getCode).collect(toList());
    }

    public List<MenuDto> getMenuDtosByUsername(String username, boolean withParentMenu) {
        List<MenuDto> menuDtos = new ArrayList<>();
        List<RoleDto> roles = uiWrapperService.getRolesByUsername(username);
        log.info("Roles {} found for user {}", roles, username);
        if (isNotEmpty(roles)) {
            Integer[] roleIds = roles.stream().map(RoleDto::getRoleId).toArray(Integer[]::new);
            List<AdmMenu> admMenusTemp = admMenusRepository.findAdmMenusByRoles(roleIds);
            Set<AdmMenu> admMenus = Sets.newTreeSet(new Comparator<AdmMenu>() {
                @Override
                public int compare(AdmMenu o1, AdmMenu o2) {
                    return o1.getIdAdmMenu().compareTo(o2.getIdAdmMenu());
                }
            });
            admMenus.addAll(admMenusTemp);
            if (isNotEmpty(admMenus) && withParentMenu) {
                Set<Integer> fetchedParentIds = Sets.newHashSet();
                Set<Integer> toFetchedParentIds = Sets.newHashSet();
                for (AdmMenu menu : admMenus) {
                    Integer parentId = menu.getParentIdAdmMenu();
                    if (parentId == null || parentId == 0) {
                        fetchedParentIds.add(menu.getIdAdmMenu());
                    } else {
                        toFetchedParentIds.add(parentId);
                    }
                }
                toFetchedParentIds.removeAll(fetchedParentIds);
                Iterable<AdmMenu> parentMenus = admMenusRepository.findAllById(toFetchedParentIds);
                parentMenus.forEach(admMenus::add);
            }
            admMenus.forEach(menu -> {
                menuDtos.add(MenuDto.from(menu, false));
            });
            return menuDtos;
        }
        return Collections.emptyList();
    }

    public List<RoleCiTypeDto> getRoleCiTypesByRoleId(int roleId) {
        List<RoleCiTypeDto> roleCiTypes = uiWrapperService.getRoleCiTypeByRoleId(roleId);
        if (roleCiTypes == null)
            roleCiTypes = Lists.newArrayList();

        List<CiTypeDto> allCiTypes = uiWrapperService.getAllCiTypes(false, null);
        if (isNotEmpty(allCiTypes) && roleCiTypes.size() < allCiTypes.size()) {
            Set<Integer> ciTypeIds = roleCiTypes.stream().map(RoleCiTypeDto::getCiTypeId).collect(Collectors.toSet());
            RoleCiTypeDto[] toAddRoleCiTypes = allCiTypes.stream()
                    .filter(ciType -> !ciTypeIds.contains(ciType.getCiTypeId()))
                    .map(ciType -> new RoleCiTypeDto(roleId, ciType.getCiTypeId(), ciType.getName()))
                    .toArray(RoleCiTypeDto[]::new);
            List<RoleCiTypeDto> addedRoleCiTypes = uiWrapperService.createRoleCiTypes(toAddRoleCiTypes);
            roleCiTypes.addAll(addedRoleCiTypes);
        }
        roleCiTypes.sort(new CiTypeIdComparator());
        CiTypePermissionUtil.evaluatePartialActionPermissions(roleCiTypes);
        return roleCiTypes;
    }

    public List<RoleCiTypeDto> getRoleCiTypesByUsername(String username) {
        List<RoleCiTypeDto> roleCiTypes = uiWrapperService.getRoleCiTypeByUsername(username);
        if (isNotEmpty(roleCiTypes)) {
            roleCiTypes = mergePermissionsByCiTypeId(roleCiTypes);
        }
        CiTypePermissionUtil.evaluatePartialActionPermissions(roleCiTypes);
        return roleCiTypes;
    }

    private List<RoleCiTypeDto> mergePermissionsByCiTypeId(List<RoleCiTypeDto> roleCiTypes) {
        Map<Integer, RoleCiTypeDto> mergedRoleCiTypes = new LinkedHashMap<>();
        roleCiTypes.forEach(roleCiType -> {
            Integer ciTypeId = roleCiType.getCiTypeId();
            RoleCiTypeDto mergedRoleCiType = mergedRoleCiTypes.get(ciTypeId);
            if (mergedRoleCiType == null) {
                mergedRoleCiType = new RoleCiTypeDto();
                mergedRoleCiType.setRoleCiTypeId(-1);
                mergedRoleCiType.setCiTypeId(ciTypeId);
                mergedRoleCiType.setCiTypeName(roleCiType.getCiTypeName());
                mergedRoleCiTypes.put(ciTypeId, mergedRoleCiType);
            }
            CiTypePermissionUtil.mergeActionPermissions(mergedRoleCiType, roleCiType);
        });
        return Lists.newArrayList(mergedRoleCiTypes.values());
    }

    public Map<String, Object> getRoleCiTypeCtrlAttributesByRoleCiTypeId(int roleCiTypeId) {
        RoleCiTypeDto roleCiType = uiWrapperService.getRoleCiTypeById(roleCiTypeId);
        if (roleCiType == null)
            throw new CmdbException("CiType permission not found for roleCiTypeId:" + roleCiTypeId);
        List<CiTypeAttrDto> accessControlAttributes = uiWrapperService.getCiTypeAccessControlAttributesByCiTypeId(roleCiType.getCiTypeId());
        for (CiTypeAttrDto ciTypeAttrDto: accessControlAttributes) {
            ciTypeAttrDto.setFilterRule(null);
        }
        List<RoleCiTypeCtrlAttrDto> roleCiTypeCtrlAttrs = uiWrapperService.getRoleCiTypeCtrlAttributesByRoleCiTypeId(roleCiTypeId);
        List<Map<String, Object>> roleCiTypeCtrlAttrsModels;
        if (isNotEmpty(roleCiTypeCtrlAttrs)) {
            roleCiTypeCtrlAttrsModels = roleCiTypeCtrlAttrs.stream().map(roleCiTypeCtrlAttr ->
                    convertRoleCiTypeCtrlAttrDtoToMap(roleCiTypeCtrlAttr, accessControlAttributes)).collect(toList());
        } else {
            roleCiTypeCtrlAttrsModels = Lists.newArrayList();
        }

        Map<String, Object> result = new HashMap<>();
        result.put("header", accessControlAttributes);
        result.put("body", roleCiTypeCtrlAttrsModels);
        return result;
    }

    private Map<String, Object> convertRoleCiTypeCtrlAttrDtoToMap(RoleCiTypeCtrlAttrDto roleCiTypeCtrlAttr, List<CiTypeAttrDto> accessControlAttributes) {
        Map<String, Object> model = new LinkedHashMap<>();
        if (isNotEmpty(accessControlAttributes)) {
            Map<Integer, RoleCiTypeCtrlAttrConditionDto> conditionMap = asMap(roleCiTypeCtrlAttr.getConditions(), RoleCiTypeCtrlAttrConditionDto::getCiTypeAttrId);
            accessControlAttributes.forEach(attr -> {
/*
                RoleCiTypeCtrlAttrConditionDto attrConditionDto = roleCiTypeAccessCtrlService
                        .queryRoleCiTypeCtrlAttrCondition(roleCiTypeCtrlAttr.getRoleCiTypeCtrlAttrId(),attr.getCiTypeAttrId());
*/
/*
                RoleCiTypeCtrlAttrConditionDto condition = conditionMap.get(attr.getCiTypeAttrId());
                if (condition == null) {
                    condition = new RoleCiTypeCtrlAttrConditionDto();
                    condition.setRoleCiTypeCtrlAttrId(roleCiTypeCtrlAttr.getRoleCiTypeCtrlAttrId());
                    condition.setCiTypeAttrId(attr.getCiTypeAttrId());
                    condition.setCiTypeAttrName(attr.getName());
                    condition = uiWrapperService.createRoleCiTypeCtrlAttrCondition(condition);
                }
                enrichConditionValueObject(condition, attr);
*/
                RoleCiTypeCtrlAttrConditionDto condition = conditionMap.get(attr.getCiTypeAttrId());
                model.put(attr.getPropertyName(), condition);
            });
        }
        model.put(CONSTANT_CREATION_PERMISSION, roleCiTypeCtrlAttr.getCreationPermission());
        model.put(CONSTANT_REMOVAL_PERMISSION, roleCiTypeCtrlAttr.getRemovalPermission());
        model.put(CONSTANT_MODIFICATION_PERMISSION, roleCiTypeCtrlAttr.getModificationPermission());
        model.put(CONSTANT_ENQUIRY_PERMISSION, roleCiTypeCtrlAttr.getEnquiryPermission());
        model.put(CONSTANT_GRANT_PERMISSION, roleCiTypeCtrlAttr.getGrantPermission());
        model.put(CONSTANT_EXECUTION_PERMISSION, roleCiTypeCtrlAttr.getExecutionPermission());

        model.put("roleCiTypeId", roleCiTypeCtrlAttr.getRoleCiTypeId());
        model.put(CONSTANT_ROLE_CI_TYPE_CTRL_ATTR_ID, roleCiTypeCtrlAttr.getRoleCiTypeCtrlAttrId());
        return model;
    }

    private void enrichConditionValueObject(RoleCiTypeCtrlAttrConditionDto condition, CiTypeAttrDto attribute) {
        String conditionValue = condition.getConditionValue();
        if (!StringUtils.isEmpty(conditionValue)) {
            String inputType = attribute.getInputType();
            if (InputType.Droplist.getCode().equals(inputType) || InputType.MultSelDroplist.getCode().equals(inputType)) {
                List<Integer> codeIds;
                if (conditionValue.contains(",")) {
                    codeIds = Stream.of(conditionValue.split(","))
                            .map(String::trim)
                            .map(Integer::valueOf)
                            .collect(Collectors.toList());
                } else {
                    codeIds = Lists.newArrayList(Integer.parseInt(conditionValue));
                }
                condition.setConditionValueObject(Lists.newArrayList(uiWrapperService.getEnumCodesByIds(codeIds)));
            } else if (InputType.Reference.getCode().equals(inputType) || InputType.MultRef.getCode().equals(inputType)) {
                Integer targetCiTypeId = attribute.getReferenceId();
                List<String> guidList;
                if (conditionValue.contains(",")) {
                    guidList = Stream.of(conditionValue.split(","))
                            .map(String::trim)
                            .collect(toList());
                } else {
                    guidList = Lists.newArrayList(conditionValue);
                }
                condition.setConditionValueObject(uiWrapperService.getCiDataByGuid(targetCiTypeId, guidList));
            } else {
                condition.setConditionValueObject(conditionValue);
            }
        }
    }

    private RoleCiTypeCtrlAttrDto convertMapToRoleCiTypeCtrlAttrDto(int roleCiTypeId, Map<String, Object> model, List<CiTypeAttrDto> accessControlAttributes) {
        RoleCiTypeCtrlAttrDto roleCiTypeCtrlAttr = new RoleCiTypeCtrlAttrDto();
        roleCiTypeCtrlAttr.setRoleCiTypeId(roleCiTypeId);
        if (model.containsKey(CONSTANT_ROLE_CI_TYPE_CTRL_ATTR_ID))
            roleCiTypeCtrlAttr.setRoleCiTypeCtrlAttrId((Integer) model.get(CONSTANT_ROLE_CI_TYPE_CTRL_ATTR_ID));

        if (model.containsKey(CONSTANT_CREATION_PERMISSION))
            roleCiTypeCtrlAttr.setCreationPermission(checkPermission((String) model.get(CONSTANT_CREATION_PERMISSION)));
        if (model.containsKey(CONSTANT_REMOVAL_PERMISSION))
            roleCiTypeCtrlAttr.setRemovalPermission(checkPermission((String) model.get(CONSTANT_REMOVAL_PERMISSION)));
        if (model.containsKey(CONSTANT_MODIFICATION_PERMISSION))
            roleCiTypeCtrlAttr.setModificationPermission(checkPermission((String) model.get(CONSTANT_MODIFICATION_PERMISSION)));
        if (model.containsKey(CONSTANT_ENQUIRY_PERMISSION))
            roleCiTypeCtrlAttr.setEnquiryPermission(checkPermission((String) model.get(CONSTANT_ENQUIRY_PERMISSION)));
        if (model.containsKey(CONSTANT_GRANT_PERMISSION))
            roleCiTypeCtrlAttr.setGrantPermission(checkPermission((String) model.get(CONSTANT_GRANT_PERMISSION)));
        if (model.containsKey(CONSTANT_EXECUTION_PERMISSION))
            roleCiTypeCtrlAttr.setExecutionPermission(checkPermission((String) model.get(CONSTANT_EXECUTION_PERMISSION)));

        if (model.containsKey(CONSTANT_CALLBACK_ID))
            roleCiTypeCtrlAttr.setCallbackId(String.valueOf(model.get(CONSTANT_CALLBACK_ID)));

        if (isNotEmpty(accessControlAttributes)) {
            accessControlAttributes.forEach(attr -> {
                Map conditionModel = (Map) model.get(attr.getPropertyName());
                if (conditionModel != null) {
                    roleCiTypeCtrlAttr.getConditions().add(convertMapToRoleCiTypeCtrlAttrConditionDto(conditionModel, attr));
                }
            });
        }
        return roleCiTypeCtrlAttr;
    }

    private String checkPermission(String permission) {
        return BooleanUtils.isTrue(permission) ? CiTypePermissions.ENABLED : CiTypePermissions.DISABLED;
    }

    private RoleCiTypeCtrlAttrConditionDto convertMapToRoleCiTypeCtrlAttrConditionDto(Map model, CiTypeAttrDto ciTypeAttr) {
        RoleCiTypeCtrlAttrConditionDto condition = new RoleCiTypeCtrlAttrConditionDto();
        condition.setCiTypeAttrId(ciTypeAttr.getCiTypeAttrId());
        condition.setCiTypeAttrName(ciTypeAttr.getName());
        if (model.containsKey("conditionType")) {
            condition.setConditionType((String) model.get("conditionType"));
        }else{
            throw new CmdbException("ConditionType is missed.");
        }
        if (model.containsKey("conditionId"))
            condition.setConditionId((Integer) model.get("conditionId"));
        if (model.containsKey("conditionType")) {
            if("Expression".equalsIgnoreCase(condition.getConditionType())) {
                List conditionValExprs = (List)model.get("conditionValueExprs");
                condition.setConditionValueExprs(conditionValExprs);
            }else if("Select".equalsIgnoreCase(condition.getConditionType())){
                List conditionSelects = (List)model.get("conditionValueSelects");
                condition.setConditionValueSelects(conditionSelects);
            }
        }

        if (model.containsKey(CONSTANT_CALLBACK_ID))
            condition.setCallbackId(String.valueOf(model.get(CONSTANT_CALLBACK_ID)));
        return condition;
    }

    @Transactional
    public List<Map<String, Object>> createRoleCiTypeCtrlAttributes(int roleCiTypeId, List<Map<String, Object>> roleCiTypeCtrlAttributes) {
        RoleCiTypeDto roleCiType = uiWrapperService.getRoleCiTypeById(roleCiTypeId);
        List<CiTypeAttrDto> accessControlAttributes = uiWrapperService.getCiTypeAccessControlAttributesByCiTypeId(roleCiType.getCiTypeId());

        List<Map<String, Object>> addedCtrlAttrDtos = Lists.newArrayList();
        if (isNotEmpty(roleCiTypeCtrlAttributes)) {
            roleCiTypeCtrlAttributes.forEach(roleCiTypeCtrlAttribute -> {
                RoleCiTypeCtrlAttrDto ctrlAttrDto = convertMapToRoleCiTypeCtrlAttrDto(roleCiTypeId, roleCiTypeCtrlAttribute, accessControlAttributes);
                RoleCiTypeCtrlAttrDto addedCtrlAttr = uiWrapperService.createRoleCiTypeCtrlAttribute(ctrlAttrDto);
                if (isNotEmpty(ctrlAttrDto.getConditions())) {
                    ctrlAttrDto.getConditions().forEach(condition -> condition.setRoleCiTypeCtrlAttrId(addedCtrlAttr.getRoleCiTypeCtrlAttrId()));
//                    List<RoleCiTypeCtrlAttrConditionDto> addedConditions = uiWrapperService
//                            .createRoleCiTypeCtrlAttrConditions(ctrlAttrDto.getConditions().toArray(new RoleCiTypeCtrlAttrConditionDto[ctrlAttrDto.getConditions().size()]));
                    List<RoleCiTypeCtrlAttrConditionDto> addedConditions = roleCiTypeAccessCtrlService.createRoleCiTypeCtrlAttrConditions(ctrlAttrDto.getConditions());
                    addedCtrlAttr.setConditions(addedConditions);
                }
                addedCtrlAttrDtos.add(convertRoleCiTypeCtrlAttrDtoToMap(addedCtrlAttr, accessControlAttributes));
            });
        }
        return addedCtrlAttrDtos;
    }

    public List<Map<String, Object>> updateRoleCiTypeCtrlAttributes(int roleCiTypeId, List<Map<String, Object>> roleCiTypeCtrlAttributes) {
        RoleCiTypeDto roleCiType = uiWrapperService.getRoleCiTypeById(roleCiTypeId);
        List<CiTypeAttrDto> accessControlAttributes = uiWrapperService.getCiTypeAccessControlAttributesByCiTypeId(roleCiType.getCiTypeId());

        List<Map<String, Object>> updateCtrlAttrDtos = Lists.newArrayList();
        if (isNotEmpty(roleCiTypeCtrlAttributes)) {
            roleCiTypeCtrlAttributes.forEach(roleCiTypeCtrlAttribute -> {
                RoleCiTypeCtrlAttrDto ctrlAttrDto = convertMapToRoleCiTypeCtrlAttrDto(roleCiTypeId, roleCiTypeCtrlAttribute, accessControlAttributes);
                RoleCiTypeCtrlAttrDto updatedCtrlAttr = uiWrapperService.updateRoleCiTypeCtrlAttribute(ctrlAttrDto);
                if (isNotEmpty(ctrlAttrDto.getConditions())) {
                    ctrlAttrDto.getConditions().forEach(condition -> condition.setRoleCiTypeCtrlAttrId(updatedCtrlAttr.getRoleCiTypeCtrlAttrId()));
//                    List<RoleCiTypeCtrlAttrConditionDto> updatedConditions = uiWrapperService
//                            .updateRoleCiTypeCtrlAttrConditions(ctrlAttrDto.getConditions().toArray(new RoleCiTypeCtrlAttrConditionDto[ctrlAttrDto.getConditions().size()]));
                    List<RoleCiTypeCtrlAttrConditionDto> updatedConditions = roleCiTypeAccessCtrlService
                            .updateRoleCiTypeCtrlAttrConditions(ctrlAttrDto.getConditions());

                    updatedCtrlAttr.setConditions(updatedConditions);
                }
                updateCtrlAttrDtos.add(convertRoleCiTypeCtrlAttrDtoToMap(updatedCtrlAttr, accessControlAttributes));
            });
        }
        return updateCtrlAttrDtos;
    }

    public void grantRoleForUsers(int roleId, List<String> userIds) {
        if (isNotEmpty(userIds)) {
            uiWrapperService.createRoleUsers(userIds.stream().map(u -> new RoleUserDto(roleId, u)).toArray(RoleUserDto[]::new));
        } else {
            log.info("Do nothing due to userIds is empty.");
        }
    }

    public void revokeRoleForUsers(int roleId, List<String> userIds) {
        if (isNotEmpty(userIds)) {
            List<RoleUserDto> roleUsers = uiWrapperService.getRoleUsers(defaultQueryObject()
                    .addEqualsFilter("roleId", roleId)
                    .addInFilter("userId", userIds));
            if (isEmpty(roleUsers)) {
                log.warn("Nothing to delete because no permission found for role {} and userIds {}", roleId, userIds);
            } else {
                uiWrapperService.deleteRoleUsers(roleUsers.stream().map(RoleUserDto::getRoleUserId).toArray(Integer[]::new));
            }
        } else {
            log.info("Nothing to delete because userIds is empty.");
        }
    }
    @OperationLogPointcut(operation = Modification)
    @Transactional
    public void assignMenuPermissionForRoles(int roleId, List<String> menuCodes) {
        if (isNotEmpty(menuCodes)) {
            for (String menuCode : menuCodes) {
                assignMenuPermissionForRole(roleId, menuCode);
            }
        }
    }

    private void assignMenuPermissionForRole(int roleId, String menuName) {
        AdmMenu menu = admMenusRepository.findByName(menuName);
        if (menu == null)
            throw new CmdbException("Unknown menu name " + menuName);
        AdmRoleMenu roleMenu = new AdmRoleMenu();
        roleMenu.setAdmMenu(menu);
        roleMenu.setIdAdmRole(roleId);
        roleMenu.setIdAdmMenu(menu.getIdAdmMenu());
        menu.getAssignedRoles().add(roleMenu);
        admMenusRepository.save(menu);
    }

    public void removeMenuPermissionForRoles(int roleId, List<String> menuCodes) {
        if (isNotEmpty(menuCodes)) {
            for (String menuCode : menuCodes) {
                removeMenuPermissionForRole(roleId, menuCode);
            }
        }
    }

    private void removeMenuPermissionForRole(int roleId, String menuName) {
        AdmMenu menu = admMenusRepository.findByName(menuName);
        if (menu == null)
            throw new CmdbException("Unknown menu name " + menuName);

        menu.getAssignedRoles().forEach(roleMenu -> {
            if (roleMenu.getIsSystem() == CmdbConstants.IS_SYSTEM_YES) {
                throw new CmdbException(String.format("Failed to revoke menu permission as it is system permission. [%s]", roleMenu.getAdmMenu().getName()));
            }
        });

        if (menu.getAssignedRoles() != null) {
            menu.getAssignedRoles().removeIf(roleMenu -> roleMenu.getIdAdmRole().equals(roleId));
        }
        admMenusRepository.save(menu);
    }

    public void assignCiTypePermissionForRole(int roleId, int ciTypeId, String actionCode) {
        RoleCiTypeDto roleCiType = uiWrapperService.getRoleCiTypeByRoleIdAndCiTypeId(roleId, ciTypeId);
        if (roleCiType == null) {
            throw new CmdbException(String.format("Permission for role[%d] ciType[%d] not found.", roleId, ciTypeId));
        } else {
            roleCiType.enableActionPermission(actionCode);
            uiWrapperService.updateRoleCiTypes(roleCiType);
        }
    }

    public void removeCiTypePermissionForRole(int roleId, int ciTypeId, String actionCode) {
        RoleCiTypeDto roleCiType = uiWrapperService.getRoleCiTypeByRoleIdAndCiTypeId(roleId, ciTypeId);
        if (roleCiType == null) {
            throw new CmdbException(String.format("Permission for role[%d] ciType[%d] not found.", roleId, ciTypeId));
        } else {
            roleCiType.disableActionPermission(actionCode);
            uiWrapperService.updateRoleCiTypes(roleCiType);
        }
    }

    public static class CiTypeIdComparator implements Comparator<RoleCiTypeDto> {
        @Override
        public int compare(RoleCiTypeDto o1, RoleCiTypeDto o2) {
            return o1.getCiTypeId().compareTo(o2.getCiTypeId());
        }
    }

    public Boolean checkUserExists(String username) {
        return userRepository.existsByCode(username);
    }

    public List<UserDto> createUser(UserDto userDto) {
        if (userDto == null)
            throw new CmdbException("User parameter should not be null.");
        if (userDto.getUsername() == null)
            throw new CmdbException("Username should not be null.");
        if (userDto.getFullName() == null)
            userDto.setFullName(userDto.getUsername());
        if (userDto.getDescription() == null)
            userDto.setDescription(userDto.getFullName());
        if (checkUserExists(userDto.getUsername())) {
            throw new CmdbException(String.format("Username[%s] already exists.", userDto.getUsername()));
        }

        return staticDtoService.create(UserDto.class, Arrays.asList(userDto));
    }

    public String getRandomPassword() {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < 8; i++) {
            int flag = (int) (Math.random() * 62);
            if (flag < 10) {
                sb.append(flag);
            } else if (flag < 36) {
                sb.append((char) (flag + 'A' - 10));
            } else {
                sb.append((char) (flag + 'a' - 36));
            }
        }
        return sb.toString();
    }

    public QueryResponse<UserAndPasswordDto> findByName(String username) {
        QueryRequest ciRequest = QueryRequest.defaultQueryObject("username", username);
        return staticDtoService.query(UserAndPasswordDto.class, ciRequest);
    }

    public Object changePassword(Map<String, Object> password) {
        ResponseDto<UserDto> responseDto = new ResponseDto<UserDto>(ResponseDto.STATUS_OK, null);
        String currentUser = CmdbThreadLocal.getIntance().getCurrentUser();
        if (currentUser != null) {
            QueryResponse<UserAndPasswordDto> queryData = findByName(currentUser);
            UserAndPasswordDto user = CollectionUtils.pickRandomOne(queryData.getContents());
            if (user == null) {
                throw new CmdbException("This user does not exist");
            }
            if (!passwordEncoder.matches((String) password.get("password"), user.getPassword())) {
                throw new CmdbException("The original password is wrong.");
            }
            String newPassword = passwordEncoder.encode((String) password.get("newPassword"));
            user.setPassword(newPassword);
            staticDtoService.update(UserDto.class, user.getUserId(), BeanMapUtils.convertBeanToMap(user));
        } else {
            throw new CmdbException("Logon user not found.");
        }
        responseDto.setStatusMessage("The password was successfully modified.");
        return responseDto;
    }

    public List<UserDto> updateUser(List<Map<String, Object>> userDtos) {
        return staticDtoService.update(UserDto.class, userDtos);
    }

    public Object adminResetPassword(Map<String, Object> userDto) {
        String randomPassword = getRandomPassword();
        QueryResponse<UserAndPasswordDto> queryData = findByName((String) userDto.get("username"));
        UserAndPasswordDto user = CollectionUtils.pickRandomOne(queryData.getContents());
        if (user == null) {
            throw new CmdbException("This user does not exist");
        } else {
            user.setPassword(passwordEncoder.encode(randomPassword));
            staticDtoService.update(UserDto.class, user.getUserId(),BeanMapUtils.convertBeanToMap(user));
            return new ResponseDto<Object>(ResponseDto.STATUS_OK, randomPassword);
        }
    }

}
