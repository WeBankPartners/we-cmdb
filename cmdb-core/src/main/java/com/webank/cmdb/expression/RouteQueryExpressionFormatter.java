package com.webank.cmdb.expression;

import com.webank.cmdb.dto.AdhocIntegrationQueryDto;
import com.webank.cmdb.dto.Filter;
import com.webank.cmdb.dto.IntegrationQueryDto;
import com.webank.cmdb.dto.Relationship;
import com.webank.cmdb.dynamicEntity.DynamicEntityMeta;
import com.webank.cmdb.dynamicEntity.FieldNode;

import java.text.NumberFormat;
import java.util.*;

public class RouteQueryExpressionFormatter {
    private Map<Integer, DynamicEntityMeta> entityMap;


    public RouteQueryExpressionFormatter(Map<Integer, DynamicEntityMeta> entityMap){
        this.entityMap = entityMap;
    }

    class AttrInfo {
        private int attrId;
        private FieldNode fieldNode;

        public AttrInfo(int attrId, FieldNode fieldNode) {
            this.attrId = attrId;
            this.fieldNode = fieldNode;
        }

        public int getAttrId() {
            return attrId;
        }

        public FieldNode getFieldNode() {
            return fieldNode;
        }
    }
    public String format(AdhocIntegrationQueryDto adhocIntegrationQuery){
        IntegrationQueryDto integrationQuery =  adhocIntegrationQuery.getCriteria();
        List<String> resultColumns = adhocIntegrationQuery.getQueryRequest().getResultColumns();
        List<Filter> filters = adhocIntegrationQuery.getQueryRequest().getFilters();
        return format(integrationQuery,filters,resultColumns);
    }

    private String format(IntegrationQueryDto integrationQuery,List<Filter> filters,List<String> resultColumns){
        StringBuilder exprBuilder = new StringBuilder();
        DynamicEntityMeta entityMeta = entityMap.get(integrationQuery.getCiTypeId());
        if(entityMeta == null){
            throw new CmdbExpressException(String.format("Can't find out dynamic entity meta for ciType (%d).",integrationQuery.getCiTypeId()));
        }

        Map<String, AttrInfo> queryAttrMap = getQueryAttrMap(integrationQuery, entityMeta);
        exprBuilder.append(entityMeta.getTableName());
        formatFilters(integrationQuery, filters, exprBuilder, entityMeta);
        formatFetch(integrationQuery,resultColumns,entityMeta,exprBuilder, queryAttrMap);

        formatChildren(integrationQuery, filters, resultColumns, exprBuilder, entityMeta);
        return exprBuilder.toString();
    }

    private Map<String, AttrInfo> getQueryAttrMap(IntegrationQueryDto integrationQuery, DynamicEntityMeta entityMeta) {
        Map<String, AttrInfo> attrInfoMap = new HashMap<>();
        for(int i=0;i<integrationQuery.getAttrKeyNames().size();i++){
           String keyName = integrationQuery.getAttrKeyNames().get(i);
           int attrId = integrationQuery.getAttrs().get(i);
            attrInfoMap.put(keyName,new AttrInfo(attrId,entityMeta.getFieldNode(attrId)));
        }
        return attrInfoMap;
    }

    private void formatFetch(IntegrationQueryDto integrationQuery, List<String> resultColumns, DynamicEntityMeta entityMeta, StringBuilder exprBuilder,
                             Map<String, AttrInfo> queryAttrMap) {
        if(resultColumns == null || resultColumns.size()==0){
            return;
        }

        int addedIndex = 0;
        for (String resultColumn : resultColumns) {
            List<String> attrKeyNames = integrationQuery.getAttrKeyNames();
            if(attrKeyNames.contains(resultColumn)){
                AttrInfo attrInfo = queryAttrMap.get(resultColumn);
                String column = attrInfo.getFieldNode().getColumn();
                if(addedIndex == 0){
                    exprBuilder.append(RouteQueryExpressionListener.FETCH_DELIMITER)
                            .append("[");
                }else{
                    exprBuilder.append(",");
                }
                exprBuilder.append(column);
                addedIndex++;
            }
        }
        if(addedIndex>0){
            exprBuilder.append("]");
        }
    }

