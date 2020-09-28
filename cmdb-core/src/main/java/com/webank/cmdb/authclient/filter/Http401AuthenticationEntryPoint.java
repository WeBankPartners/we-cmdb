package com.webank.cmdb.authclient.filter;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.AuthenticationEntryPoint;

import com.fasterxml.jackson.databind.ObjectMapper;

public class Http401AuthenticationEntryPoint implements AuthenticationEntryPoint {
    private static final Logger log = LoggerFactory.getLogger(Http401AuthenticationEntryPoint.class);
    
    private static String HEADER_WWW_AUTHENTICATE = "WWW-Authenticate";

    private String headerValue = "Bearer realm=\"Central Authentication Server\";profile=\"JWT\";";
    
    private ObjectMapper objectMapper = new ObjectMapper();

    @Override
    public void commence(HttpServletRequest request, HttpServletResponse response,
            AuthenticationException authException) throws IOException, ServletException {
        
        log.warn("=== authentication failed === ");
        response.setHeader(HEADER_WWW_AUTHENTICATE, translateAuthenticateHeader(authException));
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        
        AuthenticationFailedResponse responseBody = AuthenticationFailedResponse.error(authException.getMessage());
        response.getOutputStream().println(objectMapper.writeValueAsString(responseBody));
        response.getOutputStream().flush();
        
    }

    protected String translateAuthenticateHeader(AuthenticationException e){
        StringBuilder sb = new StringBuilder();
        sb.append(this.headerValue);
        sb.append("error=\"").append(e.getMessage()).append("\";");
        
        return sb.toString();
    }
    
    static class AuthenticationFailedResponse {
        public final static String STATUS_OK = "OK";
        public final static String STATUS_ERROR = "ERROR";
        
        public final static String OK_MESSAGE = "success";

        private String status;
        private String message;
        private Object data;

        public String getStatus() {
            return status;
        }

        public void setStatus(String status) {
            this.status = status;
        }

        public String getMessage() {
            return message;
        }

        public void setMessage(String message) {
            this.message = message;
        }

        public Object getData() {
            return data;
        }

        public void setData(Object data) {
            this.data = data;
        }

        public AuthenticationFailedResponse withData(Object data){
            this.data = data;
            return this;
        }

        public static AuthenticationFailedResponse okay() {
            AuthenticationFailedResponse result = new AuthenticationFailedResponse();
            result.setStatus(STATUS_OK);
            result.setMessage(OK_MESSAGE);
            return result;
        }

        public static AuthenticationFailedResponse okayWithData(Object data) {
            return okay().withData(data);
        }

        public static AuthenticationFailedResponse error(String errorMessage) {
            AuthenticationFailedResponse result = new AuthenticationFailedResponse();
            result.setStatus(STATUS_ERROR);
            result.setMessage(errorMessage);
            return result;
        }
    }
}
