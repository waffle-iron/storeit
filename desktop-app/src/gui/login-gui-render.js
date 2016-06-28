import {ipc} from 'electron'

document.getElementById("loginGoogle").addEventListener("click", () => {
    ipc.send('loginGoogle')
})

document.getElementById("loginFacebook").addEventListener("click", () => {
    ipc.send('loginFacebook')
})