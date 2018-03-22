<template>
  <div class="page-wrapper">
    <header class="header">
      <div class="container">
        <a href="#" class="header__logo">
          <img src="../assets/images/fundamental-icon.svg" alt=""/>
          <h3>Release Notes</h3>
        </a>
        <a href="http://www.fundamental.net/contact/" target="_blank" class="btn btn--contact">Contact us</a>
      </div>
    </header>
    <div class="spacer"></div>
    <vue-simple-spinner v-if="loading"></vue-simple-spinner>
    <div class="login" v-if="!loading">
      <div class="login-line"></div>
      <img src="../assets/images/feature-crm.svg" alt=""/>
      <form @submit="login()">
        <!-- username / email -->
        <input class="input" type="text" v-model="user.email" placeholder="Username or Email" required/>

        <!-- password -->
        <input class="input" type="password" v-model="user.password" placeholder="Password" required/>

        <!-- remember -->
        <!-- TODO: add funtionality to radio button-->
        <label class="radio">
          <input type="radio" id="toggle-changes"  v-model="user.remember_me" />
          <span class="radio__indi"></span>
          <span class="radio__label">Remember Me</span>
        </label>


        <!-- error -->
        <span class="error" v-if="error">{{ error }}</span>

        <!-- login button-->
        <button type="submit" style="font-size: 11px">
          LOGIN
        </button>

      </form>
    </div>
    <p v-if="!loading">Forgot your password? &nbsp; <a class="contact-link" target="_blank" href="mailto:support@fundamental.net">Contact Support</a> &nbsp; to reset it.</p>


  </div>
</template>

<script>
  import users from '../assets/users.json'
  export default {
    name: 'Login',
    data () {
      return {
        users: users.users,
        user: {
          email: '',
          password: '',
          remember_me: true
        },
        error: '',
        loading: false
      }
    },
    created () {
      this.loading = true
      if (localStorage.getItem('user') !== null) {
        setTimeout(() => {
          this.$router.push('ReleaseNotes')
        }, 5000)
      } else {
        this.loading = false
      }
    },
    methods: {
      login () {
        // search by email
        this.loading = true
        let user = this.users.find((user) => {
          return user.email === this.user.email
        })
        // check if user exists
        if (user !== undefined) {
          this.error = ''
          // check password
          if (user.password === this.user.password) {
            // redirect page and set cookie
            localStorage.setItem('user', JSON.stringify(this.user))
            this.$router.push('ReleaseNotes')
          } else {
            this.error = 'Error: Password is incorrect'
            alert(this.error)
          }
        } else {
          this.error = 'Error: This user does not exist'
          alert(this.error)
        }
        this.loading = false
      }
    }
  }
</script>

<style scoped>
  @import '../assets/styles/main.css';

  .page-wrapper {
    background-color: #4a4c54 !important;
    display: flex;
    flex-direction: column;
    height: 100vh;
    width: 100vw;
    /*justify-self: center;*/
    /*justify-content: center;*/
    /*align-items: center;*/
  }

  .page-wrapper p {
    padding-top: 27px;
    display: flex;
    align-self: center;
    color: white;
    font-weight: 100;
  }

  .contact-link {
    font-weight: 800;
  }

  .contact-link:hover {
    /*text-decoration: underline;*/
    border-bottom: 1px solid white;

  }

  .spacer {
    margin-top: 150px;
  }

  .radio {
    padding-bottom: 28px;
  }

  .radio__label {
    font-size: 12px;
  }

  .error {
    padding-bottom: 10px;
    color:red;
  }


  .login {
    width: 420px;
    padding-bottom: 49px;
    /*height: 420px;*/
    border-radius: 5px;
    background-image: linear-gradient(135deg, #ffffff, #e1e2e1);
    display: flex;
    flex-direction: column;
    align-self: center;
  }

  .login img {
    margin-top: 50px;
  }

  .login form {
    width: 300px;
    margin-top: 30px;
    display: flex;
    flex-direction: column;
    align-self: center;
  }

  form button {
    height: 42px;
    border-radius: 2px;
    background-color: #ff4335;
    color: white;
    line-height: 0.91;
    letter-spacing: 1.1px;
    text-align: center;
  }

  .input {
    outline: none;
    -webkit-appearance: none;
    -moz-appearance: none;
    appearance: none;
    background-color: transparent;
    border-style: none;
    border-bottom: 1px solid rgba(74, 76, 84, 0.15);
    margin-bottom: 40px;
    font-size: 14px;
    color: #4a4c54;
    letter-spacing: 1px;
    padding-bottom: 5px;
    height: 21px;
  }

  .login-line {
    width: 100%;
    height: 9px;
    border-radius: 5px 5px 0px 0px;
    background-image: linear-gradient(106deg, #ff7865, #ff4335);
    overflow:auto;
  }


</style>

