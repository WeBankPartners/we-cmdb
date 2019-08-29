package com.webank.cmdb.controller;

import static com.webank.cmdb.domain.AdmMenu.*;

import java.util.List;

import javax.annotation.security.RolesAllowed;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.google.common.collect.Lists;
import com.webank.cmdb.constant.CmdbConstants;
import com.webank.cmdb.constant.ImplementOperation;
import com.webank.cmdb.constant.PriorityUpdateOper;
import com.webank.cmdb.domain.AdmBasekeyCat;
import com.webank.cmdb.domain.AdmCiType;
import com.webank.cmdb.dto.CiTypeAttrDto;
import com.webank.cmdb.dto.CiTypeAttrGroupDto;
import com.webank.cmdb.dto.CiTypeCategoryDto;
import com.webank.cmdb.dto.CiTypeDto;
import com.webank.cmdb.dto.CiTypeHeaderDto;
import com.webank.cmdb.dto.CiTypeReferenceDto;
import com.webank.cmdb.exception.InvalidArgumentException;
import com.webank.cmdb.mvc.CiTypeAttrValidator;
import com.webank.cmdb.repository.AdmBasekeyCatRepository;
import com.webank.cmdb.repository.AdmCiTypeRepository;
import com.webank.cmdb.repository.AdmCiTypeRepository.BasekeyInfo;
import com.webank.cmdb.service.CiTypeService;
import com.webank.cmdb.service.StaticDtoService;

/**
 * Handle request related to CI type
 * 
 * @author graychen
 *
 */

@RestController
public class CiTypeController {
    @Autowired
    private AdmCiTypeRepository admCiTypeRepository;
    @Autowired
    private CiTypeService ciTypeService;
    @Autowired
    private AdmBasekeyCatRepository basekeyCatRepository;
    @Autowired
    private StaticDtoService staticDtoService;

    @RolesAllowed({MENU_QUERY_CONFIG, MENU_OVERVIEW, MENU_PERMISSION})
    @GetMapping("/ciTypes")
    public List<CiTypeDto> listCiTypes() {
        final List<CiTypeDto> ciTypes = Lists.newLinkedList();
        admCiTypeRepository.findAll().forEach(c -> {
            if (c != null) {
                ciTypes.add(CiTypeDto.fromAdmCIType(c));
            }
        });
        return ciTypes;
    }

    @RolesAllowed({MENU_QUERY_CONFIG, MENU_COMMON_INTERFACE_RUNNER, MENU_OVERVIEW, MENU_COMMON_INTERFACE_CONFIG})
    @GetMapping("/catalog/ciTypes")
    public List<CiTypeCategoryDto> listCiTypeCatalogInfo() {
        AdmBasekeyCat admBasekeyCat = basekeyCatRepository.findAllByCatName(CmdbConstants.CI_TYPE_CATALOG);
        List<BasekeyInfo> basekeyInfos = admCiTypeRepository.findCatalogCiTypes(admBasekeyCat.getIdAdmBasekeyCat());
        return CiTypeCategoryDto.Builder.build(basekeyInfos);
    }

    @RolesAllowed({MENU_OVERVIEW})
    @GetMapping("/ciType/ciTypeAndAttr/{ciTypeId}")
    public CiTypeDto getCiTypeAndAttributes(@PathVariable("ciTypeId") int admCiTypeId) {
        AdmCiType admCiType = admCiTypeRepository.findByIdAdmCiType(admCiTypeId);
        CiTypeDto ciTypeAttr = CiTypeDto.fromAdmCITypeWithAttr(admCiType);
        return ciTypeAttr;
    }

    @RolesAllowed({MENU_OVERVIEW})
    @PostMapping("/ciType/add")
    public CiTypeDto addCiType(@Valid @RequestBody CiTypeDto ciType) {
        return ciTypeService.addCiType(ciType);
    }

    @RolesAllowed({MENU_QUERY_CONFIG, MENU_OVERVIEW})
    @PostMapping("/ciType/{ciTypeId}/update")
    public void updateCiType(@PathVariable("ciTypeId") int ciTypeId, @RequestBody CiTypeDto ciType) {
        ciTypeService.updateCiType(ciTypeId, ciType);
    }

    @RolesAllowed({MENU_OVERVIEW})
    @PostMapping("/ciType/{ciTypeId}/delete")
    public void deleteCiType(@PathVariable("ciTypeId") int ciTypeId) {
        staticDtoService.delete(CiTypeDto.class, ciTypeId);
    }

    @RolesAllowed({MENU_OVERVIEW})
    @PostMapping("/ciType/{ciTypeId}/implement")
    public void implementCiType(@PathVariable("ciTypeId") int ciTypeId, @RequestParam("operation") String operaCode) {
        ImplementOperation operation = ImplementOperation.fromCode(operaCode);
        if (ImplementOperation.None.equals(operation)) {
            throw new InvalidArgumentException(String.format("Operation code [%s] is not supported", operaCode));
        }

        ciTypeService.implementCiType(ciTypeId, operation);
    }

