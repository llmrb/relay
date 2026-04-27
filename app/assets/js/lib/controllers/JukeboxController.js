import { Jukebox } from "../../jukebox"

import { Controller } from "."

export const JukeboxController = ({target}) => {
  const jukebox = Jukebox()

  const enhance = (root = target) => {
    const nodes = root.querySelectorAll(".assistant-content")
    if (nodes.length > 0)
      jukebox.scanForMusic(nodes[nodes.length - 1])
  }

  return Controller({enhance})
}
