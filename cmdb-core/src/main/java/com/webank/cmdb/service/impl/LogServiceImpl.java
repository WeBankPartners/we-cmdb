package com.webank.cmdb.service.impl;

import java.sql.Timestamp;
import java.util.LinkedList;
import java.util.List;

import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.google.common.collect.Lists;
import com.webank.cmdb.constant.InputType;
import com.webank.cmdb.constant.LogCategory;
import com.webank.cmdb.constant.LogOperation;
import com.webank.cmdb.domain.AdmLog;
import com.webank.cmdb.dto.LogDto;
import com.webank.cmdb.dto.QueryHeader;
import com.webank.cmdb.dto.QueryRequest;
import com.webank.cmdb.dto.QueryResponse;
import com.webank.cmdb.repository.StaticEntityRepository;
import com.webank.cmdb.service.LogService;

@Service
public class LogServiceImpl implements LogService {
    @Autowired
    private StaticEntityRepository staticEntityRepository;

    @Override
    public String getName() {
        return LogService.NAME;
    }

    @Override
    public QueryResponse<LogDto> query(QueryRequest ciRequest) {
        QueryResponse<AdmLog> domainResponse = staticEntityRepository.query(AdmLog.class, ciRequest);
        List<LogDto> dtos = Lists.transform(domainResponse.getContents(), (x) -> {
            return LogDto.fromDomain(x);
        });
        QueryResponse<LogDto> dtoResponse = new QueryResponse<>(domainResponse.getPageInfo(), dtos);
        return dtoResponse;
    }

    @Override
    public List<QueryHeader> queryHeader() {
        List<QueryHeader> headers = new LinkedList<>();
        headers.add(new QueryHeader("ciName", InputType.Text.getCode()));
        headers.add(new QueryHeader("guid", InputType.Text.getCode()));
        headers.add(new QueryHeader("ciTypeName", InputType.Text.getCode()));
        headers.add(new QueryHeader("createdDate", InputType.Date.getCode()));
        headers.add(new QueryHeader("user", InputType.Text.getCode()));
        headers.add(new QueryHeader("logCat", InputType.Droplist.getCode(), LogCategory.codes()));
        headers.add(new QueryHeader("logContent", InputType.Text.getCode()));
        headers.add(new QueryHeader("operation", InputType.Droplist.getCode(), LogOperation.codes()));
        headers.add(new QueryHeader("remark", InputType.Text.getCode()));
        return headers;
    }

    @Transactional(value = Transactional.TxType.REQUIRES_NEW)
    @Override
    public AdmLog log(LogCategory category, String user, LogOperation operation, String logContent, String remark) {
        AdmLog admLog = createAdmLog(category, user, operation, logContent, remark);
        return staticEntityRepository.create(admLog);
    }

    @Transactional(value = Transactional.TxType.REQUIRES_NEW)
    @Override
    public AdmLog log(LogCategory category, String user, LogOperation operation, String logContent, String remark, String ciGuid, String ciName, Integer ciTypeId, String ciTypeName) {
        AdmLog admLog = createAdmLog(category, user, operation, logContent, remark);
        admLog.setCiTypeInstanceGuid(ciGuid);
        admLog.setCiName(ciName);
        admLog.setCiTypeId(ciTypeId);
        admLog.setCiTypeName(ciTypeName);
        return staticEntityRepository.create(admLog);
    }

    private AdmLog createAdmLog(LogCategory category, String user, LogOperation operation, String logContent, String remark) {
        AdmLog admlog = new AdmLog();
        admlog.setIdAdmUser(user);
        admlog.setLogCat(category.getCode());
        admlog.setOperation(operation.getCode());
        admlog.setLogContent(logContent);
        admlog.setCreatedDate(new Timestamp(System.currentTimeMillis()));
        admlog.setRemark(remark);
        admlog.setStatus(0);
        return admlog;
    }
}
