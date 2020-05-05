package com.webank.cmdb.expression;

import com.google.common.collect.Lists;
import com.webank.cmdb.dto.AdhocIntegrationQueryDto;
import com.webank.cmdb.dto.Filter;
import com.webank.cmdb.dto.IntegrationQueryDto;
import com.webank.cmdb.dynamicEntity.DynamicEntityMeta;
import com.webank.cmdb.dynamicEntity.FieldNode;
import com.webank.cmdb.exception.CmdbException;

import java.text.NumberFormat;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

public class RouteQueryExpressionFormatter {
    private Map<Integer, DynamicEntityMeta> entityMap;

    public RouteQueryExpressionFormatter(Map<Integer, DynamicEntityMeta> entityMap){
        this.entityMap = entityMap;
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

        exprBuilder.append(entityMeta.getTableName());
        if(filters != null && filters.size()>0){
            exprBuilder.append("[");
            Iterator<Filter> filterIterator = filters.iterator();
            while(filterIterator.hasNext()){
                Filter filter = filterIterator.next();
                if(filter.getName().indexOf(integrationQuery.getName()+":")==0) {
                    exprBuilder.append(formatFilter(integrationQuery, filter, entityMeta));
                }
            }
            exprBuilder.append("]");
        }
        List<IntegrationQueryDto> children = integrationQuery.getChildren();
        if(children == null || children.size()==0){
            exprBuilder.append(".[");
            if(resultColumns != null && resultColumns.size()>0){
                Iterator<String> resultCols = resultColumns.iterator();
                while(resultCols.hasNext()){
                    String resultCol = resultCols.next();
                    exprBuilder.append(resultCol);
                    if(resultCols.hasNext()){
                        exprBuilder.append(",");
                    }
                }
            }
            exprBuilder.append("]");
        }else{
            children.forEach(childIntegrationQuery -> {
                exprBuilder.append(format(childIntegrationQuery,filters,resultColumns));
                }
            );
        }
        return exprBuilder.toString();
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
