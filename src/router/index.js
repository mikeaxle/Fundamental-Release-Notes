import Vue from 'vue'
import Router from 'vue-router'
import ReleaseNotes from '@/components/ReleaseNotes'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'ReleaseNotes',
      component: ReleaseNotes
    }
  ]
})
