import Vue from "vue";
import VueHighlightJS from "vue-highlight.js";
import "vue-highlight.js/lib/allLanguages";
import "highlight.js/styles/default.css";
import router from "./router-plugin";
import iView from "iview";
import "iview/dist/styles/iview.css";
import VueI18n from "vue-i18n";
import locale from "iview/dist/locale/en-US";
import "./locale/i18n";

import WeCMDBSelect from "../src/pages/components/select.vue";
import WeCMDBRefSelect from "./pages/components/ref-select.js";
import WeCMDBTable from "./pages/components/table.js";
import WeCMDBSimpleTable from "../src/pages/components/simple-table.vue";
import WeCMDBAttrInput from "../src/pages/components/attr-input";
import WeCMDBSequenceDiagram from "../src/pages/components/sequence-diagram.vue";
import WeCMDBOrchestration from "../src/pages/components/WeCMDBOrchestration.vue";

window.component("WeCMDBSelect", WeCMDBSelect);
window.component("WeCMDBRefSelect", WeCMDBRefSelect);
window.component("WeCMDBTable", WeCMDBTable);
window.component("WeCMDBSimpleTable", WeCMDBSimpleTable);
window.component("WeCMDBAttrInput", WeCMDBAttrInput);
window.component("WeCMDBSequenceDiagram", WeCMDBSequenceDiagram);
window.component("WeCMDBOrchestration", WeCMDBOrchestration);
Vue.config.productionTip = false;

Vue.use(iView, {
  transfer: true,
  size: "default",
  VueI18n,
  locale
});

Vue.use(VueHighlightJS);

window.addRoutes && window.addRoutes(router, "cmdb");
