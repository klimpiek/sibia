import Autocomplete from './autocomplete.js'

export default class extends Autocomplete {
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

  loadstart(event) {
//    console.log(event)
  }

  load(event) {
//    console.log(event)
  }
}
