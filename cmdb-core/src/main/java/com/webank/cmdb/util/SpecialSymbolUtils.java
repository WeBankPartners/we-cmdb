package com.webank.cmdb.util;

public class SpecialSymbolUtils {
	private static byte  b1[] = {0x01};  
    private static String specialSeparator = new String(b1);   
    
    public static String getPrepositionalSpecialSymbol(String s) {
    	String separator = specialSeparator + s;
    	return separator;
	}
    public static String getAfterSpecialSymbol(String s) {
    	String separator = s + specialSeparator;
    	return separator;
    }
    public static String getAroundSpecialSymbol(String s) {
    	String separator = specialSeparator + s + specialSeparator;
    	return separator;
    }
	public static String getSpecialSeparator() {
		return specialSeparator;
	}
}
