package com.webank.cmdb.controller.ui.helper;

public class CiRoutineItem {
	private int ciTypeId;
	private CiParentRs parentRs;
	
	public CiRoutineItem() {
		super();
	}
	
	public CiRoutineItem(int ciTypeId, CiParentRs parentRs) {
		super();
		this.ciTypeId = ciTypeId;
		this.parentRs = parentRs;
	}

	public int getCiTypeId() {
		return ciTypeId;
	}
	public void setCiTypeId(int ciTypeId) {
		this.ciTypeId = ciTypeId;
	}
	public CiParentRs getParentRs() {
		return parentRs;
	}
	public void setParentRs(CiParentRs parentRs) {
		this.parentRs = parentRs;
	}

	@Override
	public String toString() {
		return "ciTypeId=" + ciTypeId + ", parentRs=" + parentRs + "";
	}
	
	
}
