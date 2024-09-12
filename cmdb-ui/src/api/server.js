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

export const login = data => req.post('/login', data)

export const getMyMenus = () => req.get('/user/menus')
// admin
export const getAllUsers = () => req.get('/user')
export const getAllRoles = () => req.get('/roles')
export const getAllMenus = () => req.get('/menus/list')
export const changePassword = data => req.post('/user/password/update', data)
export const getRolesByUser = username => req.get(`/user/roles?user_id=${username}`)
export const getUsersByRole = roleName => req.get(`/roles/user?role_id=${roleName}`)
export const getPermissionsByRole = roleName => req.get(`/roles/menus?role_id=${roleName}`)
export const getoperationPermissionsByRole = roleId => req.get(`/permissions/ci/${roleId}`)
export const getPermissionsByUser = username => req.get(`/user/permissions?user_id=${username}`)
export const addRole = data => req.post(`/roles`, data)
export const deleteRole = id => req.delete(`roles?role_id=${id}`)
export const addUser = data => req.post(`/user`, data)
export const deleteUser = id => req.delete(`/user?user_id=${id}`)
export const addUsersToRole = data => req.post(`/roles/user`, data)

export const getPermissionList = roleCiType => req.get(`/permissions/list/${roleCiType}`)
export const addPermissionList = (roleCiType, data) => req.post(`/permissions/list/${roleCiType}`, data)
export const editPermissionList = (roleCiType, data) => req.put(`/permissions/list/${roleCiType}`, data)
export const deletePermissionList = (roleCiType, data) =>
  req.delete(`/permissions/list/${roleCiType}?ids=${data.join(',')}`)

export const assignCiTypePermissionForRoleInBatch = (ciTypePermissions, roleId) =>
  req.post(`/permissions/ci/${roleId}`, ciTypePermissions)
export const romoveUsersFromRole = (users, roleName) => req.delete(`/roles/${roleName}/user`, { data: users })
export const addMenusToRole = data => req.post(`/roles/menus`, data)
export const removeMenusFromRole = data => req.delete(`/roles/menus`, data)
export const addDataPermissionAction = (roleName, ciTypeId, actionCode) =>
  req.post(`/roles/${roleName}/citypes/${ciTypeId}/actions/${actionCode}`)
export const removeDataPermissionAction = (roleName, ciTypeId, actionCode) =>
  req.delete(`/roles/${roleName}/citypes/${ciTypeId}/actions/${actionCode}`)
export const getRoleCiTypeCtrlAttributesByRoleCiTypeId = roleCiType => req.get(`/permissions/condition/${roleCiType}`)
export const createRoleCiTypeCtrlAttributes = (roleCitypeId, data) =>
  req.post(`/permissions/condition/${roleCitypeId}`, data)
export const updateRoleCiTypeCtrlAttributes = (roleCitypeId, data) =>
  req.put(`/permissions/condition/${roleCitypeId}`, data)
// export const updateRoleCiTypeCtrlAttributes = (roleCitypeId, data) =>
//   req.post(`/permissions/list/${roleCitypeId}`, data)
export const deleteRoleCiTypeCtrlAttributes = (roleCitypeId, ids) =>
  req.delete(`/permissions/condition/${roleCitypeId}?ids=${ids}`)
export const editPassword = data => req.post('/user/password/change', data)
export const resetPassword = data => req.post('/user/password/reset', data)
// enum

export const getEnumCodesByCategoryId = catId => req.get(`/base-key/categories/${catId}`)
export const getEnumCategoriesByTypeId = catTypeId => req.get(`/enum/category-types/${catTypeId}/categories`)
// CI
export const getRefCiTypeFrom = id => req.get(`/ci-types/references/${id}`)
export const getRefCiTypeTo = id => req.get(`/ci-types/${id}/references/to`)
export const getCiTypeAttr = id => req.get(`/ci-types-attr/${id}/attributes`)
export const getSpecialConnector = () => req.get(`/base-key/categories/special-connector`)

// CI design
export const implementCiType = (id, op) => req.post(`/ci-types/${id}/implement?operation=${op}`)

