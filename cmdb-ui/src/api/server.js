import { req as request, baseURL } from './base'
import { pluginErrorMessage } from './base-plugin'
let req = request
if (window.request) {
  req = {
    post: (url, ...params) => pluginErrorMessage(window.request.post(baseURL + url, ...params)),
    get: (url, ...params) => pluginErrorMessage(window.request.get(baseURL + url, ...params)),
    delete: (url, ...params) => pluginErrorMessage(window.request.delete(baseURL + url, ...params)),
    put: (url, ...params) => pluginErrorMessage(window.request.put(baseURL + url, ...params))
  }
}
export const getMyMenus = () => req.get('/my-menus')
// admin
export const getAllUsers = () => req.get('/admin/users')
export const getAllRoles = () => req.get('/admin/roles')
export const getAllMenus = () => req.get('/admin/menus')
export const getRolesByUser = username => req.get(`/admin/users/${username}/roles`)
export const getUsersByRole = roleName => req.get(`/admin/roles/${roleName}/users`)
export const getPermissionsByRole = roleName => req.get(`/admin/roles/${roleName}/permissions`)
export const getPermissionsByUser = username => req.get(`/admin/users/${username}/permissions`)
export const addRole = data => req.post(`/admin/roles/create`, data)
export const addUser = data => req.post(`/admin/users/create`, data)
export const addUsersToRole = (users, roleName) => req.post(`/admin/roles/${roleName}/users`, users)
export const romoveUsersFromRole = (users, roleName) => req.delete(`/admin/roles/${roleName}/users`, { data: users })
export const addMenusToRole = (menuCodes, roleName) => req.post(`/admin/roles/${roleName}/menu-permissions`, menuCodes)
export const removeMenusFromRole = (menuCodes, roleName) =>
  req.delete(`/admin/roles/${roleName}/menu-permissions`, { data: menuCodes })
export const addDataPermissionAction = (roleName, ciTypeId, actionCode) =>
  req.post(`/admin/roles/${roleName}/citypes/${ciTypeId}/actions/${actionCode}`)
export const removeDataPermissionAction = (roleName, ciTypeId, actionCode) =>
  req.delete(`/admin/roles/${roleName}/citypes/${ciTypeId}/actions/${actionCode}`)
export const getRoleCiTypeCtrlAttributesByRoleCiTypeId = roleCitypeId =>
  req.get(`/admin/role-citypes/${roleCitypeId}/ctrl-attributes`)
export const createRoleCiTypeCtrlAttributes = (roleCitypeId, data) =>
  req.post(`/admin/role-citypes/${roleCitypeId}/ctrl-attributes/create`, data)
export const updateRoleCiTypeCtrlAttributes = (roleCitypeId, data) =>
  req.post(`/admin/role-citypes/${roleCitypeId}/ctrl-attributes/update`, data)
export const deleteRoleCiTypeCtrlAttributes = (roleCitypeId, data) =>
  req.post(`/admin/role-citypes/${roleCitypeId}/ctrl-attributes/delete`, data)
export const editPassword = data => req.post('/admin/users/password/change', data)
export const resetPassword = data => req.post('/admin/users/password/reset', data)
// enum
export const getEnumCodesByCategoryId = (catTypeId, catId) =>
  req.get(`/enum/category-types/${catTypeId}/categories/${catId}/codes`)
export const getEnumCategoriesByTypeId = catTypeId => req.get(`/enum/category-types/${catTypeId}/categories`)
// CI
export const getRefCiTypeFrom = id => req.get(`/ci-types/${id}/references/by`)
export const getRefCiTypeTo = id => req.get(`/ci-types/${id}/references/to`)
export const getCiTypeAttr = id => req.get(`/ci-types/${id}/attributes`)
export const getSpecialConnector = () => req.get('/static-data/special-connector')
// CI design
export const implementCiType = (id, op) => req.post(`/ci-types/${id}/implement?operation=${op}`)
export const implementCiAttr = (ciTypeId, ciAttrId, op) =>
  req.post(`/ci-types/${ciTypeId}/attributes/${ciAttrId}/implement?operation=${op}`)
