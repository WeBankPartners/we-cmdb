// Generated from RouteQuery.g4 by ANTLR 4.8
package com.webank.cmdb.expression.antlr4;
import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.misc.*;
import org.antlr.v4.runtime.tree.*;
import java.util.List;
import java.util.Iterator;
import java.util.ArrayList;

@SuppressWarnings({"all", "warnings", "unchecked", "unused", "cast"})
public class RouteQueryParser extends Parser {
	static { RuntimeMetaData.checkVersion("4.8", RuntimeMetaData.VERSION); }

	protected static final DFA[] _decisionToDFA;
	protected static final PredictionContextCache _sharedContextCache =
		new PredictionContextCache();
	public static final int
		T__0=1, TILDE=2, GT=3, DOT=4, LP=5, RP=6, DC=7, SC=8, DQM=9, BL=10, BR=11, 
		LSB=12, RSB=13, OP_EQ=14, OP_GT=15, OP_LT=16, OP_NE=17, OP_IN=18, OP_CTAN=19, 
		OP_NN=20, OP_NL=21, OPERATOR=22, STRING=23, NUMBER=24, BOOLEAN=25, ID=26, 
		PKG_ID=27, WS=28;
	public static final int
		RULE_route = 0, RULE_link = 1, RULE_to = 2, RULE_by = 3, RULE_fwd_node = 4, 
		RULE_bwd_node = 5, RULE_entity_node = 6, RULE_fetch = 7, RULE_entity = 8, 
		RULE_attr = 9, RULE_attr_array = 10, RULE_cond_array = 11, RULE_condition = 12, 
		RULE_array = 13, RULE_value = 14;
	private static String[] makeRuleNames() {
		return new String[] {
			"route", "link", "to", "by", "fwd_node", "bwd_node", "entity_node", "fetch", 
			"entity", "attr", "attr_array", "cond_array", "condition", "array", "value"
		};
	}
	public static final String[] ruleNames = makeRuleNames();

	private static String[] makeLiteralNames() {
		return new String[] {
			null, "','", "'~'", "'>'", "'.'", "'('", "')'", null, "':'", null, "'{'", 
			"'}'", "'['", "']'", "'eq'", "'gt'", "'lt'", "'ne'", "'in'", "'contains'", 
			"'notNull'", "'null'"
		};
	}
	private static final String[] _LITERAL_NAMES = makeLiteralNames();
	private static String[] makeSymbolicNames() {
		return new String[] {
			null, null, "TILDE", "GT", "DOT", "LP", "RP", "DC", "SC", "DQM", "BL", 
			"BR", "LSB", "RSB", "OP_EQ", "OP_GT", "OP_LT", "OP_NE", "OP_IN", "OP_CTAN", 
			"OP_NN", "OP_NL", "OPERATOR", "STRING", "NUMBER", "BOOLEAN", "ID", "PKG_ID", 
			"WS"
		};
	}
	private static final String[] _SYMBOLIC_NAMES = makeSymbolicNames();
	public static final Vocabulary VOCABULARY = new VocabularyImpl(_LITERAL_NAMES, _SYMBOLIC_NAMES);

	/**
	 * @deprecated Use {@link #VOCABULARY} instead.
	 */
	@Deprecated
	public static final String[] tokenNames;
	static {
		tokenNames = new String[_SYMBOLIC_NAMES.length];
		for (int i = 0; i < tokenNames.length; i++) {
			tokenNames[i] = VOCABULARY.getLiteralName(i);
			if (tokenNames[i] == null) {
				tokenNames[i] = VOCABULARY.getSymbolicName(i);
			}

			if (tokenNames[i] == null) {
				tokenNames[i] = "<INVALID>";
			}
		}
	}

	@Override
	@Deprecated
	public String[] getTokenNames() {
		return tokenNames;
	}

	@Override

	public Vocabulary getVocabulary() {
		return VOCABULARY;
	}

	@Override
	public String getGrammarFileName() { return "RouteQuery.g4"; }

	@Override
	public String[] getRuleNames() { return ruleNames; }

	@Override
	public String getSerializedATN() { return _serializedATN; }

	@Override
	public ATN getATN() { return _ATN; }

	public RouteQueryParser(TokenStream input) {
		super(input);
		_interp = new ParserATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}

	public static class RouteContext extends ParserRuleContext {
		public RouteContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_route; }
	 
