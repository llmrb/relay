import "../css/application.css"
import htmx from "htmx.org"
import hljs from "highlight.js"
import { marked } from "marked"

window.htmx = htmx
window.marked = marked
require("htmx-ext-ws")

import { Jukebox } from "../js/jukebox"

;(function() {
  document.addEventListener("DOMContentLoaded", () => {
    const jukebox = Jukebox()
    const scroll = () => {
      const stream = document.getElementById("chatbot-stream")
      if (!stream) return
      stream.scrollTop = stream.scrollHeight
    }

    const follow = () => {
      scroll()
      requestAnimationFrame(scroll)
      setTimeout(scroll, 0)
      setTimeout(scroll, 32)
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

    // Simple timer functionality for thinking/tool execution
    let timerInterval = null
    let timerStartTime = null

    const startTimer = (statusText) => {
      if (timerInterval) {
        clearInterval(timerInterval)
      }
      
      timerStartTime = Date.now()
      timerInterval = setInterval(() => {
        const elapsedSeconds = Math.floor((Date.now() - timerStartTime) / 1000)
        updateStatusText(`${statusText} (${elapsedSeconds}s)`)
      }, 1000)
      
      // Initial update
      updateStatusText(`${statusText} (0s)`)
    }

    const stopTimer = () => {
      if (timerInterval) {
        clearInterval(timerInterval)
        timerInterval = null
      }
      timerStartTime = null
    }

    const updateStatusText = (text) => {
      const statusElement = document.getElementById("chatbot-status")
      if (!statusElement) return
      
      const statusSpan = statusElement.querySelector(".font-medium.text-zinc-100")
      if (statusSpan) {
        statusSpan.textContent = text
      }
    }

    // Handle status updates from HTMX
    document.body.addEventListener("htmx:oobAfterSwap", (event) => {
      if (event.target.id === "chatbot-status") {
        const statusSpan = event.target.querySelector(".font-medium.text-zinc-100")
        if (!statusSpan) return
        
        const statusText = statusSpan.textContent.trim()
        
        // Check if we should start/stop timer
        if (statusText.startsWith("Thinking") || statusText.startsWith("Running")) {
          // Extract base status without existing timer
          const baseStatus = statusText.replace(/\s*\(\d+s\)$/, "")
          startTimer(baseStatus)
        } else {
          stopTimer()
        }
      }
    })

    markdown()
    follow()

    document.body.addEventListener("htmx:afterSwap", (event) => markdown(event.target))
    document.body.addEventListener("htmx:oobAfterSwap", (event) => {
      markdown(event.target)
      follow()
    })
  })
})()