export const implementCiAttr = (ciTypeId, ciAttrId) => {
  req.delete(`/ci-types-attr/${ciTypeId}/attributes/${ciAttrId}`)
}
export const getAllCITypes = () => req.get('/ci-types')
export const getAllEnumCategoryTypes = data => {
  const status = data.toString()
  return req.get(`/ci-types?with-attributes=no&status=${status}`)
}

export const createCat = data => req.post(`/base-key/categories/create`, data)
export const getAllEnumCategories = () => req.get('/base-key/categories?page=0&pageSize=10000')
export const getEnumCategoriesById = id => req.get(`/base-key/categories/${id}`)
export const createEnumCategory = data => req.post(`/enum/category-types/${data.catTypeId}/categories/create`, data)
export const updateEnumCategory = data =>
  req.put(`/enum/category-types/${data.catTypeId}/categories/${data.catId}`, data)
export const getAllCITypesByLayerWithAttr = data => {
  const status = data.toString()
  return req.get(`/ci-types?group-by=group&with-attributes=yes&status=${status}`)
}
export const getAllCITypesByLayers = data => {
  const status = data.toString()
  return req.get(`/ci-types?group-by=group&with-attributes=no&status=${status}`)
}
export const getAllCITypesWithAttr = data => {
  const status = data.toString()
  return req.get(`/ci-types?with-attributes=yes&status=${status}`)
}
export const getAllLayers = () => req.get('/base-key/categories/ci_layer')
export const createLayer = data => req.post('/base-key/codes', data)
export const deleteLayer = id => req.delete(`/base-key/codes/${id}`)
export const updateLayer = data => req.put(`/base-key/codes/${data[0].codeId}`, data)
export const swapLayerPosition = (layerId, targetLayerId) =>
  req.post(`/ci-type-layers/${layerId}/swap-position?target-layer-id=${targetLayerId}`)
export const deleteCITypeByID = id => req.delete(`/ci-types/${id}`)
export const deleteAttr = (ciTypeId, attrId) => req.delete(`/ci-types-attr/${ciTypeId}/attributes/${attrId}`)
export const applyCiTypes = data => req.post(`/ci-types/apply/${data.ciTypeId}`, data)
export const restoreCiTypes = ciTypeId => req.post(`/ci-types/rollback/${ciTypeId}`)
export const updateCIType = (id, data) => req.put(`/ci-types/${id}`, data)
export const createNewCIType = data => req.post(`/ci-types`, data)
export const createNewCIAttr = (id, data) => req.post(`/ci-types-attr/${id}/attributes`, data)

export const updateCIAttrOrder = (ciType, attrs) => req.post(`/ci-types-attr/${ciType}/attributes/swap-position`, attrs)

export const updateCIAttr = (ciTypeId, attrId, data) => req.put(`/ci-types-attr/${ciTypeId}/attributes/${attrId}`, data)
export const applyCIAttr = (ciTypeId, attrIds, data) =>
  req.post(`/ci-types-attr/${ciTypeId}/attributes/apply/${attrIds}`, data)
export const restoreCIAttr = (ciTypeId, attrIds) =>
  req.post(`/ci-types-attr/${ciTypeId}/attributes/rollback/${attrIds}`)
export const swapCiTypeAttributePosition = (ciTypeId, attrId, targetAttrId) => {
  return req.post(`/ci-types-attr/${ciTypeId}/attributes/${attrId}/swap-position?target-attribute-id=${targetAttrId}`)
}
export const getAllInputTypes = () => req.get(`/base-key/categories/input_type`)

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

