package com.webank.cmdb.service.impl;

import java.sql.Timestamp;
import java.util.LinkedList;
import java.util.List;

import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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
import com.webank.cmdb.service.StaticDtoService;

@Service
public class LogServiceImpl implements LogService {
    @Autowired
    private StaticDtoService staticDtoService;
    @Autowired
    private StaticEntityRepository staticEntityRepository;

    @Override
    public String getName() {
        return LogService.NAME;
    }

    @Override
    public QueryResponse<LogDto> query(QueryRequest ciRequest) {
        QueryResponse<LogDto> domainResponse = staticDtoService.query(LogDto.class, ciRequest);
        return domainResponse;
    }

    @Override
    public List<QueryHeader> queryHeader() {
        List<QueryHeader> headers = new LinkedList<>();
        headers.add(new QueryHeader("Guid", "guid", InputType.Text.getCode()));
        headers.add(new QueryHeader("Created Date", "createdDate", InputType.Date.getCode()));
        headers.add(new QueryHeader("User", "user", InputType.Text.getCode()));
        headers.add(new QueryHeader("Log Cat", "logCat", InputType.Droplist.getCode(), LogCategory.codes()));
        headers.add(new QueryHeader("Log Content", "logContent", InputType.Text.getCode()));
        headers.add(new QueryHeader("Operation", "operation", InputType.Droplist.getCode(), LogOperation.codes()));
        headers.add(new QueryHeader("Remark", "remark", InputType.Text.getCode()));
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
