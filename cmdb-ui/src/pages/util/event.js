export const addEvent = (selector, type, fn) => {
  let nodesEl = document.querySelectorAll(selector)
  console.log(nodesEl)
  let length = nodesEl.length
  for (let i = 0; i < length; i++) {
    let node = nodesEl[i]
    node.removeEventListener(type, fn)
    node.addEventListener(type, fn)
  }
}
