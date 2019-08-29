import req from "./base";

export const getMyMenus = () =>
  process.env.NODE_ENV === "development"
    ? req.get("/admin/menus")
    : req.get("/my-menus");
// init page

// flow
export const saveFlow = data => req.post("/process/definitions", data);
export const getAllFlow = () => req.get("/process/definitions");
export const getFlowDetailByID = id =>
  req.get(`process/definitions/definition/${id}`);
export const getFlowPreview = data =>
  req.post(`/process/definitions/definition/input-parameters/preview`, data);

// admin
export const getAllUsers = () => req.get("/admin/users");
export const getAllRoles = () => req.get("/admin/roles");
export const getAllMenus = () => req.get("/admin/menus");
export const getAllPermissionEntryPoints = () =>
  req.get("/admin/permission-entry-points");
export const getRolesByUser = username =>
  req.get(`/admin/users/${username}/roles`);
export const getUsersByRole = roleId => req.get(`/admin/roles/${roleId}/users`);
export const getPermissionsByRole = roleId =>
  req.get(`/admin/roles/${roleId}/permissions`);
export const getPermissionsByUser = username =>
  req.get(`/admin/users/${username}/permissions`);
export const addRole = data => req.post(`/admin/roles/create`, data);
export const addUsersToRole = (users, roleId) =>
  req.post(`/admin/roles/${roleId}/users`, users);
export const romoveUsersFromRole = (users, roleId) =>
  req.delete(`/admin/roles/${roleId}/users`, { data: users });
export const addMenusToRole = (menuCodes, roleId) =>
  req.post(`/admin/roles/${roleId}/menu-permissions`, menuCodes);
export const removeMenusFromRole = (menuCodes, roleId) =>
  req.delete(`/admin/roles/${roleId}/menu-permissions`, { data: menuCodes });
export const addDataPermissionAction = (roleId, ciTypeId, actionCode) =>
  req.post(`/admin/roles/${roleId}/citypes/${ciTypeId}/actions/${actionCode}`);
export const removeDataPermissionAction = (roleId, ciTypeId, actionCode) =>
  req.delete(
    `/admin/roles/${roleId}/citypes/${ciTypeId}/actions/${actionCode}`
  );
export const addCITypeAttrsAttr = (roleId, ciTypeAttributeId, optionId) =>
  req.post(
    `/admin/roles/${roleId}/citype-attributes/${ciTypeAttributeId}/options/${optionId}`
  );
export const removeCITypeAttrsAttr = (roleId, ciTypeAttributeId, optionId) =>
  req.delete(
    `/admin/roles/${roleId}/citype-attributes/${ciTypeAttributeId}/options/${optionId}`
  );
export const getRoleCiTypeCtrlAttributesByRoleCiTypeId = roleCitypeId =>
  req.get(`/admin/role-citypes/${roleCitypeId}/ctrl-attributes`);
export const createRoleCiTypeCtrlAttributes = (roleCitypeId, data) =>
  req.post(`/admin/role-citypes/${roleCitypeId}/ctrl-attributes/create`, data);
export const updateRoleCiTypeCtrlAttributes = (roleCitypeId, data) =>
  req.post(`/admin/role-citypes/${roleCitypeId}/ctrl-attributes/update`, data);
export const deleteRoleCiTypeCtrlAttributes = (roleCitypeId, data) =>
  req.post(`/admin/role-citypes/${roleCitypeId}/ctrl-attributes/delete`, data);

//enum
export const getEnumList = data => req.post(`/cmdb/enum/codes/query`, data);

export const deleteEnumRecord = (catTypeId, catId, codeId) =>
  req.delete(
    `/cmdb/enum/category-types/${catTypeId}/categories/${catId}/codes/${codeId}`
  );
export const addEnumRecord = (catTypeId, data) =>
  req.post(
    `/cmdb/enum/category-types/${catTypeId}/categories/${
      data.catId
    }/codes/create`,
    data
  );
