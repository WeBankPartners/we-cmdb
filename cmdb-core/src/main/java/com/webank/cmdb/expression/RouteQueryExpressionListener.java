package com.webank.cmdb.expression;

import com.sun.org.apache.xpath.internal.operations.Bool;
import com.webank.cmdb.constant.FilterOperator;
import com.webank.cmdb.dto.AdhocIntegrationQueryDto;
import com.webank.cmdb.dto.Filter;
import com.webank.cmdb.dto.IntegrationQueryDto;
import com.webank.cmdb.dto.Relationship;
import com.webank.cmdb.dynamicEntity.DynamicEntityMeta;
import com.webank.cmdb.dynamicEntity.FieldNode;
import com.webank.cmdb.expression.antlr4.RouteQueryBaseListener;
import com.webank.cmdb.expression.antlr4.RouteQueryParser;

import java.text.NumberFormat;
import java.text.ParseException;
import java.util.*;

public class RouteQueryExpressionListener extends RouteQueryBaseListener {
    public static final String ATTR_DELIMITER = ".";
    public static final String ATTR_REG_SPLITTER = "\\"+ATTR_DELIMITER;
    public static final String FETCH_DELIMITER = ":";

    private Stack<Filter> conditions = new Stack<>();
    private Stack<Object> values = new Stack<>();
    private Stack<String> entities = new Stack<>();

    //for Array
    private Boolean isArrayBegan = false;
    private Stack<Object> arrValues = new Stack<>();

    private Stack<String> attrs = new Stack<>();
    private Stack<String> fetchAttrs = new Stack<>();
    private boolean fetchBegan = false;

    //'table name' -> 'entity meta'
    private Map<String, DynamicEntityMeta> entityMap;
    //CiType Id -> entity meta
    private Map<Integer,DynamicEntityMeta> entityIdMap = new HashMap<>();

    //integration query chain
    private List<IntegrationQueryDto> integrationChain = new LinkedList<>();
    private AdhocIntegrationQueryDto adhocIntegrationQuery = new AdhocIntegrationQueryDto();

    public RouteQueryExpressionListener(Map<String,DynamicEntityMeta> entityMap){
        this.entityMap = entityMap;
        entityMap.forEach((tableName,meta)-> entityIdMap.put(meta.getCiTypeId(),meta)
        );
    }

    public AdhocIntegrationQueryDto getAdhocIntegrationQuery(){
        if(integrationChain.size()>0){
            adhocIntegrationQuery.setCriteria(integrationChain.get(0));
            return adhocIntegrationQuery;
        }else{
            return null;
        }
    }

    private String getAttrKeyname(String intQueryName,String attrName){
        return intQueryName + ATTR_DELIMITER + attrName;
    }

    private void processFetch(){
        while(fetchAttrs.size()>0){
            String attr = fetchAttrs.pop();
            IntegrationQueryDto intQuery = getIntegrationInChain(-1);
            String intQueryName = intQuery.getKeyName();
            Integer ciTypeId = intQuery.getCiTypeId();
            DynamicEntityMeta meta = entityIdMap.get(ciTypeId);
            if(meta == null){
                throw new CmdbExpressException(String.format("CiType (%d, %s) is not existed.",ciTypeId, intQueryName));
            }

            FieldNode fieldNode = meta.getFieldNode(attr);
            if(fieldNode == null){
                throw new CmdbExpressException(String.format("Attribute (%s) is not existed for CiType (%d, %s).",attr,ciTypeId, intQueryName));
            }

            String fetchAttrName = getAttrKeyname(intQueryName,attr);
            if(!intQuery.getAttrs().contains(fieldNode.getAttrId())){
                intQuery.getAttrs().add(fieldNode.getAttrId());
                intQuery.getAttrKeyNames().add(fetchAttrName);
            }

            List<String> resultColumns = adhocIntegrationQuery.getQueryRequest().getResultColumns();
            if(!resultColumns.contains(fetchAttrName)){
                resultColumns.add(fetchAttrName);
            }
        }
        fetchAttrs.clear();
    }