    @RolesAllowed({MENU_OVERVIEW})
    @PostMapping("/ciType/attr/{ciTypeAttrId}/implement")
    public void implementCiTypeAttr(@PathVariable("ciTypeAttrId") int ciTypeAttrId, @RequestParam("operation") String operaCode) {
        ImplementOperation operation = ImplementOperation.fromCode(operaCode);
        if (ImplementOperation.None.equals(operation)) {
            throw new InvalidArgumentException(String.format("Operation code [%s] is not supported", operaCode));
        }

        ciTypeService.implementCiTypeAttr(ciTypeAttrId, operation);
    }

    @RolesAllowed({MENU_OVERVIEW})
    @PostMapping("/ciType/{ciTypeId}/attr/add")
    public CiTypeAttrDto addCiTypeAttribute(@PathVariable("ciTypeId") int ciTypeId, @Valid @RequestBody CiTypeAttrDto ciTypeAttr) {
        ciTypeAttr.setCiTypeId(ciTypeId);
        return ciTypeService.addCiTypeAttribute(ciTypeId, ciTypeAttr);
    }

    @RolesAllowed({MENU_OVERVIEW})
    @PostMapping("/ciType/{ciTypeId}/attr/{ciTypeAttrId}/delete")
    public void deleteCiTypeAttribute(@PathVariable("ciTypeId") int ciTypeId, @PathVariable("ciTypeAttrId") int ciTypeAttrId) {
        staticDtoService.delete(CiTypeAttrDto.class, ciTypeAttrId);
    }

    @RolesAllowed({MENU_COMMON_INTERFACE_CONFIG})
    @GetMapping("/ciType/{ciTypeId}/attrs")
    public List<CiTypeAttrDto> getCiTypeAttributes(@PathVariable("ciTypeId") int ciTypeId) {
        return ciTypeService.listAllAttributes(ciTypeId);
    }

    @RolesAllowed({MENU_OVERVIEW})
    @PostMapping("/ciType/{ciTypeId}/attr/{ciTypeAttrId}/update")
    public void updateCiTypeAttribute(@PathVariable("ciTypeId") int ciTypeId, @PathVariable("ciTypeAttrId") int ciTypeAttrId, @RequestBody CiTypeAttrDto ciTypeAttr) {
        ciTypeService.updateCiTypeAttribute(ciTypeId, ciTypeAttrId, ciTypeAttr);
    }

    @RolesAllowed({MENU_OVERVIEW})
    @GetMapping("/ciType/{ciTypeId}/attrUniqueGroups")
    public List<CiTypeAttrGroupDto> listCiTypeAttrGroup(@PathVariable("ciTypeId") int ciTypeId) {
        return ciTypeService.getAttrGroup(ciTypeId);
    }

    @RolesAllowed({MENU_OVERVIEW})
    @PostMapping("/ciType/{ciTypeId}/attrUniqueGroup/add")
    public void addCiTypeAttrGroup(@PathVariable("ciTypeId") int ciTypeId, @Valid @RequestBody CiTypeAttrGroupDto attrGroup) {
        ciTypeService.addAttrGroup(attrGroup);
    }

    @RolesAllowed({MENU_OVERVIEW})
    @PostMapping("/ciType/attrUniqueGroup/{attrGroupId}/delete")
    public void deleteCiTypeAttrGroup(@PathVariable("attrGroupId") int attrGroupId) {
        ciTypeService.deleteAttrGroup(attrGroupId);
    }

    @RolesAllowed({MENU_QUERY_CONFIG})
    @GetMapping("/ciType/{ciTypeId}/header")
    public List<CiTypeHeaderDto> getCiTypeHeader(@PathVariable("ciTypeId") int ciTypeId) {
        return ciTypeService.getCiTypeHeader(ciTypeId);
    }

    // For CI Type
    /**
     * Query CI types which have attribute reference to the given CI type
     * 
     * @param ciTypeId
     * @return
     */
    @RolesAllowed({MENU_COMMON_INTERFACE_CONFIG})
    @GetMapping("/ciType/{ciTypeId}/referBy")
    public List<CiTypeReferenceDto> queryReferencedBy(@PathVariable("ciTypeId") int ciTypeId) {
        return ciTypeService.queryReferencedBy(ciTypeId);
    }

    /**
     * Query CI types which are referenced by the given CI type
     * 
     * @param ciTypeId
     * @return
     */
    @RolesAllowed({MENU_COMMON_INTERFACE_CONFIG})
    @GetMapping("/ciType/{ciTypeId}/referTo")
    public List<CiTypeReferenceDto> queryReferenceTo(@PathVariable("ciTypeId") int ciTypeId) {
        return ciTypeService.queryReferenceTo(ciTypeId);
    }
}
