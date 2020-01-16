export const addEvent = (selector, type, fn) => {
  let nodesEl = document.querySelectorAll(selector)
  let length = nodesEl.length
  const func = e => {
    fn(e)
  }
  for (let i = 0; i < length; i++) {
    let node = nodesEl[i]
    node.removeEventListener(type, func)
    node.addEventListener(type, func)
  }
}
