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
          <li style="color: #4a4c54 !important;">{{ type.type }} &nbsp; : &nbsp; {{ category.type }}</li>
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
              <h4>{{ release.name }}</h4>

              <dl class="article__meta-details">
                <dt>Module</dt>
                <dd>{{ category.type }}</dd>

                <dt>Ticket</dt>
                <dd>{{ article.title }}</dd>

                <dt>Date</dt>
                <!-- todo: add date here from database -->
                <dd><time datetime="2017-09-19"> --- </time></dd>
              </dl>

              <!-- share via email-->
              <social-sharing
                :url="email_body"
                :title="category.type + ': ' + article.desc"
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
              <h1>{{ category.type }}: {{ article.desc }}</h1>
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
  import { HTTP } from '../http-common'
  export default {
    name: 'Article',
    data () {
      return {
        article: {},
        category: {},
        type: {},
        release: {},
        email_body: 'Hello, \n \n Please refer below to the latest Fundamental Release Notes.\n \n' + window.location.href
      }
    },
    created () {
      this.fetchData()
    },
    watch: {
      '$route': 'fetchData'
    },
    methods: {
      getEmailBody () {
        return `
            <article class="article__content">
              <h1>{{ category.type }}: {{ article.desc }}</h1>
              <div class="rte">
                <p v-html="this.article.solution"></p>
              </div>
            </article>
        `
      },
      // function to load log data
      fetchData () {
        HTTP.get(`logs/${this.$route.params.id}?transform=1`)
        .then((res) => {
          this.article = res.data
          return res.data
        })
        .then((article) => {
          this.getCategory(article)
          this.getType(article)
          this.getRelease(article)
        })
        .catch((err) => {
          alert(err)
        })
      },
      // function to get category
      getCategory (article) {
        HTTP.get(`categories/${article.category}?transform=1`)
        .then((res) => {
          this.category = res.data
        })
        .catch((err) => {
          alert(err)
        })
      },
      // function to get type
      getType (article) {
        HTTP.get(`types/${article.type}?transform=1`)
        .then((res) => {
          this.type = res.data
        })
        .catch((err) => {
          alert(err)
        })
      },
      // function to get release
      getRelease (article) {
        HTTP.get(`releases/${article.release}?transform=1`)
        .then((res) => {
          this.release = res.data
        })
        .catch((err) => {
          alert(err)
        })
      }
    }
  }
</script>

<style>
  @import '../assets/styles/main.css';
</style>
