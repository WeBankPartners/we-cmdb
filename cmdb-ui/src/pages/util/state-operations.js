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
