dofile 'MoveWindow.lua'
dofile 'WebView.lua'

local web = nil
local distance = 65

-- Bind keys to window movements
MoveWindow:bind({
	up = {0, distance, false},
	right = {distance, 0, true},
	down = {0, distance, true},
	left = {distance, 0, false}
})

-- Show webview and notification when cmd + alt + ctrl + W is pressed
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W", function()
	local mousePosition = hs.mouse.getAbsolutePosition()

	local notification = {
		title = "Ayylmao", 
		informativeText = nil
	}

	-- Create a WebView
	if (web ~= nil) then
		web:hide()
		web = nil
		notification.informativeText = "Webview destroyed."
	else
		web = WebView.create(mousePosition.x, mousePosition.y, 650, 500)
		web:url('http://news.ycombinator.com')
		web:show()
		notification.informativeText = "Webview created."
	end	

	-- Create notification
	hs.notify.new(notification):send()
end)