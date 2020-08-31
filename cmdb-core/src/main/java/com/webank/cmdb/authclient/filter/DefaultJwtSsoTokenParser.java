package com.webank.cmdb.authclient.filter;

import org.apache.commons.codec.binary.Base64;


import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jws;
import io.jsonwebtoken.JwtParser;
import io.jsonwebtoken.Jwts;

/**
 * 
 * @author gavinli
 *
 */
public class DefaultJwtSsoTokenParser implements JwtSsoTokenParser {

    private static final String SIGNING_KEY = "Platform+Auth+Server+Secret";
    
    private String jwtSigningKey;
    
    private JwtParser jwtParser;
    
    public DefaultJwtSsoTokenParser(String jwtSigningKey) {
    	if(jwtSigningKey == null) {
    		this.jwtSigningKey = SIGNING_KEY;
    	}else {
    		this.jwtSigningKey = jwtSigningKey;
    	}
    	
    	this.jwtParser = Jwts.parser().setSigningKey(decodeBase64(getJwtSigningKey()));
    }

    @Override
    public Jws<Claims> parseJwt(String token) {
        return jwtParser.parseClaimsJws(token);
    }

	private String getJwtSigningKey() {
		return jwtSigningKey;
	}
	
    private byte[] decodeBase64(String base64String){
        return Base64.decodeBase64(base64String);
    }
}
