import Vue from "vue";
import VueHighlightJS from "vue-highlight.js";
import "vue-highlight.js/lib/allLanguages";
import "highlight.js/styles/default.css";
import router from "./router-plugin";
import ViewUI from "view-design";
import "view-design/dist/styles/iview.css";
import locale from "view-design/dist/locale/en-US";
import "./locale/i18n";
import zh_CN from "./locale/i18n/zh-CN.json";
import en_US from "./locale/i18n/en-US.json";

import WeCMDBSelect from "../src/pages/components/select.vue";
import WeCMDBRefSelect from "./pages/components/ref-select.js";
import WeCMDBTable from "./pages/components/table.js";
import WeCMDBSimpleTable from "../src/pages/components/simple-table.vue";
import WeCMDBAttrInput from "../src/pages/components/attr-input";
import WeCMDBSequenceDiagram from "../src/pages/components/sequence-diagram.vue";
import WeCMDBOrchestration from "../src/pages/components/orchestration.vue";

window.component("WeCMDBSelect", WeCMDBSelect);
window.component("WeCMDBRefSelect", WeCMDBRefSelect);
window.component("WeCMDBTable", WeCMDBTable);
window.component("WeCMDBSimpleTable", WeCMDBSimpleTable);
window.component("WeCMDBAttrInput", WeCMDBAttrInput);
window.component("WeCMDBSequenceDiagram", WeCMDBSequenceDiagram);
window.component("WeCMDBOrchestration", WeCMDBOrchestration);
Vue.config.productionTip = false;

Vue.use(ViewUI, {
  transfer: true,
  size: "default",
  locale
});

window.locale("zh-CN", zh_CN);
window.locale("en_US", en_US);

Vue.use(VueHighlightJS);

window.addRoutes && window.addRoutes(router, "cmdb");
