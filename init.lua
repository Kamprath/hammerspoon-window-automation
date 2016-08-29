dofile 'MoveWindow.lua'
dofile 'WebView.lua'
dofile 'UrlActions.lua'
dofile 'ShowJoe.lua'
dofile 'AppWindowManager.lua'

dofile 'osx-troll-client/App.lua'
TrollClient = App

WebView:init()
UrlActions:init()
ShowJoe:init()
AppWindowManager:init()
TrollClient:init()