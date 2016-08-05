dofile 'MoveWindow.lua'
dofile 'WebView.lua'
dofile 'UrlEvents.lua'

-- Bind keys to window movements
local distance = 50
MoveWindow:bind({
	up = {0, distance, false},
	right = {distance, 0, true},
	down = {0, distance, true},
	left = {distance, 0, false}
})

WebView:init()
UrlEvents:init()