export const getAllCITypes = () => req.get('/ci-types')
export const getAllEnumCategoryTypes = () => req.get('/enum/category-types')
export const getAllEnumCategories = () => req.get('/enum/category-types/categories')
export const createEnumCategory = data => req.post(`/enum/category-types/${data.catTypeId}/categories/create`, data)
export const updateEnumCategory = data =>
  req.put(`/enum/category-types/${data.catTypeId}/categories/${data.catId}`, data)
export const getAllCITypesByLayerWithAttr = data => {
  const status = data.toString()
  return req.get(`/ci-types?group-by=layer&with-attributes=yes&status=${status}`)
}
export const getAllLayers = () => req.get('/ci-type-layers')
export const createLayer = data => req.post('/ci-type-layers/create', data)
export const deleteLayer = id => req.delete(`/ci-type-layers/${id}`)
export const updateLayer = data => req.post(`/enum/codes/update`, data)
export const swapLayerPosition = (layerId, targetLayerId) =>
  req.post(`/ci-type-layers/${layerId}/swap-position?target-layer-id=${targetLayerId}`)
export const deleteCITypeByID = id => req.delete(`/ci-types/${id}`)
export const deleteAttr = (ciTypeId, attrId) => req.delete(`/ci-types/${ciTypeId}/attributes/${attrId}`)
export const applyCiTypes = id => req.post(`/ci-types/${id}/apply`)
export const updateCIType = (id, data) => req.put(`/ci-types/${id}`, data)
export const createNewCIType = data => req.post(`/ci-types/create`, data)
export const createNewCIAttr = (id, data) => req.post(`/ci-types/${id}/attributes/create`, data)
export const updateCIAttr = (ciTypeId, attrId, data) => req.put(`/ci-types/${attrId}/attributes/${ciTypeId}`, data)
export const applyCIAttr = (ciTypeId, attrIds) => req.post(`/ci-types/${ciTypeId}/ci-type-attributes/apply`, attrIds)
export const swapCiTypeAttributePosition = (ciTypeId, attrId, targetAttrId) => {
  return req.post(`/ci-types/${ciTypeId}/attributes/${attrId}/swap-position?target-attribute-id=${targetAttrId}`)
}
export const getAllInputTypes = () => req.get('/static-data/available-ci-type-attribute-input-types')
export const getEnumByCIType = id =>
  req.get(`/enum/category-types/categories/query-by-multiple-types?ci-type-id=${id}&types=common-private`)
export const getAllIdcDesignData = () => req.get(`/ci-data/all-idc-design`)
export const getIdcDesignTreeByGuid = data => req.post(`/data-tree/query-idc-design-tree`, data)
export const getAllZoneLinkDesignGroupByIdcDesign = () => req.get(`/all-zone-link-design`)
export const getAllIdcData = () => req.get(`/ci-data/all-idc`)
export const getIdcImplementTreeByGuid = data => req.post(`/data-tree/query-idc-tree`, data)
export const getPlanningDesignTabs = () => req.get('/planning-designs/tabs')
export const getResourcePlanningTabs = () => req.get('/resource-planning/tabs')
export const getPlanningDesignsCiData = data =>
  req.post(`/planning-designs/ci-data?code-id=${data.id}&idcs-guid=${data.idcGuid}`, data.queryObject)
export const getResourcePlanningCiData = data =>
  req.post(`/resource-planning/ci-data?code-id=${data.id}&idcs-guid=${data.idcGuid}`, data.queryObject)
export const getAllZoneLinkGroupByIdc = () => req.get(`/all-zone-link`)
export const getSystemDesigns = () => req.get('/system-designs')
export const getSystems = () => req.get('/system')
export const getAllDesignTreeFromSystemDesign = id =>
  req.get(`/trees/all-design-trees/from-system-design?system-design-guid=${id}`)
export const saveAllDesignTreeFromSystemDesign = id =>
  req.post(`/trees/all-design-trees/from-system-design/save?system-design-guid=${id}`)
export const getArchitectureDesignTabs = () => req.get('/architecture-designs/tabs')
export const getArchitectureCiDatas = (tabId, sysId, rguid, payload) =>
  req.post(`/architecture-designs/tabs/ci-data?code-id=${tabId}&system-design-guid=${sysId}&r-guid=${rguid}`, payload)
export const getApplicationFrameworkDesignDataTree = guid =>
  req.get(`/data-tree/application-framework-design?system-design-guid=${guid}`)
