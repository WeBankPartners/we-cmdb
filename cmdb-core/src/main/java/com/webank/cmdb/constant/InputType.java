package com.webank.cmdb.constant;

/**
 * The allowable input types of a CI type attribute
 * 
 * @author graychen
 *
 */
public enum InputType {
    None("none"), Text("text"), Date("date"), TextArea("textArea"), Droplist("select"), MultSelDroplist("multiSelect"), Reference("ref"), MultRef("multiRef"), Number("number"), OrchestrationMuliRef("orchestration_multi_ref"),
    Orchestration("orchestration_ref"),Password("password");

    private String code;

    private InputType(String code) {
        this.code = code;
    }

    public String getCode() {
        return code;
    }

    /**
     * Get InputType from code
     * 
     * @param code The input type code
     * @return The matching enum value. None if there is not matching enum value
     */
    static public InputType fromCode(String code) {
        for (InputType inputType : values()) {
            if (None.equals(inputType))
                continue;

            if (inputType.getCode().equals(code)) {
                return inputType;
            }
        }
        return None;
    }
}
