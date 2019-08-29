import Vue from "vue";
import axios from "axios";
const baseURL = "";
const req = axios.create({
  withCredentials: true,
  baseURL,
  timeout: 50000
});

req.defaults.headers.common["Http-Client-Type"] = "Ajax";

const throwError = res => new Error(res.message || "error");
req.interceptors.response.use(
  res => {
    if (res.status === 200) {
      if (res.headers["cas-redirect-flag"] === "true") {
        const currentUrl = window.location.href;
        if (currentUrl.indexOf("ticket=") !== -1) return;
        window.location.href =
          res.headers.location.split("?")[0] + "?service=" + currentUrl;
      }
      if (res.data.status === "ERROR") {
        const errorMes = Array.isArray(res.data.data)
          ? res.data.data.map(_ => _.errorMessage).join("<br/>")
          : res.data.message;
        Vue.prototype.$Notice.error({
          title: "Error",
          desc: errorMes,
          duration: 0
        });
      }
      return {
        ...res.data,
        user: res.headers["current_user"] || " - "
      };
    } else {
      return {
        data: throwError(res)
      };
    }
  },
  res => {
    const { response } = res;
    Vue.prototype.$Notice.error({
      title: "error",
      desc:
        (response.data &&
          "status:" +
            response.data.status +
            "<br/> error:" +
            response.data.error +
            "<br/> message:" +
            response.data.message) ||
        "error"
    });
    return new Promise((resolve, reject) => {
      resolve({
        data: throwError(res)
      });
    });
  }
);

function setHeaders(obj) {
  Object.keys(obj).forEach(key => {
    req.defaults.headers.common[key] = obj[key];
  });
}

export default req;

export { setHeaders };
