package com.webank.cmdb.service.impl;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.webank.cmdb.domain.AdmSequence;
import com.webank.cmdb.repository.AdmSequenceRepository;
import com.webank.cmdb.service.SequenceService;

import javax.transaction.Transactional;

@Service
public class SequenceServiceImpl implements SequenceService {
    private static final int DEFAULT_VAL = 1;
    private static final int INIT_VAL = 1;

    private static Logger logger = LoggerFactory.getLogger(SequenceServiceImpl.class);

    @Override
    public String getName() {
        return SequenceService.NAME;
    }

    @Autowired
    private AdmSequenceRepository sequenceRepository;

    @Transactional(Transactional.TxType.REQUIRES_NEW)
    @Override
    public synchronized String getNextGuid(String seqName, Integer ciTypeId) {
        AdmSequence sequence = sequenceRepository.findBySeqName(seqName);
        if (sequence == null) {
            sequence = new AdmSequence();
            sequence.setSeqName(seqName);
            sequence.setCurrentVal(INIT_VAL);
            sequence.setIncrementVal(DEFAULT_VAL);
            sequence.setLeftZeroPadding("N");
            sequence.setLengthLimitation(8);
            logger.info("Create new sequece :{}", seqName);
        } else {
            int prevId = sequence.getCurrentVal();
            int currId = prevId + sequence.getIncrementVal();
            if (currId == prevId)
                currId = prevId + 1;

            if (String.format("%d", currId).length() > sequence.getLengthLimitation()) {
                currId = INIT_VAL;
            }
            sequence.setCurrentVal(currId);
        }
        sequenceRepository.saveAndFlush(sequence);
        return String.format("%04d", ciTypeId) + "_" + String.format("%010d", sequence.getCurrentVal());
    }

}
