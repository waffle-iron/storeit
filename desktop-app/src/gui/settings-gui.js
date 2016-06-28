import Client from '../client'
import {logger} from '../log'
import electron from 'electron'

let {app} = electron
let {BrowserWindow} = electron
let ipc = electron.ipcMain

let win;

let createWindow = () => {
  win = new BrowserWindow({width: 800, height: 600});

  win.loadURL(`file://${__dirname}/../../settings.html`);

  win.on('closed', () => {
    win = null;
  });

}

export let openSettingsGui = () => {
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
