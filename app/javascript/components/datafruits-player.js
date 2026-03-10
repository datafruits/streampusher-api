/**
 * DatafruitsPlayer Web Component
 *
 * Converts the Ember DatafruitsPlayer component to a standard Web Component.
 * Handles audio playback for both the live stream and podcast episodes.
 *
 * Ember services replaced by:
 *   - metadata service → custom "metadataupdate" events via ActionCable/Turbo Streams
 *   - eventBus service → native DOM CustomEvents
 *   - fastboot service → not needed (server-rendered)
 *   - videoStream service → VideoStreamElement web component (optional integration)
 */
class DatafruitsPlayerElement extends HTMLElement {
  constructor() {
    super()
    this._playerState = "paused" // "playing" | "loading" | "paused"
    this._muted = false
    this._showingVolumeControl = false
    this._volume = 0.8
    this._oldVolume = 0.8
    this._playButtonPressed = false
    this._playingPodcast = false
    this._title = ""
    this._episodeId = ""
    this._showSeriesId = ""
    this._playTime = 0.0
    this._duration = 0.0
    this._playTimePercentage = 0.0
    this._podcastTrackId = ""
    this._debounceVolumeHideTimer = null
  }

  connectedCallback() {
    this._volume = parseFloat(localStorage.getItem("datafruits-volume")) || 0.8

    this._bindEventListeners()
    this._setupAudioElement()
    this._setRadioTitle()
    this._render()
  }

  disconnectedCallback() {
    document.removeEventListener("trackPlayed", this._onTrackPlayed)
    document.removeEventListener("trackPaused", this._onTrackPaused)
    document.removeEventListener("metadataUpdate", this._onMetadataUpdate)
    document.removeEventListener("canonicalMetadataUpdate", this._onCanonicalMetadataUpdate)
  }

  _bindEventListeners() {
    this._onTrackPlayed = this._handleTrackPlayed.bind(this)
    this._onTrackPaused = this._handleTrackPaused.bind(this)
    this._onMetadataUpdate = this._handleMetadataUpdate.bind(this)
    this._onCanonicalMetadataUpdate = this._handleCanonicalMetadataUpdate.bind(this)

    document.addEventListener("trackPlayed", this._onTrackPlayed)
    document.addEventListener("trackPaused", this._onTrackPaused)
    document.addEventListener("metadataUpdate", this._onMetadataUpdate)
    document.addEventListener("canonicalMetadataUpdate", this._onCanonicalMetadataUpdate)
  }

  _setupAudioElement() {
    const audio = this.querySelector("#radio-player")
    if (!audio) return

    audio.volume = this._volume

    audio.addEventListener("loadstart", () => {
      if (this._playButtonPressed) {
        this._playerState = audio.readyState === 0 ? "loading" : "seeking"
        this._render()
      }
      this.querySelector(".seek")?.classList.add("seeking")
    })
    audio.addEventListener("pause", () => {
      this._playerState = "paused"
      this._render()
    })
    audio.addEventListener("playing", () => {
      this._playerState = "playing"
      this._render()
    })
    audio.addEventListener("timeupdate", () => {
      if (audio.duration) {
        this._playTimePercentage = (100 / audio.duration) * audio.currentTime
        if (this._playingPodcast) {
          this._playTime = audio.currentTime
          this._duration = audio.duration
        }
        this._renderProgress()
      }
    })
    audio.addEventListener("canplay", () => {
      this._duration = audio.duration
      this.querySelector(".seek-bar-wrapper")?.classList.remove("seeking")
      this.querySelector(".seek")?.classList.remove("seeking")
      this._render()
    })
  }

  _getIcecastHost() {
    return this.dataset.icecastHost || "https://streampusher-relay.club"
  }

  _handleTrackPlayed(event) {
    const { track_id, title, cdnUrl } = event.detail
    const audio = this.querySelector("#radio-player")
    if (!audio) return

    if (String(this._podcastTrackId) !== String(track_id)) {
      this._title = title
      this._podcastTrackId = String(track_id)
      this._setPageTitle()
      this._playingPodcast = true
      this._playTime = 0.0
      this._playTimePercentage = 0.0
      audio.src = cdnUrl
      if (audio.readyState === 0) {
        this._playerState = "loading"
      }
    }
    audio.play().catch(e => console.error("Audio play failed", e))
    this._render()
  }

