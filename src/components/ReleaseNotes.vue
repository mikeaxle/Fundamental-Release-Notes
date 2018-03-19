<template>
  <div class="page-wrapper">
    <!-- header -->
    <header class="header">
      <div class="container">
        <a href="#" class="header__logo">
          <img src="../assets/images/fundamental-icon.svg" alt=""/>
          <h3>Release Notes</h3>
        </a>
        <a href="http://www.fundamental.net/contact/" target="_blank" class="btn btn--contact">Contact us</a>
      </div>
    </header>

   <!-- radio buttons -->
    <section class="versions">
      <div class="container">
        <!-- version selector -->
        <div class="versions__row">
          <div class="versions__toggle">
            <label class="radio">
              <input type="radio" id="toggle-changes" checked :value=1  v-model="versionMode" @change="modeToggle()"/>
              <span class="radio__indi"></span>
              <span class="radio__label">Changes and issues in version</span>
            </label>
          </div>
          <!-- version drop down -->
          <div class="versions__select">
            <div class="custom-select" v-bind:class="{'custom-select--disabled': versionMode === 2 }">
              <div class="custom-select__arrow">
                <span class="svg svg-arrow-down"></span>
              </div>
              <div class="custom-select__value">{{ currentRelease !== null ? currentRelease.name : 'Select Version' }}</div>
            <select name="filter-version" id="filter-version" v-model="currentRelease" :disabled="versionMode == 2 ? true : false">
              <option v-for="r in releases" v-bind:value="r">{{ r.name }}</option>
            </select>
            </div>
          </div>
        </div>
        <div class="versions__row">
          <div class="versions__toggle">
            <label class="radio">
              <input type="radio" id="toggle-changes" :value=2 v-model="versionMode"  @change="modeToggle()"/>
              <span class="radio__indi"></span>
              <span class="radio__label">Updating from version</span>
            </label>
          </div>
          <div class="versions__select versions__select--combo">
            <div class="custom-select" v-bind:class="{'custom-select--disabled': versionMode === 1 }">
              <div class="custom-select__arrow">
                <span class="svg svg-arrow-down"></span>
              </div>
              <div class="custom-select__value">{{ fromRelease !== null ? fromRelease.name : 'Select Start Version' }}</div>
              <select name="filter-version-from" id="filter-version-from" v-model="fromRelease" :disabled="versionMode == 1 ? true : false">
                <option v-for="r in filteredFromReleases" v-bind:value="r">{{ r.name }}</option>
              </select>
            </div>

            <p class="versions__to">to</p>
            <div class="custom-select" v-bind:class="{'custom-select--disabled': versionMode === 1 }">
              <div class="custom-select__arrow">
                <span class="svg svg-arrow-down"></span>
              </div>
              <div class="custom-select__value">{{ toRelease !== null ? toRelease.name : 'Select End Version' }}</div>
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
              <div v-for="t in types">
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
              <div v-for="c in categories">
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

            <div v-if="currentRelease === null && fromRelease === null && toRelease === null">
              <h3>Please select a product version above.</h3>
            </div>

            <!-- notes from version selector -->
            <div class="notes" v-if="currentRelease !== null">
              <div style="display: flex; flex-direction: row;">
                <h2>Changes and issues in version {{ currentRelease.name }}</h2>
                <span @click="downloadPdf()">DOwnload PDF</span>
                <download-excel
                  class   = "btn btn-default"
                  :data   = "filteredLogs"
                  :fields = "json_fields"
                  name    = "filename.xls">

                  Download Excel

                </download-excel>
              </div>

              <!-- types -->
              <div class="notes__section" v-for="t in types">
                <div v-if="getTypes(t)">
                  <h3>{{ t.type }}</h3>
                  <!-- category -->
                  <div class="notes__item" v-for="c in categories" >
                    <div v-if="getCategories(c, t)">
                      <h4>{{ c.type }}</h4>
                      <!-- logs -->
                      <log :logs="filteredLogs" :category="c" :type="t"></log>
                    </div>
                  </div>

                </div>

                <!-- if there are no types in release and check box is selected, this will show -->
                <div v-if="getTypes(t) === false && checkIfTypeIsSelected(t.id) === true">
                  <h3>{{ t.type }}</h3>
                  There are no <b>{{ t.type }}</b> notes in version {{ currentRelease.name }}
                </div>
              </div>
            </div>

            <!-- notes from version camparison -->
            <div class="notes" v-if="fromRelease !== null && toRelease !== null">
              <div style="display: flex; flex-direction: row;">
                <h2>Updating from version {{ fromRelease.name }} to {{ toRelease.name }}</h2>
                <span @click="downloadPdf()">DOwnload PDF</span>
                <span>DOwnload CSV</span>
              </div>
              <!-- types -->
              <div class="notes__section" v-for="t in types">
                <div v-if="getTypes(t)">
                  <h3>{{ t.type }}</h3>
                  <!-- category -->
                  <div class="notes__item" v-for="c in categories" v-if="getCategories(c,t)">
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

