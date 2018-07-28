import {app, BrowserWindow} from 'electron';

function createWindow()
{
    let win = new BrowserWindow({width: 800, height: 600});
    win.loadURL('http://localhost:9000/#/hello');    
}

app.on('ready', createWindow);