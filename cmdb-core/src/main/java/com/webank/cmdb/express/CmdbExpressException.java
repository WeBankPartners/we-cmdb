package com.webank.cmdb.express;

import com.webank.cmdb.exception.CmdbException;

public class CmdbExpressException extends CmdbException {
    private static final long serialVersionUID = 1L;

    public CmdbExpressException(String message) {
        super(message);
    }

    public CmdbExpressException(String message, Throwable cause) {
        super(message, cause);
    }

}
