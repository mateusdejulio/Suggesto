const { contextBridge, ipcRenderer } = require('electron');
//contextBridge é o que permite expor funções especificas as janelas criadas pelo main, sem dar acesso total ao node
//ipc renderer é o que se comunica com o ipc main, enviando e recebendo mensagens 

