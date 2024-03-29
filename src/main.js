// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import App from './App'
import router from './router'
import Log from '@/components/Log.vue'
import Vue2Filters from 'vue2-filters'
import JsonExcel from 'vue-json-excel'
import Spinner from 'vue-simple-spinner'

const SocialSharing = require('vue-social-sharing')

Vue.component('log', Log)
Vue.component('downloadExcel', JsonExcel)
Vue.component('vue-simple-spinner', Spinner)
Vue.use(Vue2Filters)
Vue.use(SocialSharing)
Vue.config.productionTip = false

/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  template: '<App/>',
  components: { App }
})
