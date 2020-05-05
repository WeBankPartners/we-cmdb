package com.webank.cmdb.expression;

import com.webank.cmdb.dto.AdhocIntegrationQueryDto;
import com.webank.cmdb.dynamicEntity.DynamicEntityMeta;
import com.webank.cmdb.expression.antlr4.RouteQueryLexer;
import com.webank.cmdb.expression.antlr4.RouteQueryParser;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.ParseTree;
import org.antlr.v4.runtime.tree.ParseTreeWalker;

import java.util.Map;

public class RouteQueryExpressionParser {
    //table name -> meta
    private Map<String, DynamicEntityMeta> entityMap;

    public RouteQueryExpressionParser(Map<String, DynamicEntityMeta> entityMap){
        this.entityMap = entityMap;
    }

    public AdhocIntegrationQueryDto parse(String expression){
        RouteQueryExpressionListener routeQueryExpressListener = new RouteQueryExpressionListener(entityMap);
        CharStream inputStream = CharStreams.fromString(expression);
        RouteQueryLexer routeQueryLexer = new RouteQueryLexer(inputStream);
        CommonTokenStream tokens = new CommonTokenStream(routeQueryLexer);
        RouteQueryParser parser = new RouteQueryParser(tokens);
        parser.addErrorListener(new BaseErrorListener() {
            @Override
            public void syntaxError(Recognizer<?, ?> recognizer, Object offendingSymbol, int line, int charPositionInLine, String msg, RecognitionException e){
                throw new CmdbExpressException(String.format("Expression syntax error: line %d:%d %s", line, charPositionInLine, msg));
            }
        });

        ParseTree tree = parser.route();
        ParseTreeWalker walker = new ParseTreeWalker();
        walker.walk(routeQueryExpressListener, tree);
        return routeQueryExpressListener.getAdhocIntegrationQuery();
    }
}
