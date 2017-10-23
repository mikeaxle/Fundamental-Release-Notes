import Vue from 'vue'
import Router from 'vue-router'
import ReleaseNotes from '@/components/ReleaseNotes'
import Contact from '@/components/Contact'
import Article from '@/components/Article'
// import Category from '@/components/Category'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'ReleaseNotes',
      component: ReleaseNotes
    },
    {
      path: '/contact',
      name: 'Contact',
      component: Contact
    },
    // {
    //   path: '/category',
    //   name: 'category',
    //   component: Category
    // },
    {
      path: '/article/:id',
      name: 'article',
      component: Article
    }
  ]
})
