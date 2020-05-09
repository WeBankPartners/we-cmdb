/*
 * To change this license header, choose License Headers in Project Properties. To change this
 * template file, choose Tools | Templates and open the template in the editor.
 */

grammar RouteQuery;

route: link # LinkRoute | entity_node # EntityRoute;

link:
	entity_node by bwd_node			# EntityByBwdNode
	| fwd_node to entity_node		# FwdNodeToEntity
	| link DOT attr to entity_node	# LinkToEntity
	| link by bwd_node				# LinkByBwdNode;

to: GT;
by: TILDE;
fwd_node: entity_node DOT attr;
bwd_node: LP attr RP entity_node;

entity_node:
	entity fetch
	| entity condition (fetch)?
	| entity cond_array (fetch)?;

fetch: SC attr | SC attr_array;
entity: ID;
attr: ID;
attr_array: '[' attr (',' attr)* ']';
cond_array: '[' condition (',' condition)* ']';

condition:
	BL attr OP_EQ value BR		# ConditionEq
	| BL attr ID OP_GT value BR	# ConditionGt
	| BL attr OP_LT value BR	# ConditionLt
	| BL attr OP_NE BR			# ConditionNe
	| BL attr OP_IN array BR	# ConditionIn
	| BL attr OP_CTAN STRING BR	# ConditionContains
	| BL attr OP_NN BR			# ConditionNotNull
	| BL attr OP_NL BR			# ConditionIsNull;

array: '[' value (',' value)* ']';

value:
	STRING		# ValString
	| NUMBER	# ValNumber
	| BOOLEAN	# ValBool
	| 'null'	# ValNull;

TILDE: '~';
GT: '>';
DOT: '.';
LP: '(';
RP: ')';
DC: ':' ':';
SC: ':';
DQM: '"' '"';
BL: '{';
BR: '}';
LSB: '[';
RSB: ']';

//filter operator
OP_EQ: 'eq';
OP_GT: 'gt';
OP_LT: 'lt';
OP_NE: 'ne';
OP_IN: 'in';
OP_CTAN: 'contains';
OP_NN: 'notNull';
OP_NL: 'null';

OPERATOR:
	OP_EQ
	| OP_GT
	| OP_LT
	| OP_NE
	| OP_IN
	| OP_CTAN
	| OP_NN
	| OP_NL;

STRING: '"' (ESC | ~["\\])* '"' | '\'' (ESC | ~['\\])* '\'';

fragment ESC: '\\' (["\\/bfnrt] | UNICODE);
fragment UNICODE: 'u' HEX HEX HEX HEX;
fragment HEX: [0-9a-fA-F];

NUMBER:
	'-'? INT '.' [0-9]+ EXP? // 1.35, 1.35E-9, 0.3, -4.5
	| '-'? INT EXP // 1e10 -3e4
	| '-'? INT; // -3, 45
BOOLEAN: 'true' | 'false';
// MEMBER: LSB ID RSB;
ID: Letter LetterOrDigit*;
PKG_ID: ID;
fragment Letter: [a-zA-Z!@#$%^&*_-];
fragment Digit: [0-9];
fragment LetterOrDigit: Letter | Digit;
fragment INT: '0' | [1-9] [0-9]*;
// no leading zeros
fragment EXP: [Ee] [+\-]? INT;
// \- since - means "range" inside [...]

WS: [ \t\r\n]+ -> skip;
// skip spaces, tabs, newlines
