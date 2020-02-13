import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ 'tasks', 'calendar', 'tasksNav', 'calendarNav' ]

  connect() {
    console.log('workspace controller')
  }

  tasksSelected(event) {
    console.log(event.currentTarget)
    event.preventDefault()
    this.tasksTarget.classList.remove('d-none')
    this.calendarTarget.classList.add('d-none')

    this.calendarNavTarget.classList.remove('active')
    this.tasksNavTarget.classList.add('active')
    event.currentTarget.blur()
  }

  calendarSelected(event) {
    event.preventDefault()
    console.log(event.currentTarget)
    this.tasksTarget.classList.add('d-none')
    this.calendarTarget.classList.remove('d-none')

    this.tasksNavTarget.classList.remove('active')
    this.calendarNavTarget.classList.add('active')
    event.currentTarget.blur()
  }
}
