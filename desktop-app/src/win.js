import Client from './client'
import {logger} from './log'
import electron from 'electron'

let {app} = electron
let {BrowserWindow} = electron
let ipc = electron.ipcMain

let win;

let createWindow = () => {
  win = new BrowserWindow({width: 800, height: 600});

  win.loadURL(`file://${__dirname}/../index.html`);

  win.on('closed', () => {
    win = null;
  });

  ipc.on('loginGoogle', (event, data) => {
      let client = new Client()
      client.auth('google')
  });
  ipc.on('loginFacebook', (event, data) => {
      let client = new Client()
      client.auth('facebook')
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
