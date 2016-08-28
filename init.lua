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

-- Bind keys to window movements
-- local distance = 50
-- MoveWindow:bind({
-- 	up = {0, distance, false},
-- 	right = {distance, 0, true},
-- 	down = {0, distance, true},
-- 	left = {distance, 0, false}
-- })