  _handleTrackPaused() {
    const audio = this.querySelector("#radio-player")
    if (!audio) return
    audio.pause()
    this._playButtonPressed = false
    this._playerState = "paused"
    this._render()
  }

  _handleMetadataUpdate(event) {
    if (!this._playingPodcast) {
      this._title = event.detail.title || ""
    }
    this._setPageTitle()
    this._render()
  }

  _handleCanonicalMetadataUpdate(event) {
    this._episodeId = event.detail.episode_id || ""
    this._showSeriesId = event.detail.show_series_id || ""
    this._render()
  }

  _setPageTitle() {
    document.title = this._title ? `DATAFRUITS.FM - ${this._title}` : "DATAFRUITS.FM"
  }

  _setRadioTitle() {
    const metaTitle = document.querySelector('meta[name="now-playing-title"]')
    if (metaTitle) {
      this._title = metaTitle.getAttribute("content") || ""
    }
    this._setPageTitle()
  }

  _play() {
    const audio = this.querySelector("#radio-player")
    if (!audio) return

    if (!this._playingPodcast) {
      audio.src = `${this._getIcecastHost()}/datafruits.mp3`
    }
    if (audio.readyState === 0) {
      this._playerState = "loading"
    }
    audio.play().catch(e => console.error("Audio play failed", e))
    this._playButtonPressed = true
    this._render()
  }

  _pause() {
    const audio = this.querySelector("#radio-player")
    if (!audio) return
    audio.pause()
    this._playButtonPressed = false
    this._playerState = "paused"
    document.dispatchEvent(new CustomEvent("trackPaused", {
      detail: { track_id: this._podcastTrackId }
    }))
    this._render()
  }

  _mute() {
    const audio = this.querySelector("#radio-player")
    if (audio) audio.muted = true
    this._muted = true
    this._oldVolume = this._volume
    this._volume = 0.0
    localStorage.setItem("datafruits-volume", "0")
    this._render()
  }

  _unmute() {
    const audio = this.querySelector("#radio-player")
    if (audio) audio.muted = false
    this._muted = false
    this._volume = this._oldVolume
    localStorage.setItem("datafruits-volume", String(this._volume))
    this._render()
  }

  _playLiveStream() {
    const audio = this.querySelector("#radio-player")
    if (!audio) return
    audio.pause()
    this._playingPodcast = false
    this._setRadioTitle()
    audio.src = `${this._getIcecastHost()}/datafruits.mp3`
    audio.play().catch(e => console.error("Audio play failed", e))
    this._render()
  }

  _seek(percentage) {
    const audio = this.querySelector("#radio-player")
    if (!audio) return
    audio.currentTime = audio.duration * (percentage / 100)
  }

  _setVolume(value) {
    this._volume = parseFloat(value)
    const audio = this.querySelector("#radio-player")
    if (audio) audio.volume = this._volume
    localStorage.setItem("datafruits-volume", String(this._volume))
  }

  _formatTime(time) {
    const hours = Math.floor(time / 3600)
    const minutes = Math.floor((time % 3600) / 60)
    const seconds = Math.floor(time % 60)
    return [hours, minutes, seconds].map(n => String(n).padStart(2, "0")).join(":")
  }

  get _formattedPlayTime() {
    if (this._playTime) {
      return `${this._formatTime(this._playTime)} / ${this._formatTime(this._duration)}`
    }
    return "..."
  }

  get _isLive() {
    return this._title && this._title.startsWith("LIVE")
  }

  get _currentShowPresent() {
    return this._episodeId && this._showSeriesId
  }

  get _volumeString() {
    return `${Math.floor(this._volume * 100)}%`
  }