export const updateSystemDesign = guid => req.post(`/deploy-designs/tabs/update-system-design?system-guid=${guid}`)
// basic data page
export const getAllSystemEnumCodesWithPayload = data => req.post(`/base-key/codes/query`, data)
export const getSystemEnumCodesBy = data => req.get(`/base-key/categories/ref_type`, data)
export const getAllSystemEnumCodes = ciTypeId => req.get(`/base-key/categories/${ciTypeId}`)
export const getSystemCategories = () => req.get(`/enum/system-categories`)
export const getAllNonSystemEnumCodes = data => req.post(`/enum/non-system/codes`, data)
export const getNonSystemCategories = () => req.get(`/enum/non-system-categories`)
export const getEffectiveStatus = () => req.get(`/static-data/effective-status`)
export const createEnumCode = data => req.post('/base-key/codes', data)
export const updateEnumCode = data => req.put(`/base-key/codes/${data[0].codeId}`, data)
export const getGroupListByCodeId = id => req.get(`/enum/categories/${id}/group-list`)
export const deleteEnumCodes = data => req.delete(`/base-key/codes`, { data: data })
export const queryCiData = data => req.post(`/ci-data/query/${data.id}`, data.queryObject)
export const queryReferenceCiData = data => req.post(`/ci-data/reference-data/query/${data.attrId}`, data.queryObject)
export const queryCiDataByType = data => {
  return req.post(`/ci-types/${data.id}/ci-data/query-by-type`, data.queryObject)
}

export const getCiByOptions = id => req.get(`/ci-types?id=${id}&with-attributes=yes`)
export const getGroupByOptions = payload =>
  req.get(
    `/ci-types?group=${payload.group}&layer=${payload.currentciLayer.join(
      ','
    )}&group-by=group&with-attributes=yes&status=${payload.currentStatus.join(',')}`
  )
export const getCiTypeAttributes = id => req.get(`/ci-types-attr/${id}/attributes`)
export const deleteCiDatas = data => req.post(`/ci-types/${data.id}/ci-data/batch-delete`, data.deleteData)
export const createCiDatas = data => req.post(`/ci-types/${data.id}/ci-data/batch-create`, data.createData)
export const updateCiDatas = data => req.post(`/ci-types/${data.id}/ci-data/batch-update`, data.updateData)
export const operateCiState = (ciTypeId, guid, op) => {
  const payload = [{ ciTypeId, guid }]
  return req.post(`/ci/state/operate?operation=${op}`, payload)
}
export const getTreeData = (ciTypeId, guid) => {
  const payload = guid
  return req.post(`/data-tree/${ciTypeId}/query`, payload)
}
export const getStateMachine = state => req.get(`/state-machine?machine=${state.join(',')}`)
export const getCiTemplate = () => req.get(`/ci-template`)
export const getStateTransition = ciTypeId => req.get(`/state-transition/${ciTypeId}`)
export const getRollbackData = guid => req.get(`/ci-data/rollback/query/${guid}`)
export const getSelectFormData = params =>
  req.get(`/ci-data/action-query/${params.operation}/${params.ciType}/${params.guid}`)

export const tableOptionExcute = (type, ciTypeId, data) => req.post(`/ci-data/do/${type}/${ciTypeId}`, data)
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
// log
export const queryLogHeader = () => req.get('/log/queryHeader')
export const queryLog = data => req.post('/log/query', data)
export const queryLogOperation = data => req.get('/log/operation')
// ci-data password
export const queryPassword = (ciTypeId, guid, field, params) =>
  req.get(`/ci-data/query-password/${ciTypeId}/${guid}/${field}`, { params: params })
export const updatePassword = (ciTypeId, data) => req.post(`/ci-data/${ciTypeId}/change-password`, data)
// wecube api
export const getWecubeRoles = () => window.request.get('platform/v1/roles/retrieve')

export const graphViews = params => req.get(`/views`, { params: params })
export const graphViewDetail = id => req.get(`/view/${id}`)
export const graphCiDataOperation = (ciType, op, payload) => {
  return req.post(`/ci-data/do/${op}/${ciType}`, payload)
}
export const graphCiConfirm = payload => {
  return req.post(`/view-confirm`, payload)
}
export const graphQueryReferenceCiData = data =>
  req.post(`/ci-data/reference-data/query/${data.attrId}`, data.queryObject)
export const graphQueryStateTransition = (ciType, payload) => req.get(`/state-transition/${ciType}`, payload)
export const graphQueryCIHistory = id => req.get(`/ci-data/rollback/query/${id}`)
export const graphQueryRootCI = data => req.post(`/view-data`, data)

