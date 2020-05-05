// Generated from .\RouteQuery.g4 by ANTLR 4.8
package com.webank.cmdb.expression.antlr4;
import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.*;
import java.util.List;

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
		RULE_route = 0, RULE_link = 1, RULE_fetch = 2, RULE_to = 3, RULE_by = 4, 
		RULE_fwd_node = 5, RULE_bwd_node = 6, RULE_entity_node = 7, RULE_entity = 8, 
		RULE_attr = 9, RULE_attr_array = 10, RULE_cond_array = 11, RULE_condition = 12, 
		RULE_array = 13, RULE_value = 14;
	private static String[] makeRuleNames() {
		return new String[] {
			"route", "link", "fetch", "to", "by", "fwd_node", "bwd_node", "entity_node", 
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
	public static class EntityFetchContext extends RouteContext {
		public Entity_nodeContext entity_node() {
			return getRuleContext(Entity_nodeContext.class,0);
		}
		public FetchContext fetch() {
			return getRuleContext(FetchContext.class,0);
		}
		public EntityFetchContext(RouteContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).enterEntityFetch(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).exitEntityFetch(this);
		}
	}
	public static class LinkFetchContext extends RouteContext {
		public LinkContext link() {
			return getRuleContext(LinkContext.class,0);
		}
		public FetchContext fetch() {
			return getRuleContext(FetchContext.class,0);
		}
		public LinkFetchContext(RouteContext ctx) { copyFrom(ctx); }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).enterLinkFetch(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof RouteQueryListener ) ((RouteQueryListener)listener).exitLinkFetch(this);
		}
	}

	public final RouteContext route() throws RecognitionException {
		RouteContext _localctx = new RouteContext(_ctx, getState());
		enterRule(_localctx, 0, RULE_route);
		try {
			setState(36);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,0,_ctx) ) {
			case 1:
				_localctx = new LinkFetchContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(30);
				link(0);
				setState(31);
				fetch();
				}
				break;
			case 2:
				_localctx = new EntityFetchContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(33);
				entity_node();
				setState(34);
				fetch();
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
			setState(47);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,1,_ctx) ) {
			case 1:
				{
				_localctx = new EntityByBwdNodeContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;

				setState(39);
				entity_node();
				setState(40);
				by();
				setState(41);
				bwd_node();
				}
				break;
			case 2:
				{
				_localctx = new FwdNodeToEntityContext(_localctx);
				_ctx = _localctx;
				_prevctx = _localctx;
				setState(43);
				fwd_node();
				setState(44);
				to();
				setState(45);
				entity_node();
				}
				break;
			}
			_ctx.stop = _input.LT(-1);
			setState(61);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,3,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					setState(59);
					_errHandler.sync(this);
					switch ( getInterpreter().adaptivePredict(_input,2,_ctx) ) {
					case 1:
						{
						_localctx = new LinkToEntityContext(new LinkContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_link);
						setState(49);
						if (!(precpred(_ctx, 2))) throw new FailedPredicateException(this, "precpred(_ctx, 2)");
						setState(50);
						match(DOT);
						setState(51);
						attr();
						setState(52);
						to();
						setState(53);
						entity_node();
						}
						break;
					case 2:
						{
						_localctx = new LinkByBwdNodeContext(new LinkContext(_parentctx, _parentState));
						pushNewRecursionContext(_localctx, _startState, RULE_link);
						setState(55);
						if (!(precpred(_ctx, 1))) throw new FailedPredicateException(this, "precpred(_ctx, 1)");
						setState(56);
						by();
						setState(57);
						bwd_node();
						}
						break;
					}
					} 
				}
				setState(63);
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

	public static class FetchContext extends ParserRuleContext {
		public TerminalNode DOT() { return getToken(RouteQueryParser.DOT, 0); }
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
		enterRule(_localctx, 4, RULE_fetch);
		try {
			setState(68);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,4,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				setState(64);
				match(DOT);
				setState(65);
				attr();
				}
				break;
			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(66);
				match(DOT);
				setState(67);
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
		enterRule(_localctx, 6, RULE_to);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(70);
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
		enterRule(_localctx, 8, RULE_by);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(72);
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
		enterRule(_localctx, 10, RULE_fwd_node);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(74);
			entity_node();
			setState(75);
			match(DOT);
			setState(76);
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
		enterRule(_localctx, 12, RULE_bwd_node);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(78);
			match(LP);
			setState(79);
			attr();
			setState(80);
			match(RP);
			setState(81);
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
		enterRule(_localctx, 14, RULE_entity_node);
		try {
			setState(90);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,5,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				setState(83);
				entity();
				}
				break;
			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(84);
				entity();
				setState(85);
				condition();
				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(87);
				entity();
				setState(88);
				cond_array();
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
			setState(92);
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
			setState(94);
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
			setState(96);
			match(LSB);
			setState(97);
			attr();
			setState(102);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==T__0) {
				{
				{
				setState(98);
				match(T__0);
				setState(99);
				attr();
				}
				}
				setState(104);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(105);
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
			setState(107);
			match(LSB);
			setState(108);
			condition();
			setState(113);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==T__0) {
				{
				{
				setState(109);
				match(T__0);
				setState(110);
				condition();
				}
				}
				setState(115);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(116);
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
			setState(164);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,8,_ctx) ) {
			case 1:
				_localctx = new ConditionEqContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(118);
				match(BL);
				setState(119);
				attr();
				setState(120);
				match(OP_EQ);
				setState(121);
				value();
				setState(122);
				match(BR);
				}
				break;
			case 2:
				_localctx = new ConditionGtContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(124);
				match(BL);
				setState(125);
				attr();
				setState(126);
				match(ID);
				setState(127);
				match(OP_GT);
				setState(128);
				value();
				setState(129);
				match(BR);
				}
				break;
			case 3:
				_localctx = new ConditionLtContext(_localctx);
				enterOuterAlt(_localctx, 3);
				{
				setState(131);
				match(BL);
				setState(132);
				attr();
				setState(133);
				match(OP_LT);
				setState(134);
				value();
				setState(135);
				match(BR);
				}
				break;
			case 4:
				_localctx = new ConditionNeContext(_localctx);
				enterOuterAlt(_localctx, 4);
				{
				setState(137);
				match(BL);
				setState(138);
				attr();
				setState(139);
				match(OP_NE);
				setState(140);
				match(BR);
				}
				break;
			case 5:
				_localctx = new ConditionInContext(_localctx);
				enterOuterAlt(_localctx, 5);
				{
				setState(142);
				match(BL);
				setState(143);
				attr();
				setState(144);
				match(OP_IN);
				setState(145);
				array();
				setState(146);
				match(BR);
				}
				break;
			case 6:
				_localctx = new ConditionContainsContext(_localctx);
				enterOuterAlt(_localctx, 6);
				{
				setState(148);
				match(BL);
				setState(149);
				attr();
				setState(150);
				match(OP_CTAN);
				setState(151);
				match(STRING);
				setState(152);
				match(BR);
				}
				break;
			case 7:
				_localctx = new ConditionNotNullContext(_localctx);
				enterOuterAlt(_localctx, 7);
				{
				setState(154);
				match(BL);
				setState(155);
				attr();
				setState(156);
				match(OP_NN);
				setState(157);
				match(BR);
				}
				break;
			case 8:
				_localctx = new ConditionIsNullContext(_localctx);
				enterOuterAlt(_localctx, 8);
				{
				setState(159);
				match(BL);
				setState(160);
				attr();
				setState(161);
				match(OP_NL);
				setState(162);
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
			setState(166);
			match(LSB);
			setState(167);
			value();
			setState(172);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==T__0) {
				{
				{
				setState(168);
				match(T__0);
				setState(169);
				value();
				}
				}
				setState(174);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(175);
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
			setState(181);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case STRING:
				_localctx = new ValStringContext(_localctx);
				enterOuterAlt(_localctx, 1);
				{
				setState(177);
				match(STRING);
				}
				break;
			case NUMBER:
				_localctx = new ValNumberContext(_localctx);
				enterOuterAlt(_localctx, 2);
				{
				setState(178);
				match(NUMBER);
				}
				break;
			case BOOLEAN:
				_localctx = new ValBoolContext(_localctx);
				enterOuterAlt(_localctx, 3);
				{
				setState(179);
				match(BOOLEAN);
				}
				break;
			case OP_NL:
				_localctx = new ValNullContext(_localctx);
				enterOuterAlt(_localctx, 4);
				{
				setState(180);
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
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\3\36\u00ba\4\2\t\2"+
		"\4\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n\t\n\4\13"+
		"\t\13\4\f\t\f\4\r\t\r\4\16\t\16\4\17\t\17\4\20\t\20\3\2\3\2\3\2\3\2\3"+
		"\2\3\2\5\2\'\n\2\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\5\3\62\n\3\3\3\3"+
		"\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\3\7\3>\n\3\f\3\16\3A\13\3\3\4\3\4\3\4"+
		"\3\4\5\4G\n\4\3\5\3\5\3\6\3\6\3\7\3\7\3\7\3\7\3\b\3\b\3\b\3\b\3\b\3\t"+
		"\3\t\3\t\3\t\3\t\3\t\3\t\5\t]\n\t\3\n\3\n\3\13\3\13\3\f\3\f\3\f\3\f\7"+
		"\fg\n\f\f\f\16\fj\13\f\3\f\3\f\3\r\3\r\3\r\3\r\7\rr\n\r\f\r\16\ru\13\r"+
		"\3\r\3\r\3\16\3\16\3\16\3\16\3\16\3\16\3\16\3\16\3\16\3\16\3\16\3\16\3"+
		"\16\3\16\3\16\3\16\3\16\3\16\3\16\3\16\3\16\3\16\3\16\3\16\3\16\3\16\3"+
		"\16\3\16\3\16\3\16\3\16\3\16\3\16\3\16\3\16\3\16\3\16\3\16\3\16\3\16\3"+
		"\16\3\16\3\16\3\16\3\16\3\16\5\16\u00a7\n\16\3\17\3\17\3\17\3\17\7\17"+
		"\u00ad\n\17\f\17\16\17\u00b0\13\17\3\17\3\17\3\20\3\20\3\20\3\20\5\20"+
		"\u00b8\n\20\3\20\2\3\4\21\2\4\6\b\n\f\16\20\22\24\26\30\32\34\36\2\2\2"+
		"\u00be\2&\3\2\2\2\4\61\3\2\2\2\6F\3\2\2\2\bH\3\2\2\2\nJ\3\2\2\2\fL\3\2"+
		"\2\2\16P\3\2\2\2\20\\\3\2\2\2\22^\3\2\2\2\24`\3\2\2\2\26b\3\2\2\2\30m"+
		"\3\2\2\2\32\u00a6\3\2\2\2\34\u00a8\3\2\2\2\36\u00b7\3\2\2\2 !\5\4\3\2"+
		"!\"\5\6\4\2\"\'\3\2\2\2#$\5\20\t\2$%\5\6\4\2%\'\3\2\2\2& \3\2\2\2&#\3"+
		"\2\2\2\'\3\3\2\2\2()\b\3\1\2)*\5\20\t\2*+\5\n\6\2+,\5\16\b\2,\62\3\2\2"+
		"\2-.\5\f\7\2./\5\b\5\2/\60\5\20\t\2\60\62\3\2\2\2\61(\3\2\2\2\61-\3\2"+
		"\2\2\62?\3\2\2\2\63\64\f\4\2\2\64\65\7\6\2\2\65\66\5\24\13\2\66\67\5\b"+
		"\5\2\678\5\20\t\28>\3\2\2\29:\f\3\2\2:;\5\n\6\2;<\5\16\b\2<>\3\2\2\2="+
		"\63\3\2\2\2=9\3\2\2\2>A\3\2\2\2?=\3\2\2\2?@\3\2\2\2@\5\3\2\2\2A?\3\2\2"+
		"\2BC\7\6\2\2CG\5\24\13\2DE\7\6\2\2EG\5\26\f\2FB\3\2\2\2FD\3\2\2\2G\7\3"+
		"\2\2\2HI\7\5\2\2I\t\3\2\2\2JK\7\4\2\2K\13\3\2\2\2LM\5\20\t\2MN\7\6\2\2"+
		"NO\5\24\13\2O\r\3\2\2\2PQ\7\7\2\2QR\5\24\13\2RS\7\b\2\2ST\5\20\t\2T\17"+
		"\3\2\2\2U]\5\22\n\2VW\5\22\n\2WX\5\32\16\2X]\3\2\2\2YZ\5\22\n\2Z[\5\30"+
		"\r\2[]\3\2\2\2\\U\3\2\2\2\\V\3\2\2\2\\Y\3\2\2\2]\21\3\2\2\2^_\7\34\2\2"+
		"_\23\3\2\2\2`a\7\34\2\2a\25\3\2\2\2bc\7\16\2\2ch\5\24\13\2de\7\3\2\2e"+
		"g\5\24\13\2fd\3\2\2\2gj\3\2\2\2hf\3\2\2\2hi\3\2\2\2ik\3\2\2\2jh\3\2\2"+
		"\2kl\7\17\2\2l\27\3\2\2\2mn\7\16\2\2ns\5\32\16\2op\7\3\2\2pr\5\32\16\2"+
		"qo\3\2\2\2ru\3\2\2\2sq\3\2\2\2st\3\2\2\2tv\3\2\2\2us\3\2\2\2vw\7\17\2"+
		"\2w\31\3\2\2\2xy\7\f\2\2yz\5\24\13\2z{\7\20\2\2{|\5\36\20\2|}\7\r\2\2"+
		"}\u00a7\3\2\2\2~\177\7\f\2\2\177\u0080\5\24\13\2\u0080\u0081\7\34\2\2"+
		"\u0081\u0082\7\21\2\2\u0082\u0083\5\36\20\2\u0083\u0084\7\r\2\2\u0084"+
		"\u00a7\3\2\2\2\u0085\u0086\7\f\2\2\u0086\u0087\5\24\13\2\u0087\u0088\7"+
		"\22\2\2\u0088\u0089\5\36\20\2\u0089\u008a\7\r\2\2\u008a\u00a7\3\2\2\2"+
		"\u008b\u008c\7\f\2\2\u008c\u008d\5\24\13\2\u008d\u008e\7\23\2\2\u008e"+
		"\u008f\7\r\2\2\u008f\u00a7\3\2\2\2\u0090\u0091\7\f\2\2\u0091\u0092\5\24"+
		"\13\2\u0092\u0093\7\24\2\2\u0093\u0094\5\34\17\2\u0094\u0095\7\r\2\2\u0095"+
		"\u00a7\3\2\2\2\u0096\u0097\7\f\2\2\u0097\u0098\5\24\13\2\u0098\u0099\7"+
		"\25\2\2\u0099\u009a\7\31\2\2\u009a\u009b\7\r\2\2\u009b\u00a7\3\2\2\2\u009c"+
		"\u009d\7\f\2\2\u009d\u009e\5\24\13\2\u009e\u009f\7\26\2\2\u009f\u00a0"+
		"\7\r\2\2\u00a0\u00a7\3\2\2\2\u00a1\u00a2\7\f\2\2\u00a2\u00a3\5\24\13\2"+
		"\u00a3\u00a4\7\27\2\2\u00a4\u00a5\7\r\2\2\u00a5\u00a7\3\2\2\2\u00a6x\3"+
		"\2\2\2\u00a6~\3\2\2\2\u00a6\u0085\3\2\2\2\u00a6\u008b\3\2\2\2\u00a6\u0090"+
		"\3\2\2\2\u00a6\u0096\3\2\2\2\u00a6\u009c\3\2\2\2\u00a6\u00a1\3\2\2\2\u00a7"+
		"\33\3\2\2\2\u00a8\u00a9\7\16\2\2\u00a9\u00ae\5\36\20\2\u00aa\u00ab\7\3"+
		"\2\2\u00ab\u00ad\5\36\20\2\u00ac\u00aa\3\2\2\2\u00ad\u00b0\3\2\2\2\u00ae"+
		"\u00ac\3\2\2\2\u00ae\u00af\3\2\2\2\u00af\u00b1\3\2\2\2\u00b0\u00ae\3\2"+
		"\2\2\u00b1\u00b2\7\17\2\2\u00b2\35\3\2\2\2\u00b3\u00b8\7\31\2\2\u00b4"+
		"\u00b8\7\32\2\2\u00b5\u00b8\7\33\2\2\u00b6\u00b8\7\27\2\2\u00b7\u00b3"+
		"\3\2\2\2\u00b7\u00b4\3\2\2\2\u00b7\u00b5\3\2\2\2\u00b7\u00b6\3\2\2\2\u00b8"+
		"\37\3\2\2\2\r&\61=?F\\hs\u00a6\u00ae\u00b7";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}