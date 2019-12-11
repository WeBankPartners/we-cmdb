package com.webank.plugins.wecmdb.exception;

public class PluginException extends RuntimeException {
    private static final long serialVersionUID = -6705726821703229173L;

    public PluginException(String message) {
        super(message);
    }

    public PluginException(String message, Throwable cause) {
        super(message, cause);
    }
}
