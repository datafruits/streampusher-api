import { Controller } from "@hotwired/stimulus"

// Handles the main home page interactions:
// - Mobile/desktop navigation menu toggles
// - User menu dropdown
// - Login modal
// - Donate modal
export default class extends Controller {
  static targets = ["mobileMenu", "submenu", "userMenu", "loginModal", "donateModal"]
  static values = {
    menuOpen: { type: Boolean, default: false },
    submenuOpen: { type: Boolean, default: false },
    userMenuOpen: { type: Boolean, default: false },
    loginModalOpen: { type: Boolean, default: false },
    donateModalOpen: { type: Boolean, default: false }
  }

  connect() {
    this.debounceTimer = null
  }

  disconnect() {
    if (this.debounceTimer) {
      clearTimeout(this.debounceTimer)
    }
  }

  toggleMenu() {
    this.menuOpenValue = !this.menuOpenValue
    if (this.hasMobileMenuTarget) {
      this.mobileMenuTarget.classList.toggle("hidden", !this.menuOpenValue)
    }
  }

  toggleSubMenu() {
    if (this.debounceTimer) {
      clearTimeout(this.debounceTimer)
    }
    this.debounceTimer = setTimeout(() => {
      this.submenuOpenValue = !this.submenuOpenValue
      if (this.hasSubmenuTarget) {
        this.submenuTarget.classList.toggle("hidden", !this.submenuOpenValue)
      }
    }, 500)
  }

  toggleUserMenu() {
    this.userMenuOpenValue = !this.userMenuOpenValue
    if (this.hasUserMenuTarget) {
      this.userMenuTarget.classList.toggle("hidden", !this.userMenuOpenValue)
    }
  }

  toggleLoginModal() {
    this.loginModalOpenValue = !this.loginModalOpenValue
    if (this.hasLoginModalTarget) {
      this.loginModalTarget.classList.toggle("hidden", !this.loginModalOpenValue)
    }
  }

  toggleDonateModal() {
    this.donateModalOpenValue = !this.donateModalOpenValue
    if (this.hasDonateModalTarget) {
      this.donateModalTarget.classList.toggle("hidden", !this.donateModalOpenValue)
    }
  }

  // Close all open menus and modals when Escape key is pressed
  closeAll() {
    if (this.menuOpenValue) {
      this.menuOpenValue = false
      if (this.hasMobileMenuTarget) {
        this.mobileMenuTarget.classList.add("hidden")
      }
    }
    if (this.submenuOpenValue) {
      this.submenuOpenValue = false
      if (this.hasSubmenuTarget) {
        this.submenuTarget.classList.add("hidden")
      }
    }
    if (this.userMenuOpenValue) {
      this.userMenuOpenValue = false
      if (this.hasUserMenuTarget) {
        this.userMenuTarget.classList.add("hidden")
      }
    }
    if (this.loginModalOpenValue) {
      this.loginModalOpenValue = false
      if (this.hasLoginModalTarget) {
        this.loginModalTarget.classList.add("hidden")
      }
    }
    if (this.donateModalOpenValue) {
      this.donateModalOpenValue = false
      if (this.hasDonateModalTarget) {
        this.donateModalTarget.classList.add("hidden")
      }
    }
  }
}
