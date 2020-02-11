// Visit The Stimulus Handbook for more details 
// https://stimulusjs.org/handbook/introduction

import { Controller } from "stimulus"
import {DataTable} from 'simple-datatables'
import 'simple-datatables/src/style.css'

export default class extends Controller {
  static targets = [ "data" ]

  connect() {
    console.log('data table')
    // Array, callback, or promise
/*
    const path = 'table/data'
    var headers = {
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content'),
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-Requested-With': 'XMLHttpRequest'
      }
*/

    /* Convert all due_at to fromNow */
/*
    document.querySelectorAll('.time_ago').forEach(function(item) {
      if (item.dataset.dueAt) {
        item.innerHTML = moment(item.dataset.dueAt).fromNow()
      }
    })
*/

    var table = this.dataTarget
    var dataTable = new DataTable(table, {
      perPage: 10,
      layout: {
        top: "{search}{pager}",
        bottom: "{select}"
      },
      columns: [
        {select: 1, sortable: false},
        {select: 2, sortable: false}
      ]
    });
/*
    fetch(path, { method: 'GET', headers: headers, credentials: 'same-origin' })
        .then(response => response.json()) 
        .then(response => {
          return response
        })
        .catch(error => console.error('Error:', error))
*/
  }

}
