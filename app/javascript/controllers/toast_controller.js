import { Controller } from "stimulus"

export default class extends Controller {
  static targets = []

  connect() {
  }

  hide(event) {
    event.preventDefault()
    this.element.remove()
    console.log("toast removed")
  }
}
