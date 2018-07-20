<template>
  <div class="page-wrapper">
    <!-- header -->
    <header class="header">
      <div class="container">
        <a href="#" class="header__logo">
          <img src="../assets/images/fundamental-icon.svg" alt=""/>
          <h3>Release Notes</h3>
        </a>
        <span>
          <a href="#" @click="logout()" class="btn btn--contact">Logout</a>
          <span style="padding-left: 20px"></span>
          <a href="http://www.fundamental.net/contact/" target="_blank" class="btn btn--contact">Contact us</a>
        </span>

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
            <div v-if="checkedFiltersTypes.length > 0 || checkedFiltersCategories.length > 0">
              <button class="clear-filters-btn" @click="clearFilters()">CLEAR FILTERS</button>
            </div>
          </div>

          <!-- release notes -->
          <div class="grid__col-2">

            <div v-if="currentRelease === null && fromRelease === null && toRelease === null">
              <h3>Please select a product version above.</h3>
            </div>

            <!-- notes from version selector -->
            <div class="notes" v-if="currentRelease !== null">

              <div style="display: flex; flex-direction: column;">
                <h2>Changes and issues in FPM version {{ currentRelease.name }}</h2>
                <div style="display: flex; flex-direction: row; margin-bottom: 30px">
                  <span style="padding-right: 40px; cursor: pointer; display: flex; align-items: center; justify-content: center" @click="downloadPdf()">
                    <img src="../assets/images/download-pdf.svg"/>
                    <span style="padding-left: 8px"></span>
                    <span class="download-link">Download</span>
                  </span>
                  <download-excel
                    style="padding-right: 40px; cursor: pointer; display: flex; align-items: center; justify-content: center"
                    :data   = "filteredLogs"
                    :fields = "json_fields"
                    :name    = "getXlsFileName">
                    <img src="../assets/images/download-xls.svg" />
                    <span style="padding-left: 8px"></span>
                    <span class="download-link">Download</span>
                  </download-excel>
                </div>
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

              <div style="display: flex; flex-direction: column;">
                <h2>Cumulative Release notes - FPM version {{ fromRelease.name }} to {{ toRelease.name }}</h2>
                <div style="display: flex; flex-direction: row; margin-bottom: 30px">
                  <span style="padding-right: 40px; cursor: pointer; display: flex; align-items: center; justify-content: center" @click="downloadPdf()">
                    <img src="../assets/images/download-pdf.svg"/>
                    <span style="padding-left: 8px"></span>
                    <span class="download-link">Download</span>
                  </span>

                  <download-excel
                    style="padding-right: 40px; cursor: pointer; display: flex; align-items: center; justify-content: center"
                    :data   = "filteredLogs"
                    :fields = "json_fields"
                    name    = "filename.xls">
                    <img src="../assets/images/download-xls.svg" />
                    <span style="padding-left: 8px"></span>
                    <span class="download-link">Download</span>
                  </download-excel>
                </div>
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
  // import axios from 'axios'
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
        filename: '',
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
      if (localStorage.getItem('user') === null) {
        this.$router.push('/')
      }
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
    <style>
    @import url('https://fonts.googleapis.com/css?family=Poppins');

      header {
    background-color: #4a4c54;
    padding: 13px 34px;
    color: #fff;
    font-size: 14px;
    font-weight: 600;
    font-family:'Poppins';
}

header .logo {
    width: 160.6px;
    height: 24.5px;
    object-fit: contain;
}

body {
    color: #4a4c54;
    font-weight: normal;
    line-height: 1.33;
    letter-spacing: normal;
    text-align: left;
    font-family: 'Poppins';
}

h1 {

    font-size: 22px;
    line-height: 1.21;
    margin-bottom: 20px;
}

h2 {
    font-size: 16px;
    font-weight: 400;
    line-height: 1;
    letter-spacing: 0.2px;
    margin: 0px;
}

h3 {

    font-size: 12px;
    line-height: 1;
    letter-spacing: normal;
    margin: 0px;
}

