import { getAllSystemEnumCodes } from '@/api/server.js'

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
      .filter(_ => _.code !== 'insert' && _.code !== 'update' && _.code !== 'delete')
      .map(item => {
        switch (item.code) {
          case 'confirm':
            return {
              label: item.value,
              props: {
                type: 'info',
                size: 'small'
              },
              isLoading: row => !!row.weTableForm.confirmLoading,
              actionType: 'confirm',
              visible: {
                key: 'nextOperations',
                value: true
              }
            }
          case 'discard':
            return {
              label: item.value,
              props: {
                type: 'warning',
                size: 'small'
              },
              isLoading: row => !!row.weTableForm.discardLoading,
              actionType: 'discard',
              visible: {
                key: 'nextOperations',
                value: true
              }
            }
          case 'startup':
            return {
              label: item.value,
              props: {
                type: 'success',
                size: 'small'
              },
              isLoading: row => !!row.weTableForm.startupLoading,
              actionType: 'startup',
              visible: {
                key: 'nextOperations',
                value: true
              }
            }
          case 'stop':
            return {
              label: item.value,
              props: {
                type: 'error',
                size: 'small'
              },
              isLoading: row => !!row.weTableForm.stopLoading,
              actionType: 'stop',
              visible: {
                key: 'nextOperations',
                value: true
              }
            }
          default:
            return {
              label: item.value,
              props: {
                type: 'info',
                size: 'small'
              },
              isLoading: row => !!row.weTableForm[`${item.code}Loading`],
              actionType: item.code,
              visible: {
                key: 'nextOperations',
                value: true
              }
            }
        }
      })
  } else {
    return []
  }
}