    private IntegrationQueryDto getIntegrationInChain(int index){
        if(index < 0){
            return integrationChain.get(integrationChain.size() + index);
        }else {
            return integrationChain.get(index);
        }
    }

    @Override
    public void exitFwdNodeToEntity(RouteQueryParser.FwdNodeToEntityContext ctx){
        processLinkEntity(true);
    }

    private void processLinkEntity(boolean isForword){
        IntegrationQueryDto fwdNode = getIntegrationInChain(-2);
        IntegrationQueryDto curNode = getIntegrationInChain(-1);
        String fwdNodeAttr = attrs.pop();
        if(isForword){//reference to
            FieldNode fwdField = getFieldNode(fwdNode.getCiTypeId(),fwdNodeAttr);
            curNode.setParentRs(new Relationship(fwdField.getAttrId(),true));
        }else{//referenced by
            FieldNode bwdField = getFieldNode(curNode.getCiTypeId(),fwdNodeAttr);
            curNode.setParentRs(new Relationship(bwdField.getAttrId(),false));
        }
        fwdNode.getChildren().add(curNode);
    }

    @Override
    public void exitLinkToEntity(RouteQueryParser.LinkToEntityContext ctx) {
        processLinkEntity(true);
    }

    @Override
    public void exitLinkByBwdNode(RouteQueryParser.LinkByBwdNodeContext ctx){
        processLinkEntity(false);
    }

    @Override
    public void exitEntityByBwdNode(RouteQueryParser.EntityByBwdNodeContext ctx){
        processLinkEntity(false);
    }

    @Override
    public void enterFetch(RouteQueryParser.FetchContext ctx) {
        fetchBegan = true;
    }

    @Override
    public void exitFetch(RouteQueryParser.FetchContext ctx){
        fetchBegan = false;
    }

    @Override public void exitEntity(RouteQueryParser.EntityContext ctx) {
        String tableName = ctx.getText();
        entities.push(tableName);
    }

    @Override
    public void exitEntity_node(RouteQueryParser.Entity_nodeContext ctx){
        IntegrationQueryDto intQuery = new IntegrationQueryDto();
        String tableName = entities.pop();
        String intQueryName = genCurIntQueryName(tableName);
        intQuery.setKeyName(intQueryName);
        DynamicEntityMeta meta = entityMap.get(tableName);
        if(meta == null){
            throw new CmdbExpressException(String.format("CiType (%s) is not existed.",tableName));
        }
        intQuery.setCiTypeId(meta.getCiTypeId());

        while(conditions.size()>0) {
            Filter filter = conditions.pop();
            String attrName = filter.getName();
            FieldNode fieldNode = meta.getFieldNode(attrName);
            if (fieldNode == null) {
                throw new CmdbExpressException(String.format("Can't find field (%s) for ci type ('%s')", attrName, tableName));
            }
            intQuery.getAttrs().add(fieldNode.getAttrId());
            String attrKeyName = getAttrKeyname(intQueryName , attrName);
            filter.setName(attrKeyName);
            if(!intQuery.getAttrKeyNames().contains(attrKeyName)) {
                intQuery.getAttrKeyNames().add(attrKeyName);
            }
            adhocIntegrationQuery.getQueryRequest().getFilters().add(filter);
        }
        integrationChain.add(intQuery);
        processFetch();
    }

    private String genCurIntQueryName(String tableName) {
        return String.format("%s_%s",currentEntityIndex(),tableName);
    }

    private int currentEntityIndex(){
        return integrationChain.size();
    }

    private FieldNode getFieldNode(Integer ciTypeId,String attrName){
        DynamicEntityMeta meta = entityIdMap.get(ciTypeId);
        if(meta == null){
            throw new CmdbExpressException(String.format("Can't find ci type for '%d'",ciTypeId));
        }
        FieldNode fieldNode = meta.getFieldNode(attrName);
        if (fieldNode == null) {
            throw new CmdbExpressException(String.format("Can't find field (%s) for ci type ('%d')", attrName, ciTypeId));
        }
        return fieldNode;
    }

    @Override
    public void exitAttr(RouteQueryParser.AttrContext ctx){
        String attr = ctx.ID().getText();
        if(fetchBegan){
            fetchAttrs.push(attr);
        }else {
            attrs.push(attr);
        }
    }

