import Vue from "vue";
import VueI18n from "vue-i18n";

import zh from "iview/dist/locale/zh-CN";
import en from "iview/dist/locale/en-US";

import ZH from "./zh-CN.json";
import EN from "./en-US.json";

Vue.use(VueI18n);

Vue.locale("zh-CN", Object.assign(zh, ZH));
Vue.locale("en-US", Object.assign(en, EN));

const navLang = navigator.language;

const localLang = navLang === "zh-CN" || navLang === "en-US" ? navLang : false;

const lang = window.localStorage.getItem("lang") || localLang || "en-US";
Vue.config.lang = lang;

export default {};
