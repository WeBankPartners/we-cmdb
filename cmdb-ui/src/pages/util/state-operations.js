import { getAllSystemEnumCodes } from '@/api/server.js'
const types = {
  confirm: 'info',
  discard: 'warning',
  startup: 'success',
  stop: 'error'
}
export const getExtraInnerActions = async () => {
  const { data, statusCode } = await getAllSystemEnumCodes({
    filters: [
      {
        name: 'cat.catName',
        operator: 'eq',
        value: 'state_transition_operation'
      }
    ],
    paging: false
  })
  if (statusCode === 'OK') {
    return data.contents
      .filter(_ => _.code !== 'insert' && _.code !== 'update' && _.code !== 'delete') // update delete 表示可编辑和可删除，
      .map(item => {
        return {
          label: item.value,
          props: {
            type: types[item.code] || 'info',
            size: 'small'
          },
          isLoading: row => !!row.weTableForm.confirmLoading,
          actionType: item.code,
          visible: {
            key: 'nextOperations',
            value: true
          }
        }
      })
  } else {
    return []
  }
}