export const getEnumCatList = () => req.get(`/cmdb/enum/all-categories`);
export const getEnumCodesByCategoryId = (catTypeId, catId) =>
  req.get(`/cmdb/enum/category-types/${catTypeId}/categories/${catId}/codes`);

export const getEnumCategoriesByTypeId = catTypeId =>
  req.get(`/cmdb/enum/category-types/${catTypeId}/categories`);

export const queryEnumCategories = data =>
  req.post(`/cmdb/enum/categories/query`, data);

export const queryEnumCodes = (catTypeId, catId, data) =>
  req.post(
    `/cmdb/enum/category-types/${catTypeId}/categories/${catId}/codes/query`,
    data
  );

//CI
export const getCITableHeader = ciTypeId =>
  req.get(`/cmdb/ci-types/${ciTypeId}/header`);
export const updateCIRecord = (ciTypeId, data) =>
  req.put(`/cmdb/ci-types/${ciTypeId}/ci-data/${data.guid}`, data);
export const addCIRecord = (ciTypeId, data) =>
  req.post(`/cmdb/ci-types/${ciTypeId}/ci-data/create`, data);
export const deleteCIRecord = (ciTypeId, ciId) =>
  req.delete(`/cmdb/ci-types/${ciTypeId}/ci-data/${ciId}`);
// plugin manager
export const getAllPluginPkgs = () => req.get("/plugin/packages");
export const getAllCiTypesByCatalog = () =>
  req.get("/cmdb/ci-types?group-by=catalog");
export const getPluginInterfaces = id =>
  req.get(`/plugin/configs/${id}/interfaces`);
export const getRefCiTypeFrom = id =>
  req.get(`/cmdb/ci-types/${id}/references/by`);
export const getRefCiTypeTo = id =>
  req.get(`/cmdb/ci-types/${id}/references/to`);
export const getCiTypeAttr = id => req.get(`/cmdb/ci-types/${id}/attributes`);
export const preconfigurePluginPackage = id =>
  req.post(`/plugin/packages/${id}/preconfigure`);
export const getAllInstancesByPackageId = packageId =>
  req.get(`/plugin/packages/${packageId}/instances`);
export const createPluginInstanceByPackageIdAndHostIp = (
  packageId,
  ip,
  port,
  payload
) =>
  req.post(
    `/plugin/packages/${packageId}/hosts/${ip}/ports/${port}/instance/launch`,
    payload
  );
export const savePluginInstance = data =>
  req.post(
    `/plugin/configs/${data.configId}/save?cmdbCiTypeId=${
      data.cmdbCiTypeId
    }&cmdbCiTypeName=${data.cmdbCiTypeName}`,
    data.pluginRegisteringModels
  );
export const decommissionPluginConfig = configId =>
  req.post(`/plugin/configs/${configId}/decommission`);
export const releasePluginConfig = configId =>
  req.post(`/plugin/configs/${configId}/release`);
export const removePluginInstance = instanceId =>
  req.delete(`/plugin/packages/instances/${instanceId}`);
export const queryLog = data =>
  req.post(`/plugin/packages/instances/log`, data);
export const getPluginInstanceLogDetail = (id, data) =>
  req.post(`/plugin/packages/instances/${id}/log-detail`, data);
export const getCiTypeAttrRefAndSelect = id =>
  req.get(`/cmdb/ci-types/${id}/attributes?accept-input-types=select,ref`);
export const getAvailableContainerHosts = () =>
  req.get(`/plugin/available-container-hosts`);
export const getAvailablePortByHostIp = ip =>
  req.get(`/plugin/hosts/${ip}/next-available-port`);
export const getLatestOnlinePluginInterfaces = ciTypeId =>
  req.get(`/plugin/latest-online-interfaces?ci-type-id=${ciTypeId || ""}`);

// CI design

export const implementCiType = (id, op) =>
  req.post(`/cmdb/ci-types/${id}/implement?operation=${op}`);
export const implementCiAttr = (ciTypeId, ciAttrId, op) =>
  req.post(
    `/cmdb/ci-types/${ciTypeId}/attributes/${ciAttrId}/implement?operation=${op}`
  );
