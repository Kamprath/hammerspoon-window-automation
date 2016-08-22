WebView = {
	-- A reference to the WebView object
	web = nil,

	window = nil,

	visible = false,

	init = function(self)
		-- Create the WebView
		self.web = self.create(1030, 500, 500, 200)
		self.web:allowTextEntry(true)
		self.web:url('file:///Users/johnny.kamprath/.hammerspoon/dashboard/index.html')

		self.window = self.web:asHSWindow()

		self:registerHandlers()
	end,

	registerHandlers = function(self)
		-- Close web view when hammerspoon://closeWebView is visited
		hs.urlevent.bind('closeWebView', function()
			self:closeWebView()
		end)

		-- Show webview when hotkey is pressed
		hs.hotkey.bind({"cmd", "shift"}, "\\", function()
			self:toggleWebView()
		end)
	end,

	create = function(x, y, width, height)
		local rect = hs.geometry.rect(x, y, width, height)

		return hs.webview.new(rect)
	end,

	toggleWebView = function(self)
		-- Show or hide the window
		if (self.visible) then
			self.web:hide()
		else
			self.web:setLevel(hs.drawing.windowLevels.overlay)
			self.web:show()

			-- focus the WebView
			hs.application.get("Hammerspoon"):activate(true)
		end

		-- Reverse this value
		self.visible = not self.visible
	end,

	closeWebView = function(self)
		self.web:hide()
		self.visible = false
	end
}