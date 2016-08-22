dofile 'MoveWindow.lua'
dofile 'WebView.lua'
dofile 'UrlActions.lua'
dofile 'ShowJoe.lua'

WebView:init()
UrlActions:init()
ShowJoe:init()

-- Bind keys to window movements
-- local distance = 50
-- MoveWindow:bind({
-- 	up = {0, distance, false},
-- 	right = {distance, 0, true},
-- 	down = {0, distance, true},
-- 	left = {distance, 0, false}
-- })