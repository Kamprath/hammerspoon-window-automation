--- This module automatically moves application windows to a specific screen and toggles fullscreen on application launch.
AppWindowManager = {

	configPath = 'apps.json',
	config = nil,

	--- Initialize the module
	-- @param self 	The AppWindowManager table
	-- @return		Returns the AppWindowManager table, or nil if an error occured
	init = function(self)
		self.config = self:getConfig()

		if not self.config then
			self.notify('Unable to load configuration.')
			return
		end

		-- listen to application events
		hs.application.watcher.new(function(...)
			self:watch(...)
		end):start()

		-- bind hotkeys to functions that move a window between screens
		hs.hotkey.bind({'command', 'alt', 'shift'}, 'right', function() self.switchScreen(true) end)
		hs.hotkey.bind({'command', 'alt', 'shift'}, 'left', function() self.switchScreen(false) end)

		return self
	end,

	--- Handle application events
	-- @param self 			The AppWindowManager table
	-- @param appName 		The name of the application
	-- @param eventType 	The event that was triggered
	-- @param app 			An hs.application table
	watch = function(self, appName, eventType, app)
		local window

		-- remove spaces from app name to match app names in config table
		appName = string.gsub(appName, " ", "")

		if eventType ~= hs.application.watcher.launched then 
			return 
		end

		local config = self.config[appName]
		if not config then
			return
		end

		-- wait until window exists, then call functions that manipulate it
		hs.timer.waitUntil(function()
			window = app:mainWindow()
			self.log(appName, 'Waiting for application window...')
			if window == nil then return false end
			return window:isVisible()
		end, function()
			self:manipulateWindow(appName, window, config)
		end, .25)
	end,

	--- Perform actions on application window depending on configuration data
	-- @param appName 	Name of the application
	-- @param window 	The application hs.window table
	-- @param config	The application's configuration data
	manipulateWindow = function(self, appName, window, config)
		hs.timer.waitUntil(function()
			-- un-fullscreen window so it can move between screens
			window:setFullScreen(false)		
			return not window:isFullScreen()
		end, function()
			-- if configured, move window to its target screen and then toggle fullscreen if specified
			if config.screen ~= nil then
				self:moveToScreen(window, config.screen, function()
					if config.fullscreen then self:toggleFullscreen(window) end
				end)
			else
				-- otherwise just toggle fullscreen
				if config.fullscreen then 
					self:toggleFullscreen(window) 
				end
			end
		end, .25)
	end,

	--- Move a window to a screen
	-- @param window 		An hs.window table
	-- @param screenNumber  The number of a screen to move the window to
	-- @param callback		(Optional) A callback function to execute after the window is moved
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

	--- Set a window to fullscreen
	-- @param window 	The application's hs.window table
	toggleFullscreen = function(self, window)  
        window:setFullScreen(true)
		self.log(nil, 'Fullscreen toggled')
	end,

	--- Log a message to the Hammerspoon console
	-- @param appName 	(Optional) The application name
	-- @param msg 		The message to log
	log = function(appName, msg)
		appName = appName or ''
		if appName ~= '' then appName = appName .. ': ' end

		hs.console.printStyledtext('* [' .. os.time() .. '] ' .. appName .. msg)
	end,

	--- Display a Hammerspoon notification
	-- @param message 	The message to display
	notify = function(message)
		hs.notify.new({
			title = "App Window Manager",
			informativeText = message
		}):send()
	end,

	--- Move the focused window to the next or previous screen
	-- @param forward	(Optional) A boolean indicating whether to move the window forward or back a screen
	switchScreen = function(forward)
		if forward == nil then forward = true end
		local window = hs.window.focusedWindow()
		local isFullscreen = window:isFullscreen()
		local currentScreen = window:screen()
		local screens = hs.screen.allScreens()
		local position, screen

		-- determine array position of 'screen'
		for pos, val in ipairs(screens) do
			-- set 'position' variable to array position when the current array item matches the 'currentScreen'
			if val == currentScreen then
				position = pos
			end
		end

		-- determine next or previous screen position
		if forward and (position == #screens) then
			screen = screens[1]
		elseif not forward and (position == 1) then
			screen = screens[#screens]
		else
			if forward then position = position + 1 end
			if not forward then position = position - 1 end
			screen = screens[position]
		end

		if not isFullscreen then 
			window:moveToScreen(screen, false, false, .25)
			return
		end

		window:setFullScreen(false)

		-- move window and toggle fullscreen after delay
		hs.timer.doAfter(.5, function()
			window:moveToScreen(screen, false, false, .1)

			-- restore fullscreen
			hs.timer.doAfter(.5, function()
				window:setFullScreen(true)
			end)
		end)
	end,

	--- Get app config data from file
	-- @param self 	The AppWindowManager table
	-- @return 		Returns a table of app configuration data
	getConfig = function(self)
		-- check if config file exists
		local file = io.open(self.configPath, 'rb')
		local data

		if not file then
			self.log(nil, 'No config file found.')
			return
		end

		-- read file contents
		data = file:read('*all')
		file:close()

		-- attempt to decode JSON
		return hs.json.decode(data)
	end
}