package com.webank.cmdb.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.webank.cmdb.domain.AdmSequence;

public interface AdmSequenceRepository extends JpaRepository<AdmSequence, Integer> {
    AdmSequence findBySeqName(String seqName);
}