export const getAllCITypes = () => req.get("/cmdb/ci-types");
export const getAllEnumCategoryTypes = () =>
  req.get("/cmdb/enum/category-types");
export const getAllEnumCategories = () =>
  req.get("/cmdb/enum/category-types/categories");
export const createEnumCategory = data =>
  req.post(
    `/cmdb/enum/category-types/${data.catTypeId}/categories/create`,
    data
  );
export const updateEnumCategory = data =>
  req.put(
    `/cmdb/enum/category-types/${data.catTypeId}/categories/${data.catId}`,
    data
  );
export const getAllCITypesByLayerWithAttr = data => {
  const status = data.toString();
  return req.get(
    `/cmdb/ci-types?group-by=layer&with-attributes=yes&status=${status}`
  );
};
export const getAllLayers = () => req.get("/cmdb/ci-type-layers");
export const createLayer = data =>
  req.post("/cmdb/ci-type-layers/create", data);
export const deleteLayer = id => req.delete(`/cmdb/ci-type-layers/${id}`);
export const updateLayer = data => req.post(`/cmdb/enum/codes/update`, data);
export const swapLayerPosition = (layerId, targetLayerId) =>
  req.post(
    `/cmdb/ci-type-layers/${layerId}/swap-position?target-layer-id=${targetLayerId}`
  );
export const deleteCITypeByID = id => req.delete(`/cmdb/ci-types/${id}`);
export const deleteAttr = (ciTypeId, attrId) =>
  req.delete(`/cmdb/ci-types/${ciTypeId}/attributes/${attrId}`);
export const applyCiTypes = id => req.post(`/cmdb/ci-types/${id}/apply`);
export const updateCIType = (id, data) => req.put(`/cmdb/ci-types/${id}`, data);
export const createNewCIType = data => req.post(`/cmdb/ci-types/create`, data);
export const createNewCIAttr = (id, data) =>
  req.post(`/cmdb/ci-types/${id}/attributes/create`, data);
export const updateCIAttr = (attrId, ciTypeId, data) =>
  req.put(`/cmdb/ci-types/${ciTypeId}/attributes/${attrId}`, data);
export const applyCIAttr = (ciTypeId, attrIds) =>
  req.post(`/cmdb/ci-types/${ciTypeId}/ci-type-attributes/apply`, attrIds);

export const swapCiTypeAttributePosition = (ciTypeId, attrId, targetAttrId) => {
  return req.post(
    `/cmdb/ci-types/${ciTypeId}/attributes/${attrId}/swap-position?target-attribute-id=${targetAttrId}`
  );
};
export const getAllInputTypes = () =>
  req.get("/cmdb/static-data/available-ci-type-attribute-input-types");
export const getEnumByCIType = id =>
  req.get(
    `/cmdb/enum/category-types/categories/query-by-multiple-types?ci-type-id=${id}&types=common-private`
  );

export const getTableStatus = () =>
  req.get("/cmdb/static-data/available-ci-type-table-status");

export const getCiTypes = data =>
  req.get(`/cmdb/ci-types?${data.key}=${data.value}`);

export const getAllIdcDesignTrees = () =>
  req.get(`/cmdb/idc-designs/all-design-trees`);

export const getAllIdcImplementTrees = () =>
  req.get(`/cmdb/idc-implements/all-implement-trees`);

export const getAllZoneLinkGroupByIdc = () => req.get(`/cmdb/all-zone-link`);

export const getAllZoneLinkDesignGroupByIdcDesign = () =>
  req.get(`/cmdb/all-zone-link-design`);

export const getAllDesignTreeFromSystemDesign = id =>
  req.get(
    `/cmdb/trees/all-design-trees/from-system-design?system-design-guid=${id}`
  );

export const saveAllDesignTreeFromSystemDesign = id =>
  req.post(
    `/cmdb/trees/all-design-trees/from-system-design/save?system-design-guid=${id}`
  );

export const getAllIdcDesignData = () =>
  req.get(`/cmdb/ci-data/all-idc-design`);

export const getAllIdcData = () => req.get(`/cmdb/ci-data/all-idc`);

