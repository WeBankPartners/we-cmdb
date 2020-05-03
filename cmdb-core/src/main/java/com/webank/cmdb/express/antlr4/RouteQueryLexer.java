// Generated from .\RouteQuery.g4 by ANTLR 4.8
package com.webank.cmdb.express.antlr4;
import org.antlr.v4.runtime.Lexer;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.TokenStream;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.misc.*;

@SuppressWarnings({"all", "warnings", "unchecked", "unused", "cast"})
public class RouteQueryLexer extends Lexer {
	static { RuntimeMetaData.checkVersion("4.8", RuntimeMetaData.VERSION); }

	protected static final DFA[] _decisionToDFA;
	protected static final PredictionContextCache _sharedContextCache =
		new PredictionContextCache();
	public static final int
		T__0=1, TILDE=2, GT=3, DOT=4, LP=5, RP=6, DC=7, SC=8, DQM=9, BL=10, BR=11, 
		LSB=12, RSB=13, OP_EQ=14, OP_GT=15, OP_LT=16, OP_NE=17, OP_IN=18, OP_CTAN=19, 
		OP_NN=20, OP_NL=21, OPERATOR=22, STRING=23, NUMBER=24, BOOLEAN=25, ID=26, 
		PKG_ID=27, WS=28;
	public static String[] channelNames = {
		"DEFAULT_TOKEN_CHANNEL", "HIDDEN"
	};

	public static String[] modeNames = {
		"DEFAULT_MODE"
	};

