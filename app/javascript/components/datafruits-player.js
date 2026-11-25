// Recording controls can dispatch datafruits:play with { url, title, id } in detail.
class DatafruitsPlayer extends HTMLElement {
  connectedCallback() {
    if (this.controller) return;
    this.controller = new AbortController();
    const { signal } = this.controller;
    this.audio = this.querySelector('audio');
    this.toggle = this.querySelector('[data-player-toggle]');
    this.status = this.querySelector('[data-player-status]');
    this.titleElement = this.querySelector('[data-player-title]');
    this.volume = this.querySelector('[data-player-volume]');
    this.seek = this.querySelector('[data-player-seek]');
    this.recording = null;
    this.liveTitle = 'DATAFRUITS.FM';
    this.loading = false;
    this.pendingPlay = false;
    this.playVersion = 0;
    try {
      const saved = localStorage.getItem('datafruits-volume');
      const value = saved === null ? 0.8 : Number(saved);
      this.audio.volume = Number.isFinite(value) ? Math.max(0, Math.min(1, value)) : 0.8;
    } catch { this.audio.volume = 0.8; }
    this.volume.value = this.audio.volume;
    const on = (target, event, handler) => target.addEventListener(event, handler, { signal });
    on(this.toggle, 'click', () => {
      if (this.pendingPlay || !this.audio.paused) this.pause();
      else this.play();
    });
    on(this.querySelector('[data-player-live]'), 'click', () => {
      this.pause();
      this.recording = null;
      this.audio.removeAttribute('src');
      this.render();
      this.play();
    });
    on(this.querySelector('[data-player-mute]'), 'click', () => {
      this.audio.muted = !this.audio.muted;
    });
    on(this.volume, 'input', () => {
      this.audio.volume = Number(this.volume.value);
      this.audio.muted = false;
      try { localStorage.setItem('datafruits-volume', this.volume.value); } catch { /* Storage may be disabled. */ }
    });
    on(this.audio, 'volumechange', () => {
      this.querySelector('[data-player-mute]').setAttribute('aria-pressed', String(this.audio.muted));
    });
    on(this.seek, 'input', () => {
      if (Number.isFinite(this.audio.duration)) this.audio.currentTime = this.audio.duration * Number(this.seek.value) / 100;
    });
    for (const event of ['waiting', 'seeking']) on(this.audio, event, () => {
      this.loading = !this.audio.paused;
      this.render();
    });
    for (const event of ['playing', 'pause', 'ended', 'seeked']) on(this.audio, event, () => {
      this.loading = false;
      this.render();
    });
    on(this.audio, 'error', () => {
      this.pendingPlay = false;
      this.loading = false;
      this.audio.pause();
      this.render();
      this.status.textContent = this.dataset.errorLabel;
    });
    for (const event of ['timeupdate', 'durationchange', 'loadedmetadata']) on(this.audio, event, () => this.renderProgress());
    on(document, 'datafruits:play', event => {
      const track = event.detail;
      if (!track?.url) return;
      const url = new URL(track.url, document.baseURI);
      if (!['https:', 'http:'].includes(url.protocol)) return;
      if (this.recording?.url !== url.href) {
        this.pause();
        this.recording = { ...track, url: url.href };
        this.audio.src = url.href;
      }
      this.play();
    });
    on(document, 'datafruits:pause', () => this.pause());
    this.render();
    this.refreshMetadata();
  }

  disconnectedCallback() {
    this.pause();
    this.controller?.abort();
    clearTimeout(this.metadataTimer);
    this.audio.removeAttribute('src');
    this.audio.load();
    this.controller = null;
  }

  async play() {
    const version = ++this.playVersion;
    this.status.textContent = '';
    if (!this.recording) this.audio.src = this.dataset.streamUrl;
    this.loading = true;
    this.pendingPlay = true;
    this.render();
    try {
      await this.audio.play();
    } catch (error) {
      if (version === this.playVersion && error.name !== 'AbortError') this.status.textContent = this.dataset.errorLabel;
    } finally {
      if (version === this.playVersion) {
        this.pendingPlay = false;
        this.loading = false;
        this.render();
      }
    }
  }

  pause() {
    ++this.playVersion;
    this.pendingPlay = false;
    this.loading = false;
    this.audio.pause();
    this.render();
  }

  render() {
    const active = this.pendingPlay || !this.audio.paused;
    this.toggle.textContent = active ? (this.recording ? this.dataset.pauseLabel : this.dataset.stopLabel) : this.dataset.playLabel;
    this.toggle.setAttribute('aria-busy', String(this.loading));
    if (this.loading) this.status.textContent = this.dataset.loadingLabel;
    else if (this.status.textContent === this.dataset.loadingLabel) this.status.textContent = '';
    this.titleElement.textContent = this.recording?.title || this.liveTitle;
    this.classList.toggle('playing-podcast', !!this.recording);
    this.classList.toggle('is-live', !this.recording && this.liveTitle.startsWith('LIVE'));
    this.querySelector('[data-player-live]').hidden = !this.recording;
    this.querySelector('[data-player-progress]').hidden = !this.recording;
    this.renderProgress();
  }

  renderProgress() {
    const duration = this.audio.duration;
    const valid = Number.isFinite(duration) && duration > 0;
    this.seek.disabled = !valid;
    this.seek.value = valid ? this.audio.currentTime / duration * 100 : 0;
    const format = seconds => {
      const total = Math.floor(Number.isFinite(seconds) ? seconds : 0);
      return [Math.floor(total / 3600), Math.floor(total / 60) % 60, total % 60]
        .map(value => String(value).padStart(2, '0')).join(':');
    };
    this.querySelector('[data-player-time]').textContent = `${format(this.audio.currentTime)} / ${format(duration)}`;
  }

  async refreshMetadata() {
    const { signal } = this.controller;
    try {
      const response = await fetch(this.dataset.metadataUrl, { signal, headers: { Accept: 'application/json' } });
      if (response.ok) {
        const metadata = await response.json();
        this.liveTitle = metadata.title || 'DATAFRUITS.FM';
        this.render();
      }
    } catch { /* Metadata outages should not interrupt audio. */ }
    if (!signal.aborted) this.metadataTimer = setTimeout(() => this.refreshMetadata(), 15000);
  }
}

customElements.define('datafruits-player', DatafruitsPlayer);
