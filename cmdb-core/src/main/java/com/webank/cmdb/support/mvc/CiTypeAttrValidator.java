package com.webank.cmdb.support.mvc;

import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

import com.webank.cmdb.constant.BooleanType;
import com.webank.cmdb.constant.InputType;
import com.webank.cmdb.dto.CiTypeAttrDto;

public class CiTypeAttrValidator implements Validator {

    @Override
    public boolean supports(Class<?> clazz) {
        return CiTypeAttrDto.class.equals(clazz);
    }

    @Override
    public void validate(Object target, Errors errors) {
        CiTypeAttrDto ciTypeAttr = (CiTypeAttrDto) target;

        validateInputType(errors, ciTypeAttr);
        // validateDisplayType(errors, ciTypeAttr);

//		validateBooleanField("editIsEditable",ciTypeAttr.getIsEditable(),errors);
//		validateBooleanField("editIsHiden",ciTypeAttr.getIsHidden(),errors);
//		validateBooleanField("editIsNull",ciTypeAttr.getIsNull(),errors);
//		validateBooleanField("editIsOnly",ciTypeAttr.getIsUnique(),errors);
    }

    private void validateBooleanField(String filedName, Integer val, Errors errors) {
        BooleanType type = BooleanType.fromCode(val);
        if (BooleanType.None.equals(type)) {
            errors.rejectValue(filedName, "Invalid display type value");
        }
    }

    /*
     * private void validateDisplayType(Errors errors, CiTypeAttrDto ciTypeAttr) {
     * DisplayType displayType = DisplayType.fromCode(ciTypeAttr.getDisplayType());
     * if(DisplayType.None.equals(displayType)) { errors.rejectValue("displayType",
     * "Invalid display type value"); } }
     */
    private void validateInputType(Errors errors, CiTypeAttrDto ciTypeAttr) {
        InputType inputType = InputType.fromCode(ciTypeAttr.getInputType());
        if (InputType.None.equals(inputType)) {
            errors.rejectValue("inputType", "inputType");
        } else if (!(InputType.Reference.equals(inputType) || InputType.MultRef.equals(inputType))) {
            ciTypeAttr.setReferenceId(null);
            ciTypeAttr.setReferenceName(null);
        }

        if (!(InputType.Droplist.equals(inputType) || InputType.Reference.equals(inputType) || InputType.MultRef.equals(inputType))) {
            ciTypeAttr.setIsAccessControlled(false);
        }
    }
}