    private void formatFilters(IntegrationQueryDto integrationQuery, List<Filter> filters, StringBuilder exprBuilder, DynamicEntityMeta entityMeta) {
        if(filters != null && filters.size()>0){
            exprBuilder.append("[");
            Iterator<Filter> filterIterator = filters.iterator();
            while(filterIterator.hasNext()){
                Filter filter = filterIterator.next();
                if(filter.getName().indexOf(integrationQuery.getName() + RouteQueryExpressionListener.ATTR_DELIMITER)==0) {
                    exprBuilder.append(formatFilter(integrationQuery, filter, entityMeta));
                }
            }
            exprBuilder.append("]");
        }
    }

    private void formatChildren(IntegrationQueryDto integrationQuery, List<Filter> filters, List<String> resultColumns, StringBuilder exprBuilder, DynamicEntityMeta entityMeta) {
        List<IntegrationQueryDto> children = integrationQuery.getChildren();
        if(children == null || children.size()==0){
            return;
        }
        else if(children.size()>1){
            throw new CmdbExpressException("Not support more than 1 child node for integrate query format.");
        }
        IntegrationQueryDto childIntegrationQuery = children.get(0);
        Relationship rs = childIntegrationQuery.getParentRs();
        int rsAttrId = rs.getAttrId();
        if(rs.getIsReferedFromParent()){
            FieldNode fieldNode = entityMeta.getFieldNode(rsAttrId);
            exprBuilder.append(".")
                    .append(fieldNode.getColumn())
                    .append(">");
        }else{
            DynamicEntityMeta childEntityMeta = entityMap.get(childIntegrationQuery.getCiTypeId());
            FieldNode fieldNode = childEntityMeta.getFieldNode(rsAttrId);
            exprBuilder.append("~")
                    .append("(").append(fieldNode.getColumn()).append(")");
        }
        exprBuilder.append(format(childIntegrationQuery,filters,resultColumns));
    }

    private String formatFilter(IntegrationQueryDto integrationQuery, Filter filter, DynamicEntityMeta entityMeta){
        StringBuilder filterBuilder = new StringBuilder("{");
        String fieldName = filter.getName();
        int index = indexOf(integrationQuery.getAttrKeyNames(),fieldName);
        if(index == -1){
            throw new CmdbExpressException(String.format("Can't find out filter name (%s) in attribute key names.",fieldName));
        }
        int attrId = integrationQuery.getAttrs().get(index);
        FieldNode fieldNode = entityMeta.getFieldNode(attrId);
        String columnName = fieldNode.getColumn();
        String valText = formatFilterValue(filter.getValue());
        filterBuilder.append(columnName)
                .append(" ").append(filter.getOperator())
                .append(" ").append(valText).append("}");
        return filterBuilder.toString();
    }

    private String formatFilterValue(Object valObject){
        StringBuilder valBuilder = new StringBuilder();
        if(valObject instanceof String){
            valBuilder.append("'").append(String.valueOf(valObject)).append("'");
        }else if (valObject instanceof Number){
            NumberFormat numberFormat = NumberFormat.getInstance();
            return numberFormat.format((Number)valObject);
        }else if(valObject instanceof Collection){
            valBuilder.append("[");
            Collection vals = (Collection)valObject;
            Iterator iterator = vals.iterator();
            while(iterator.hasNext()){
                String text = formatFilterValue(iterator.next());
                valBuilder.append(text);
                if(iterator.hasNext()){
                    valBuilder.append(",");
                }
            }
            valBuilder.append("]");
        }
        return  valBuilder.toString();
    }

    private int indexOf(List<String> names,String targetName){
        for (int i=0;i<names.size();i++){
            if(names.get(i).equalsIgnoreCase(targetName)){
                return i;
            }
        }
        return -1;
    }
}