</template>

<script>
  import { HTTP } from '../http-common'
  import { saveAs } from 'file-saver/FileSaver'
  export default {
    name: 'ReleaseNotes',
    data () {
      return {
        categories: [],
        types: [],
        releases: [],
        logs: [],
        logBinaries: [],
        currentRelease: null,           // variable to store currently selected release
        fromRelease: null,              // variable to store from release
        toRelease: null,                // variable to store to release
        checkedFiltersTypes: [],        // array to store type filters
        checkedFiltersCategories: [],   // array to store category filters
        versionMode: 1,
        html: '',
        json_fields: {
          'Release': 'release',
          'Category': 'category',
          'Type': 'type',
          'Title': 'title',
          'Description': 'desc',
          'Solution': 'solution'
        }
      }
    },
    created () {
      this.init()
    },
    components: {
    },
    methods: {
      getFieldName (id, field) {
        let name = ''
        if (field === 'types') {
          let tmp = this.types.find((type) => {
            return type.id === id
          })
          name = tmp.type
          console.log(name)
        }
        return name
      },
      createHtml () {
        this.html = `<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <link rel="stylesheet" type="text/css" href="assets/styles.css">
    <style>
      @import url('https://fonts.googleapis.com/css?family=Poppins:400,600');
      header {
    background-color: #4a4c54;
    padding: 13px 34px;
    color: #fff;
    font-size: 14px;
    font-weight: 600;
    font-family:Poppins;
}

header img {
    width: 160.6px;
    height: 24.5px;
    object-fit: contain;
}
    </style>

</head>

<body>
    <header id="pageHeader">
        <table width="100%">
            <tr>
                <td>
                    <img src="${window.location.origin}/pdf-assets/fundamental.png" align="left" srcset="${window.location.origin}/pdf-assets/fundamental@2x.png 2x,
                    ${window.location.origin}/pdf-assets/fundamental@3x.png 3x">
                </td>
                <td style="text-align:right; color: white !important">
                  <span>Release Notes</span>
                </td>
            </tr>
        </table>
    </header>
    <div class="content">
        <!-- heading -->
        ${this.getTitle()}
        <!-- each item is meant to be put through an array to generate release notes -->
        <!-- type -->
        ${this.getTypesHtml()}
    </div>
</body>

</html>`
      },
      getTitle () {
        if (this.fromRelease !== null && this.toRelease !== null) {
          return `<h1>Updating from version ${this.fromRelease.name} to ${this.toRelease.name}</h1>`
        } else if (this.currentRelease !== null) {
          return `<h1>Changes and issues in version ${this.currentRelease.name}</h1>`
        }
      },
      getTypesHtml () {
        let html = ''
        this.types.forEach((t) => {
          if (this.getTypes(t)) {
            html += `<div class="type"><h2> ${t.type} </h2>
            <!-- category -->`
            this.categories.forEach((c) => {
              if (this.getCategories(c, t)) {
                html += `<div class="category">
                <h3>${c.type}</h3>
                <div class="line"></div>
                <!-- log -->`
                this.filteredLogs.forEach((fl) => {
                  if (fl.category === c.id && fl.type === t.id) {
                    html += `
            <div class="log">
            <!--  log title & desc -->
            <p>
            <span>${fl.title}</span>${fl.desc}</p>

            <!-- solution -->
            ${fl.solution}
            </div>`
                  }
                })
              }
            })
            html += `<div class="line" style="margin-top: 40px !important;"></div>
          </div></div>`
          }
        })
        return html
      },
      downloadPdf () {
        // call function to create HTML
        this.createHtml()
        // console.log(this.html)
        // make call to API
        fetch('http://localhost:3000/print-pdf', {
          method: 'post',
          headers: {'Content-Type': 'application/json'},
          body: JSON.stringify({
            html: this.html
          })
        })
        .then((res) => {
          // convert response to array buffer
          return res.arrayBuffer()
        })
        .then((data) => {
          // create and download pdf file
          const file = new Blob([data], {type: 'application/pdf'})
          saveAs(file, `release notes - ${Date.now()} .pdf`)
        }, (err) => {
          console.log(err.message)
        })
      },
      init () {
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
      },
      // function to toggle display modes
      modeToggle () {
        // if version mode is 1 null fromRelease and toRelease
        if (this.versionMode === 1) {
          this.fromRelease = null
          this.toRelease = null
        }
        // if version mode is 2, null currentRelease
        if (this.versionMode === 2) {
          this.currentRelease = null
        }
      },
      // function to check the types present in the current release logs
      getTypes (releaseType) {
        // get logs
        let logs = this.filteredLogs
        // set flag to false
        let flag = false
        // check version mode is equal to single
        if (this.versionMode === 1) {
          // if current release is selected
          if (this.currentRelease !== null) {
            logs.forEach((l) => {
              if (l.type === releaseType.id) {
                flag = true
              }
            })
          }
        }
        // check version mode is equal to multiple
        if (this.versionMode === 2) {
          // check if from release and to release are null
          if (this.fromRelease !== null && this.toRelease !== null) {
            // iterate logs
            logs.forEach((l) => {
              if (l.type === releaseType.id) {
                flag = true
              }
            })
          }
        }
        // return flag
        return flag
      },
      // function to check the types present in the current release logs
      getTypesComparison: function () {
      },
      // function to check the categories present in the current release logs
      getCategories (category, type) {
        // get logs
        let logs = this.filteredLogs
        // set flag to false
        let flag = false
        if (this.versionMode === 1) {
          // if current release is selected
          if (this.currentRelease !== null) {
            logs.forEach((l) => {
              if (l.category === category.id && l.type === type.id) {
                flag = true
              }
            })
          }
        }
        // check version mode is equal to multiple
        if (this.versionMode === 2) {
          // check if from release and to release are null
          if (this.fromRelease !== null && this.toRelease !== null) {
            // iterate logs
            logs.forEach((l) => {
              if (l.category === category.id && l.type === type.id) {
                flag = true
              }
            })
          }
        }

        // return flag
        return flag
      },
      // function to get the logs of the selected release
      getLogs () {
        // get logs
        HTTP.get('logs?transform=1')
          .then((res) => {
            this.logs = res.data.logs
            // this.logs.forEach(l => {
            //   l.isopen = true
            // })
          })
          .catch((err) => {
            alert(err)
          })
        // array to store logs
        let logs = []
        // if type is single
        if (this.versionMode === 1) {
          // if current release is selected
          if (this.currentRelease !== null) {
            this.logs.forEach((l) => {
              // get all logs where release id ===  current selected release id
              if (l.release === this.currentRelease.id) {
                // push to array
                logs.push(l)
              }
            })
          }
        }
        // if type is multiple
        if (this.versionMode === 2) {
          if (this.fromRelease !== null && this.toRelease !== null) {
            // get all releases between from and to and store in array
            let releases = []
            releases = this.releases.filter((r) => {
              let tmp
              // check if current releases is >= from release and <= toRelease
              if (r.id >= this.fromRelease.id && r.id <= this.toRelease.id) {
                tmp = r
              }
              return tmp
            })
            // iterate logs array
            this.logs.forEach((l) => {
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
      },
      checkIfTypeIsSelected (id) {
        let flag = false
        if (this.checkedFiltersTypes.length > 0) {
          this.checkedFiltersTypes.forEach((f) => {
            if (id === f.id) {
              flag = true
            }
          })
        }
        return flag
      },
      checkIfCategoryIsSelected (id) {
        let flag = false
        if (this.checkedFiltersCategories.length > 0) {
          this.checkedFiltersCategories.forEach((f) => {
            console.log(f.id + ' ' + id)
            if (id === f.id) {
              flag = true
            }
          })
        }
        console.log(flag)
        return flag
      }
    },
    computed: {
      // function to filters logs
      filteredLogs () {
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
        return result
      },
      filteredFromReleases () {
        let result = []
        // filter out last result
        result = this.releases.filter((r, i) => {
          let tmp
          if (i < this.releases.length - 1) {
            tmp = r
          }
          return tmp
        })
        return result
      },
      filteredToReleases () {
        let result = []
        // filter by release id
        if (this.fromRelease !== null) {
          result = this.releases.filter((r) => {
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
