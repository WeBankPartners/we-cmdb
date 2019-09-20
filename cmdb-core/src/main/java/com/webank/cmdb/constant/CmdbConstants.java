package com.webank.cmdb.constant;

public class CmdbConstants {
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

    public static final String PERMISSION_TYPE_READONLY = "只读";
    public static final String PERMISSION_TYPE_EDITABLE = "编辑";
    public static final String PERMISSION_TYPE_ADDDELE = "增删";

    public static final String ROLE_TYPE_PLATFORM_ADM = "平台管理";
    public static final String ROLE_TYPE_TENEMENT_ADM = "租户管理";
    public static final String ROLE_TYPE_CI_ADM = "CI管理";
    public static final String ROLE_TYPE_DATA_USER = "数据使用";

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

    public static final String ADD_SUCCESS = "新增成功";
    public static final String ADD_FAILURE = "新增失败";
    public static final String UPDATE_SUCCESS = "修改成功";
    public static final String UPDATE_FAILURE = "修改失败";
    public static final String DELETE_SUCCESS = "删除成功";
    public static final String DELETE_FAILURE = "删除失败";

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
}
