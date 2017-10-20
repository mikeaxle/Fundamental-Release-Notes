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

   <!-- radio buttons -->
    <section class="versions">
      <div class="container">
        <!-- version selector -->
        <div class="versions__row">
          <div class="versions__toggle">
            <label class="radio">
              <input type="radio" checked value="1" id="toggle-changes" v-model="versionMode"/>
              <span class="radio__indi"></span>
              <span class="radio__label">Changes and issues version</span>
            </label>
          </div>
          <!-- version drop down -->
          <div class="versions__select">
            <div class="custom-select" data-widget="CustomSelect">
            <select name="filter-version" id="filter-version" v-model="currentRelease" :disabled="versionMode == 2 ? true : false">
              <option v-for="r in json.releases" v-bind:value="r">{{ r.name }}</option>
            </select>
            </div>
          </div>
        </div>
        <div class="versions__row">
          <div class="versions__toggle">
            <label class="radio">
              <input type="radio" value="2" v-model="versionMode" id="toggle-changes"/>
              <span class="radio__indi"></span>
              <span class="radio__label">Updating from version</span>
            </label>
          </div>
          <div class="versions__select versions__select--combo">
            <div class="custom-select custom-select--disabled" data-widget="CustomSelect">
              <select name="filter-version-from" id="filter-version-from" v-model="fromRelease" :disabled="versionMode == 1 ? true : false">
                <option v-for="r in filteredFromReleases" v-bind:value="r">{{ r.name }}</option>
              </select>
            </div>

            <p class="versions__to">to</p>
            <div class="custom-select custom-select--disabled" data-widget="CustomSelect">
              <select name="filter-version-to" id="filter-version-to" v-model="toRelease" :disabled="versionMode == 1 ? true : false">
                <option v-for="r in filteredToReleases" v-bind:value="r">{{ r.name }}</option>
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
            <!-- notes from version selector -->
            <div class="notes" v-if="currentRelease !== null">
              <h2>{{ currentRelease.name }}</h2>
              <!-- types -->
              <div class="notes__section" v-for="t in json.types">
                <div v-if="getTypes(t, 'single')">
                  <h3>{{ t.type }}</h3>
                  <!-- category -->
                  <div class="notes__item" v-for="c in json.categories">
                    <div v-if="getCategories(c, 'single')">
                      <h4>{{ c.type }}</h4>
                        <!-- logs -->
                        <log :logs="filteredLogs('single')" :category="c" :type="t"></log>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- notes from version camparison -->
            <div class="notes" v-if="fromRelease !== null && toRelease !== null">
              <h2>Updating from {{ fromRelease.name }} to {{ toRelease.name }}</h2>
              <!-- types -->
              <div class="notes__section" v-for="t in json.types">
                <div v-if="getTypes(t, 'multiple')">
                  <h3>{{ t.type }}</h3>
                  <!-- category -->
                  <div class="notes__item" v-for="c in json.categories">
                    <div v-if="getCategories(c, 'multiple')">
                      <h4>{{ c.type }}</h4>
                      <!-- logs -->
                      <log :logs="filteredLogs('multiple')" :category="c" :type="t"></log>
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
        json: json,                     // variable to store json object parsed from MYSQL
        currentRelease: null,           // variable to store currently selected release
        fromRelease: null,              // variable to store from release
        toRelease: null,                // variable to store to release
        checkedFiltersTypes: [],        // array to store type filters
        checkedFiltersCategories: [],   // array to store category filters
        versionMode: '1'
      }
    },
    components: {
    },
    methods: {
      // function to check the types present in the current release logs
      getTypes: function (releaseType, type) {
        // get logs
        let logs = this.filteredLogs(type)
        // set flag to false
        let flag = false
        // if current release is selected
        if (this.currentRelease !== null) {
          logs.forEach((l) => {
            if (l.type === releaseType.id) {
              flag = true
            }
          })
        }
        // return flag
        return flag
      },
      // function to check the types present in the current release logs
      getTypesComparison: function () {
      },
      // function to check the categories present in the current release logs
      getCategories: function (category, type) {
        // get logs
        let logs = this.filteredLogs(type)
        // set flag to false
        let flag = false
        // if current release is selected
        if (this.currentRelease !== null) {
          logs.forEach((l) => {
            if (l.category === category.id) {
              flag = true
            }
          })
        }
        // return flag
        return flag
      },
      // function to get the logs of the selected release
      getLogs: function (type) {
        // array to store logs
        let logs = []
        // if type is single
        if (type === 'single') {
          // if current release is selected
          if (this.currentRelease !== null) {
            json.logs.forEach((l) => {
              // get all logs where release id ===  current selected release id
              if (l.release === this.currentRelease.id) {
                // push to array
                logs.push(l)
              }
            })
          }
        }
        // if type is multiple
        if (type === 'multiple') {
          if (this.fromRelease !== null && this.toRelease !== null) {
            // get all releases between from and to and store in array
            let releases = []
            releases = this.json.releases.filter((r) => {
              let tmp
              // check if current releases is >= from release and <= toRelease
              if (r.id >= this.fromRelease && r.id <= this.toRelease) {
                tmp = r
              }
              return tmp
            })
            // iterate logs array
            json.logs.forEach((l) => {
              // iterate releases array
              // get all logs where release id === the ids of the items in releases array
              releases.forEach((r) => {
                if (l.release === r.id) {
                  // push to array
                  logs.push(l)
                }
              })
            })
          }
        }

        // return logs array
        return logs
      }
    },
    computed: {
      // function to filters logs
      filteredLogs: function (type) {
        // get all logs under release
        let result = this.getLogs(type)
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
        return result
      },
      filteredFromReleases: function () {
        let result = []
        // filter out last result
        result = this.json.releases.filter((r, i) => {
          let tmp
          if (i < this.json.releases.length - 1) {
            tmp = r
          }
          return tmp
        })
        return result
      },
      filteredToReleases: function () {
        let result = []
        // filter by release id
        if (this.fromRelease !== null) {
          result = this.json.releases.filter((r) => {
            let tmp
            if (this.fromRelease.id < r.id) {
              tmp = r
            }
            return tmp
          })
        }
        return result
      }
    }
  }
</script>

<style>
  @import '../assets/styles/main.css';
</style>
