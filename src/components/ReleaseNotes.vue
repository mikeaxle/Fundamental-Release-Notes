<template>
  <div class="page-wrapper">
    <!-- header -->
    <header class="header">
      <div class="container">
        <a href="#" class="header__logo">
          <img src="../assets/images/fundamental-icon.svg" alt=""/>
          <h3>Release Notes</h3>
        </a>
        <a href="#" class="btn btn--contact">Contact us</a>
      </div>
    </header>

    <!-- version selector -->
    <section class="versions">
      <div class="container">

        <div class="versions__row">
          <div class="versions__toggle">
            <label class="radio">
              <input type="radio" checked value="1" name="toggle-version" id="toggle-changes"/>
              <span class="radio__indi"></span>
              <span class="radio__label">Changes and issues version</span>
            </label>
          </div>
          <!-- version drop down -->
          <div class="versions__select">
            <div class="custom-select" data-widget="CustomSelect">
            <select name="filter-version" id="filter-version" v-model="currentRelease">
              <option v-for="r in json.releases" v-bind:value="r">{{ r.name }}</option>
            </select>
            </div>
          </div>
        </div>

        <div class="versions__row">
          <div class="versions__toggle">
            <label class="radio">
              <input type="radio" value="2" name="toggle-version" id="toggle-updates"/>
              <span class="radio__indi"></span>
              <span class="radio__label">Updating from version</span>
            </label>
          </div>
          <div class="versions__select versions__select--combo">
            <div class="custom-select custom-select--disabled" data-widget="CustomSelect">
              <select name="filter-version-from" id="filter-version-from" disabled>
                <option v-for="r in json.releases">{{ r.name }}</option>
              </select>
            </div>

            <p class="versions__to">to</p>
            <div class="custom-select custom-select--disabled" data-widget="CustomSelect">
              <select name="filter-version-to" id="filter-version-to" disabled>
                <option v-for="r in json.releases">{{ r.name }}</option>
              </select>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- main page content -->
    <div class="page-content">
      <div class="container">

        <div class="grid grid--sidebar">
          <div class="grid__col-1">

            <!-- type filters -->
            <div class="filter">
              <h5>Filter by type</h5>
              <div v-for="t in json.types">
                <label class="checkbox checkbox--right">
                  <input type="checkbox" v-bind:value="t" v-model="checkedFiltersTypes"/>
                  <span class="checkbox__indi"></span>
                  <span class="checkbox__label">{{ t.type }}</span>
                </label>
              </div>
            </div>

            <!-- category filters -->
            <div class="filter">
              <h5>Filter by category</h5>
              <div v-for="c in json.categories">
                <label class="checkbox checkbox--right">
                  <input type="checkbox" v-bind:value="c" v-model="checkedFiltersCategories"/>
                  <span class="checkbox__indi"></span>
                  <span class="checkbox__label">{{ c.type }}</span>
                </label>
              </div>
            </div>


          </div>

          <!-- release notes -->
          <div class="grid__col-2">

            <div class="notes" v-if="currentRelease !== null">
              <h2>{{ currentRelease.name }}</h2>
              <!-- types -->
              <div class="notes__section" v-for="t in json.types">

                <div v-if="getTypes(t)">
                  <h3>{{ t.type }}</h3>

                  <!-- category -->
                  <div class="notes__item" v-for="c in json.categories">
                    <div v-if="getCategories(c)">
                      <h4>{{ c.type }}</h4>
                        <!-- logs -->
                        <log :logs="filteredLogs" :category="c" :type="t"></log>
                    </div>
                  </div>
                </div>
              </div>

            </div>
          </div>

        </div>
      </div>
    </div>
  </div>

</template>

<script>
  import json from '../assets/demo.json'

  export default {
    name: 'ReleaseNotes',
    data () {
      return {
        json: json,
        currentRelease: null,
        checkedFiltersTypes: [],
        checkedFiltersCategories: []
      }
    },
    components: {
    },
    methods: {
      // function to check the types present in the current release logs
      getTypes: function (type) {
        let logs = this.filteredLogs
        let flag = false
        if (this.currentRelease !== null) {
          logs.forEach((l) => {
            if (l.type === type.id) {
              flag = true
            }
          })
        }
        return flag
      },

      // function to check the categories present in the current release logs
      getCategories: function (category) {
        let logs = this.filteredLogs
        let flag = false
        if (this.currentRelease !== null) {
          logs.forEach((l) => {
            if (l.category === category.id) {
              flag = true
            }
          })
        }
        return flag
      },
      // function to get the logs of the selected release
      getLogs: function () {
        let logs = []

        if (this.currentRelease !== null) {
          json.logs.forEach((l) => {
            if (l.release === this.currentRelease.id) {
              logs.push(l)
            }
          })
        }
        return logs
      }
    },
    // function to filters logs
    computed: {
      filteredLogs: function () {
        // get all logs under release
        let result = this.getLogs()
        // filter by type
        if (this.checkedFiltersTypes.length > 0) {
          result = result.filter((l) => {
            let tmp
            this.checkedFiltersTypes.forEach((t) => {
              if (l.type === t.id) {
                tmp = l
              }
            })
            return tmp
          })
        }
        // filter by category
        if (this.checkedFiltersCategories.length > 0) {
          result = result.filter((l) => {
            let tmp
            this.checkedFiltersCategories.forEach((c) => {
              if (l.category === c.id) {
                tmp = l
              }
            })
            return tmp
          })
        }
        // return result
        console.log(result)
        return result
      }
    }
  }
</script>

<style>
  @import '../assets/styles/main.css';
</style>