export const getDeployCiData = (data, payload) =>
  req.post(`/deploy-designs/tabs/ci-data?code-id=${data.codeId}&system-guid=${data.systemGuid}`, payload)
export const getDeployDesignTabs = () => req.get(`/deploy-designs/tabs`)
export const getAllDeployTreesFromSystemCi = guid => req.get(`/trees/all-deploy-trees/from-system?system-guid=${guid}`)
export const startProcessInstancesWithCiDataInbatch = data => req.post(`/process/inbatch/instances`, data)
export const getApplicationDeploymentDataTree = guid => req.get(`/data-tree/application-deployment?system-guid=${guid}`)
export const getTableStatus = () => req.get('/static-data/available-ci-type-table-status')
export const updateSystemDesign = guid => req.post(`/deploy-designs/tabs/update-system-design?system-guid=${guid}`)
// basic data page
export const getAllSystemEnumCodes = data => req.post(`/enum/system/codes`, data)
export const getSystemCategories = () => req.get(`/enum/system-categories`)
export const getAllNonSystemEnumCodes = data => req.post(`/enum/non-system/codes`, data)
export const getNonSystemCategories = () => req.get(`/enum/non-system-categories`)
export const getEffectiveStatus = () => req.get(`/static-data/effective-status`)
export const createEnumCode = data => req.post('/enum/codes/create', data)
export const updateEnumCode = data => req.post(`/enum/codes/update`, data)
export const getGroupListByCodeId = id => req.get(`/enum/categories/${id}/group-list`)
export const deleteEnumCodes = data => req.post(`/enum/codes/delete`, data)
export const queryCiData = data => req.post(`/ci-types/${data.id}/ci-data/query`, data.queryObject)
export const queryCiDataByType = data => {
  return req.post(`/ci-types/${data.id}/ci-data/query-by-type`, data.queryObject)
}
export const getCiTypeAttributes = id => req.get(`/ci-types/${id}/attributes`)
export const deleteCiDatas = data => req.post(`/ci-types/${data.id}/ci-data/batch-delete`, data.deleteData)
export const createCiDatas = data => req.post(`/ci-types/${data.id}/ci-data/batch-create`, data.createData)
export const updateCiDatas = data => req.post(`/ci-types/${data.id}/ci-data/batch-update`, data.updateData)
export const operateCiState = (ciTypeId, guid, op) => {
  const payload = [{ ciTypeId, guid }]
  return req.post(`/ci/state/operate?operation=${op}`, payload)
}
export const getTreeData = (ciTypeId, guid) => {
  const payload = [guid]
  return req.post(`/data-tree/${ciTypeId}/query`, payload)
}
// ci integrate query
export const getQueryNames = id => req.get(`/intQuery/ciType/${id}/search`)
export const queryIntHeader = id => req.get(`/intQuery/${id}/header`)
export const excuteIntQuery = (id, data) => req.post(`/intQuery/${id}/execute`, data)
export const fetchIntQueryById = (ciTypeId, queryId) => req.get(`/intQuery/ciType/${ciTypeId}/${queryId}`)
export const saveIntQuery = (ciTypeId, queryName, data) =>
  req.post(`/intQuery/ciType/${ciTypeId}/${queryName}/save`, data)
export const updateIntQuery = (queryId, data) => req.post(`/intQuery/${queryId}/update`, data)
export const deleteIntQuery = (ciTypeId, queryId) => req.post(`/intQuery/ciType/${ciTypeId}/${queryId}/delete`)
// filterRules
export const queryReferenceEnumCodes = data => req.post(`/referenceEnumCodes/${data.attrId}/query`, data.params)
export const queryReferenceCiData = data => req.post(`/referenceCiData/${data.attrId}/query`, data.queryObject)
// log
export const queryLogHeader = () => req.get('/log/queryHeader')
export const queryLog = data => req.post('/log/query', data)
// ci-data password
export const queryPassword = (ciTypeId, guid, field) => req.get(`/ci-data/${ciTypeId}/query-password/${guid}/${field}`)
export const updatePassword = (ciTypeId, data) => req.post(`/ci-data/${ciTypeId}/change-password`, data)
// wecube api
export const getWecubeRoles = () => window.request.get('platform/v1/roles/retrieve')
