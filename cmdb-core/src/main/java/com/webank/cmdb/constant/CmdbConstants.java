package com.webank.cmdb.constant;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class CmdbConstants {
    
    public static final String DEFAULT_SA = "admin";
    public static final String CI_TYPE_CATALOG = "ci_catalog";
    public static final String CI_TYPE_LAYER = "ci_layer";
    public static final String CI_TYPE_ZOOM_LEVEL = "ci_zoom_level";
    public static final String CI_TYPE_REFERENCE_TYPE = "CI Reference Type";
    public static final String CI_TYPE_CI_STATE_TYPE = "ci_state_type";
    public static final String CI_STATE_DESIGN = "ci_state_design";
    public static final String CI_STATE_CREATE = "ci_state_create";
    public static final String CI_STATE_START_STOP = "ci_state_start_stop";

    public static final String TENEMENT_EN_SORT_NAME = "en_sort_name";
    public static final String TENEMENT_ID = "id_adm_tennement";

    public static final String SEQ_CI_TYPE = "seq_ci_type";
    public static final String SEQ_CI_INSTANCE = "seq_ci_instance";

    public static final String PERMISSION_TYPE_READONLY = "readonly";
    public static final String PERMISSION_TYPE_EDITABLE = "editable";
    public static final String PERMISSION_TYPE_ADDDELE = "adddele";

    public static final String ROLE_TYPE_PLATFORM_ADM = "platform_adm";
    public static final String ROLE_TYPE_TENEMENT_ADM = "tenement_adm";
    public static final String ROLE_TYPE_CI_ADM = "ci_adm";
    public static final String ROLE_TYPE_DATA_USER = "data_user";

    public static final String ACTION_TYPE_SELECT = "select";
    public static final String ACTION_TYPE_UPDATE = "update";
    public static final String ACTION_TYPE_DELETE = "delete";
    public static final String ACTION_TYPE_INSERT = "insert";
    public static final String ACTION_TYPE_UPSERT = "upsert";
    public static final String ACTION_TYPE_REMOVED = "removed";

    public static final String INPUT_TYPE_SELECT = "select";
    public static final String INPUT_TYPE_REF = "ref";
    public static final String INPUT_TYPE_TEXT = "text";
    public static final String INPUT_TYPE_NUMBER = "number";
    public static final String INPUT_TYPE_DATE = "date";
    public static final String INPUT_TYPE_TEXTAREA = "textArea";
    public static final String INPUT_TYPE_TIME = "time";
    public static final String INPUT_TYPE_MULTISELECT = "multiSelect";
    public static final String INPUT_TYPE_MULTIREF = "multiRef";

    public static final int OPERATE_CI_LIMIT_ROW_COUNT = 20;

    public static final String ADD_SUCCESS = "add_success";
    public static final String ADD_FAILURE = "add_failure";
    public static final String UPDATE_SUCCESS = "update_success";
    public static final String UPDATE_FAILURE = "update_failure";
    public static final String DELETE_SUCCESS = "delete_success";
    public static final String DELETE_FAILURE = "delete_failure";

    public static final String CUR_ADM_USER = "cur_adm_user";

    public static final String APPLICATION_JSON = "application/json";

    public static class CI_TYPE {
        public static final int TABLE_STATUS_TO_BE_CREATED = 0;
        public static final int TABLE_STATUS_CREATED = 1;
        public static final int ATTR_STATUS_ADD = 2;
        public static final int ATTR_STATUS_EDIT = 1;
        public static final int ATTR_STATUS_NORMAL = 0;
    }

    public static final String MESSAGE_TYPE_MAIL = "mailsend";
    public static final String MESSAGE_TYPE_RTX = "rtxsend";
    public static final String MESSAGE_TYPE_WECHAT = "wechatsend";
    public static final String[] SEND_WAY = { MESSAGE_TYPE_MAIL, MESSAGE_TYPE_RTX, MESSAGE_TYPE_WECHAT };

    public static final int MESSAGE_ATTACHEMENT_MAX_SIZE = 20 * 1024 * 1024;

    // excel export
    public final static int MAX_SHEETS = 100;
    public final static int MAX_RECORD_PER_SHEET = 10000;
    public final static String[] ENCRYPT_PATTERN = new String[] { "((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)" };

    public static class ADM_LOG {

        public static final int STATUS_DEFUALT = 0;

        public static final int STATUS_TRANSLATED = 1;

        public static final int STATUS_HAVE_NOT_TRANSLATED = 2;
    }

    public final static int VERSION_ATTR_TYPE_TABLE = 1;
    public final static int VERSION_ATTR_TYPE_FIELD = 2;
    public final static int VERSION_ATTR_TYPE_DATA = 3;
    public final static String XML_HEADER_GB2312 = "<?xml version=\"1.0\" encoding=\"gb2312\" ?>";
    public final static String SVG_DOCTYPE = "<!DOCTYPE svg PUBLIC \"-//W3C//DTDSVG 1.0//EN\" \"http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd\" >";

    public final static String CALLBACK_ID = "callbackId";
    public final static String GUID = "guid";
    public final static Integer IS_SYSTEM_YES = 1;
    public final static Integer IS_SYSTEM_NO = 0;
    public final static Integer IS_AUTO_YES = 1;
    public final static Integer IS_AUTO_NO = 0;
    public final static Integer IS_EDITABLE_YES = 1;
    public final static Integer IS_EDITABLE_NO = 0;

    public static final String DEFAULT_FIELD_CREATED_DATE = "created_date";
    public static final String DEFAULT_FIELD_CREATED_BY = "created_by";
    public static final String DEFAULT_FIELD_UPDATED_DATE = "updated_date";
    public static final String DEFAULT_FIELD_UPDATED_BY = "updated_by";
    public static final String DEFAULT_FIELD_GUID = "guid";
    public static final String DEFAULT_FIELD_ROOT_GUID = "r_guid";
    public static final String DEFAULT_FIELD_PARENT_GUID = "p_guid";
    public static final String DEFAULT_FIELD_KEY_NAME = "key_name";
    public static final String DEFAULT_FIELD_STATE = "state";
    public static final String DEFAULT_FIELD_CODE = "code";
    public static final String DEFAULT_FIELD_DESCRIPTION = "description";
    public static final String DEFAULT_FIELD_FIXED_DATE = "fixed_date";
    public static final String DEFAULT_FIELD_ORCHESTRATION = "orchestration";
    public static final String DEFAULT_FIELD_BIZ_KEY = "biz_key";

    public static final Integer ENUM_CAT_TYPE_SYS = 1;
    public static final Integer ENUM_CAT_TYPE_COMMON = 2;
    public static final Integer ENUM_CAT_TYPE_DEFAULT = 3;

    public static final int MAX_LENGTH_OF_TABLE = 64;
    public static final int MAX_LENGTH_OF_COLUMN = 64;
    public static final Integer DEFAULT_LENGTH_OF_MULTIPLE_REF = 1000;
    public static final Integer DEFAULT_LENGTH_OF_GUID = 15;
    public static final Integer DEFAULT_LENGTH_OF_SELECT = 15;
    public static final Integer DEFAULT_LENGTH_OF_MULTIPLE_SELECT = 1000;

    public static final String DATE_FORMAT_YYYY_MM_DD_HH_MM_SS = "yyyy-MM-dd HH:mm:ss";

    public static final List<String> MYSQL_SCHEMA_KEYWORDS = Arrays.asList("ACCESSIBLE","ADD","ALL","ALTER","ANALYZE","AND","AS","ASC","ASENSITIVE","BEFORE","BETWEEN","BIGINT","BINARY","BLOB","BOTH","BY","CALL","CASCADE","CASE","CHANGE","CHAR","CHARACTER","CHECK","COLLATE","COLUMN","CONDITION","CONSTRAINT","CONTINUE","CONVERT","CREATE","CROSS","CUBE","CUME_DIST","CURRENT_DATE","CURRENT_TIME","CURRENT_TIMESTAMP","CURRENT_USER","CURSOR","DATABASE","DATABASES","DAY_HOUR","DAY_MICROSECOND","DAY_MINUTE","DAY_SECOND","DEC","DECIMAL","DECLARE","DEFAULT","DELAYED","DELETE","DENSE_RANK","DESC","DESCRIBE","DETERMINISTIC","DISTINCT","DISTINCTROW","DIV","DOUBLE","DROP","DUAL","EACH","ELSE","ELSEIF","EMPTY","ENCLOSED","ESCAPED","EXCEPT","EXISTS","EXIT","EXPLAIN","FALSE","FETCH","FIRST_VALUE","FLOAT","FLOAT4","FLOAT8","FOR","FORCE","FOREIGN","FROM","FULLTEXT","FUNCTION","GENERATED","GET","GRANT","GROUP","GROUPING","GROUPS","HAVING","HIGH_PRIORITY","HOUR_MICROSECOND","HOUR_MINUTE","HOUR_SECOND","IF","IGNORE","IN","INDEX","INFILE","INNER","INOUT","INSENSITIVE","INSERT","INT","INT1","INT2","INT3","INT4","INT8","INTEGER","INTERVAL","INTO","IO_AFTER_GTIDS","IO_BEFORE_GTIDS","IS","ITERATE","JOIN","JSON_TABLE","KEY","KEYS","KILL","LAG","LAST_VALUE","LATERAL","LEAD","LEADING","LEAVE","LEFT","LIKE","LIMIT","LINEAR","LINES","LOAD","LOCALTIME","LOCALTIMESTAMP","LOCK","LONG","LONGBLOB","LONGTEXT","LOOP","LOW_PRIORITY","MASTER_BIND","MASTER_SSL_VERIFY_SERVER_CERT","MATCH","MAXVALUE","MEDIUMBLOB","MEDIUMINT","MEDIUMTEXT","MEMBER","MIDDLEINT","MINUTE_MICROSECOND","MINUTE_SECOND","MOD","MODIFIES","NATURAL","NOT","NO_WRITE_TO_BINLOG","NTH_VALUE","NTILE","NULL","NUMERIC","OF","ON","OPTIMIZE","OPTIMIZER_COSTS","OPTION","OPTIONALLY","OR","ORDER","OUT","OUTER","OUTFILE","OVER","PARTITION","PERCENT_RANK","PRECISION","PRIMARY","PROCEDURE","PURGE","RANGE","RANK","READ","READS","READ_WRITE","REAL","RECURSIVE","REFERENCES","REGEXP","RELEASE","RENAME","REPEAT","REPLACE","REQUIRE","RESIGNAL","RESTRICT","RETURN","REVOKE","RIGHT","RLIKE","ROW","ROWS","ROW_NUMBER","SCHEMA","SCHEMAS","SECOND_MICROSECOND","SELECT","SENSITIVE","SEPARATOR","SET","SHOW","SIGNAL","SMALLINT","SPATIAL","SPECIFIC","SQL","SQLEXCEPTION","SQLSTATE","SQLWARNING","SQL_BIG_RESULT","SQL_CALC_FOUND_ROWS","SQL_SMALL_RESULT","SSL","STARTING","STORED","STRAIGHT_JOIN","SYSTEM","TABLE","TERMINATED","THEN","TINYBLOB","TINYINT","TINYTEXT","TO","TRAILING","TRIGGER","TRUE","UNDO","UNION","UNIQUE","UNLOCK","UNSIGNED","UPDATE","USAGE","USE","USING","UTC_DATE","UTC_TIME","UTC_TIMESTAMP","VALUES","VARBINARY","VARCHAR","VARCHARACTER","VARYING","VIRTUAL","WHEN","WHERE","WHILE","WINDOW","WITH","WRITE","XOR","YEAR_MONTH","ZEROFILL");
    public static List<String> DEFAULT_FIELDS = new ArrayList<>();

    public static final String SYMBOL_COMMA = ",";
    public static final String SYMBOL_EQUALSIGN = "=";
    public static final String SYMBOL_AND = "&";

    public static final String PASSWORD = "password";
    public static final String PASSWORD_SHOW = "******";

}
