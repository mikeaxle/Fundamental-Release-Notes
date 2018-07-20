import axios from 'axios'
export const HTTP = axios.create({
  baseURL: 'https://releasenotes.fundamental.net/api.php',
  headers: {'Access-Control-Allow-Origin': '*'}
})