		public RouteContext() { }
		public void copyFrom(RouteContext ctx) {
			super.copyFrom(ctx);
		}
	}
	public static class EntityRouteContext extends RouteContext {
		public Entity_nodeContext entity_node() {
			return getRuleContext(Entity_nodeContext.class,0);
		}
		public EntityRouteContext(RouteContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).enterEntityRoute(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).exitEntityRoute(this);
		}
	}
	public static class LinkRouteContext extends RouteContext {
		public LinkContext link() {
			return getRuleContext(LinkContext.class,0);
		}
		public LinkRouteContext(RouteContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).enterLinkRoute(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).exitLinkRoute(this);
		}
	}

	public final RouteContext route() throws RecognitionException {
		RouteContext _localctx = new RouteContext(_ctx, getState());
		enterRule(_localctx, 0, RULE_route);
		try {
			setState(32);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,0,_ctx) ) {
			case 1:
				_localctx = new LinkRouteContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(30);
				link(0);
				}
				break;
			case 2:
				_localctx = new EntityRouteContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(31);
				entity_node();
				}
				break;
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class LinkContext extends ParserRuleContext {
		public LinkContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_link; }
	 
		public LinkContext() { }
		public void copyFrom(LinkContext ctx) {
			super.copyFrom(ctx);
		}
	}
	public static class LinkToEntityContext extends LinkContext {
		public LinkContext link() {
			return getRuleContext(LinkContext.class,0);
		}
		public TerminalNode DOT() { return getToken(RouteQueryParser.DOT, 0); }
		public AttrContext attr() {
			return getRuleContext(AttrContext.class,0);
		}
		public ToContext to() {
			return getRuleContext(ToContext.class,0);
		}
		public Entity_nodeContext entity_node() {
			return getRuleContext(Entity_nodeContext.class,0);
		}
		public LinkToEntityContext(LinkContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).enterLinkToEntity(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).exitLinkToEntity(this);
		}
	}
	public static class FwdNodeToEntityContext extends LinkContext {
		public Fwd_nodeContext fwd_node() {
			return getRuleContext(Fwd_nodeContext.class,0);
		}
		public ToContext to() {
			return getRuleContext(ToContext.class,0);
		}
		public Entity_nodeContext entity_node() {
			return getRuleContext(Entity_nodeContext.class,0);
		}
		public FwdNodeToEntityContext(LinkContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).enterFwdNodeToEntity(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).exitFwdNodeToEntity(this);
		}
	}
	public static class LinkByBwdNodeContext extends LinkContext {
		public LinkContext link() {
			return getRuleContext(LinkContext.class,0);
		}
		public ByContext by() {
			return getRuleContext(ByContext.class,0);
		}
		public Bwd_nodeContext bwd_node() {
			return getRuleContext(Bwd_nodeContext.class,0);
		}
		public LinkByBwdNodeContext(LinkContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).enterLinkByBwdNode(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).exitLinkByBwdNode(this);
		}
	}
	public static class EntityByBwdNodeContext extends LinkContext {
		public Entity_nodeContext entity_node() {
			return getRuleContext(Entity_nodeContext.class,0);
		}
		public ByContext by() {
			return getRuleContext(ByContext.class,0);
		}
		public Bwd_nodeContext bwd_node() {
			return getRuleContext(Bwd_nodeContext.class,0);
		}
		public EntityByBwdNodeContext(LinkContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).enterEntityByBwdNode(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).exitEntityByBwdNode(this);
		}
	}

	public final LinkContext link() throws RecognitionException {
		return link(0);
	}

	private LinkContext link(int _p) throws RecognitionException {
		ParserRuleContext _parentctx = _ctx;
		int _parentState = getState();
		LinkContext _localctx = new LinkContext(_ctx, _parentState);
		LinkContext _prevctx = _localctx;
		int _startState = 2;
		enterRecursionRule(_localctx, 2, RULE_link, _p);
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(43);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,1,_ctx) ) {
			case 1:
				{
				_localctx = new EntityByBwdNodeContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;

				setState(35);
				entity_node();
				setState(36);
				by();
				setState(37);
				bwd_node();
				}
				break;
			case 2:
				{
				_localctx = new FwdNodeToEntityContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(39);
				fwd_node();
				setState(40);
				to();
				setState(41);
				entity_node();
				}
				break;
			}
			_ctx.stop = _input.LT(-1);
			setState(57);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,3,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					setState(55);
					_errHandler.sync(this);
					switch ( getInterpreter().adaptivePredict(_input,2,_ctx) ) {
					case 1:
						{
						_localctx = new LinkToEntityContext(new LinkContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_link);
						setState(45);
						if (!(precpred(_ctx, 2))) throw new FailedPredicateException(this, "precpred(_ctx, 2)");
						setState(46);
						match(DOT);
						setState(47);
						attr();
						setState(48);
						to();
						setState(49);
						entity_node();
						}
						break;
					case 2:
						{
						_localctx = new LinkByBwdNodeContext(new LinkContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_link);
						setState(51);
						if (!(precpred(_ctx, 1))) throw new FailedPredicateException(this, "precpred(_ctx, 1)");
						setState(52);
						by();
						setState(53);
						bwd_node();
						}
						break;
					}
					} 
				}
				setState(59);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,3,_ctx);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			unrollRecursionContexts(_parentctx);
		}
		return _localctx;
	}

	public static class ToContext extends ParserRuleContext {
		public TerminalNode GT() { return getToken(RouteQueryParser.GT, 0); }
		public ToContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_to; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).enterTo(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).exitTo(this);
		}
	}

	public final ToContext to() throws RecognitionException {
		ToContext _localctx = new ToContext(_ctx, getState());
		enterRule(_localctx, 4, RULE_to);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(60);
			match(GT);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ByContext extends ParserRuleContext {
		public TerminalNode TILDE() { return getToken(RouteQueryParser.TILDE, 0); }
		public ByContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_by; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).enterBy(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).exitBy(this);
		}
	}

	public final ByContext by() throws RecognitionException {
		ByContext _localctx = new ByContext(_ctx, getState());
		enterRule(_localctx, 6, RULE_by);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(62);
			match(TILDE);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class Fwd_nodeContext extends ParserRuleContext {
		public Entity_nodeContext entity_node() {
			return getRuleContext(Entity_nodeContext.class,0);
		}
		public TerminalNode DOT() { return getToken(RouteQueryParser.DOT, 0); }
		public AttrContext attr() {
			return getRuleContext(AttrContext.class,0);
		}
		public Fwd_nodeContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_fwd_node; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).enterFwd_node(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).exitFwd_node(this);
		}
	}

	public final Fwd_nodeContext fwd_node() throws RecognitionException {
		Fwd_nodeContext _localctx = new Fwd_nodeContext(_ctx, getState());
		enterRule(_localctx, 8, RULE_fwd_node);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(64);
			entity_node();
			setState(65);
			match(DOT);
			setState(66);
			attr();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class Bwd_nodeContext extends ParserRuleContext {
		public TerminalNode LP() { return getToken(RouteQueryParser.LP, 0); }
		public AttrContext attr() {
			return getRuleContext(AttrContext.class,0);
		}
		public TerminalNode RP() { return getToken(RouteQueryParser.RP, 0); }
		public Entity_nodeContext entity_node() {
			return getRuleContext(Entity_nodeContext.class,0);
		}
		public Bwd_nodeContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_bwd_node; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).enterBwd_node(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).exitBwd_node(this);
		}
	}

	public final Bwd_nodeContext bwd_node() throws RecognitionException {
		Bwd_nodeContext _localctx = new Bwd_nodeContext(_ctx, getState());
		enterRule(_localctx, 10, RULE_bwd_node);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(68);
			match(LP);
			setState(69);
			attr();
			setState(70);
			match(RP);
			setState(71);
			entity_node();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class Entity_nodeContext extends ParserRuleContext {
		public EntityContext entity() {
			return getRuleContext(EntityContext.class,0);
		}
		public FetchContext fetch() {
			return getRuleContext(FetchContext.class,0);
		}
		public ConditionContext condition() {
			return getRuleContext(ConditionContext.class,0);
		}
		public Cond_arrayContext cond_array() {
			return getRuleContext(Cond_arrayContext.class,0);
		}
		public Entity_nodeContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_entity_node; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).enterEntity_node(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).exitEntity_node(this);
		}
	}

	public final Entity_nodeContext entity_node() throws RecognitionException {
		Entity_nodeContext _localctx = new Entity_nodeContext(_ctx, getState());
		enterRule(_localctx, 12, RULE_entity_node);
		try {
			setState(87);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,7,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				setState(73);
				entity();
				setState(75);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,4,_ctx) ) {
				case 1:
					{
					setState(74);
					fetch();
					}
					break;
				}
				}
				break;
			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(77);
				entity();
				setState(78);
				condition();
				setState(80);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,5,_ctx) ) {
				case 1:
					{
					setState(79);
					fetch();
					}
					break;
				}
				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(82);
				entity();
				setState(83);
				cond_array();
				setState(85);
				_errHandler.sync(this);
				switch ( getInterpreter().adaptivePredict(_input,6,_ctx) ) {
				case 1:
					{
					setState(84);
					fetch();
					}
					break;
				}
				}
				break;
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class FetchContext extends ParserRuleContext {
		public TerminalNode SC() { return getToken(RouteQueryParser.SC, 0); }
		public AttrContext attr() {
			return getRuleContext(AttrContext.class,0);
		}
		public Attr_arrayContext attr_array() {
			return getRuleContext(Attr_arrayContext.class,0);
		}
		public FetchContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_fetch; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).enterFetch(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).exitFetch(this);
		}
	}

	public final FetchContext fetch() throws RecognitionException {
		FetchContext _localctx = new FetchContext(_ctx, getState());
		enterRule(_localctx, 14, RULE_fetch);
		try {
			setState(93);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,8,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				setState(89);
				match(SC);
				setState(90);
				attr();
				}
				break;
			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(91);
				match(SC);
				setState(92);
				attr_array();
				}
				break;
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class EntityContext extends ParserRuleContext {
		public TerminalNode ID() { return getToken(RouteQueryParser.ID, 0); }
		public EntityContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_entity; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).enterEntity(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).exitEntity(this);
		}
	}

	public final EntityContext entity() throws RecognitionException {
		EntityContext _localctx = new EntityContext(_ctx, getState());
		enterRule(_localctx, 16, RULE_entity);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(95);
			match(ID);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class AttrContext extends ParserRuleContext {
		public TerminalNode ID() { return getToken(RouteQueryParser.ID, 0); }
		public AttrContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_attr; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).enterAttr(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).exitAttr(this);
		}
	}

	public final AttrContext attr() throws RecognitionException {
		AttrContext _localctx = new AttrContext(_ctx, getState());
		enterRule(_localctx, 18, RULE_attr);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(97);
			match(ID);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class Attr_arrayContext extends ParserRuleContext {
		public TerminalNode LSB() { return getToken(RouteQueryParser.LSB, 0); }
		public List<AttrContext> attr() {
			return getRuleContexts(AttrContext.class);
		}
		public AttrContext attr(int i) {
			return getRuleContext(AttrContext.class,i);
		}
		public TerminalNode RSB() { return getToken(RouteQueryParser.RSB, 0); }
		public Attr_arrayContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_attr_array; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).enterAttr_array(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).exitAttr_array(this);
		}
	}

	public final Attr_arrayContext attr_array() throws RecognitionException {
		Attr_arrayContext _localctx = new Attr_arrayContext(_ctx, getState());
		enterRule(_localctx, 20, RULE_attr_array);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(99);
			match(LSB);
			setState(100);
			attr();
			setState(105);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==T__0) {
				{
				{
				setState(101);
				match(T__0);
				setState(102);
				attr();
				}
				}
				setState(107);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(108);
			match(RSB);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class Cond_arrayContext extends ParserRuleContext {
		public TerminalNode LSB() { return getToken(RouteQueryParser.LSB, 0); }
		public List<ConditionContext> condition() {
			return getRuleContexts(ConditionContext.class);
		}
		public ConditionContext condition(int i) {
			return getRuleContext(ConditionContext.class,i);
		}
		public TerminalNode RSB() { return getToken(RouteQueryParser.RSB, 0); }
		public Cond_arrayContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_cond_array; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).enterCond_array(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).exitCond_array(this);
		}
	}

	public final Cond_arrayContext cond_array() throws RecognitionException {
		Cond_arrayContext _localctx = new Cond_arrayContext(_ctx, getState());
		enterRule(_localctx, 22, RULE_cond_array);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(110);
			match(LSB);
			setState(111);
			condition();
			setState(116);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==T__0) {
				{
				{
				setState(112);
				match(T__0);
				setState(113);
				condition();
				}
				}
				setState(118);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(119);
			match(RSB);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ConditionContext extends ParserRuleContext {
		public ConditionContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_condition; }
	 
		public ConditionContext() { }
		public void copyFrom(ConditionContext ctx) {
			super.copyFrom(ctx);
		}
	}
	public static class ConditionNotNullContext extends ConditionContext {
		public TerminalNode BL() { return getToken(RouteQueryParser.BL, 0); }
		public AttrContext attr() {
			return getRuleContext(AttrContext.class,0);
		}
		public TerminalNode OP_NN() { return getToken(RouteQueryParser.OP_NN, 0); }
		public TerminalNode BR() { return getToken(RouteQueryParser.BR, 0); }
		public ConditionNotNullContext(ConditionContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).enterConditionNotNull(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).exitConditionNotNull(this);
		}
	}
	public static class ConditionGtContext extends ConditionContext {
		public TerminalNode BL() { return getToken(RouteQueryParser.BL, 0); }
		public AttrContext attr() {
			return getRuleContext(AttrContext.class,0);
		}
		public TerminalNode ID() { return getToken(RouteQueryParser.ID, 0); }
		public TerminalNode OP_GT() { return getToken(RouteQueryParser.OP_GT, 0); }
		public ValueContext value() {
			return getRuleContext(ValueContext.class,0);
		}
		public TerminalNode BR() { return getToken(RouteQueryParser.BR, 0); }
		public ConditionGtContext(ConditionContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).enterConditionGt(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).exitConditionGt(this);
		}
	}
	public static class ConditionIsNullContext extends ConditionContext {
		public TerminalNode BL() { return getToken(RouteQueryParser.BL, 0); }
		public AttrContext attr() {
			return getRuleContext(AttrContext.class,0);
		}
		public TerminalNode OP_NL() { return getToken(RouteQueryParser.OP_NL, 0); }
		public TerminalNode BR() { return getToken(RouteQueryParser.BR, 0); }
		public ConditionIsNullContext(ConditionContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).enterConditionIsNull(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).exitConditionIsNull(this);
		}
	}
	public static class ConditionContainsContext extends ConditionContext {
		public TerminalNode BL() { return getToken(RouteQueryParser.BL, 0); }
		public AttrContext attr() {
			return getRuleContext(AttrContext.class,0);
		}
		public TerminalNode OP_CTAN() { return getToken(RouteQueryParser.OP_CTAN, 0); }
		public TerminalNode STRING() { return getToken(RouteQueryParser.STRING, 0); }
		public TerminalNode BR() { return getToken(RouteQueryParser.BR, 0); }
		public ConditionContainsContext(ConditionContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).enterConditionContains(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).exitConditionContains(this);
		}
	}
	public static class ConditionEqContext extends ConditionContext {
		public TerminalNode BL() { return getToken(RouteQueryParser.BL, 0); }
		public AttrContext attr() {
			return getRuleContext(AttrContext.class,0);
		}
		public TerminalNode OP_EQ() { return getToken(RouteQueryParser.OP_EQ, 0); }
		public ValueContext value() {
			return getRuleContext(ValueContext.class,0);
		}
		public TerminalNode BR() { return getToken(RouteQueryParser.BR, 0); }
		public ConditionEqContext(ConditionContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).enterConditionEq(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).exitConditionEq(this);
		}
	}
	public static class ConditionInContext extends ConditionContext {
		public TerminalNode BL() { return getToken(RouteQueryParser.BL, 0); }
		public AttrContext attr() {
			return getRuleContext(AttrContext.class,0);
		}
		public TerminalNode OP_IN() { return getToken(RouteQueryParser.OP_IN, 0); }
		public ArrayContext array() {
			return getRuleContext(ArrayContext.class,0);
		}
		public TerminalNode BR() { return getToken(RouteQueryParser.BR, 0); }
		public ConditionInContext(ConditionContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).enterConditionIn(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).exitConditionIn(this);
		}
	}
	public static class ConditionNeContext extends ConditionContext {
		public TerminalNode BL() { return getToken(RouteQueryParser.BL, 0); }
		public AttrContext attr() {
			return getRuleContext(AttrContext.class,0);
		}
		public TerminalNode OP_NE() { return getToken(RouteQueryParser.OP_NE, 0); }
		public ValueContext value() {
			return getRuleContext(ValueContext.class,0);
		}
		public TerminalNode BR() { return getToken(RouteQueryParser.BR, 0); }
		public ConditionNeContext(ConditionContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).enterConditionNe(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).exitConditionNe(this);
		}
	}
	public static class ConditionLtContext extends ConditionContext {
		public TerminalNode BL() { return getToken(RouteQueryParser.BL, 0); }
		public AttrContext attr() {
			return getRuleContext(AttrContext.class,0);
		}
		public TerminalNode OP_LT() { return getToken(RouteQueryParser.OP_LT, 0); }
		public ValueContext value() {
			return getRuleContext(ValueContext.class,0);
		}
		public TerminalNode BR() { return getToken(RouteQueryParser.BR, 0); }
		public ConditionLtContext(ConditionContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).enterConditionLt(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).exitConditionLt(this);
		}
	}

	public final ConditionContext condition() throws RecognitionException {
		ConditionContext _localctx = new ConditionContext(_ctx, getState());
		enterRule(_localctx, 24, RULE_condition);
		try {
			setState(168);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,11,_ctx) ) {
			case 1:
				_localctx = new ConditionEqContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(121);
				match(BL);
				setState(122);
				attr();
				setState(123);
				match(OP_EQ);
				setState(124);
				value();
				setState(125);
				match(BR);
				}
				break;
			case 2:
				_localctx = new ConditionGtContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(127);
				match(BL);
				setState(128);
				attr();
				setState(129);
				match(ID);
				setState(130);
				match(OP_GT);
				setState(131);
				value();
				setState(132);
				match(BR);
				}
				break;
			case 3:
				_localctx = new ConditionLtContext(_localctx);
				enterOuterAlt(_localctx, 3);
				{
				setState(134);
				match(BL);
				setState(135);
				attr();
				setState(136);
				match(OP_LT);
				setState(137);
				value();
				setState(138);
				match(BR);
				}
				break;
			case 4:
				_localctx = new ConditionNeContext(_localctx);
				enterOuterAlt(_localctx, 4);
				{
				setState(140);
				match(BL);
				setState(141);
				attr();
				setState(142);
				match(OP_NE);
				setState(143);
				value();
				setState(144);
				match(BR);
				}
				break;
			case 5:
				_localctx = new ConditionInContext(_localctx);
				enterOuterAlt(_localctx, 5);
				{
				setState(146);
				match(BL);
				setState(147);
				attr();
				setState(148);
				match(OP_IN);
				setState(149);
				array();
				setState(150);
				match(BR);
				}
				break;
			case 6:
				_localctx = new ConditionContainsContext(_localctx);
				enterOuterAlt(_localctx, 6);
				{
				setState(152);
				match(BL);
				setState(153);
				attr();
				setState(154);
				match(OP_CTAN);
				setState(155);
				match(STRING);
				setState(156);
				match(BR);
				}
				break;
			case 7:
				_localctx = new ConditionNotNullContext(_localctx);
				enterOuterAlt(_localctx, 7);
				{
				setState(158);
				match(BL);
				setState(159);
				attr();
				setState(160);
				match(OP_NN);
				setState(161);
				match(BR);
				}
				break;
			case 8:
				_localctx = new ConditionIsNullContext(_localctx);
				enterOuterAlt(_localctx, 8);
				{
				setState(163);
				match(BL);
				setState(164);
				attr();
				setState(165);
				match(OP_NL);
				setState(166);
				match(BR);
				}
				break;
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ArrayContext extends ParserRuleContext {
		public TerminalNode LSB() { return getToken(RouteQueryParser.LSB, 0); }
		public List<ValueContext> value() {
			return getRuleContexts(ValueContext.class);
		}
		public ValueContext value(int i) {
			return getRuleContext(ValueContext.class,i);
		}
		public TerminalNode RSB() { return getToken(RouteQueryParser.RSB, 0); }
		public ArrayContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_array; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).enterArray(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).exitArray(this);
		}
	}

	public final ArrayContext array() throws RecognitionException {
		ArrayContext _localctx = new ArrayContext(_ctx, getState());
		enterRule(_localctx, 26, RULE_array);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(170);
			match(LSB);
			setState(171);
			value();
			setState(176);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==T__0) {
				{
				{
				setState(172);
				match(T__0);
				setState(173);
				value();
				}
				}
				setState(178);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(179);
			match(RSB);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ValueContext extends ParserRuleContext {
		public ValueContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_value; }
	 
		public ValueContext() { }
		public void copyFrom(ValueContext ctx) {
			super.copyFrom(ctx);
		}
	}
	public static class ValNumberContext extends ValueContext {
		public TerminalNode NUMBER() { return getToken(RouteQueryParser.NUMBER, 0); }
		public ValNumberContext(ValueContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).enterValNumber(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).exitValNumber(this);
		}
	}
	public static class ValBoolContext extends ValueContext {
		public TerminalNode BOOLEAN() { return getToken(RouteQueryParser.BOOLEAN, 0); }
		public ValBoolContext(ValueContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).enterValBool(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).exitValBool(this);
		}
	}
	public static class ValStringContext extends ValueContext {
		public TerminalNode STRING() { return getToken(RouteQueryParser.STRING, 0); }
		public ValStringContext(ValueContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).enterValString(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).exitValString(this);
		}
	}
	public static class ValNullContext extends ValueContext {
		public TerminalNode OP_NL() { return getToken(RouteQueryParser.OP_NL, 0); }
		public ValNullContext(ValueContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).enterValNull(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).exitValNull(this);
		}
	}

	public final ValueContext value() throws RecognitionException {
		ValueContext _localctx = new ValueContext(_ctx, getState());
		enterRule(_localctx, 28, RULE_value);
		try {
			setState(185);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case STRING:
				_localctx = new ValStringContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(181);
				match(STRING);
				}
				break;
			case NUMBER:
				_localctx = new ValNumberContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(182);
				match(NUMBER);
				}
				break;
			case BOOLEAN:
				_localctx = new ValBoolContext(_localctx);
				enterOuterAlt(_localctx, 3);
				{
				setState(183);
				match(BOOLEAN);
				}
				break;
			case OP_NL:
				_localctx = new ValNullContext(_localctx);
				enterOuterAlt(_localctx, 4);
				{
				setState(184);
				match(OP_NL);
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public boolean sempred(RuleContext _localctx, int ruleIndex, int predIndex) {
		switch (ruleIndex) {
		case 1:
			return link_sempred((LinkContext)_localctx, predIndex);
		}
		return true;
	}
	private boolean link_sempred(LinkContext _localctx, int predIndex) {
		switch (predIndex) {
		case 0:
			return precpred(_ctx, 2);
		case 1:
			return precpred(_ctx, 1);
		}
		return true;
	}

	public static final String _serializedATN =
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\3\36\u00be\4\2\t\2"+
		"\4\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n\t\n\4\13"+
		"\t\13\4\f\t\f\4\r\t\r\4\16\t\16\4\17\t\17\4\20\t\20\3\2\3\2\5\2#\n\2\3"+
		"\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\5\3.\n\3\3\3\3\3\3\3\3\3\3\3\3\3\3"+
		"\3\3\3\3\3\3\3\7\3:\n\3\f\3\16\3=\13\3\3\4\3\4\3\5\3\5\3\6\3\6\3\6\3\6"+
		"\3\7\3\7\3\7\3\7\3\7\3\b\3\b\5\bN\n\b\3\b\3\b\3\b\5\bS\n\b\3\b\3\b\3\b"+
		"\5\bX\n\b\5\bZ\n\b\3\t\3\t\3\t\3\t\5\t`\n\t\3\n\3\n\3\13\3\13\3\f\3\f"+
		"\3\f\3\f\7\fj\n\f\f\f\16\fm\13\f\3\f\3\f\3\r\3\r\3\r\3\r\7\ru\n\r\f\r"+
		"\16\rx\13\r\3\r\3\r\3\16\3\16\3\16\3\16\3\16\3\16\3\16\3\16\3\16\3\16"+
		"\3\16\3\16\3\16\3\16\3\16\3\16\3\16\3\16\3\16\3\16\3\16\3\16\3\16\3\16"+
		"\3\16\3\16\3\16\3\16\3\16\3\16\3\16\3\16\3\16\3\16\3\16\3\16\3\16\3\16"+
		"\3\16\3\16\3\16\3\16\3\16\3\16\3\16\3\16\3\16\5\16\u00ab\n\16\3\17\3\17"+
		"\3\17\3\17\7\17\u00b1\n\17\f\17\16\17\u00b4\13\17\3\17\3\17\3\20\3\20"+
		"\3\20\3\20\5\20\u00bc\n\20\3\20\2\3\4\21\2\4\6\b\n\f\16\20\22\24\26\30"+
		"\32\34\36\2\2\2\u00c5\2\"\3\2\2\2\4-\3\2\2\2\6>\3\2\2\2\b@\3\2\2\2\nB"+
		"\3\2\2\2\fF\3\2\2\2\16Y\3\2\2\2\20_\3\2\2\2\22a\3\2\2\2\24c\3\2\2\2\26"+
		"e\3\2\2\2\30p\3\2\2\2\32\u00aa\3\2\2\2\34\u00ac\3\2\2\2\36\u00bb\3\2\2"+
		"\2 #\5\4\3\2!#\5\16\b\2\" \3\2\2\2\"!\3\2\2\2#\3\3\2\2\2$%\b\3\1\2%&\5"+
		"\16\b\2&\'\5\b\5\2\'(\5\f\7\2(.\3\2\2\2)*\5\n\6\2*+\5\6\4\2+,\5\16\b\2"+
		",.\3\2\2\2-$\3\2\2\2-)\3\2\2\2.;\3\2\2\2/\60\f\4\2\2\60\61\7\6\2\2\61"+
		"\62\5\24\13\2\62\63\5\6\4\2\63\64\5\16\b\2\64:\3\2\2\2\65\66\f\3\2\2\66"+
		"\67\5\b\5\2\678\5\f\7\28:\3\2\2\29/\3\2\2\29\65\3\2\2\2:=\3\2\2\2;9\3"+
		"\2\2\2;<\3\2\2\2<\5\3\2\2\2=;\3\2\2\2>?\7\5\2\2?\7\3\2\2\2@A\7\4\2\2A"+
		"\t\3\2\2\2BC\5\16\b\2CD\7\6\2\2DE\5\24\13\2E\13\3\2\2\2FG\7\7\2\2GH\5"+
		"\24\13\2HI\7\b\2\2IJ\5\16\b\2J\r\3\2\2\2KM\5\22\n\2LN\5\20\t\2ML\3\2\2"+
		"\2MN\3\2\2\2NZ\3\2\2\2OP\5\22\n\2PR\5\32\16\2QS\5\20\t\2RQ\3\2\2\2RS\3"+
		"\2\2\2SZ\3\2\2\2TU\5\22\n\2UW\5\30\r\2VX\5\20\t\2WV\3\2\2\2WX\3\2\2\2"+
		"XZ\3\2\2\2YK\3\2\2\2YO\3\2\2\2YT\3\2\2\2Z\17\3\2\2\2[\\\7\n\2\2\\`\5\24"+
		"\13\2]^\7\n\2\2^`\5\26\f\2_[\3\2\2\2_]\3\2\2\2`\21\3\2\2\2ab\7\34\2\2"+
		"b\23\3\2\2\2cd\7\34\2\2d\25\3\2\2\2ef\7\16\2\2fk\5\24\13\2gh\7\3\2\2h"+
		"j\5\24\13\2ig\3\2\2\2jm\3\2\2\2ki\3\2\2\2kl\3\2\2\2ln\3\2\2\2mk\3\2\2"+
		"\2no\7\17\2\2o\27\3\2\2\2pq\7\16\2\2qv\5\32\16\2rs\7\3\2\2su\5\32\16\2"+
		"tr\3\2\2\2ux\3\2\2\2vt\3\2\2\2vw\3\2\2\2wy\3\2\2\2xv\3\2\2\2yz\7\17\2"+
		"\2z\31\3\2\2\2{|\7\f\2\2|}\5\24\13\2}~\7\20\2\2~\177\5\36\20\2\177\u0080"+
		"\7\r\2\2\u0080\u00ab\3\2\2\2\u0081\u0082\7\f\2\2\u0082\u0083\5\24\13\2"+
		"\u0083\u0084\7\34\2\2\u0084\u0085\7\21\2\2\u0085\u0086\5\36\20\2\u0086"+
		"\u0087\7\r\2\2\u0087\u00ab\3\2\2\2\u0088\u0089\7\f\2\2\u0089\u008a\5\24"+
		"\13\2\u008a\u008b\7\22\2\2\u008b\u008c\5\36\20\2\u008c\u008d\7\r\2\2\u008d"+
		"\u00ab\3\2\2\2\u008e\u008f\7\f\2\2\u008f\u0090\5\24\13\2\u0090\u0091\7"+
		"\23\2\2\u0091\u0092\5\36\20\2\u0092\u0093\7\r\2\2\u0093\u00ab\3\2\2\2"+
		"\u0094\u0095\7\f\2\2\u0095\u0096\5\24\13\2\u0096\u0097\7\24\2\2\u0097"+
		"\u0098\5\34\17\2\u0098\u0099\7\r\2\2\u0099\u00ab\3\2\2\2\u009a\u009b\7"+
		"\f\2\2\u009b\u009c\5\24\13\2\u009c\u009d\7\25\2\2\u009d\u009e\7\31\2\2"+
		"\u009e\u009f\7\r\2\2\u009f\u00ab\3\2\2\2\u00a0\u00a1\7\f\2\2\u00a1\u00a2"+
		"\5\24\13\2\u00a2\u00a3\7\26\2\2\u00a3\u00a4\7\r\2\2\u00a4\u00ab\3\2\2"+
		"\2\u00a5\u00a6\7\f\2\2\u00a6\u00a7\5\24\13\2\u00a7\u00a8\7\27\2\2\u00a8"+
		"\u00a9\7\r\2\2\u00a9\u00ab\3\2\2\2\u00aa{\3\2\2\2\u00aa\u0081\3\2\2\2"+
		"\u00aa\u0088\3\2\2\2\u00aa\u008e\3\2\2\2\u00aa\u0094\3\2\2\2\u00aa\u009a"+
		"\3\2\2\2\u00aa\u00a0\3\2\2\2\u00aa\u00a5\3\2\2\2\u00ab\33\3\2\2\2\u00ac"+
		"\u00ad\7\16\2\2\u00ad\u00b2\5\36\20\2\u00ae\u00af\7\3\2\2\u00af\u00b1"+
		"\5\36\20\2\u00b0\u00ae\3\2\2\2\u00b1\u00b4\3\2\2\2\u00b2\u00b0\3\2\2\2"+
		"\u00b2\u00b3\3\2\2\2\u00b3\u00b5\3\2\2\2\u00b4\u00b2\3\2\2\2\u00b5\u00b6"+
		"\7\17\2\2\u00b6\35\3\2\2\2\u00b7\u00bc\7\31\2\2\u00b8\u00bc\7\32\2\2\u00b9"+
		"\u00bc\7\33\2\2\u00ba\u00bc\7\27\2\2\u00bb\u00b7\3\2\2\2\u00bb\u00b8\3"+
		"\2\2\2\u00bb\u00b9\3\2\2\2\u00bb\u00ba\3\2\2\2\u00bc\37\3\2\2\2\20\"-"+
		"9;MRWY_kv\u00aa\u00b2\u00bb";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}