package com.webank.cmdb.constant;

public enum CiStatus {
    None("none"), NotCreated("notCreated"), Created("created"), Dirty("dirty"), Decommissioned("decommissioned");

    private String code;

    private CiStatus(String code) {
        this.code = code;
    }

    public String getCode() {
        return code;
    }

    /**
     * Get CiStatus from code
     * 
     * @param code The input CiStatus code
     * @return The matching enum value. None if there is not matching enum value
     */
    static public CiStatus fromCode(String code) {
        for (CiStatus ciStatus : values()) {
            if (None.equals(ciStatus))
                continue;

            if (ciStatus.getCode().equals(code)) {
                return ciStatus;
            }
        }
        return None;
    }

    public boolean isImplementOperationSupported(ImplementOperation operation) {
        switch (this) {
        case NotCreated:
            return (ImplementOperation.Apply.equals(operation));
        case Created:
            return (ImplementOperation.Update.equals(operation) || ImplementOperation.Decommission.equals(operation));
        case Decommissioned:
            return (ImplementOperation.Revert.equals(operation));
        case Dirty:
            return (ImplementOperation.Revert.equals(operation));
        }
        return false;
    }

    /**
     * Check if the Ci data can support CRUD operation
     * 
     * @param ciStatus
     * @return true if we can implement CRUD operation on the CiType under the given
     *         ci status
     */
    public boolean supportCiDataOperation() {
        return (Created.equals(this) || Dirty.equals(this));
    }

    public static boolean shouldBeLoadedForDynamicEntity(CiStatus ciStatus) {
        return !NotCreated.equals(ciStatus);
    }
}
