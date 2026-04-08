/**
 * AudioVisualizer Web Component
 *
 * Converts the Ember AudioVisualizer component to a standard Web Component.
 * Renders a real-time waveform/frequency visualizer using the Web Audio API
 * connected to the radio player audio element.
 */
class AudioVisualizerElement extends HTMLElement {
  constructor() {
    super()
    this._animationId = null
    this._audioContext = null
    this._analyser = null
    this._source = null
  }

  connectedCallback() {
    this._canvas = this.querySelector("canvas") || this._createCanvas()
    this._ctx = this._canvas.getContext("2d")
    this._bindToAudioPlayer()
  }

  disconnectedCallback() {
    if (this._animationId) {
      cancelAnimationFrame(this._animationId)
      this._animationId = null
    }
    if (this._audioContext) {
      this._audioContext.close()
      this._audioContext = null
    }
  }

  _createCanvas() {
    const canvas = document.createElement("canvas")
    canvas.id = "visualizer"
    canvas.width = 4000
    canvas.height = 150
    canvas.className = "h-20"
    this.appendChild(canvas)
    return canvas
  }

  _bindToAudioPlayer() {
    const audio = document.getElementById("radio-player")
    if (!audio) {
      setTimeout(() => this._bindToAudioPlayer(), 500)
      return
    }

    audio.addEventListener("play", () => this._startVisualizer(audio), { once: false })
    audio.addEventListener("pause", () => this._stopDraw())
  }

  _startVisualizer(audio) {
    if (this._audioContext) return

    try {
      this._audioContext = new (window.AudioContext || window.webkitAudioContext)()
      this._analyser = this._audioContext.createAnalyser()
      this._analyser.fftSize = 256
      this._source = this._audioContext.createMediaElementSource(audio)
      this._source.connect(this._analyser)
      this._analyser.connect(this._audioContext.destination)
      this._draw()
    } catch (e) {
      console.warn("AudioVisualizer: Web Audio API not supported or error occurred", e)
    }
  }

  _stopDraw() {
    if (this._animationId) {
      cancelAnimationFrame(this._animationId)
      this._animationId = null
    }
  }

  _draw() {
    if (!this._analyser || !this._canvas) return

    const bufferLength = this._analyser.frequencyBinCount
    const dataArray = new Uint8Array(bufferLength)

    const render = () => {
      this._animationId = requestAnimationFrame(render)
      this._analyser.getByteFrequencyData(dataArray)

      const width = this._canvas.width
      const height = this._canvas.height
      this._ctx.clearRect(0, 0, width, height)

      const barWidth = (width / bufferLength) * 2.5
      let x = 0

      for (let i = 0; i < bufferLength; i++) {
        const barHeight = dataArray[i]
        const r = barHeight + 25 * (i / bufferLength)
        const g = 250 * (i / bufferLength)
        const b = 50

        this._ctx.fillStyle = `rgb(${r},${g},${b})`
        this._ctx.fillRect(x, height - barHeight / 2, barWidth, barHeight / 2)
        x += barWidth + 1
      }
    }

    render()
  }
}

if (!customElements.get("audio-visualizer")) {
  customElements.define("audio-visualizer", AudioVisualizerElement)
}
