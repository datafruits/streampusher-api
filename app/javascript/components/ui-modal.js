class UiModal extends HTMLElement {
  #dragging = false;
  #clickedOffsetX = 0;
  #clickedOffsetY = 0;
  #modal = null;

  connectedCallback() {
    // Teleport to #modals-container (portal behaviour)
    const container = document.getElementById('modals-container');
    if (container && this.parentElement !== container) {
      container.appendChild(this);
      return; // connectedCallback fires again after the move
    }

    this.#build();
    this.addEventListener('mousedown', this.#onMousedown);
    document.addEventListener('mousemove', this.#onMousemove);
    document.addEventListener('mouseup', this.#onMouseup);
  }

  disconnectedCallback() {
    document.removeEventListener('mousemove', this.#onMousemove);
    document.removeEventListener('mouseup', this.#onMouseup);
  }

  close() {
    this.dispatchEvent(new CustomEvent('ui-modal:close', { bubbles: true }));
    //this.remove();
  }

  #build() {
    // Capture any content placed inside the element before building
    const existingContent = Array.from(this.childNodes);

    const modal = document.createElement('div');
    modal.className = 'modal';

    const modalTop = document.createElement('div');
    modalTop.className = 'modal-top';

    const closeBtn = document.createElement('button');
    closeBtn.type = 'button';
    closeBtn.className = 'cool-button';
    closeBtn.textContent = 'X';
    closeBtn.addEventListener('click', () => this.close());
    modalTop.appendChild(closeBtn);

    const modalBody = document.createElement('div');
    modalBody.className = 'modal-body';
    existingContent.forEach(node => modalBody.appendChild(node));

    modal.appendChild(modalTop);
    modal.appendChild(modalBody);
    this.appendChild(modal);
    this.#modal = modal;
  }

  #onMousedown = (event) => {
    const modalTop = this.#modal?.querySelector('.modal-top');
    if (!modalTop) return;
    // Only drag when clicking directly on the modal-top bar (not its children)
    if (event.target === modalTop || modalTop.contains(event.target)) {
      this.#clickedOffsetX = event.offsetX;
      this.#clickedOffsetY = event.offsetY;
      this.#dragging = true;
      this.#modal.classList.add('dragging');
    }
  };

  #onMousemove = (event) => {
    if (!this.#dragging || !this.#modal) return;
    this.#modal.style.top = `${event.clientY - this.#clickedOffsetY}px`;
    this.#modal.style.left = `${event.clientX - this.#clickedOffsetX}px`;
    this.#modal.style.transform = 'none';
  };

  #onMouseup = () => {
    if (!this.#dragging) return;
    this.#dragging = false;
    this.#modal?.classList.remove('dragging');
  };
}

customElements.define('ui-modal', UiModal);
