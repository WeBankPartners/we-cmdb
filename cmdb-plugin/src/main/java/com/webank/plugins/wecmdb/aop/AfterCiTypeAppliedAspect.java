package com.webank.plugins.wecmdb.aop;

import com.webank.plugins.wecmdb.config.PluginApplicationProperties;
import com.webank.plugins.wecmdb.service.WeCubeDataModelSynchronizer;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.DisposableBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import reactor.core.scheduler.Schedulers;

import java.time.Duration;
import java.util.concurrent.atomic.AtomicBoolean;

@Aspect
@Component
public class AfterCiTypeAppliedAspect implements DisposableBean {
    private final static Logger logger = LoggerFactory.getLogger(AfterCiTypeAppliedAspect.class);

    @Autowired
    private PluginApplicationProperties pluginApplicationProperties;
    @Autowired
    private WeCubeDataModelSynchronizer weCubeDataModelSynchronizer;

    private final AtomicBoolean isDataSyncSubscribed = new AtomicBoolean(false);

    @Pointcut("execution(* com.webank.cmdb.service.impl.CiTypeServiceImpl.applyCiType(..))")
    private void applyCiTypeOperation() {}
    @Pointcut("execution(* com.webank.cmdb.service.impl.CiTypeServiceImpl.applyAllCiType(..))")
    private void applyAllCiTypeOperation() {}
    @Pointcut("applyCiTypeOperation() && applyCiTypeOperation()")
    private void applyCiTypeOperations() {}

    @AfterReturning("applyCiTypeOperations()")
    public synchronized void notifyWeCube() {
        try {
            if(!Boolean.TRUE.equals(pluginApplicationProperties.getKeepDataModelSync())) return;

            if(!isDataSyncSubscribed.compareAndSet(false, true)) return;

            weCubeDataModelSynchronizer.synchronize()
                    .doAfterTerminate(() -> isDataSyncSubscribed.set(false))
                    .delaySubscription(Duration.ofSeconds(1))
                    .subscribeOn(Schedulers.single())
                    .subscribe();
        } catch (Exception e) {
            logger.error("Error occurred when synchronizing data model to WeCube.", e);
        }
    }

    @Override
    public void destroy() {
        Schedulers.shutdownNow();
    }
}
