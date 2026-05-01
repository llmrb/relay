const Timer = function(parentEl) {
  if (!parentEl)
    return null

  const self = Object.create(null)

  self.parentEl = parentEl
  self.timeout = null
  self.startTime = null
  self.el = null

  const getSpan = (parent = self.parentEl) => {
    return parent?.querySelector(".status-value")
  }

  const getTextEl = (parent = self.parentEl) => {
    return parent?.querySelector(".status-text")
  }

  const create = () => {
    const timer = document.createElement("span")
    timer.className = "timer-value"
    return timer
  }

  const update = (elapsedSeconds) => {
    if (!self.el) return
    self.el.textContent = `${elapsedSeconds}s`
    if (elapsedSeconds >= 10)
      self.el.title = `Running for ${elapsedSeconds} seconds`
    else
      self.el.removeAttribute("title")
  }

  const tick = () => {
    if (!self.startTime) return
    const elapsedMs = Date.now() - self.startTime
    const elapsedSeconds = Math.floor(elapsedMs / 1000)
    update(elapsedSeconds)
    const delay = 1000 - (elapsedMs % 1000)
    self.timeout = setTimeout(tick, delay)
  }

  const attachTo = (textEl) => {
    if (self.el && !self.el.isConnected)
      self.el = null
    if (!textEl || self.el) return
    self.el = create()
    const wrapper = document.createElement("span")
    wrapper.className = "status-active"
    const originalText = textEl.textContent.replace(/\s*\(\d+s\)$/, "")
    const textNode = document.createTextNode(originalText)
    textEl.textContent = ""
    wrapper.appendChild(textNode)
    wrapper.appendChild(self.el)
    textEl.appendChild(wrapper)
  }

  const detach = () => {
    if (!self.el) return
    if (self.el.parentNode)
      self.el.parentNode.remove()
    self.el = null
  }

  const start = (statusText) => {
    if (self.timeout)
      clearTimeout(self.timeout)
    self.startTime = Date.now()
    const textEl = getTextEl()
    if (!textEl) return
    attachTo(textEl)
    update(0)
    self.timeout = setTimeout(tick, 1000)
  }

  const stop = () => {
    if (self.timeout)
      clearTimeout(self.timeout)
    self.timeout = null
    detach()
    self.startTime = null
  }

  self.handle = (parent) => {
    const span = getSpan(parent)
    if (!span) return
    const statusText = span.textContent.trim()
    if (
      statusText.startsWith("Thinking") ||
      statusText.startsWith("Running") ||
      statusText.startsWith("Compacting")
    )
      start(statusText)
    else
      stop()
  }

  return self
}

export { Timer }
