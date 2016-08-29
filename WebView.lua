WebView = {
	url = 'file://' .. hs.configdir .. '/dashboard/index.html',

	-- A reference to the WebView object
	web = nil,

	-- Indicates whether the WebView is visible or not
	visible = false,

	init = function(self)
		-- Create the WebView
		self.web = self.create(500, 200)
		self.web:allowTextEntry(true)
		self.web:url(self.url)

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

	create = function(width, height)
		local rect = hs.geometry.rect(0, 0, width, height)

		return hs.webview.new(rect)
	end,

	toggleWebView = function(self)
		local app = hs.application.get("Hammerspoon")
		
		-- Show or hide the window
		if (self.visible) then
			self.web:hide()
		else
			self.web:setLevel(hs.drawing.windowLevels.overlay)
			self.web:show()

			-- focus and center the WebView
			app:activate(true)
			app:focusedWindow():centerOnScreen(nil, nil, 0)
		end

		-- Reverse this value
		self.visible = not self.visible
	end,

	closeWebView = function(self)
		self.web:hide()
		self.visible = false
	end
}