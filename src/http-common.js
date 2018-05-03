import axios from 'axios'

export const HTTP = axios.create({
  baseURL: 'https://fundamental-release-notes.herokuapp.com/api.php'
})
