package com.webank.cmdb.config.log;

import static java.lang.annotation.ElementType.METHOD;
import static java.lang.annotation.RetentionPolicy.RUNTIME;

import java.lang.annotation.Documented;
import java.lang.annotation.Retention;
import java.lang.annotation.Target;

@Documented
@Target(METHOD)
@Retention(RUNTIME)
public @interface OperationLogPointcut {
    Operation operation();

    Class objectClass() default Object.class;

    enum Operation {
        Creation, Modification, Removal, Implementation
    }
}
