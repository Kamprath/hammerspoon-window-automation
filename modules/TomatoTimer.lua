-- Todo:
-- * Inject JS that detects when the timer has run out and 
--   hits an HS URL that notifies you of the time running
--   out

local TomatoTimer = {
	web = nil,

	--- WebView configuration data
	config = {
		url = 'http://tomato-timer.com/',
		size = {550, 420},

		--- This table contains script data to inject into the WebView
		script = {
			source = (function()
				local file = io.open(hs.configdir .. '/config/tomato_timer.js', 'rb')

				if not file then return nil end
				
				local script = file:read('*all')
				file:close()

				return script
			end)(),
			mainFrame = true,
			injectionTime = 'documentEnd'
		}
	},

	init = function(self)
		local config = self.config

		-- create webview but remain invisible
		self.web = self.createWebView(config.size[1], config.size[2], config.url, config.script)

		-- bind hotkey to method
		hs.hotkey.bind({'alt', 'shift'}, 'T', function() self:toggleWebView(self.web) end)
	end,

	toggleWebView = function(self, webView)
		-- if web view is visible, hide it
		if webView:hswindow() ~= nil then
			self.hideWebView(webView)
			return
		end

		self.showWebView(webView)
	end,

	showWebView = function(webView)
		local app = hs.application.get('Hammerspoon')

		-- set WebView level to overlay
		webView:level(hs.drawing.windowLevels.overlay)

		-- show, focus, and center the WebView
		webView:show()
		app:activate(true)
		-- webView:hswindow():centerOnScreen(nil, nil, 0)
		app:focusedWindow():centerOnScreen(nil, nil, 0)
	end,

	hideWebView = function(webView)
		webView:hide()
	end,

	createWebView = function(width, height, url, script)
		local rect = hs.geometry.rect(0, 0, width, height)

		-- create a 'user content object' to inject JavaScript that removes page clutter into the page
		local userContentController = hs.webview.usercontent.new('tomato')
		userContentController:injectScript(script)

		-- create and configure the WebView
		local web = hs.webview.new(rect, userContentController)
		web:allowTextEntry(true)
		web:url(url)

		return web
	end
}

return TomatoTimer