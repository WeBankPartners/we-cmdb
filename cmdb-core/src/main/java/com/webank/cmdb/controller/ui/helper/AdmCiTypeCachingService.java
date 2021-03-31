package com.webank.cmdb.controller.ui.helper;

import java.util.LinkedList;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.webank.cmdb.domain.AdmCiType;
import com.webank.cmdb.domain.AdmCiTypeAttr;
import com.webank.cmdb.repository.AdmCiTypeRepository;

/**
 * 
 * @author gavin
 *
 */
@Service
public class AdmCiTypeCachingService {
    private static final Logger log = LoggerFactory.getLogger(AdmCiTypeCachingService.class);

    @Autowired
    private AdmCiTypeRepository ciTypeRepository;

    private volatile long lastRefreshedTime = 0L;

    private long refreshTimeIntervalMillis = 10 * 60 * 1000;

    private ConcurrentMap<Integer, AdmCiType> cachedAdmCiTypes = new ConcurrentHashMap<Integer, AdmCiType>();
    
    public void forceRefresh(){
        doRefresh();
    }

    protected synchronized void tryRefresh() {
        long intervalMillis = System.currentTimeMillis() - lastRefreshedTime;
        if (intervalMillis >= refreshTimeIntervalMillis) {
            doRefresh();
        }
    }

    protected synchronized void doRefresh() {
        cachedAdmCiTypes.clear();

        List<AdmCiType> admCiTypes = ciTypeRepository.findAllAdmCiTypesAndAttrs();

        if (admCiTypes == null || admCiTypes.isEmpty()) {
            return;
        }

        for (AdmCiType admCiType : admCiTypes) {
            cachedAdmCiTypes.put(admCiType.getIdAdmCiType(), admCiType);
        }

        log.info("total {} AdmCiTypes loaded...", admCiTypes.size());
        lastRefreshedTime = System.currentTimeMillis();
    }

    protected void tryCacheAdmCiType(AdmCiType admCiType) {
        if (admCiType == null) {
            return;
        }
        cachedAdmCiTypes.put(admCiType.getIdAdmCiType(), admCiType);
    }

    /**
     * key method in this service
     * 
     * @param ciTypeId
     * @return
     */
    protected AdmCiType fetchAdmCiTypeById(Integer ciTypeId) {
        tryRefresh();
        AdmCiType admCiType = cachedAdmCiTypes.get(ciTypeId);
        if (admCiType == null) {
            admCiType = ciTypeRepository.findAdmCiTypeAndAttrsById(ciTypeId);
            tryCacheAdmCiType(admCiType);
        }

        return admCiType;
    }

    public List<AdmCiTypeAttr> findAllByCiTypeId(Integer ciTypeId) {
        AdmCiType admCiType = fetchAdmCiTypeById(ciTypeId);
        if (admCiType == null) {
            return null;
        }

        return admCiType.getAdmCiTypeAttrs();
    }

    public List<AdmCiTypeAttr> findByCiTypeIdAndEditIsOnly(int ciTypeId, int editIsOnly) {
        AdmCiType admCiType = fetchAdmCiTypeById(ciTypeId);
        if (admCiType == null) {
            return null;
        }

        List<AdmCiTypeAttr> admCiTypeAttrs = admCiType.getAdmCiTypeAttrs();
        if (admCiTypeAttrs == null) {
            return null;
        }

        List<AdmCiTypeAttr> filteredCiTypeAttrs = new LinkedList<AdmCiTypeAttr>();

        for (AdmCiTypeAttr a : admCiTypeAttrs) {
            if(a.getEditIsOnly() == null){
                continue;
            }
            if (editIsOnly == a.getEditIsOnly()) {
                filteredCiTypeAttrs.add(a);
            }
        }

        return filteredCiTypeAttrs;
    }

    public List<AdmCiTypeAttr> findAllByCiTypeIdAndIsAccessControlled(Integer ciTypeId, Integer isAccessControlled) {
        AdmCiType admCiType = fetchAdmCiTypeById(ciTypeId);
        if (admCiType == null) {
            return null;
        }

        List<AdmCiTypeAttr> admCiTypeAttrs = admCiType.getAdmCiTypeAttrs();
        if (admCiTypeAttrs == null) {
            return null;
        }

        List<AdmCiTypeAttr> filteredCiTypeAttrs = new LinkedList<AdmCiTypeAttr>();

        for (AdmCiTypeAttr a : admCiTypeAttrs) {
            if(a.getIsAccessControlled() == null){
                continue;
            }
            if (isAccessControlled == a.getIsAccessControlled()) {
                filteredCiTypeAttrs.add(a);
            }
        }

        return filteredCiTypeAttrs;
    }

    public List<AdmCiTypeAttr> findByCiTypeIdAndIsAuto(int ciTypeId, int isAuto) {
        AdmCiType admCiType = fetchAdmCiTypeById(ciTypeId);
        if (admCiType == null) {
            return null;
        }

        List<AdmCiTypeAttr> admCiTypeAttrs = admCiType.getAdmCiTypeAttrs();
        if (admCiTypeAttrs == null) {
            return null;
        }

        List<AdmCiTypeAttr> filteredCiTypeAttrs = new LinkedList<AdmCiTypeAttr>();

        for (AdmCiTypeAttr a : admCiTypeAttrs) {
            if (a.getIsAuto() != null && (isAuto == a.getIsAuto())) {
                filteredCiTypeAttrs.add(a);
            }
        }

        return filteredCiTypeAttrs;
    }

    public List<AdmCiTypeAttr> findAllByMatchAutoFillRule(String value) {
        List<AdmCiTypeAttr> filteredCiTypeAttrs = new LinkedList<AdmCiTypeAttr>();
        if (StringUtils.isBlank(value)) {
            return filteredCiTypeAttrs;
        }

        tryRefresh();

        for (AdmCiType admCiType : this.cachedAdmCiTypes.values()) {
            List<AdmCiTypeAttr> admCiTypeAttrs = admCiType.getAdmCiTypeAttrs();
            if (admCiTypeAttrs == null) {
                continue;
            }

            for (AdmCiTypeAttr attr : admCiTypeAttrs) {
                if (ifMatchByAutoFillRule(attr, value)) {
                    filteredCiTypeAttrs.add(attr);
                }
            }
        }

        return filteredCiTypeAttrs;
    }

    private boolean ifMatchByAutoFillRule(AdmCiTypeAttr attr, String value) {
        if (StringUtils.isBlank(attr.getAutoFillRule())) {
            return false;
        }

        if (attr.getAutoFillRule().contains(value)) {
            return true;
        }

        return false;
    }

}
