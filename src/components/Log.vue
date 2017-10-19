<template>
  <!-- logs -->
    <div class="notes__subitem" style="border-bottom: none !important;" >

      <div class="notes__subitem-header" v-for="l in logs" style="border-bottom: 1px solid #e0e0e0 !important;">
        <div v-if="l.category === category.id">

          <p><strong>{{ l.title }}</strong> {{ l.desc }}</p>
          <a href="article.html" target="_blank" title="Opens in a new window"
             class="notes__subitem-launch">
            <span class="svg svg-new-window svg-new-window-dims"></span>
          </a>
          <a class="notes__subitem-open" @click="l.isopen = !l.isopen">
            <span class="svg svg-expand-down svg-expand-down-dims"></span></a>

          <!-- log content -->
          <transition v-on:enter="enter" v-on:leave="leave">
            <div class="notes__subitem-content item" id="note-1" v-show="l.isopen">
              <div class="rte" v-html="l.solution"></div>
            </div>
          </transition>
        </div>
      </div>
    </div>


</template>

<script>
  import Velocity from 'velocity'
  export default {
    name: 'Log',
    props: ['logs', 'category'],
    data () {
      return {
        show: false
      }
    },
    methods: {
      openItem: function (item) {
        item.isopen = !item.isopen
      },
//
//      setClass: function (item) {
//        if (item.isopen === true) {
//          return 'open'
//        }
//        return 'close'
//      },
      beforeEnter: function (el) {
        el.style.opacity = 0
      },
      enter: function (el, done) {
        Velocity(el, 'slideDown', {duration: 400, easing: 'easeInBack'}, {complete: done})
      },
      leave: function (el, done) {
        Velocity(el, 'slideUp', {duration: 400, easing: 'easeInBack'}, {complete: done})
      }
    }
  }
</script>

<style scoped>
  .item {
    overflow:hidden;
  }
</style>


