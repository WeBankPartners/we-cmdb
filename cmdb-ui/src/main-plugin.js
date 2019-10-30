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

import WeSelect from "../src/pages/components/select.vue";
import RefSelect from "./pages/components/ref-select.js";
import WeTable from "./pages/components/table.js";
import SimpleTable from "../src/pages/components/simple-table.vue";
import AttrInput from "../src/pages/components/attr-input";
import sequenceDiagram from "../src/pages/components/sequence-diagram.vue";
import orchestration from "../src/pages/components/orchestration.vue";

Vue.component("WeSelect", WeSelect);
Vue.component("RefSelect", RefSelect);
Vue.component("WeTable", WeTable);
Vue.component("SimpleTable", SimpleTable);
Vue.component("AttrInput", AttrInput);
Vue.component("sequenceDiagram", sequenceDiagram);
Vue.component("orchestration", orchestration);
Vue.config.productionTip = false;

Vue.use(iView, {
  transfer: true,
  size: "default",
  VueI18n,
  locale
});

Vue.use(VueHighlightJS);

window.addRoutes && window.addRoutes(router, "cmdb");
