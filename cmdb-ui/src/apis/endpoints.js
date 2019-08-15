import { instance as req } from "./base";

export const fetchCiTypeLayerMap = () => req.get("/baseKey/ciLayers");

export const fetchZoomLevels = () => req.get("/baseKey/zoomLevels");

export const fetchCatalogs = () => req.get("/catalog/ciTypes");

export const fetchCatalogMap = () => req.get("/baseKey/catalogs");

export const fetchLayerMap = () => req.get("/baseKey/ciLayers");

export const fetchCITypeAttrById = ciTypeId =>
  req.get(`/ciType/ciTypeAndAttr/${ciTypeId}`);

export const updateCiType = data =>
  req.post(`/ciType/${data.ciTypeId}/update`, data);

export const addCiType = data => req.post("/ciType/add", data);

export const addCiTypeAttr = (ciTypeId, data) =>
  req.post(`/ciType/${ciTypeId}/attr/add`, data);

export const updateCiTypeAttr = (ciTypeId, data) =>
  req.post(`/ciType/${ciTypeId}/attr/${data.ciTypeAttrId}/update`, data);

export const addUnionGroup = data =>
  req.post(`/ciType/${data.ciTypeId}/attrUniqueGroup/add`, data);

export const fetchUnionGroup = ciTypeId =>
  req.get(`/ciType/${ciTypeId}/attrUniqueGroups`);

export const deleteUnionGroup = attrGroupId =>
  req.post(`/ciType/attrUniqueGroup/${attrGroupId}/delete`);

// basic config query
export const fetchBasicConfigCat = () => {
  return req.get("/baseKey/catType/overview");
};

export const fetchCatCodes = catId => {
  return req.get(`/baseKey/category/${catId}/codes`);
};

export const moveUpCatCodes = codeId => {
  return req.post(`/baseKey/category/code/${codeId}/up`);
};

export const moveDownCatCodes = codeId => {
  return req.post(`/baseKey/category/code/${codeId}/down`);
};
export const deleteCatCodes = codeId => {
  return req.post(`/baseKey/category/code/${codeId}/delete`);
};

export const addCatCode = data => {
  return req.post(`/baseKey/category/${data.id}/code/add`, data);
};

export const updateCatCode = data => {
  return req.post(`/baseKey/category/code/${data.id}/update`, data);
};

export const addCategory = data => {
  return req.post(`/baseKey/catType/${data.id}/category/add`, data);
};

export const updateCategory = data => {
  return req.post(`/baseKey/catType/category/${data.id}/update`, data);
};

export const fetchAllCategories = () => {
  return req.get("/baseKey/catType/categories");
};

// 配置查询
export const fetchCiFilters = ciTypeId => {
  return req.get(`/ciType/${ciTypeId}/header`);
};

export const fetchAllCiTypes = () => {
  return req.get("/ciTypes");
};

export const fetchCis = (ciTypeId, data) => {
  return req.post(`/ciType/${ciTypeId}/cis`, data);
};

export const updateCi = (ciTypeId, data) => {
  return req.post(`/ciType/${ciTypeId}/ci/${data.guid}/update`, data);
};

export const addCi = (ciTypeId, data) => {
  return req.post(`/ciType/${ciTypeId}/ci/add`, data);
};

export const deleteCi = (ciTypeId, guid) => {
  return req.post(`/ciType/${ciTypeId}/ci/${guid}/delete`);
};

export const fetchCiReferBy = ciTypeId => {
  return req.get(`/ciType/${ciTypeId}/referBy`);
};

export const fetchCiReferTo = ciTypeId => {
  return req.get(`/ciType/${ciTypeId}/referTo`);
};

export const fetchQueries = (ciTypeId, name) => {
  return req.get(`/intQuery/ciType/${ciTypeId}/search`, { params: { name } });
};

export const fetchIntQueryById = (ciTypeId, queryId) => {
  return req.get(`/intQuery/ciType/${ciTypeId}/${queryId}`);
};

export const saveIntQuery = (ciTypeId, queryName, data) => {
  return req.post(`/intQuery/ciType/${ciTypeId}/${queryName}/save`, data);
};

export const fetchCiTypeAttrs = ciTypeId => {
  return req.get(`/ciType/${ciTypeId}/attrs`);
};

export const executeIntQuery = (queryId, data = {}) => {
  return req.post(`/intQuery/${queryId}/execute`, data);
};

export const fetchLogQuerys = data => {
  return req.post(`/log/query`, data);
};

export const logQuerys = () => {
  return req.get(`/log/queryHeader`);
};

export const fetchIntQueryHeader = queryId => {
  return req.get(`/intQuery/${queryId}/header`);
};

export const deleteCiTypeAttr = (ciTypeId, ciTypeAttrId) => {
  return req.post(`/ciType/${ciTypeId}/attr/${ciTypeAttrId}/delete`);
};

export const deleteCiType = ciTypeId => {
  return req.post(`/ciType/${ciTypeId}/delete`);
};

export const implementAttr = (ciTypeAttrId, params) => {
  return req.post(`/ciType/attr/${ciTypeAttrId}/implement`, null, { params });
};

export const implementCiType = (ciTypeId, params) => {
  return req.post(`/ciType/${ciTypeId}/implement`, null, { params });
};

// permission management
export const retrieveUsers = data => req.post("/users/retrieve", data);

export const retrieveRoles = data => req.post("/roles/retrieve", data);

export const updateRoles = data => req.post("/roles/update", data);

export const createRoles = data => req.post("/roles/create", data);

export const deleteRoles = data => req.post("/roles/delete", data);

export const retrieveRoleUsers = data => req.post("/role-users/retrieve", data);

export const createRoleUsers = data => req.post("/role-users/create", data);

export const deleteRoleUsers = data => req.post("/role-users/delete", data);

export const retrieveRoleCiTypes = data =>
  req.post("/role-citypes/retrieve", data);

export const createRoleCiTypes = data => req.post("/role-citypes/create", data);

export const updateRoleCiTypes = data => req.post("/role-citypes/update", data);

export const retrieveMenus = () =>
  req.post("/menus/retrieve", {
    sorting: {
      asc: true,
      field: "seqNo"
    }
  });

export const retrieveRoleMenus = data => req.post("/role-menus/retrieve", data);

export const createRoleMenus = data => req.post("/role-menus/create", data);

export const deleteRoleMenus = data => req.post("/role-menus/delete", data);

export const myMenus = () => req.get("my-menus");
