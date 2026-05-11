//O Cofre/Servidor. É o único lugar seguro que tem a chave do banco de dados e pode fazer as verificações.'
// É o arquivo Main que cria as janelas e que conversa com o sistema operacional 

const { app, BrowserWindow, nativeTheme, ipcMain } = require('electron')
//importamos os recursos 'app' e 'BrowserWindow'  do framework electron
//importamos ipcMain do electron também para podermos fazer a ponte do front para o back, usando ipcMain e ipcRenderer

const path = require('path')
// O path serve para organizar os caminhos de acessos à pastas e arquivos
let win; 

const createLoginWindow = () => {
    console.log("Tentando abrir a janela...");
    nativeTheme.themeSource = 'dark'
//Importamos o recurso nativeTheme e definimos que a janela sempre estará no tema escuro

 //atribuindo a nova janela a nossa váriavel global para poder controlar de outra função
    win = new BrowserWindow({
        width: 800,
        height: 600,
 //tamanho da janela
    
    autoHideMenuBar : true,
//esconder o menu de funções padrão da página
    
    webPreferences : {
        preload: path.join(__dirname, 'preload.js'),
        contextIsolation: true,
        nodeIntegration : true,
        webSecurity : false,
    }

  
    });
    
    win.maximize()
    win.loadURL("http://localhost:5173")
// carrega a interface React (rodando no Vite) dentro da janela do app Electron no endereço passado 
}

app.whenReady().then(() =>{
    createLoginWindow();

    app.on('activate', ()=> {
        if (BrowserWindow.getAllWindows().length === 0) createLoginWindow();
    });
});

    app.on('window-all-closed', () => {
        if (process.platform !== 'darwin') app.quit();
    })

