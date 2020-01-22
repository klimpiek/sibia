import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "output" ]

  connect() {
//    this.outputTarget.textContent = 'Hello, Klimmer!'

    console.log("Hello, Stimulus! from console", this.element)
  }
}
