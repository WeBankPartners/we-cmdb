package com.webank.cmdb.expression;

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
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Stack;

public class RouteQueryExpressionListener extends RouteQueryBaseListener {
    public static final String ATTR_DELIMITER = ".";
    public static final String ATTR_REG_SPLITTER = "\\"+ATTR_DELIMITER;

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

    //integration query chain
    private List<IntegrationQueryDto> integrationChain = new LinkedList<>();
    private AdhocIntegrationQueryDto adhocIntegrationQuery = new AdhocIntegrationQueryDto();

    public RouteQueryExpressionListener(Map<String,DynamicEntityMeta> entityMap){
        this.entityMap = entityMap;
    }

    public AdhocIntegrationQueryDto getAdhocIntegrationQuery(){
        if(integrationChain.size()>0){
            adhocIntegrationQuery.setCriteria(integrationChain.get(0));
            return adhocIntegrationQuery;
        }else{
            return null;
        }
    }

    @Override
    public void exitLinkFetch(RouteQueryParser.LinkFetchContext ctx) {
        processFetch();
    }

    private String getAttrKeyname(String entityName,String attrName){
        return entityName + ATTR_DELIMITER + attrName;
    }

    @Override
    public void exitEntityFetch(RouteQueryParser.EntityFetchContext ctx) {
        processFetch();
    }

    private void processFetch(){
        while(fetchAttrs.size()>0){
            String attr = fetchAttrs.pop();
            IntegrationQueryDto intQuery = getIntegrationInChain(-1);
            String tableName = intQuery.getName();
            DynamicEntityMeta meta = entityMap.get(tableName);
            FieldNode fieldNode = meta.getFieldNode(attr);
            intQuery.getAttrs().add(fieldNode.getAttrId());
            String fetchAttrName = getAttrKeyname(tableName,attr);
            intQuery.getAttrKeyNames().add(fetchAttrName);
            adhocIntegrationQuery.getQueryRequest().getResultColumns().add(fetchAttrName);
        }
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
            FieldNode fwdField = getFieldNode(fwdNode.getName(),fwdNodeAttr);
            curNode.setParentRs(new Relationship(fwdField.getAttrId(),true));
        }else{//referenced by
            FieldNode bwdField = getFieldNode(curNode.getName(),fwdNodeAttr);
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

    @Override
    public void exitTo(RouteQueryParser.ToContext ctx){

    }

    @Override
    public void exitBy(RouteQueryParser.ByContext ctx){

    }

    @Override
    public void exitFwd_node(RouteQueryParser.Fwd_nodeContext ctx){

    }

    @Override
    public void exitBwd_node(RouteQueryParser.Bwd_nodeContext ctx){

    }
    @Override public void exitEntity(RouteQueryParser.EntityContext ctx) {
        String tableName = ctx.getText();
        entities.push(tableName);
    }

    @Override
    public void exitEntity_node(RouteQueryParser.Entity_nodeContext ctx){
        IntegrationQueryDto intQuery = new IntegrationQueryDto();
        String tableName = entities.pop();
        intQuery.setName(tableName);
        DynamicEntityMeta meta = entityMap.get(tableName);
        if(meta == null){
            throw new CmdbExpressException(String.format("Can't find ci type for '%s'",tableName));
        }
        intQuery.setCiTypeId(meta.getCiTypeId());

        while(conditions.size()>0) {
            Filter filter = conditions.pop();
            String filterName = filter.getName();
            String[] frags = filterName.split(ATTR_REG_SPLITTER);
            String attrName = frags[1];
            FieldNode fieldNode = meta.getFieldNode(attrName);
            if (fieldNode == null) {
                throw new CmdbExpressException(String.format("Can't find field (%s) for ci type ('%s')", attrName, tableName));
            }
            intQuery.getAttrs().add(fieldNode.getAttrId());
            intQuery.getAttrKeyNames().add(tableName + ATTR_DELIMITER + attrName);
            adhocIntegrationQuery.getQueryRequest().getFilters().add(filter);
        }
        integrationChain.add(intQuery);
    }

    private FieldNode getFieldNode(String tableName,String attrName){
        DynamicEntityMeta meta = entityMap.get(tableName);
        if(meta == null){
            throw new CmdbExpressException(String.format("Can't find ci type for '%s'",tableName));
        }
        FieldNode fieldNode = meta.getFieldNode(attrName);
        if (fieldNode == null) {
            throw new CmdbExpressException(String.format("Can't find field (%s) for ci type ('%s')", attrName, tableName));
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
    public void exitAttr_array(RouteQueryParser.Attr_arrayContext ctx){

    }

    @Override
    public void exitConditionEq(RouteQueryParser.ConditionEqContext ctx){
        Object val = values.pop();
        conditions.push(new Filter(getAttrKeyname(entities.peek(),ctx.attr().getText()), FilterOperator.Equal.getCode(),val));
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
            conditions.push(new Filter(getAttrKeyname(entities.peek(),ctx.attr().getText()), FilterOperator.Greater.getCode(),val));
        }else{
            throw new CmdbExpressException(String.format("gt operator should apply on number (not %s).",String.valueOf(val)));
        }
    }

    @Override
    public void exitConditionLt(RouteQueryParser.ConditionLtContext ctx){
        Object val = values.pop();
        if(val instanceof  Number){
            conditions.push(new Filter(getAttrKeyname(entities.peek(),ctx.attr().getText()), FilterOperator.Less.getCode(),val));
        }else{
            throw new CmdbExpressException(String.format("lt operator should apply on number (not %s).",String.valueOf(val)));
        }
    }
    public void exitConditionNe(RouteQueryParser.ConditionNeContext ctx){
        Object val = values.pop();
        conditions.push(new Filter(getAttrKeyname(entities.peek(),ctx.attr().getText()), FilterOperator.NotEqual.getCode(),val));
    }

    @Override
    public void exitConditionIn(RouteQueryParser.ConditionInContext ctx){

    }

    @Override
    public void exitConditionContains(RouteQueryParser.ConditionContainsContext ctx){
        Object val = values.pop();
        if(val instanceof  String){
            conditions.push(new Filter(getAttrKeyname(entities.peek(),ctx.attr().getText()), FilterOperator.Contains.getCode(),val));
        }else{
            throw new CmdbExpressException(String.format("contains operator should apply on number (not %s).",String.valueOf(val)));
        }

    }

    @Override
    public void exitConditionNotNull(RouteQueryParser.ConditionNotNullContext ctx){
        conditions.push(new Filter(getAttrKeyname(entities.peek(),ctx.attr().getText()), FilterOperator.NotNull.getCode(),null));
    }

    @Override
    public void exitConditionIsNull(RouteQueryParser.ConditionIsNullContext ctx){
        conditions.push(new Filter(getAttrKeyname(entities.peek(),ctx.attr().getText()), FilterOperator.Null.getCode(),null));
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
        values.push(trimStringVal(ctx.getText()));
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
        values.push(number);
    }

    @Override
    public void exitValBool(RouteQueryParser.ValBoolContext ctx){

    }

    @Override
    public void exitValNull(RouteQueryParser.ValNullContext ctx){

    }
}
