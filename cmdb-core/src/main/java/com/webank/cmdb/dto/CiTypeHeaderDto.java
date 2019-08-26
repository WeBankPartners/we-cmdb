package com.webank.cmdb.dto;

import java.util.LinkedList;
import java.util.List;

import org.springframework.beans.BeanUtils;

public class CiTypeHeaderDto extends CiTypeAttrDto {
    private List<Object> vals = new LinkedList<>();

    public CiTypeHeaderDto() {
    }

    public CiTypeHeaderDto(CiTypeAttrDto attrDto) {
        BeanUtils.copyProperties(attrDto, this);
    }

    public void addEnumValue(int id, String code) {
        this.vals.add(new EnumValue(id, code));
    }
    
    public void addStringValue(String val) {
        vals.add(val);
    }
    
    public void addStringValues(List<String> valList) {
        vals.addAll(valList);
    }
    
    public void addValues(List<?> valList) {
    	vals.addAll(valList);
    }

    class EnumValue {
        private int id;
        private String code;

        public EnumValue() {
        }

        public EnumValue(int id, String code) {
            this.id = id;
            this.code = code;
        }

        public int getId() {
            return id;
        }

        public void setId(int id) {
            this.id = id;
        }

        public String getCode() {
            return code;
        }

        public void setCode(String code) {
            this.code = code;
        }

    }
    
    static public class CiKeyPair{
    	private String guid;
    	private String keyName;
    	
    	public CiKeyPair(String guid,String keyName) {
    		this.guid = guid;
    		this.keyName = keyName;
    	}
    	
		public String getGuid() {
			return guid;
		}
		public void setGuid(String guid) {
			this.guid = guid;
		}
		public String getKeyName() {
			return keyName;
		}
		public void setKeyName(String keyName) {
			this.keyName = keyName;
		}
    	
    }

    public List<Object> getVals() {
        return vals;
    }

    public void setVals(List<Object> vals) {
        this.vals = vals;
    }
}
