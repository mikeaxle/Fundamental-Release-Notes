import axios from 'axios'

export const HTTP = axios.create({
  baseURL: 'http://www.fundamental.net/releasenotes/api.php/'
})