export const getReportListByPermission = permission => req.get(`/reports?permission=${permission}`)
export const getReportStruct = reportId => req.get(`/report-struct/${reportId}`)
export const deleteReport = reportId => req.delete(`/report/${reportId}`)
export const addReport = data => req.post(`/reports`, data)
export const editReport = data => req.put(`/reports`, data)
export const getRolesByCurrentUser = () => req.get(`/user/roles`)
export const getReportData = (reportId, data) => req.post(`/report-data/${reportId}`, data)
export const getReportFilterData = reportId => req.get(`/report-flat-struct/${reportId}`)
export const configReport = data => req.post(`/report-objects`, data)
export const moveLayer = data => req.post(`/base-key/codes/swap-position`, data)

export const addView = data => req.post(`/views`, data)
export const deleteView = data => req.delete(`/views`, { data: data })
export const getGraphByView = data => req.post(`/view-graphs-query`, data)
export const addGraph = data => req.post(`/view-graphs`, data)
export const deleteGraph = data => req.delete(`/view-graphs`, { data: data })
export const getElementByGraph = data => req.post(`/view-elements-query`, data)
export const addElementForGraph = data => req.post(`/view-elements`, data)
export const editElementForGraph = data => req.put(`/view-elements`, data)
export const deleteElementForGraph = data => req.delete(`/view-elements`, { data: data })
export const getReportObject = data => req.post(`/report-objects/query`, data)
export const getAttrByReportObject = data => req.post(`/report-objects-attr/query`, data)

export const getStateMachineList = data => req.post(`/state-config/state-machine/list`, data)
export const getStateMachineFullInfo = id => req.get(`/state-config/state-machine/query?id=${id}`)
export const exportStateMachineFullInfo = id => req.get(`/state-config/state-machine/query?export=yes&id=${id}`)
export const confirmImportStateMachine = data => req.post(`/state-config/state-machine/confirm`, data)

export const addStateMachine = data => req.post(`/state-config/state-machine`, data)
export const editStateMachine = data => req.put(`/state-config/state-machine`, data)
export const deleteStateMachine = id => req.delete(`/state-config/state-machine?ids=${id}`)

export const getState = data => req.post(`/state-config/state/list`, data)
export const editState = data => req.put(`/state-config/state`, data)
export const addState = data => req.post(`/state-config/state`, data)
export const deleteState = id => req.delete(`/state-config/state?ids=${id}`)

export const getStateTran = data => req.post(`/state-config/transition/list`, data)
export const editStateTran = data => req.put(`/state-config/transition`, data)
export const addStateTran = data => req.post(`/state-config/transition`, data)
export const deleteStateTran = id => req.delete(`/state-config/transition?ids=${id}`)

// export const getCiTemplate = data => req.get(`/ci-template`)
export const editCiTemplate = data => req.put(`/ci-template`, data)
export const addCiTemplate = data => req.post(`/ci-template`, data)
export const deleteCiTemplate = id => req.delete(`/ci-template?ids=${id}`)

export const getCiTemplateAttr = params => req.post(`/ci-template-attr/list`, params)
export const editCiTemplateAttr = data => req.put(`/ci-template-attr`, data)
export const addCiTemplateAttr = data => req.post(`/ci-template-attr`, data)
export const deleteCiTemplateAttr = id => req.delete(`/ci-template-attr?ids=${id}`)
export const getReportDetail = reportId => req.get(`/report-message/${reportId}`)

export const editGraph = data => req.put(`/view-graphs`, data)
export const editView = data => req.put(`/views`, data)
export const getViewById = viewId => req.get(`/view-message/${viewId}`)

export const exportReport = data => req.post(`/report/export`, data)
export const importReport = data => req.post(`/ci-data/import/${data.ciType}`, data.data)
export const importCiData = data => req.post(`/ci-data/simple/import/${data.ciType}`, data.data)

export const getEncryptKey = () => req.get(`/ci-data/password/encrypt-key`)
// 获取视图dot
export const viewGraphDot = data => req.post(`/view-graph-data`, data)
