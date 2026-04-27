import { Controller } from "."

export const MCPFormController = ({target}) => {
  const selectors = {
    root: "#mcp-modal-root",
    modal: "#mcp-modal"
  }

  const close = () => {
    const root = target.querySelector(selectors.root)
    if (root)
      root.innerHTML = ""
  }

  const onClick = (event) => {
    const clicked = event.target instanceof Element ? event.target : null
    if (!clicked)
      return
    if (clicked.closest("[data-mcp-close='true']"))
      close()
  }

  const onKeydown = (event) => {
    if (event.key !== "Escape")
      return
    if (!target.querySelector(selectors.modal))
      return
    close()
  }

  const start = () => {
    target.addEventListener("click", onClick)
    target.addEventListener("keydown", onKeydown)
  }

  const stop = () => {
    target.removeEventListener("click", onClick)
    target.removeEventListener("keydown", onKeydown)
  }

  return Controller({start, stop})
}
