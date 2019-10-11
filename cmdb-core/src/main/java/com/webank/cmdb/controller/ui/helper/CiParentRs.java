package com.webank.cmdb.controller.ui.helper;

public class CiParentRs {
	private int isReferedFromParent;
	private int attrId;
	
	public CiParentRs(int attrId, int isReferedFromParent) {
		super();
		this.attrId = attrId;
		this.isReferedFromParent = isReferedFromParent;
	}
	
	public CiParentRs() {
		super();
	}

	public int getIsReferedFromParent() {
		return isReferedFromParent;
	}
	public void setIsReferedFromParent(int isReferedFromParent) {
		this.isReferedFromParent = isReferedFromParent;
	}
	public int getAttrId() {
		return attrId;
	}
	public void setAttrId(int attrId) {
		this.attrId = attrId;
	}

	@Override
	public String toString() {
		return "isReferedFromParent=" + isReferedFromParent + ", attrId=" + attrId + "";
	}
	
	
}
