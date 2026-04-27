export const Controller = (impl = {}) => {
  return {
    start: impl.start || (() => {}),
    stop: impl.stop || (() => {}),
    enhance: impl.enhance || (() => {})
  }
}
