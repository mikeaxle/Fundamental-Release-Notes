<template>
  <div class="page-wrapper">

    <header class="header">
      <div class="container">
        <router-link class="header__logo" to="/">
          <img src="../assets/images/fundamental-icon.svg" alt="" />
          <h3>Release Notes</h3>
        </router-link>
        <a href="#" class="btn btn--contact">Contact us</a>
      </div>
    </header>
    <section class="subheader">
      <div class="container">

        <ul class="breadcrumbs">
          <li><router-link to="/">Fundamental Release Notes</router-link></li>
          <li><router-link to="#">{{ getType() }}</router-link></li>
          <!--<li>{{ getCategory()  }}</li>-->
        </ul>


      </div>
    </section>
    <div class="page-content">
      <div class="container">

        <div class="grid grid--sidebar">
          <div class="grid__col-1">

            <!-- log details-->
            <div class="article__meta">
              <h4>{{ getRelease() }}</h4>

              <dl class="article__meta-details">
                <dt>Module</dt>
                <!--<dd>{{ getCategory() }}</dd>-->

                <dt>Ticket</dt>
                <!--<dd>{{ article.title }}</dd>-->

                <dt>Date</dt>
                <dd><time datetime="2017-09-19">19 September 2017</time></dd>
              </dl>

              <!-- share via email-->
              <!--<social-sharing-->
                <!--:url="$route.fullPath"-->
                <!--:title="article.desc"-->
                <!--inline-template>-->
                <!--<network network="email" class="article__meta-email">-->
                  <!--<span class="svg svg-footer-mail-us svg-footer-mail-us-dims"></span>Share via email-->
                <!--</network>-->
              <!--</social-sharing>-->

            </div>
          </div>
          <div class="grid__col-2">

            <!-- log content-->
            <article class="article__content">
              <!--<h1>{{ getCategory() }}: {{ article.desc }}</h1>-->
              <!--<div class="rte">-->
                <!--<p v-html="article.solution"></p>-->
              <!--</div>-->

            </article>

          </div>
        </div>


      </div>
    </div>

  </div>
</template>

<script>
  // import axios from 'axios'
  import { HTTP } from '../http-common'
  export default {
    name: 'Category',
    data () {
      return {
        categories: [],
        types: [],
        releases: [],
        logs: [],
        logBinaries: []
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
        // http calls
        // get categories
        HTTP.get('categories?transform=1')
          .then((res) => {
            this.categories = res.data.categories
          })
          .catch((err) => {
            alert(err)
          })
        // get types
        HTTP.get('types?transform=1')
          .then((res) => {
            this.types = res.data.types
          })
          .catch((err) => {
            alert(err)
          })
        // get releases
        HTTP.get('releases?transform=1')
          .then((res) => {
            this.releases = res.data.releases
          })
          .catch((err) => {
            alert(err)
          })
        // get logBinaries
        HTTP.get('logBinaries?transform=1')
          .then((res) => {
            this.logBinaries = res.data.logBinaries
          })
          .catch((err) => {
            alert(err)
          })
        this.logs.forEach((l) => {
          if (l.category === this.$route.params.category && l.type === this.$route.params.type && l.release === this.$route.params.release) {
            console.log(l)
            this.category.push(l)
          }
        })
      },
      // function to get type
      getType () {
        let type = ''
        this.types.forEach((t) => {
          if (t.id === this.$route.params.type) {
            type = t.type
          }
        })
        return type
      },
      // function to get release
      getRelease () {
        let release = ''
        this.releases.forEach((r) => {
          if (r.id === this.$route.params.release) {
            release = r.name
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
