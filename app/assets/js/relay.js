import "../css/application.css"
import htmx from "htmx.org"
import hljs from "highlight.js"
import { marked } from "marked"

window.htmx = htmx
window.marked = marked
require("htmx-ext-ws")

import { Jukebox } from "../js/jukebox"
import { Timer } from "../js/jukebox/timer"

;(function() {
  document.addEventListener("DOMContentLoaded", () => {
    const jukebox = Jukebox()
    const timer = Timer(document.getElementById("chatbot-status"))

    let shouldFollow = true

    const streamEl = () => document.getElementById("chatbot-stream")

    const isNearBottom = (el, threshold = 48) => {
      if (!el) return true
      return el.scrollHeight - el.scrollTop - el.clientHeight <= threshold
    }

    const scroll = () => {
      const stream = streamEl()
      if (!stream) return
      stream.scrollTop = stream.scrollHeight
    }

    const follow = () => {
      if (!shouldFollow) return

      scroll()
      requestAnimationFrame(() => {
        if (shouldFollow) scroll()
      })
      setTimeout(() => {
        if (shouldFollow) scroll()
      }, 0)
      setTimeout(() => {
        if (shouldFollow) scroll()
      }, 32)
    }

    const bindScrollTracking = () => {
      const stream = streamEl()
      if (!stream || stream.dataset.followBound === "true") return

      stream.dataset.followBound = "true"
      shouldFollow = isNearBottom(stream)

      stream.addEventListener("scroll", () => {
        shouldFollow = isNearBottom(stream)
      }, { passive: true })
    }

    const syntaxHighlight = (el) =>{
      hljs.highlightElement(el)
    }

    const modifyAnchors = (el) =>{
      el.setAttribute("target", "_blank")
      el.setAttribute("rel", "noreferrer noopener")
    }

    const markdown = (root = document.body) => {
      const nodes = root.querySelectorAll("[data-markdown]")
      nodes.forEach((node, index) => {
        node.innerHTML = marked.parse(node.dataset.markdownSource || "")
        node.querySelectorAll("pre code").forEach(syntaxHighlight)
        node.querySelectorAll("a").forEach(modifyAnchors)
        if (index === nodes.length - 1)
          jukebox.scanForMusic(node)
      })
    }

    // Handle status updates from HTMX
    document.body.addEventListener("htmx:oobAfterSwap", (event) => {
      if (event.target.id === "chatbot-status") {
        timer.parentEl = event.target
        timer.handle(event.target)
      }
    })

    markdown()
    bindScrollTracking()
    follow()

    document.body.addEventListener("htmx:afterSwap", (event) => {
      markdown(event.target)
      bindScrollTracking()
    })

    document.body.addEventListener("htmx:oobAfterSwap", (event) => {
      markdown(event.target)
      bindScrollTracking()
      follow()
    })
  })
})()
