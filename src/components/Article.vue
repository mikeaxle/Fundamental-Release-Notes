<template>
  <div class="page-wrapper">

    <header class="header">
      <div class="container">
        <router-link class="header__logo" to="/">
          <img src="../assets/images/fundamental-icon.svg" alt="" />
          <h3>Release Notes</h3>
        </router-link>
        <a href="http://www.fundamental.net/contact" target="_blank" class="btn btn--contact">Contact us</a>
      </div>
    </header>
    <section class="subheader">
      <div class="container">

        <ul class="breadcrumbs">
          <li><router-link to="/">Fundamental Release Notes</router-link></li>
          <li style="color: #4a4c54 !important;">{{ getType('name') }} &nbsp; : &nbsp; {{ getCategory('name') }}</li>
          <!--<li><router-link :to="{ name: 'category', params: { category: getCategory('id'), type: getType('id'), release: getRelease('id')  }}">{{ getType('name') }}</router-link></li>-->
          <!--<li>{{ getCategory('name')  }}</li>-->
        </ul>


      </div>
    </section>
    <div class="page-content">
      <div class="container">

        <div class="grid grid--sidebar">
          <div class="grid__col-1">

            <!-- log details-->
            <div class="article__meta">
              <h4>{{ getRelease('name') }}</h4>

              <dl class="article__meta-details">
                <dt>Module</dt>
                <dd>{{ getCategory('name') }}</dd>

                <dt>Ticket</dt>
                <dd>{{ article.title }}</dd>

                <dt>Date</dt>
                <dd><time datetime="2017-09-19">19 September 2017</time></dd>
              </dl>

              <!-- share via email-->
              <social-sharing
                :url="$route.fullPath"
                :title="article.desc"
                inline-template>
                <network network="email" class="article__meta-email" style="cursor: pointer !important;">
                  <span class="svg svg-footer-mail-us svg-footer-mail-us-dims" ></span>Share via email
                </network>
              </social-sharing>

            </div>
          </div>
          <div class="grid__col-2">

            <!-- log content-->
            <article class="article__content">
              <h1>{{ getCategory('name') }}: {{ article.desc }}</h1>
              <div class="rte">
                <p v-html="article.solution"></p>
              </div>

            </article>

          </div>
        </div>


      </div>
    </div>

  </div>
</template>

<script>
  // import axios from 'axios'
  import json from '../assets/demo.json'
  export default {
    name: 'Article',
    data () {
      return {
        article: {}
      }
    },
    created () {
      this.fetchData()
    },
    watch: {
      '$route': 'fetchData'
    },
    methods: {
      // function to load log data
      fetchData () {
        json.logs.forEach((l) => {
          if (l.id === Number(this.$route.params.id)) {
            this.article = l
          }
        })
      },
      // function to get category
      getCategory (field) {
        let category
        json.categories.forEach((c) => {
          if (c.id === this.article.category) {
            if (field === 'id') {
              category = c.id
            } else if (field === 'name') {
              category = c.type
            }
          }
        })
        return category
      },
      // function to get type
      getType (field) {
        let type
        json.types.forEach((t) => {
          if (t.id === this.article.type) {
            if (field === 'id') {
              type = t.id
            } else if (field === 'name') {
              type = t.type
            }
          }
        })
        return type
      },
      // function to get release
      getRelease (field) {
        let release = ''
        json.releases.forEach((r) => {
          if (r.id === this.article.release) {
            if (field === 'id') {
              release = r.id
            } else if (field === 'name') {
              release = r.name
            }
          }
        })
        return release
      }
    }
  }
</script>

<style>
  @import '../assets/styles/main.css';
</style>
