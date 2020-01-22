import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ['favoriteCheckbox', 'allDayCheckbox']

  connect() {
//    console.log("favorite ", this.favoriteCheckboxTarget.checked)
//    console.log("all day ", this.allDayCheckboxTarget.checked)
  }

  // We need to manually do so because a hidden_field is inserted between form label and checkbox.
  // It make Spectre.css form-switch not working visually.
  favoriteToggle(event) {
    event.preventDefault()
    let checked = this.favoriteCheckboxTarget.checked
    this.favoriteCheckboxTarget.checked = (checked === false)
  }

  allDayToggle(event) {
    event.preventDefault()
    let checked = this.allDayCheckboxTarget.checked
    this.allDayCheckboxTarget.checked = (checked === false)
  }
}