ul {
    line-height: 1.33 !important;
    list-style-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 512 512'%3E%3Ccircle cx='256' cy='256' r='256' fill='#ff0000' /%3E%3C/svg%3E");
}

.line {
    margin-top: 15px;
    margin-bottom: 15px;
    height: 1px;
    background-color: #dfdfdf;
         border-bottom: solid 1px #dfdfdf;
}

.content {
    padding: 0px 35px;
}

.title {
  font-family: 'PoppinsBold';
}

.type {
    padding-top: 20px;
}

.category {
    padding-top: 21px;
    padding-bottom: 0px;
}

.log {
    font-size: 9px;
    font-weight: 400;
    line-height: 1.33;
}
    </style>

</head>

<body>
    <header>
        <table width="100%">
            <tr>
                <td>
                    <img align="left" height=40 src="data:image/png;base64,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"/>
                </td>
                <td style="color: white !important; text-align:right";>
                  Fundamental Portfolio Manager(FPM) Release Notes
                </td>
            </tr>
        </table>
    </header>

    <div class="content">
        <!-- heading -->
        <h1>${this.getTitle()}</h1>
        <!-- each item is meant to be put through an array to generate release notes -->
        <!-- type -->
        ${this.getTypesHtml()}
    </div>
</body>

</html>`
      },
      getTitle () {
        if (this.fromRelease !== null && this.toRelease !== null) {
          return `Fundamental Cumulative Release notes - FPM version ${this.fromRelease.name} to ${this.toRelease.name}`
        } else if (this.currentRelease !== null) {
          return `Fundamental Release Notes - FPM version ${this.currentRelease.name}`
          // return `<h1>Changes and issues in FPM version ${this.currentRelease.name}</h1>`
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
            <span class="title">${fl.title}</span> ${fl.desc}</p>

            <!-- solution -->
            ${fl.solution}
            </div>`
                  }
                })
              }
            })
            html += `<div class="line" style="margin-top: 25px !important;"></div>
          </div></div>`
          }
        })
        return html
      },
      downloadPdf () {
        // call function to create HTML
        this.createHtml()
        // console.log(this.html)
        fetch('https://url-to-pdf-api.herokuapp.com/api/render', {
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
          saveAs(file, `${this.getTitle()}.pdf`)
        }, (err) => {
          alert(err.message)
        })
      },
      init () {
        // get logs
        HTTP.get('logs?transform=1')
          .then((res) => {
            this.logs = res.data.logs
          })
          .catch((err) => {
            alert(err)
          })
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
        // HTTP.get('logBinaries?transform=1')
        //   .then((res) => {
        //     this.logBinaries = res.data.logBinaries
        //   })
        //   .catch((err) => {
        //     alert(err)
        //   })
      },
      clearFilters () {
        this.checkedFiltersTypes = []
        this.checkedFiltersCategories = []
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
      },
      logout () {
        this.$router.push('/')
        localStorage.clear()
      }
    },
    computed: {
      getXlsFileName () {
        return `${this.getTitle()}.xls`
      },
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

  .clear-filters-btn {
    width: 160px;
    height: 28px;
    border-radius: 2px;
    box-shadow: inset 0 -2px 0 0 rgba(255, 67, 53, 0.06);
    border: solid 1px #ff4335;
    font-family: Poppins;
    font-size: 11px;
    font-weight: bold;
    line-height: 0.91;
    letter-spacing: 1.1px;
    text-align: center;
    color: #ff4335;
  }

  .clear-filters-btn-disabled {
    width: 160px;
    height: 28px;
    border-radius: 2px;
    box-shadow: inset 0 -2px 0 0 rgba(255, 67, 53, 0.06);
    border: solid 1px darkgrey;
    font-family: Poppins;
    font-size: 11px;
    font-weight: bold;
    line-height: 0.91;
    letter-spacing: 1.1px;
    text-align: center;
    color: darkgrey;
  }

  .download-link {

  }

  .download-link:hover {
    /*text-decoration: underline;*/
    color: red;

  }

</style>
