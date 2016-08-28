-- This module automatically moves application windows to a specific screen and toggles fullscreen on application launch.
AppWindowManager = {

	config = {
		HyperTerm = {
			fullscreen = true,
			screen = 2
		},
		GoogleChrome = {
			fullscreen = true,
			screen = 2
		},
		SublimeText = {
			fullscreen = true,
			screen = 1
		},
		Spotify = {
			fullscreen = true,
			screen = 2
		},
		Mail = {
			fullscreen = true,
			screen = 2
		},
		Slack = {
			fullscreen = true,
			screen = 2
		}
	},

	init = function(self)
		hs.application.watcher.new(function(...)
			self:watch(...)
		end):start()

		return self
	end,

	watch = function(self, appName, eventType, app)
		local window

		-- remove spaces from app name to match app names in config table
		appName = string.gsub(appName, " ", "")

		if eventType ~= hs.application.watcher.launched then 
			return 
		end

		self.log(appName, 'Launched')

		local config = self.config[appName]

		-- return if application name isn't in self.config
		if not config then 
			self.log(appName, 'No config data found')
			return
		end

		-- wait until window exists, then call functions that manipulate it
		hs.timer.waitUntil(function()
			window = app:mainWindow()

			return window ~= nil
		end, function()
			local notificationMsg = nil

			-- un-fullscreen window so it can move between screens
			window:setFullScreen(false)
			
			hs.timer.waitUntil(function()
				return not window:isFullScreen()
			end, function()
				-- If configured, move window to its target screen and then toggle fullscreen if specified
				if config.screen ~= nil then
					notificationMsg = 'Moved ' .. appName .. ' window to screen ' .. config.screen

					self:moveToScreen(window, config.screen, function()
						if config.fullscreen then self:toggleFullscreen(window) end
					end)

					if config.fullscreen then notificationMsg = notificationMsg .. ' and toggled fullscreen' end

				else
					-- If specified, toggle fullscreen
					if config.fullscreen then 
						self:toggleFullscreen(window) 
					end

					notificationMsg = 'Toggled fullscreen for ' .. appName
				end

				if notificationMsg ~= nil then
					self.notify(notificationMsg .. '.')
				end
			end, .25)
		end, .25)
	end,

	moveToScreen = function(self, window, screenNumber, callback)
		local screens = hs.screen.allScreens()

		-- return if the screen doesn't exist
		if screens[screenNumber] == nil then return end

  		window:moveToScreen(screens[screenNumber])
  		
		self.log(nil, 'Window moved to screen ' .. screenNumber)

		if callback ~= nil then
			callback()
		end
	end,

	toggleFullscreen = function(self, window)  
        window:setFullScreen(true)
		self.log(nil, 'Fullscreen toggled')
	end,

	log = function(appName, msg)
		appName = appName or ''
		if appName ~= '' then appName = appName .. ': ' end

		hs.console.printStyledtext('* [' .. os.time() .. '] ' .. appName .. msg)
	end,

	notify = function(message)
		hs.notify.new({
			title = "App Window Manager",
			informativeText = message
		}):send()
	end

}