WebView = {
	-- A reference to the WebView object
	web = nil,

	init = function(self)
		-- Close web view when hammerspoon://closeWebView is visited
		hs.urlevent.bind('closeWebView', function()
			self:closeWebView()
		end)

		-- Show webview when cmd + alt + ctrl + W is pressed
		hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W", function()
			local mousePosition = hs.mouse.getAbsolutePosition()

			-- Create a WebView
			if (self.web ~= nil) then
				self:closeWebView()
			else
				self.web = WebView.create(mousePosition.x, mousePosition.y, 500, 420)
				self.web:allowTextEntry(true)
				self.web:url('file:///Users/johnny.kamprath/.hammerspoon/test.html')

				self.web:show()
			end
		end)
	end,

	closeWebView = function(self)
		if (self.web ~= nil) then
			self.web:hide()
			self.web = nil
		end
	end,

	create = function(x, y, width, height)
		local rect = hs.geometry.rect(x, y, width, height)

		return hs.webview.new(rect)
	end
}