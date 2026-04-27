import { Controller } from "."

export const ActivityController = ({target}) => {
  const indicator = target.querySelector("#htmx-activity")
  const bar = target.querySelector("#htmx-activity-bar")

  const sync = () => {
    const active = target.querySelector(".htmx-request") !== null
    if (indicator) {
      indicator.classList.toggle("is-active", active)
      indicator.setAttribute("aria-busy", active ? "true" : "false")
    }
    if (bar)
      bar.classList.toggle("is-active", active)
  }

  const ignoresEvent = (event) => {
    return event.detail.requestConfig?.elt?.closest("[hx-ext='ws']")
  }

  const beginRequest = (event) => {
    if (ignoresEvent(event))
      return
    requestAnimationFrame(sync)
  }

  const endRequest = (event) => {
    if (ignoresEvent(event))
      return
    requestAnimationFrame(sync)
  }

  const afterSettle = () => {
    requestAnimationFrame(sync)
  }

  const start = () => {
    target.addEventListener("htmx:beforeRequest", beginRequest)
    target.addEventListener("htmx:afterRequest", endRequest)
    target.addEventListener("htmx:sendError", endRequest)
    target.addEventListener("htmx:responseError", endRequest)
    target.addEventListener("htmx:afterSettle", afterSettle)
    sync()
  }

  const stop = () => {
    target.removeEventListener("htmx:beforeRequest", beginRequest)
    target.removeEventListener("htmx:afterRequest", endRequest)
    target.removeEventListener("htmx:sendError", endRequest)
    target.removeEventListener("htmx:responseError", endRequest)
    target.removeEventListener("htmx:afterSettle", afterSettle)
  }

  return Controller({
    start,
    stop,
    enhance: sync
  })
}