export const getIdcDesignTreeByGuid = data =>
  req.post(`/cmdb/data-tree/query-idc-design-tree`, data);

export const getIdcImplementTreeByGuid = data =>
  req.post(`/cmdb/data-tree/query-idc-tree`, data);

export const getApplicationFrameworkDesignDataTree = guid =>
  req.get(
    `/cmdb/data-tree/application-framework-design?system-design-guid=${guid}`
  );

export const getApplicationDeploymentDesignDataTree = (guid, codeId) =>
  req.get(
    `/cmdb/data-tree/application-deployment-design?env-code=${codeId}&system-design-guid=${guid}`
  );

// basic data page
export const getAllSystemEnumCodes = data => {
  return req.post(`/cmdb/enum/system/codes`, data);
};
export const getSystemCategories = () =>
  req.get(`/cmdb/enum/system-categories`);

export const getAllNonSystemEnumCodes = data => {
  return req.post(`/cmdb/enum/non-system/codes`, data);
};
export const getNonSystemCategories = () =>
  req.get(`/cmdb/enum/non-system-categories`);

export const getEffectiveStatus = () =>
  req.get(`/cmdb/static-data/effective-status`);
export const createEnumCode = data => {
  return req.post(
    `/cmdb/enum/category-types/0/categories/${data.catId}/codes/create`,
    data
  );
};
export const updateEnumCode = data => {
  return req.post(`/cmdb/enum/codes/update`, data);
};
export const getGroupListByCodeId = id =>
  req.get(`/cmdb/enum/categories/${id}/group-list`);
export const deleteEnumCodes = data => {
  return req.post(`/cmdb/enum/codes/delete`, data);
};
export const queryCiData = data => {
  return req.post(`/cmdb/ci-types/${data.id}/ci-data/query`, data.queryObject);
};
export const getCiTypeAttributes = id => {
  return req.get(`/cmdb/ci-types/${id}/attributes`);
};
export const deleteCiDatas = data => {
  return req.post(
    `/cmdb/ci-types/${data.id}/ci-data/batch-delete`,
    data.deleteData
  );
};
export const createCiDatas = data => {
  return req.post(
    `/cmdb/ci-types/${data.id}/ci-data/batch-create`,
    data.createData
  );
};
export const updateCiDatas = data => {
  return req.post(
    `/cmdb/ci-types/${data.id}/ci-data/batch-update`,
    data.updateData
  );
};

export const operateCiState = (ciTypeId, guid, op) => {
  const payload = [{ ciTypeId, guid }];
  return req.post(`/cmdb/ci/state/operate?operation=${op}`, payload);
};

// ci integrate query
export const getQueryNames = id => {
  return req.get(`/cmdb/intQuery/ciType/${id}/search`);
};
export const queryIntHeader = id => {
  return req.get(`/cmdb/intQuery/${id}/header`);
};
export const excuteIntQuery = (id, data) => {
  return req.post(`/cmdb/intQuery/${id}/execute`, data);
};

