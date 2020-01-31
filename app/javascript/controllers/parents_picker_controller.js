import Autocomplete from './autocomplete.js'

export default class extends Autocomplete {
  static targets = [ 'input', 'hidden', 'results', 'parentGroup', 'hint' ]

  initialize() {
//    console.log('parents-picker initialized')
  }

  focus(event) {
    // Display optiosn only if there is no input
    const query = this.inputTarget.value.trim()
    if (!query || query.length < this.minLength) {
      this.fetchResults()
    }
  }

  blur(event) {
    this.hintError(event)
  }

  remove(event) {
    event.preventDefault()
    this.inputTarget.value = ""
    this.hiddenTarget.value = ""
    this.hintError(event)
  }

  loadstart(event) {
    // Clear hidden value to avoid invalid parent
    this.hiddenTarget.value = ""
  }

  hintError(event) {
    console.log(event)
    if (this.inputTarget.value.trim()) {
      if (this.hiddenTarget.value.trim()) {
        this.parentGroupTarget.classList.remove("has-error")
        this.hintTarget.classList.add("d-hide")
      } else {
        this.parentGroupTarget.classList.add("has-error")
        this.hintTarget.classList.remove("d-hide")
      }
    } else {
      this.parentGroupTarget.classList.remove("has-error")
      this.hintTarget.classList.add("d-hide")
    }
  }
}
