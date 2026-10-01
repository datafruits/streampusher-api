class ChatMessageList extends HTMLElement {
  connectedCallback() {
    this.messages = this.querySelector("#messages")
    this.newMessagesNotice = this.querySelector(".chat-new-messages")

    if (!this.messages) return

    this.isPinnedToBottom = true
    this.onScroll = () => {
      this.isPinnedToBottom = this.distanceFromBottom() < 48
      if (this.isPinnedToBottom) this.hideNewMessagesNotice()
    }

    this.messages.addEventListener("scroll", this.onScroll, { passive: true })
    this.observer = new MutationObserver(() => this.messagesChanged())
    this.observer.observe(this.messages, { childList: true })
    this.scrollToBottom()
  }

  disconnectedCallback() {
    this.observer?.disconnect()
    this.messages?.removeEventListener("scroll", this.onScroll)
  }

  distanceFromBottom() {
    return this.messages.scrollHeight - this.messages.scrollTop - this.messages.clientHeight
  }

  messagesChanged() {
    if (this.isPinnedToBottom) {
      this.scrollToBottom()
    } else {
      this.newMessagesNotice?.removeAttribute("hidden")
    }
  }

  scrollToBottom() {
    requestAnimationFrame(() => {
      this.messages.scrollTop = this.messages.scrollHeight
      this.hideNewMessagesNotice()
    })
  }

  hideNewMessagesNotice() {
    this.newMessagesNotice?.setAttribute("hidden", "")
  }
}

customElements.define("chat-message-list", ChatMessageList)