    @Override
    public void exitConditionEq(RouteQueryParser.ConditionEqContext ctx){
        Object val = values.pop();
        conditions.push(new Filter(attrs.pop(), FilterOperator.Equal.getCode(),val));
    }

    @Override
    public void exitConditionIn(RouteQueryParser.ConditionInContext ctx) {
        List<Object> inValues = new ArrayList<>(arrValues);
        arrValues.clear();
        conditions.push(new Filter(attrs.pop(), FilterOperator.In.getCode(),inValues));
    }

    private String trimStringVal(String val){
        if(val.length()>0){
            if(val.charAt(0) == '\'' || val.charAt(0) == '"'){
                val = val.substring(1);
            }
            if(val.charAt(val.length()-1) == '\'' || val.charAt(val.length()-1) == '"'){
                val = val.substring(0,val.length()-1);
            }
            return val;
        }
        return val;
    }

    @Override
    public void exitConditionGt(RouteQueryParser.ConditionGtContext ctx){
        Object val = values.pop();
        if(val instanceof  Number){
            conditions.push(new Filter(attrs.pop(), FilterOperator.Greater.getCode(),val));
        }else{
            throw new CmdbExpressException(String.format("gt operator should apply on number (not %s).",String.valueOf(val)));
        }
    }

    @Override
    public void exitConditionLt(RouteQueryParser.ConditionLtContext ctx){
        Object val = values.pop();
        if(val instanceof  Number){
            conditions.push(new Filter(attrs.pop(), FilterOperator.Less.getCode(),val));
        }else{
            throw new CmdbExpressException(String.format("lt operator should apply on number (not %s).",String.valueOf(val)));
        }
    }
    public void exitConditionNe(RouteQueryParser.ConditionNeContext ctx){
        Object val = values.pop();
        conditions.push(new Filter(attrs.pop(), FilterOperator.NotEqual.getCode(),val));
    }

    @Override
    public void exitConditionContains(RouteQueryParser.ConditionContainsContext ctx){
        Object val = values.pop();
        if(val instanceof  String){
            conditions.push(new Filter(attrs.pop(), FilterOperator.Contains.getCode(),val));
        }else{
            throw new CmdbExpressException(String.format("contains operator should apply on number (not %s).",String.valueOf(val)));
        }

    }

    @Override
    public void exitConditionNotNull(RouteQueryParser.ConditionNotNullContext ctx){
        conditions.push(new Filter(attrs.pop(), FilterOperator.NotNull.getCode(),null));
    }

    @Override
    public void exitConditionIsNull(RouteQueryParser.ConditionIsNullContext ctx){
        conditions.push(new Filter(attrs.pop(), FilterOperator.Null.getCode(),null));
    }

    @Override
    public void enterArray(RouteQueryParser.ArrayContext ctx) {
        isArrayBegan = true;
        arrValues.clear();
    }

    @Override
    public void exitArray(RouteQueryParser.ArrayContext ctx){
        isArrayBegan = false;
    }

    @Override
    public void exitValString(RouteQueryParser.ValStringContext ctx){
        String strVal = trimStringVal(ctx.getText());
        if(isArrayBegan){
            arrValues.push(strVal);
        }else {
            values.push(trimStringVal(ctx.getText()));
        }
    }

    @Override
    public void exitValNumber(RouteQueryParser.ValNumberContext ctx){
        NumberFormat numFormat = NumberFormat.getInstance();
        String txt = ctx.getText();
        Number number = null;
        try {
            number = numFormat.parse(ctx.getText());
        } catch (ParseException e) {
            throw new CmdbExpressException(String.format("Failed to convert text '%s' to number.",txt));
        }

        if(isArrayBegan){
            arrValues.push(number);
        }else {
            values.push(number);
        }
    }
    @Override
    public void exitValBool(RouteQueryParser.ValBoolContext ctx) {
        String strBool = ctx.getText();
        Boolean boolVal = Boolean.valueOf(strBool);
        if(isArrayBegan){
            arrValues.push(boolVal);
        }else {
            values.push(boolVal);
        }

    }
}