export const fetchIntQueryById = (ciTypeId, queryId) => {
  return req.get(`/cmdb/intQuery/ciType/${ciTypeId}/${queryId}`);
};
export const saveIntQuery = (ciTypeId, queryName, data) => {
  return req.post(`/cmdb/intQuery/ciType/${ciTypeId}/${queryName}/save`, data);
};
export const updateIntQuery = (queryId, data) => {
  return req.post(`/cmdb/intQuery/${queryId}/update`, data);
};
export const deleteIntQuery = (ciTypeId, queryId) => {
  return req.post(`/cmdb/intQuery/ciType/${ciTypeId}/${queryId}/delete`);
};
//batch-job management
export const getQueryNamesByAttrId = (id, attrId) => {
  return req.get(`/cmdb/intQuery/ciType/${id}/search?tailAttrId=${attrId}`);
};
export const createBatchJob = data => {
  return req.post(`/batch-job/create`, data);
};
export const execBatchJob = batchJobId => {
  return req.post(`/batch-job/${batchJobId}/execute`);
};
export const getBatchJobExecLog = data => {
  return req.post(`/batch-job/search-text`, data);
};
export const getBatchJobExecLogDetail = data => {
  return req.post(`/batch-job/get-context`, data);
};
// artifact manage
export const getPackageCiTypeId = () => req.get("/artifact/getPackageCiTypeId");
export const getSystemDesignVersions = () => {
  return req.get(`/artifact/system-design-versions`);
};
export const getSystemDesignVersion = version => {
  return req.get(`/artifact/system-design-versions/${version}`);
};
export const queryPackages = (guid, data) => {
  return req.post(`/artifact/unit-designs/${guid}/packages/query`, data);
};
export const deactivePackage = (guid, packageId) => {
  return req.post(
    `/artifact/unit-designs/${guid}/packages/${packageId}/deactive`,
    {}
  );
};
export const activePackage = (guid, packageId) => {
  return req.post(
    `/artifact/unit-designs/${guid}/packages/${packageId}/active`,
    {}
  );
};
export const getFiles = (guid, packageId, data) => {
  return req.post(
    `/artifact/unit-designs/${guid}/packages/${packageId}/files/query`,
    data
  );
};
export const getKeys = (guid, packageId, data) => {
  return req.post(
    `/artifact/unit-designs/${guid}/packages/${packageId}/property-keys/query`,
    data
  );
};
export const saveConfigFiles = (guid, packageId, data) => {
  return req.post(
    `/artifact/unit-designs/${guid}/packages/${packageId}/save`,
    data
  );
};
export const artifactManagementCreateEnumCode = data => {
  return req.post(
    `/cmdb/enum/category-types/2/categories/18/codes/create`,
    data
  );
};
export const saveDiffConfigEnumCodes = data =>
  req.post("/artifact/enum/codes/diff-config/save", data);

export const getDiffConfigEnumCodes = () =>
  req.get("/artifact/enum/codes/diff-config/query");

// deployment design
export const getSystemDesigns = () => {
  return req.get(`/cmdb/system-designs`);
};
export const previewDeployGraph = data => {
  return req.post(`/process/definitions/preview`, data);
};
export const getAllDeployTreesFromDesignCi = (id, env) => {
  return req.get(
    `/cmdb/trees/all-deploy-trees/from-subsys?env-code=${env}&system-design-guid=${id}`
  );
};
export const startProcessInstancesWithCiDataInbatch = data => {
  return req.post(`/process/inbatch/instances`, data);
};
export const getDeployDesignTabs = () => req.get(`/cmdb/deploy-designs/tabs`);

export const getDeployCiData = (data, payload) =>
  req.post(
    `/cmdb/deploy-designs/tabs/ci-data?code-id=${data.codeId}&env-code=${
      data.envCode
    }&system-design-guid=${data.systemDesignGuid}`,
    payload
  );

export const getArchitectureDesignTabs = () =>
  req.get("/cmdb/architecture-designs/tabs");
export const getArchitectureCiDatas = (tabId, sysId, payload) =>
  req.post(
    `/cmdb/architecture-designs/tabs/ci-data?code-id=${tabId}&system-design-guid=${sysId}`,
    payload
  );
//deployment
export const listProcessTransactions = () =>
  req.get("/process/process-transactions");
export const refreshStatusesProcessTransactions = id =>
  req.get(`/process/process-transactions/${id}/outlines`);
//filterRules
export const queryReferenceEnumCodes = data =>
  req.post(`/cmdb/referenceEnumCodes/${data.attrId}/query`, data.params);
export const queryReferenceCiData = data =>
  req.post(`/cmdb/referenceCiData/${data.attrId}/query`, data.queryObject);
//worker flow execution
export const previewProcessDefinition = data =>
  req.post("/process/definitions/definition/preview", data);
export const startProcessInstanceWithCiData = data =>
  req.post("/process/instances", data);
export const refreshProcessInstanceStatus = id =>
  req.get(`/process/instances/${id}/outline`);
export const restartProcessInstance = data =>
  req.post("/process/instances/restart", data);
