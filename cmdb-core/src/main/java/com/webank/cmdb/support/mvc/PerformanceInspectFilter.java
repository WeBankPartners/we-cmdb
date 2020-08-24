package com.webank.cmdb.support.mvc;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.lang.Nullable;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.OncePerRequestFilter;
import org.springframework.web.util.ContentCachingRequestWrapper;
import org.springframework.web.util.WebUtils;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.UnsupportedEncodingException;

@Component
public class PerformanceInspectFilter extends OncePerRequestFilter {
    private final static Logger logger = LoggerFactory.getLogger(PerformanceInspectFilter.class);

    private static final String PERFORMANCE_INSPECT_REQUEST = "com.webank.cmdb.support.mvc.PerformanceInspectInterceptor_request";
    private static final int DEFAULT_MAX_PAYLOAD_LENGTH = 3000;

    @Value("${cmdb.performance.inspect.payload-limit:3000}")
    private int maxPayloadLength = DEFAULT_MAX_PAYLOAD_LENGTH;

    @Value("${cmdb.performance.inspect.threshold:500}")
    private long processThreshold = 500;

    @Value("${cmdb.performance.inspect.enable:false}")
    private boolean enableInspect = false;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
        boolean isFirstRequest = !isAsyncDispatch(request);
        HttpServletRequest requestToUse = request;

        if(enableInspect){
            if (isFirstRequest && !(request instanceof ContentCachingRequestWrapper)) {
                requestToUse = new ContentCachingRequestWrapper(request, maxPayloadLength);
            }

            if (isFirstRequest) {
                beforeRequest(requestToUse);
            }
            try {
                filterChain.doFilter(requestToUse, response);
            }
            finally {
                if (!isAsyncStarted(requestToUse)) {
                    afterRequest(requestToUse);
                }
            }
        }else{
            filterChain.doFilter(requestToUse, response);
        }
    }

    protected void beforeRequest(HttpServletRequest request){
        long requestTime = System.currentTimeMillis();
        request.setAttribute(PERFORMANCE_INSPECT_REQUEST,requestTime);
    }

    protected void afterRequest(HttpServletRequest request){
        long completeTime = System.currentTimeMillis();
        Long requestTime = (Long) request.getAttribute(PERFORMANCE_INSPECT_REQUEST);
        if (requestTime == null) {
            return;
        } else {
            long elapseTime = completeTime - requestTime;
            if (elapseTime > processThreshold) {
                String message = createMessage(request,"[Performance inspect] ", "]",elapseTime);
                logger.info(message);
            }
        }
    }

    protected String createMessage(HttpServletRequest request, String prefix, String suffix, long elapseTime) {
        StringBuilder msg = new StringBuilder();
        msg.append(prefix);
        msg.append("elapse time=").append(elapseTime);
        msg.append(" uri=").append(request.getRequestURI());

        String queryString = request.getQueryString();
        if (queryString != null) {
            msg.append('?').append(queryString);
        }

        String payload = getMessagePayload(request);
        if (payload != null) {
            msg.append(";payload=").append(payload);
        }

        msg.append(suffix);
        return msg.toString();
    }

    @Nullable
    protected String getMessagePayload(HttpServletRequest request) {
        ContentCachingRequestWrapper wrapper =
                WebUtils.getNativeRequest(request, ContentCachingRequestWrapper.class);
        if (wrapper != null) {
            byte[] buf = wrapper.getContentAsByteArray();
            if (buf.length > 0) {
                int length = Math.min(buf.length, maxPayloadLength);
                try {
                    return new String(buf, 0, length, wrapper.getCharacterEncoding());
                }
                catch (UnsupportedEncodingException ex) {
                    return "[unknown]";
                }
            }
        }
        return null;
    }

}
