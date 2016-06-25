import * as auth from './auth.js'
import {logger} from './log.js'
import * as electron from 'electron'

const {app} = electron
const {BrowserWindow} = electron
const ipc = electron.ipcMain

let win;

let createWindow = () => {
  win = new BrowserWindow({width: 800, height: 600});

  win.loadURL(`file://${__dirname}/../index.html`);

  win.on('closed', () => {
    win = null;
  });

  ipc.on('loginGoogle', function(event, data){
    auth.googleAuth()
  });
}

export let openLoginWin = () => {
  app.on('ready', createWindow);

  app.on('window-all-closed', () => {
    if (process.platform !== 'darwin') {
      app.quit();
    }
  });

  app.on('activate', () => {
    if (win === null) {
      createWindow();
    }
  });
}
