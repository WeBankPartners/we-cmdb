package com.webank.cmdb.exception;

import java.lang.reflect.UndeclaredThrowableException;
import java.util.List;

import javax.persistence.PersistenceException;

import org.hibernate.JDBCException;
import org.hibernate.exception.DataException;
import org.hibernate.exception.SQLGrammarException;

import com.google.common.collect.Lists;

public class BatchChangeException extends CmdbException {
    private static final long serialVersionUID = 2829464363135608132L;

    private List<ExceptionHolder> exceptionHolders = Lists.newLinkedList();

    public BatchChangeException(String message) {
        super(message);
    }

    public BatchChangeException(String message, List<ExceptionHolder> exceptionHolders) {
        super(message);
        this.exceptionHolders = exceptionHolders;
    }

    public static class ExceptionHolder {
        private String callBackId;
        private Object requestData;
        private Exception exception;
        private String errorMessage;

        public ExceptionHolder(String callBackId, Object requestData, String errorMessage, Exception exception) {
            this.callBackId = callBackId;
            this.requestData = requestData;
            this.exception = exception;
            this.errorMessage = errorMessage;
        }

        public Exception getException() {
            return exception;
        }

        public void setException(Exception exception) {
            this.exception = exception;
        }

        public Object getRequestData() {
            return requestData;
        }

        public void setRequestData(Object requestData) {
            this.requestData = requestData;
        }

        public String getErrorMessage() {
            return errorMessage;
        }

        public void setErrorMessage(String errorMessage) {
            this.errorMessage = errorMessage;
        }

        public String getCallBackId() {
            return callBackId;
        }

        public void setCallBackId(String callBackId) {
            this.callBackId = callBackId;
        }

        public static String extractExceptionMessage(Exception e) {
            if (e instanceof UndeclaredThrowableException) {
                Throwable cause = ((UndeclaredThrowableException) e).getUndeclaredThrowable().getCause();
                if (cause instanceof PersistenceException) {
                    cause = ((PersistenceException) cause).getCause();
                    if (cause instanceof DataException) {
                        return ((DataException) cause).getSQLException().getMessage();
                        
                    }else if(cause instanceof SQLGrammarException) {
                        return ((SQLGrammarException) cause).getSQLException().getMessage();
                    }
                }
            }
            return e.getMessage();
        }
    }

    public List<ExceptionHolder> getExceptionHolders() {
        return exceptionHolders;
    }

    public void setExceptionHolders(List<ExceptionHolder> exceptionHolders) {
        this.exceptionHolders = exceptionHolders;
    }
}
