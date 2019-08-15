package com.webank.cmdb.service;

public interface SequenceService extends CmdbService {
    static public String NAME = "SequenceService";

    String getNextGuid(String seqName, Integer ciTypeId);
}
