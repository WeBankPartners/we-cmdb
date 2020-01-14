const getCiTypeEnabledAction = (name, actions) => {
  if (!actions) {
    return false
  } else {
    if (actions.enabledActions) {
      return !!actions.enabledActions.find(_ => _ === name)
    }
  }
}

const getCiTypeAttribute = (ciTypeAttributeId, attributePermissions) => {
  if (!attributePermissions) {
    return []
  } else {
    const ciTypeAttribute = attributePermissions.find(_ => _.ciTypeAttributeId === ciTypeAttributeId)
    return ciTypeAttribute ? ciTypeAttribute.enabledOptions : []
  }
}

export const formatDataPermissionTree = (
  checkable,
  data,
  setPermissionAction,
  setCITypeAttrsAttr,
  selectedPermission = []
) => {
  const tagsDefaultStyle = { border: '#515a61 1px dashed' }
  const tagsDefaultProps = {
    checkable: checkable || false,
    color: 'success'
  }
  return data.ciPermissionEntryPoints.map(_ => {
    const ciType = selectedPermission.find(c => _.ciTypeId === c.ciTypeId)
    return {
      title: _.ciTypeName,
      id: _.ciTypeId,
      expand: true,
      render: (h, { root, node, data }) => {
        return h(
          'div',
          {
            style: {
              display: 'inline-block',
              width: '100%'
            }
          },
          [
            h('span', data.title),
            h(
              'div',
              {
                style: {
                  display: 'inline-block',
                  float: 'right',
                  marginRight: '32px'
                }
              },
              [
                h(
                  'Tag',
                  {
                    props: {
                      name: 'CREATE',
                      ...tagsDefaultProps,
                      checked: getCiTypeEnabledAction('CREATE', ciType)
                    },
                    style: tagsDefaultStyle,
                    on: {
                      'on-change': (checked, name) => {
                        setPermissionAction(checked, name, data.id)
                      }
                    }
                  },
                  this.$t('permission_management_data_creation')
                ),
                h(
                  'Tag',
                  {
                    props: {
                      name: 'REMOVE',
                      ...tagsDefaultProps,
                      checked: getCiTypeEnabledAction('REMOVE', ciType)
                    },
                    style: tagsDefaultStyle,
                    on: {
                      'on-change': (checked, name) => {
                        setPermissionAction(checked, name, data.id)
                      }
                    }
                  },
                  this.$t('permission_management_data_removal')
                ),
                h(
                  'Tag',
                  {
                    props: {
                      name: 'MODIFY',
                      ...tagsDefaultProps,
                      checked: getCiTypeEnabledAction('MODIFY', ciType)
                    },
                    style: tagsDefaultStyle,
                    on: {
                      'on-change': (checked, name) => {
                        setPermissionAction(checked, name, data.id)
                      }
                    }
                  },
                  this.$t('permission_management_data_modification')
                ),
                h(
                  'Tag',
                  {
                    props: {
                      name: 'QUERY',
                      ...tagsDefaultProps,
                      checked: getCiTypeEnabledAction('QUERY', ciType)
                    },
                    style: tagsDefaultStyle,
                    on: {
                      'on-change': (checked, name) => {
                        setPermissionAction(checked, name, data.id)
                      }
                    }
                  },
                  this.$t('permission_management_data_enquiry')
                ),
                h(
                  'Tag',
                  {
                    props: {
                      name: 'PERFORM',
                      ...tagsDefaultProps,
                      checked: getCiTypeEnabledAction('PERFORM', ciType)
                    },
                    style: tagsDefaultStyle,
                    on: {
                      'on-change': (checked, name) => {
                        setPermissionAction(checked, name, data.id)
                      }
                    }
                  },
                  this.$t('permission_management_data_execution')
                ),
                h(
                  'Tag',
                  {
                    props: {
                      name: 'GRANT',
                      ...tagsDefaultProps,
                      checked: getCiTypeEnabledAction('GRANT', ciType)
                    },
                    style: tagsDefaultStyle,
                    on: {
                      'on-change': (checked, name) => {
                        setPermissionAction(checked, name, data.id)
                      }
                    }
                  },
                  this.$t('permission_management_data_empower')
                )
              ]
            )
          ]
        )
      },
      children: _.attributeAuthenticationEntryPoints
        ? _.attributeAuthenticationEntryPoints.map(j => {
          return {
            title: j.ciTypeAttributeName,
            id: j.ciTypeAttributeId,
            expand: true,
            render: (h, { root, node, data }) => {
              return h(
                'div',
                {
                  style: {
                    display: 'inline-block',
                    width: '100%'
                  }
                },
                [
                  h('span', data.title),
                  h(
                    'div',
                    {
                      style: {
                        display: 'inline-block',
                        float: 'right',
                        marginRight: '35px',
                        maxWidth: '200px'
                      }
                    },
                    [
                      h(
                        'Select',
                        {
                          props: {
                            disabled: !checkable,
                            multiple: true,
                            size: 'small',
                            value: ciType ? getCiTypeAttribute(data.id, ciType.attributePermissions) : []
                          },
                          style: {
                            overflow: 'hidden'
                          },
                          on: {
                            'on-change': value => {
                              setCITypeAttrsAttr(value, j.ciTypeAttributeId)
                            }
                          }
                        },
                        j.options.map(o => {
                          return h(
                            'Option',
                            {
                              props: {
                                key: o.key,
                                value: o.key
                              }
                            },
                            o.value
                          )
                        })
                      )
                    ]
                  )
                ]
              )
            }
          }
        })
        : []
    }
  })
}
