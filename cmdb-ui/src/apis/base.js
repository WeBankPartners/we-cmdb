import axios from "axios";
import CMDBMessage from "../components/cmdb-message";

const baseURL = "/cmdb";

const instance = axios.create({
  baseURL
  //   timeout: 50000
});

let username = "";

const throwError = res => new Error(res);

instance.interceptors.response.use(
  res => {
    if (res.status === 200 && res.data.statusCode === "OK") {
      username = res.headers["username"] || " - ";
      return res.data.data;
    } else {
      if (res.data.statusCode.startsWith("ERR_") && res.data.data) {
        CMDBMessage({
          variant: "error",
          message: res.data.data.map((_, index) => {
            if (index !== 0) {
              return "\n" + _.errorMessage;
            }
            return _.errorMessage;
          })
        });
      } else {
        CMDBMessage({
          variant: "error",
          message: res.data.statusMessage || "Unknown Error"
        });
      }

      return throwError(res.data.data);
    }
  },
  res => {
    CMDBMessage({
      variant: "error",
      message:
        res.response.data.statusMessage ||
        res.response.data.data.message ||
        "Unknown Error"
    });
    return new Promise((resolve, reject) => {
      resolve(throwError(res.response.data.message));
    });
  }
);

export { instance, username };
