// Load all the controllers within this directory and all subdirectories. 
// Controller files must be named *_controller.js.

import { Application } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"

const application = Application.start()
const context = require.context("controllers", true, /_controller\.js$/)
application.load(definitionsFromContext(context))

// Autocomplete
import Autocomplete from './autocomplete.js'
application.register('autocomplete', Autocomplete)

// flatpickr date & time picker
import Flatpickr from 'stimulus-flatpickr'
application.register('flatpickr', Flatpickr)
