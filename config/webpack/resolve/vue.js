// https://medium.com/@acesubido/solving-csp-problems-on-vue-2-0-and-rails-webpacker-3-5-7f2faf086aff

const DEBUG = process.env.NODE_ENV === "development"

const buildPath = DEBUG ? "vue/dist/vue.esm.js" : "vue/dist/vue.runtime.esm.js"

module.exports = {
  resolve: {
    alias: { "@vue": buildPath }
  }
}
