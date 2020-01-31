import Autocomplete from './autocomplete.js'

export default class extends Autocomplete {
  initialize() {
    console.log('tags-picker initialized')
    this.set_hidden()
  }

  focus(event) {
    // Display optiosn only if there is no input
    const query = this.inputTarget.value.trim()
    if (!query || query.length < this.minLength) {
      this.fetchResults()
    }
  }

  // Remove tag chip
  remove(event) {
    event.preventDefault()
    let tag = event.target.dataset.value
    let element = this.element.querySelector("#"+tag)
    element.remove()
    this.set_hidden()
  }
  
  add(event) {
    event.preventDefault()
    let tags = this.tags()
    let chips = this.element.querySelector("#chips")
    let new_tags = []
    let new_tag = this.inputTarget.value.trim()
    if (new_tag) {
      if (tags.includes(new_tag)) {
        // Do not add existing tag
      } else {
        new_tags.push(this.inputTarget.value)
      }
    }
    console.log(new_tags)
    new_tags.forEach(function(tag) {
      let span = document.createElement('span')
      let link = document.createElement('a')

      link.setAttribute("href", "#")
      link.setAttribute("class", "btn btn-clear")
      link.setAttribute("aria-label", "Close")
      link.setAttribute("role", "button")
      link.setAttribute("data-action", "click->tags-picker#remove")
      link.setAttribute("data-value", tag)

      span.setAttribute("id", tag)
      span.setAttribute("class", "chip tag")
      span.innerHTML = tag
      span.appendChild(link)

      chips.appendChild(span)
    })
    this.set_hidden()
    this.inputTarget.value = ""
  }

  // clear tag in text field

  clear(event) {
    event.preventDefault()
    this.inputTarget.value = ""
  }

  tags() {
    let tags_list = this.element.querySelectorAll(".tag")
    let tags = Array.from(tags_list).map(function(v, i) {
      return v.id
    })
    console.log(tags)
    return tags
  }

  set_hidden() {
    let tags = this.tags()
    let s = tags.join(', ')
    console.log(s)
    this.hiddenTarget.value = s
  }
}