  _renderProgress() {
    const seekBar = this.querySelector(".seek-bar")
    if (seekBar) seekBar.value = this._playTimePercentage

    const timeDisplay = this.querySelector(".play-time-display")
    if (timeDisplay) timeDisplay.textContent = this._formattedPlayTime
  }

  _render() {
    const controls = this.querySelector(".player-controls")
    if (!controls) return

    this._renderLoadingState(controls)
    this._renderVolumeControl()
    this._renderNowPlaying()
    this._renderSeekBar()
    this._renderPlayTime()
    this._renderReturnToLive()
  }

  _renderLoadingState(controls) {
    const loadingEl = controls.querySelector("#loading-stream")
    const playEl = controls.querySelector("#play-stream")
    const pauseEl = controls.querySelector("#pause-stream")

    if (loadingEl) loadingEl.classList.toggle("hidden", this._playerState !== "loading")
    if (playEl) playEl.classList.toggle("hidden", this._playerState !== "paused")
    if (pauseEl) pauseEl.classList.toggle("hidden", this._playerState !== "playing")
  }

  _renderVolumeControl() {
    const muteBtn = this.querySelector(".jp-mute")
    const unmuteBtn = this.querySelector(".jp-unmute")
    if (muteBtn) muteBtn.classList.toggle("hidden", this._muted)
    if (unmuteBtn) unmuteBtn.classList.toggle("hidden", !this._muted)

    const volumeInput = this.querySelector(".volume-control")
    if (volumeInput) {
      volumeInput.value = this._volume
      volumeInput.parentElement?.classList.toggle("hidden", !this._showingVolumeControl)
    }

    const volumeStr = this.querySelector(".volume-string")
    if (volumeStr) volumeStr.textContent = this._volumeString
  }

  _renderNowPlaying() {
    const titleEl = this.querySelector(".jp-title")
    if (titleEl) titleEl.textContent = this._title || ""
  }

  _renderSeekBar() {
    const seekSection = this.querySelector(".seek")
    if (seekSection) {
      seekSection.classList.toggle("hidden", !this._playingPodcast)
    }
  }

  _renderPlayTime() {
    const timeEl = this.querySelector(".play-time-display")
    if (timeEl) {
      timeEl.classList.toggle("hidden", !(this._playingPodcast && this._playerState === "playing"))
      timeEl.textContent = this._formattedPlayTime
    }
  }

  _renderReturnToLive() {
    const returnBtn = this.querySelector(".return-to-live")
    if (returnBtn) returnBtn.classList.toggle("hidden", !this._playingPodcast)
  }

  _attachClickHandlers() {
    // Play / Pause
    this.querySelector("#play-stream")?.addEventListener("click", e => {
      e.preventDefault()
      this._play()
    })
    this.querySelector("#pause-stream")?.addEventListener("click", e => {
      e.preventDefault()
      this._pause()
    })

    // Mute / Unmute
    this.querySelector(".jp-mute")?.addEventListener("click", e => {
      e.preventDefault()
      this._mute()
    })
    this.querySelector(".jp-unmute")?.addEventListener("click", e => {
      e.preventDefault()
      this._unmute()
    })

    // Volume
    this.querySelector(".volume-control")?.addEventListener("input", e => {
      this._setVolume(e.target.value)
    })

    // Volume control show/hide
    const volumeBtn = this.querySelector("#volume-control")
    volumeBtn?.addEventListener("mouseenter", () => {
      this._showingVolumeControl = true
      this._render()
    })
    volumeBtn?.addEventListener("mouseleave", () => {
      if (this._debounceVolumeHideTimer) clearTimeout(this._debounceVolumeHideTimer)
      this._debounceVolumeHideTimer = setTimeout(() => {
        this._showingVolumeControl = false
        this._render()
      }, 3000)
    })

    // Seek
    this.querySelector(".seek-bar")?.addEventListener("input", e => {
      this._seek(e.target.value)
    })

    // Return to live
    this.querySelector(".return-to-live")?.addEventListener("click", e => {
      e.preventDefault()
      this._playLiveStream()
    })
  }
}

if (!customElements.get("datafruits-player")) {
  customElements.define("datafruits-player", DatafruitsPlayerElement)
}
