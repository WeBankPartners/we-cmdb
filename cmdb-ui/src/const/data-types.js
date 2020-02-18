export const INPUT_TYPES = [
  {
    value: 'text',
    label: '文本'
  },
  {
    value: 'textArea',
    label: '文本框'
  },
  {
    value: 'date',
    label: '日期'
  },
  {
    value: 'ref',
    label: '引用'
  },
  {
    value: 'multiRef',
    label: '多选引用'
  },
  {
    value: 'select',
    label: '枚举'
  },
  {
    value: 'multiSelect',
    label: '多选枚举'
  }
]

export const PROPERTY_TYPE_MAP = {
  text: 'varchar',
  number: 'int',
  date: 'datetime',
  textArea: 'varchar',
  select: 'int',
  multiSelect: 'varchar',
  ref: 'varchar',
  multiRef: 'varchar',
  password: 'varchar'
}
