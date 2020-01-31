import Autocomplete from './autocomplete.js'

export default class extends Autocomplete {
  static targets = [ 'input', 'hidden', 'results', 'select' ]

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

  remove(event) {
    event.preventDefault()
    this.inputTarget.value = ""
    this.hiddenTarget.value = ""
    console.log(event)
  }

  loadstart(event) {
//    console.log(event)
  }

  load(event) {
//    console.log(event)
  }
}
