import { init } from "@rematch/core";
import configManagement from "./config-management";

const store = init({
  models: {
    configManagement
  }
});

export default store;
