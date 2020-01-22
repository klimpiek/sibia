import Flatpickr from 'stimulus-flatpickr'
import 'flatpickr/dist/themes/dark.css'

export default class extends Flatpickr {
  initialize() {
    this.config = {
      enableTime: true,
      time_24hr: true,
      altInput: true,
      altFormat: "Y-m-d H:i"
    }
    console.log('datetime-pickr initialized')
  }
}
