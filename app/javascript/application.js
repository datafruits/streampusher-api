import "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"

// Import web components
import "components/datafruits-player"
import "components/audio-visualizer"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus = application

eagerLoadControllersFrom("controllers", application)
