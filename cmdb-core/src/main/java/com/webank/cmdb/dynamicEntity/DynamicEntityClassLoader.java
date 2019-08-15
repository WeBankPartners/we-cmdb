package com.webank.cmdb.dynamicEntity;

import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLClassLoader;
import java.util.Map;

/**
 * This class load is used to load CI entity classes from byte array, which are
 * generated from AdmCiType and AdmCiTypeAttr table data.
 * 
 * @author graychen
 *
 */
public class DynamicEntityClassLoader extends URLClassLoader {
    private Map<String, byte[]> entityBufMap;

    public DynamicEntityClassLoader(ClassLoader parentCL, Map<String, byte[]> entityBufMap) {
        super(new URL[0], parentCL);
        this.entityBufMap = entityBufMap;
    }

    public Class<?> getClass(byte[] bytes) {
        Class<?> clzz = this.defineClass(null, bytes, 0, bytes.length);
        return clzz;
    }

    @Override
    public URL getResource(String name) {
        try {
            return new URL("file://CiEntity/" + name);
        } catch (MalformedURLException e) {
            return null;
        }
    }

    @Override
    protected Class<?> findClass(String name) throws ClassNotFoundException {
        byte[] entityBuf = entityBufMap.get(name);
        if (entityBuf != null) {
            return defineClass(null, entityBuf, 0, entityBuf.length);
        }
        throw new ClassNotFoundException(name);
    }

}
