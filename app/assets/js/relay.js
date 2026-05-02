import "../css/application.scss"
import htmx from "htmx.org"

window.htmx = htmx
require("htmx-ext-ws")

import { Relay } from "../js/lib/relay"

;(function() {
  document.addEventListener("DOMContentLoaded", () => {
    Relay().start()
  })
})()