	private static String[] makeRuleNames() {
		return new String[] {
			"T__0", "TILDE", "GT", "DOT", "LP", "RP", "DC", "SC", "DQM", "BL", "BR", 
			"LSB", "RSB", "OP_EQ", "OP_GT", "OP_LT", "OP_NE", "OP_IN", "OP_CTAN", 
			"OP_NN", "OP_NL", "OPERATOR", "STRING", "ESC", "UNICODE", "HEX", "NUMBER", 
			"BOOLEAN", "ID", "PKG_ID", "Letter", "Digit", "LetterOrDigit", "INT", 
			"EXP", "WS"
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


	public RouteQueryLexer(CharStream input) {
		super(input);
		_interp = new LexerATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}

	@Override
	public String getGrammarFileName() { return "RouteQuery.g4"; }

	@Override
	public String[] getRuleNames() { return ruleNames; }

	@Override
	public String getSerializedATN() { return _serializedATN; }

	@Override
	public String[] getChannelNames() { return channelNames; }

	@Override
	public String[] getModeNames() { return modeNames; }

	@Override
	public ATN getATN() { return _ATN; }

	public static final String _serializedATN =
		"\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\2\36\u0103\b\1\4\2"+
		"\t\2\4\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n\t\n\4"+
		"\13\t\13\4\f\t\f\4\r\t\r\4\16\t\16\4\17\t\17\4\20\t\20\4\21\t\21\4\22"+
		"\t\22\4\23\t\23\4\24\t\24\4\25\t\25\4\26\t\26\4\27\t\27\4\30\t\30\4\31"+
		"\t\31\4\32\t\32\4\33\t\33\4\34\t\34\4\35\t\35\4\36\t\36\4\37\t\37\4 \t"+
		" \4!\t!\4\"\t\"\4#\t#\4$\t$\4%\t%\3\2\3\2\3\3\3\3\3\4\3\4\3\5\3\5\3\6"+
		"\3\6\3\7\3\7\3\b\3\b\3\b\3\t\3\t\3\n\3\n\3\n\3\13\3\13\3\f\3\f\3\r\3\r"+
		"\3\16\3\16\3\17\3\17\3\17\3\20\3\20\3\20\3\21\3\21\3\21\3\22\3\22\3\22"+
		"\3\23\3\23\3\23\3\24\3\24\3\24\3\24\3\24\3\24\3\24\3\24\3\24\3\25\3\25"+
		"\3\25\3\25\3\25\3\25\3\25\3\25\3\26\3\26\3\26\3\26\3\26\3\27\3\27\3\27"+
		"\3\27\3\27\3\27\3\27\3\27\5\27\u0095\n\27\3\30\3\30\3\30\7\30\u009a\n"+
		"\30\f\30\16\30\u009d\13\30\3\30\3\30\3\30\3\30\7\30\u00a3\n\30\f\30\16"+
		"\30\u00a6\13\30\3\30\5\30\u00a9\n\30\3\31\3\31\3\31\5\31\u00ae\n\31\3"+
		"\32\3\32\3\32\3\32\3\32\3\32\3\33\3\33\3\34\5\34\u00b9\n\34\3\34\3\34"+
		"\3\34\6\34\u00be\n\34\r\34\16\34\u00bf\3\34\5\34\u00c3\n\34\3\34\5\34"+
		"\u00c6\n\34\3\34\3\34\3\34\3\34\5\34\u00cc\n\34\3\34\5\34\u00cf\n\34\3"+
		"\35\3\35\3\35\3\35\3\35\3\35\3\35\3\35\3\35\5\35\u00da\n\35\3\36\3\36"+
		"\7\36\u00de\n\36\f\36\16\36\u00e1\13\36\3\37\3\37\3 \3 \3!\3!\3\"\3\""+
		"\5\"\u00eb\n\"\3#\3#\3#\7#\u00f0\n#\f#\16#\u00f3\13#\5#\u00f5\n#\3$\3"+
		"$\5$\u00f9\n$\3$\3$\3%\6%\u00fe\n%\r%\16%\u00ff\3%\3%\2\2&\3\3\5\4\7\5"+
		"\t\6\13\7\r\b\17\t\21\n\23\13\25\f\27\r\31\16\33\17\35\20\37\21!\22#\23"+
		"%\24\'\25)\26+\27-\30/\31\61\2\63\2\65\2\67\329\33;\34=\35?\2A\2C\2E\2"+
		"G\2I\36\3\2\f\4\2$$^^\4\2))^^\n\2$$\61\61^^ddhhppttvv\5\2\62;CHch\3\2"+
		"\62;\t\2##%(,,//B\\`ac|\3\2\63;\4\2GGgg\4\2--//\5\2\13\f\17\17\"\"\2\u0115"+
		"\2\3\3\2\2\2\2\5\3\2\2\2\2\7\3\2\2\2\2\t\3\2\2\2\2\13\3\2\2\2\2\r\3\2"+
		"\2\2\2\17\3\2\2\2\2\21\3\2\2\2\2\23\3\2\2\2\2\25\3\2\2\2\2\27\3\2\2\2"+
		"\2\31\3\2\2\2\2\33\3\2\2\2\2\35\3\2\2\2\2\37\3\2\2\2\2!\3\2\2\2\2#\3\2"+
		"\2\2\2%\3\2\2\2\2\'\3\2\2\2\2)\3\2\2\2\2+\3\2\2\2\2-\3\2\2\2\2/\3\2\2"+
		"\2\2\67\3\2\2\2\29\3\2\2\2\2;\3\2\2\2\2=\3\2\2\2\2I\3\2\2\2\3K\3\2\2\2"+
		"\5M\3\2\2\2\7O\3\2\2\2\tQ\3\2\2\2\13S\3\2\2\2\rU\3\2\2\2\17W\3\2\2\2\21"+
		"Z\3\2\2\2\23\\\3\2\2\2\25_\3\2\2\2\27a\3\2\2\2\31c\3\2\2\2\33e\3\2\2\2"+
		"\35g\3\2\2\2\37j\3\2\2\2!m\3\2\2\2#p\3\2\2\2%s\3\2\2\2\'v\3\2\2\2)\177"+
		"\3\2\2\2+\u0087\3\2\2\2-\u0094\3\2\2\2/\u00a8\3\2\2\2\61\u00aa\3\2\2\2"+
		"\63\u00af\3\2\2\2\65\u00b5\3\2\2\2\67\u00ce\3\2\2\29\u00d9\3\2\2\2;\u00db"+
		"\3\2\2\2=\u00e2\3\2\2\2?\u00e4\3\2\2\2A\u00e6\3\2\2\2C\u00ea\3\2\2\2E"+
		"\u00f4\3\2\2\2G\u00f6\3\2\2\2I\u00fd\3\2\2\2KL\7.\2\2L\4\3\2\2\2MN\7\u0080"+
		"\2\2N\6\3\2\2\2OP\7@\2\2P\b\3\2\2\2QR\7\60\2\2R\n\3\2\2\2ST\7*\2\2T\f"+
		"\3\2\2\2UV\7+\2\2V\16\3\2\2\2WX\7<\2\2XY\7<\2\2Y\20\3\2\2\2Z[\7<\2\2["+
		"\22\3\2\2\2\\]\7$\2\2]^\7$\2\2^\24\3\2\2\2_`\7}\2\2`\26\3\2\2\2ab\7\177"+
		"\2\2b\30\3\2\2\2cd\7]\2\2d\32\3\2\2\2ef\7_\2\2f\34\3\2\2\2gh\7g\2\2hi"+
		"\7s\2\2i\36\3\2\2\2jk\7i\2\2kl\7v\2\2l \3\2\2\2mn\7n\2\2no\7v\2\2o\"\3"+
		"\2\2\2pq\7p\2\2qr\7g\2\2r$\3\2\2\2st\7k\2\2tu\7p\2\2u&\3\2\2\2vw\7e\2"+
		"\2wx\7q\2\2xy\7p\2\2yz\7v\2\2z{\7c\2\2{|\7k\2\2|}\7p\2\2}~\7u\2\2~(\3"+
		"\2\2\2\177\u0080\7p\2\2\u0080\u0081\7q\2\2\u0081\u0082\7v\2\2\u0082\u0083"+
		"\7P\2\2\u0083\u0084\7w\2\2\u0084\u0085\7n\2\2\u0085\u0086\7n\2\2\u0086"+
		"*\3\2\2\2\u0087\u0088\7p\2\2\u0088\u0089\7w\2\2\u0089\u008a\7n\2\2\u008a"+
		"\u008b\7n\2\2\u008b,\3\2\2\2\u008c\u0095\5\35\17\2\u008d\u0095\5\37\20"+
		"\2\u008e\u0095\5!\21\2\u008f\u0095\5#\22\2\u0090\u0095\5%\23\2\u0091\u0095"+
		"\5\'\24\2\u0092\u0095\5)\25\2\u0093\u0095\5+\26\2\u0094\u008c\3\2\2\2"+
		"\u0094\u008d\3\2\2\2\u0094\u008e\3\2\2\2\u0094\u008f\3\2\2\2\u0094\u0090"+
		"\3\2\2\2\u0094\u0091\3\2\2\2\u0094\u0092\3\2\2\2\u0094\u0093\3\2\2\2\u0095"+
		".\3\2\2\2\u0096\u009b\7$\2\2\u0097\u009a\5\61\31\2\u0098\u009a\n\2\2\2"+
		"\u0099\u0097\3\2\2\2\u0099\u0098\3\2\2\2\u009a\u009d\3\2\2\2\u009b\u0099"+
		"\3\2\2\2\u009b\u009c\3\2\2\2\u009c\u009e\3\2\2\2\u009d\u009b\3\2\2\2\u009e"+
		"\u00a9\7$\2\2\u009f\u00a4\7)\2\2\u00a0\u00a3\5\61\31\2\u00a1\u00a3\n\3"+
		"\2\2\u00a2\u00a0\3\2\2\2\u00a2\u00a1\3\2\2\2\u00a3\u00a6\3\2\2\2\u00a4"+
		"\u00a2\3\2\2\2\u00a4\u00a5\3\2\2\2\u00a5\u00a7\3\2\2\2\u00a6\u00a4\3\2"+
		"\2\2\u00a7\u00a9\7)\2\2\u00a8\u0096\3\2\2\2\u00a8\u009f\3\2\2\2\u00a9"+
		"\60\3\2\2\2\u00aa\u00ad\7^\2\2\u00ab\u00ae\t\4\2\2\u00ac\u00ae\5\63\32"+
		"\2\u00ad\u00ab\3\2\2\2\u00ad\u00ac\3\2\2\2\u00ae\62\3\2\2\2\u00af\u00b0"+
		"\7w\2\2\u00b0\u00b1\5\65\33\2\u00b1\u00b2\5\65\33\2\u00b2\u00b3\5\65\33"+
		"\2\u00b3\u00b4\5\65\33\2\u00b4\64\3\2\2\2\u00b5\u00b6\t\5\2\2\u00b6\66"+
		"\3\2\2\2\u00b7\u00b9\7/\2\2\u00b8\u00b7\3\2\2\2\u00b8\u00b9\3\2\2\2\u00b9"+
		"\u00ba\3\2\2\2\u00ba\u00bb\5E#\2\u00bb\u00bd\7\60\2\2\u00bc\u00be\t\6"+
		"\2\2\u00bd\u00bc\3\2\2\2\u00be\u00bf\3\2\2\2\u00bf\u00bd\3\2\2\2\u00bf"+
		"\u00c0\3\2\2\2\u00c0\u00c2\3\2\2\2\u00c1\u00c3\5G$\2\u00c2\u00c1\3\2\2"+
		"\2\u00c2\u00c3\3\2\2\2\u00c3\u00cf\3\2\2\2\u00c4\u00c6\7/\2\2\u00c5\u00c4"+
		"\3\2\2\2\u00c5\u00c6\3\2\2\2\u00c6\u00c7\3\2\2\2\u00c7\u00c8\5E#\2\u00c8"+
		"\u00c9\5G$\2\u00c9\u00cf\3\2\2\2\u00ca\u00cc\7/\2\2\u00cb\u00ca\3\2\2"+
		"\2\u00cb\u00cc\3\2\2\2\u00cc\u00cd\3\2\2\2\u00cd\u00cf\5E#\2\u00ce\u00b8"+
		"\3\2\2\2\u00ce\u00c5\3\2\2\2\u00ce\u00cb\3\2\2\2\u00cf8\3\2\2\2\u00d0"+
		"\u00d1\7v\2\2\u00d1\u00d2\7t\2\2\u00d2\u00d3\7w\2\2\u00d3\u00da\7g\2\2"+
		"\u00d4\u00d5\7h\2\2\u00d5\u00d6\7c\2\2\u00d6\u00d7\7n\2\2\u00d7\u00d8"+
		"\7u\2\2\u00d8\u00da\7g\2\2\u00d9\u00d0\3\2\2\2\u00d9\u00d4\3\2\2\2\u00da"+
		":\3\2\2\2\u00db\u00df\5? \2\u00dc\u00de\5C\"\2\u00dd\u00dc\3\2\2\2\u00de"+
		"\u00e1\3\2\2\2\u00df\u00dd\3\2\2\2\u00df\u00e0\3\2\2\2\u00e0<\3\2\2\2"+
		"\u00e1\u00df\3\2\2\2\u00e2\u00e3\5;\36\2\u00e3>\3\2\2\2\u00e4\u00e5\t"+
		"\7\2\2\u00e5@\3\2\2\2\u00e6\u00e7\t\6\2\2\u00e7B\3\2\2\2\u00e8\u00eb\5"+
		"? \2\u00e9\u00eb\5A!\2\u00ea\u00e8\3\2\2\2\u00ea\u00e9\3\2\2\2\u00ebD"+
		"\3\2\2\2\u00ec\u00f5\7\62\2\2\u00ed\u00f1\t\b\2\2\u00ee\u00f0\t\6\2\2"+
		"\u00ef\u00ee\3\2\2\2\u00f0\u00f3\3\2\2\2\u00f1\u00ef\3\2\2\2\u00f1\u00f2"+
		"\3\2\2\2\u00f2\u00f5\3\2\2\2\u00f3\u00f1\3\2\2\2\u00f4\u00ec\3\2\2\2\u00f4"+
		"\u00ed\3\2\2\2\u00f5F\3\2\2\2\u00f6\u00f8\t\t\2\2\u00f7\u00f9\t\n\2\2"+
		"\u00f8\u00f7\3\2\2\2\u00f8\u00f9\3\2\2\2\u00f9\u00fa\3\2\2\2\u00fa\u00fb"+
		"\5E#\2\u00fbH\3\2\2\2\u00fc\u00fe\t\13\2\2\u00fd\u00fc\3\2\2\2\u00fe\u00ff"+
		"\3\2\2\2\u00ff\u00fd\3\2\2\2\u00ff\u0100\3\2\2\2\u0100\u0101\3\2\2\2\u0101"+
		"\u0102\b%\2\2\u0102J\3\2\2\2\27\2\u0094\u0099\u009b\u00a2\u00a4\u00a8"+
		"\u00ad\u00b8\u00bf\u00c2\u00c5\u00cb\u00ce\u00d9\u00df\u00ea\u00f1\u00f4"+
		"\u00f8\u00ff\3\b\2\2";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}