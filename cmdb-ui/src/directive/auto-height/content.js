export default {
  bind (el) {},
  inserted (el, binding, vnode) {
    const modalEl = el.querySelector('.ivu-modal')
    const scrollEl = el.querySelector('.ivu-modal-body')
    const clientHeight = document.documentElement.clientHeight
    scrollEl.style.maxHeight = clientHeight - 200 + 'px'
    scrollEl.style.overflowY = 'scroll'
    scrollEl.style.position = 'relative'
    modalEl.style.top = '50px'
  }
}
