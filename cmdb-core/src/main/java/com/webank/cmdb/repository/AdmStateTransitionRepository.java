package com.webank.cmdb.repository;

import java.util.List;

import org.springframework.cache.annotation.CacheConfig;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.webank.cmdb.domain.AdmStateTransition;

@Repository
@CacheConfig(cacheManager = "requestScopedCacheManager", cacheNames = "admStateTransitionRepository")
public interface AdmStateTransitionRepository extends JpaRepository<AdmStateTransition, Integer> {

    @Query(value = "select * from adm_state_transition tr " + "INNER JOIN adm_basekey_code bc " + "ON tr.operation = bc.id_adm_basekey "
            + "where tr.current_state = :currentState and tr.current_state_is_confirmed = :isCurrentStateConfirmed " + "and bc.CODE = :operation ", nativeQuery = true)
    List<AdmStateTransition> findTargetTransition(@Param("currentState") int currentState, @Param("isCurrentStateConfirmed") int isCurrentStateConfirmed, @Param("operation") String operation);

    List<AdmStateTransition> findByOperationCode_codeAndTargetStateCode_catId(String operation, int catId);

    @Cacheable("admStateTransitionRepository-findDistinctOperationByCurrentStateAndCurrentStateIsConfirmed")
    List<AdmStateTransition> findDistinctOperationByCurrentStateAndCurrentStateIsConfirmed(int currentState, int currentStateIsConfirmed);

    List<AdmStateTransition> findByCurrentStateAndCurrentStateIsConfirmedAndTargetState(int curState, int isConfirmed, int targetState);
}
