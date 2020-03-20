export const resetButtonDisabled = v => {
  return !(v.actionType === 'add' || v.actionType === 'export' || v.actionType === 'cancel')
}
