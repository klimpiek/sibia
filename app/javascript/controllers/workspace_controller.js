import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ 'tasks', 'events', 'tasksNav', 'eventsNav' ]

  connect() {
    console.log('workspace controller')
  }

  tasksSelected(event) {
    console.log(event.currentTarget)
    event.preventDefault()
    this.tasksTarget.classList.remove('d-none')
    this.eventsTarget.classList.add('d-none')

    this.eventsNavTarget.classList.remove('active')
    this.tasksNavTarget.classList.add('active')
    event.currentTarget.blur()
  }

  eventsSelected(event) {
    event.preventDefault()
    console.log(event.currentTarget)
    this.tasksTarget.classList.add('d-none')
    this.eventsTarget.classList.remove('d-none')

    this.tasksNavTarget.classList.remove('active')
    this.eventsNavTarget.classList.add('active')
    event.currentTarget.blur()
  }
}
