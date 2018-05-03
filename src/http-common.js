import axios from 'axios'

export const HTTP = axios.create({
  baseURL: 'https://cors-anywhere.herokuapp.com/http://fundamental.net/releasenotes/api.php
})
