// Generated from .\RouteQuery.g4 by ANTLR 4.8
package com.webank.cmdb.expression.antlr4;
import org.antlr.v4.runtime.tree.ParseTreeListener;

/**
 * This interface defines a complete listener for a parse tree produced by
 * {@link RouteQueryParser}.
 */
public interface RouteQueryListener extends ParseTreeListener {
	/**
	 * Enter a parse tree produced by the {@code LinkFetch}
	 * labeled alternative in {@link RouteQueryParser#route}.
	 * @param ctx the parse tree
	 */
	void enterLinkFetch(RouteQueryParser.LinkFetchContext ctx);
	/**
	 * Exit a parse tree produced by the {@code LinkFetch}
	 * labeled alternative in {@link RouteQueryParser#route}.
	 * @param ctx the parse tree
	 */
	void exitLinkFetch(RouteQueryParser.LinkFetchContext ctx);
	/**
	 * Enter a parse tree produced by the {@code EntityFetch}
	 * labeled alternative in {@link RouteQueryParser#route}.
	 * @param ctx the parse tree
	 */
	void enterEntityFetch(RouteQueryParser.EntityFetchContext ctx);
	/**
	 * Exit a parse tree produced by the {@code EntityFetch}
	 * labeled alternative in {@link RouteQueryParser#route}.
	 * @param ctx the parse tree
	 */
	void exitEntityFetch(RouteQueryParser.EntityFetchContext ctx);
	/**
	 * Enter a parse tree produced by the {@code LinkToEntity}
	 * labeled alternative in {@link RouteQueryParser#link}.
	 * @param ctx the parse tree
	 */
	void enterLinkToEntity(RouteQueryParser.LinkToEntityContext ctx);
	/**
	 * Exit a parse tree produced by the {@code LinkToEntity}
	 * labeled alternative in {@link RouteQueryParser#link}.
	 * @param ctx the parse tree
	 */
	void exitLinkToEntity(RouteQueryParser.LinkToEntityContext ctx);
	/**
	 * Enter a parse tree produced by the {@code FwdNodeToEntity}
	 * labeled alternative in {@link RouteQueryParser#link}.
	 * @param ctx the parse tree
	 */
	void enterFwdNodeToEntity(RouteQueryParser.FwdNodeToEntityContext ctx);
	/**
	 * Exit a parse tree produced by the {@code FwdNodeToEntity}
	 * labeled alternative in {@link RouteQueryParser#link}.
	 * @param ctx the parse tree
	 */
	void exitFwdNodeToEntity(RouteQueryParser.FwdNodeToEntityContext ctx);
	/**
	 * Enter a parse tree produced by the {@code LinkByBwdNode}
	 * labeled alternative in {@link RouteQueryParser#link}.
	 * @param ctx the parse tree
	 */
	void enterLinkByBwdNode(RouteQueryParser.LinkByBwdNodeContext ctx);
	/**
	 * Exit a parse tree produced by the {@code LinkByBwdNode}
	 * labeled alternative in {@link RouteQueryParser#link}.
	 * @param ctx the parse tree
	 */
	void exitLinkByBwdNode(RouteQueryParser.LinkByBwdNodeContext ctx);
	/**
	 * Enter a parse tree produced by the {@code EntityByBwdNode}
	 * labeled alternative in {@link RouteQueryParser#link}.
	 * @param ctx the parse tree
	 */
	void enterEntityByBwdNode(RouteQueryParser.EntityByBwdNodeContext ctx);
	/**
	 * Exit a parse tree produced by the {@code EntityByBwdNode}
	 * labeled alternative in {@link RouteQueryParser#link}.
	 * @param ctx the parse tree
	 */
	void exitEntityByBwdNode(RouteQueryParser.EntityByBwdNodeContext ctx);
	/**
	 * Enter a parse tree produced by {@link RouteQueryParser#fetch}.
	 * @param ctx the parse tree
	 */
	void enterFetch(RouteQueryParser.FetchContext ctx);
	/**
	 * Exit a parse tree produced by {@link RouteQueryParser#fetch}.
	 * @param ctx the parse tree
	 */
	void exitFetch(RouteQueryParser.FetchContext ctx);
	/**
	 * Enter a parse tree produced by {@link RouteQueryParser#to}.
	 * @param ctx the parse tree
	 */
	void enterTo(RouteQueryParser.ToContext ctx);
	/**
	 * Exit a parse tree produced by {@link RouteQueryParser#to}.
	 * @param ctx the parse tree
	 */
	void exitTo(RouteQueryParser.ToContext ctx);
	/**
	 * Enter a parse tree produced by {@link RouteQueryParser#by}.
	 * @param ctx the parse tree
	 */
	void enterBy(RouteQueryParser.ByContext ctx);
	/**
	 * Exit a parse tree produced by {@link RouteQueryParser#by}.
	 * @param ctx the parse tree
	 */
	void exitBy(RouteQueryParser.ByContext ctx);
	/**
	 * Enter a parse tree produced by {@link RouteQueryParser#fwd_node}.
	 * @param ctx the parse tree
	 */
	void enterFwd_node(RouteQueryParser.Fwd_nodeContext ctx);
	/**
	 * Exit a parse tree produced by {@link RouteQueryParser#fwd_node}.
	 * @param ctx the parse tree
	 */
	void exitFwd_node(RouteQueryParser.Fwd_nodeContext ctx);
	/**
	 * Enter a parse tree produced by {@link RouteQueryParser#bwd_node}.
	 * @param ctx the parse tree
	 */
	void enterBwd_node(RouteQueryParser.Bwd_nodeContext ctx);
	/**
	 * Exit a parse tree produced by {@link RouteQueryParser#bwd_node}.
	 * @param ctx the parse tree
	 */
	void exitBwd_node(RouteQueryParser.Bwd_nodeContext ctx);
	/**
	 * Enter a parse tree produced by {@link RouteQueryParser#entity_node}.
	 * @param ctx the parse tree
	 */
	void enterEntity_node(RouteQueryParser.Entity_nodeContext ctx);
	/**
	 * Exit a parse tree produced by {@link RouteQueryParser#entity_node}.
	 * @param ctx the parse tree
	 */
	void exitEntity_node(RouteQueryParser.Entity_nodeContext ctx);
	/**
	 * Enter a parse tree produced by {@link RouteQueryParser#entity}.
	 * @param ctx the parse tree
	 */
	void enterEntity(RouteQueryParser.EntityContext ctx);
	/**
	 * Exit a parse tree produced by {@link RouteQueryParser#entity}.
	 * @param ctx the parse tree
	 */
	void exitEntity(RouteQueryParser.EntityContext ctx);
	/**
	 * Enter a parse tree produced by {@link RouteQueryParser#attr}.
	 * @param ctx the parse tree
	 */
	void enterAttr(RouteQueryParser.AttrContext ctx);
	/**
	 * Exit a parse tree produced by {@link RouteQueryParser#attr}.
	 * @param ctx the parse tree
	 */
	void exitAttr(RouteQueryParser.AttrContext ctx);
	/**
	 * Enter a parse tree produced by {@link RouteQueryParser#attr_array}.
	 * @param ctx the parse tree
	 */
	void enterAttr_array(RouteQueryParser.Attr_arrayContext ctx);
	/**
	 * Exit a parse tree produced by {@link RouteQueryParser#attr_array}.
	 * @param ctx the parse tree
	 */
	void exitAttr_array(RouteQueryParser.Attr_arrayContext ctx);
	/**
	 * Enter a parse tree produced by {@link RouteQueryParser#cond_array}.
	 * @param ctx the parse tree
	 */
	void enterCond_array(RouteQueryParser.Cond_arrayContext ctx);
	/**
	 * Exit a parse tree produced by {@link RouteQueryParser#cond_array}.
	 * @param ctx the parse tree
	 */
	void exitCond_array(RouteQueryParser.Cond_arrayContext ctx);
	/**
	 * Enter a parse tree produced by the {@code ConditionEq}
	 * labeled alternative in {@link RouteQueryParser#condition}.
	 * @param ctx the parse tree
	 */
	void enterConditionEq(RouteQueryParser.ConditionEqContext ctx);
	/**
	 * Exit a parse tree produced by the {@code ConditionEq}
	 * labeled alternative in {@link RouteQueryParser#condition}.
	 * @param ctx the parse tree
	 */
	void exitConditionEq(RouteQueryParser.ConditionEqContext ctx);
	/**
	 * Enter a parse tree produced by the {@code ConditionGt}
	 * labeled alternative in {@link RouteQueryParser#condition}.
	 * @param ctx the parse tree
	 */
	void enterConditionGt(RouteQueryParser.ConditionGtContext ctx);
	/**
	 * Exit a parse tree produced by the {@code ConditionGt}
	 * labeled alternative in {@link RouteQueryParser#condition}.
	 * @param ctx the parse tree
	 */
	void exitConditionGt(RouteQueryParser.ConditionGtContext ctx);
	/**
	 * Enter a parse tree produced by the {@code ConditionLt}
	 * labeled alternative in {@link RouteQueryParser#condition}.
	 * @param ctx the parse tree
	 */
	void enterConditionLt(RouteQueryParser.ConditionLtContext ctx);
	/**
	 * Exit a parse tree produced by the {@code ConditionLt}
	 * labeled alternative in {@link RouteQueryParser#condition}.
	 * @param ctx the parse tree
	 */
	void exitConditionLt(RouteQueryParser.ConditionLtContext ctx);
	/**
	 * Enter a parse tree produced by the {@code ConditionNe}
	 * labeled alternative in {@link RouteQueryParser#condition}.
	 * @param ctx the parse tree
	 */
	void enterConditionNe(RouteQueryParser.ConditionNeContext ctx);
	/**
	 * Exit a parse tree produced by the {@code ConditionNe}
	 * labeled alternative in {@link RouteQueryParser#condition}.
	 * @param ctx the parse tree
	 */
	void exitConditionNe(RouteQueryParser.ConditionNeContext ctx);
	/**
	 * Enter a parse tree produced by the {@code ConditionIn}
	 * labeled alternative in {@link RouteQueryParser#condition}.
	 * @param ctx the parse tree
	 */
	void enterConditionIn(RouteQueryParser.ConditionInContext ctx);
	/**
	 * Exit a parse tree produced by the {@code ConditionIn}
	 * labeled alternative in {@link RouteQueryParser#condition}.
	 * @param ctx the parse tree
	 */
	void exitConditionIn(RouteQueryParser.ConditionInContext ctx);
	/**
	 * Enter a parse tree produced by the {@code ConditionContains}
	 * labeled alternative in {@link RouteQueryParser#condition}.
	 * @param ctx the parse tree
	 */
	void enterConditionContains(RouteQueryParser.ConditionContainsContext ctx);
	/**
	 * Exit a parse tree produced by the {@code ConditionContains}
	 * labeled alternative in {@link RouteQueryParser#condition}.
	 * @param ctx the parse tree
	 */
	void exitConditionContains(RouteQueryParser.ConditionContainsContext ctx);
	/**
	 * Enter a parse tree produced by the {@code ConditionNotNull}
	 * labeled alternative in {@link RouteQueryParser#condition}.
	 * @param ctx the parse tree
	 */
	void enterConditionNotNull(RouteQueryParser.ConditionNotNullContext ctx);
	/**
	 * Exit a parse tree produced by the {@code ConditionNotNull}
	 * labeled alternative in {@link RouteQueryParser#condition}.
	 * @param ctx the parse tree
	 */
	void exitConditionNotNull(RouteQueryParser.ConditionNotNullContext ctx);
	/**
	 * Enter a parse tree produced by the {@code ConditionIsNull}
	 * labeled alternative in {@link RouteQueryParser#condition}.
	 * @param ctx the parse tree
	 */
	void enterConditionIsNull(RouteQueryParser.ConditionIsNullContext ctx);
	/**
	 * Exit a parse tree produced by the {@code ConditionIsNull}
	 * labeled alternative in {@link RouteQueryParser#condition}.
	 * @param ctx the parse tree
	 */
	void exitConditionIsNull(RouteQueryParser.ConditionIsNullContext ctx);
	/**
	 * Enter a parse tree produced by {@link RouteQueryParser#array}.
	 * @param ctx the parse tree
	 */
	void enterArray(RouteQueryParser.ArrayContext ctx);
	/**
	 * Exit a parse tree produced by {@link RouteQueryParser#array}.
	 * @param ctx the parse tree
	 */
	void exitArray(RouteQueryParser.ArrayContext ctx);
	/**
	 * Enter a parse tree produced by the {@code ValString}
	 * labeled alternative in {@link RouteQueryParser#value}.
	 * @param ctx the parse tree
	 */
	void enterValString(RouteQueryParser.ValStringContext ctx);
	/**
	 * Exit a parse tree produced by the {@code ValString}
	 * labeled alternative in {@link RouteQueryParser#value}.
	 * @param ctx the parse tree
	 */
	void exitValString(RouteQueryParser.ValStringContext ctx);
	/**
	 * Enter a parse tree produced by the {@code ValNumber}
	 * labeled alternative in {@link RouteQueryParser#value}.
	 * @param ctx the parse tree
	 */
	void enterValNumber(RouteQueryParser.ValNumberContext ctx);
	/**
	 * Exit a parse tree produced by the {@code ValNumber}
	 * labeled alternative in {@link RouteQueryParser#value}.
	 * @param ctx the parse tree
	 */
	void exitValNumber(RouteQueryParser.ValNumberContext ctx);
	/**
	 * Enter a parse tree produced by the {@code ValBool}
	 * labeled alternative in {@link RouteQueryParser#value}.
	 * @param ctx the parse tree
	 */
	void enterValBool(RouteQueryParser.ValBoolContext ctx);
	/**
	 * Exit a parse tree produced by the {@code ValBool}
	 * labeled alternative in {@link RouteQueryParser#value}.
	 * @param ctx the parse tree
	 */
	void exitValBool(RouteQueryParser.ValBoolContext ctx);
	/**
	 * Enter a parse tree produced by the {@code ValNull}
	 * labeled alternative in {@link RouteQueryParser#value}.
	 * @param ctx the parse tree
	 */
	void enterValNull(RouteQueryParser.ValNullContext ctx);
	/**
	 * Exit a parse tree produced by the {@code ValNull}
	 * labeled alternative in {@link RouteQueryParser#value}.
	 * @param ctx the parse tree
	 */
	void exitValNull(RouteQueryParser.ValNullContext ctx);
}