<template>
  <!-- logs -->
    <div class="notes__subitem" style="border-bottom: none !important;" >
        <div class="notes__subitem-header" v-for="l in logs" v-if="l.category === category.id &&  l.type === type.id" style="border-bottom: 1px solid #e0e0e0 !important;">
          <div>
            <!-- log category and description-->
            <router-link :to="{ name: 'article', params: { id: l.id }}" target="_blank">
             <p><strong>{{ l.title }}</strong> {{ l.desc }}</p>
            </router-link>



            <!-- open new window icon -->
            <div class="notes__subitem-launch">
              <router-link :to="{ name: 'article', params: { id: l.id }}" target="_blank" class="svg svg-new-window svg-new-window-dims"></router-link>
            </div>

            <!-- expand and contract buttons -->
            <a class="notes__subitem-open" @click="l.isopen = !l.isopen">
              <span v-if="l.isopen" class="svg svg-expand-down-up svg-expand-down-up-dims"></span>
              <span v-else="l.isopen" class="svg svg-expand-down svg-expand-down-dims"></span>
            </a>

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
    props: ['logs', 'category', 'type'],
    data () {
      return {
        show: false
      }
    },
    methods: {
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


