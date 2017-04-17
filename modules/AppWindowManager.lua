settings = (require('modules/Settings'))('appwindowmanager')

--- This module automatically moves application windows to a specific screen and toggles fullscreen on application launch.
return {

	--- Stores sizes of windows prior to being maximized
	windowSizes = {},

	--- Initialize the module
	-- @param self 	The module table
	-- @return		Returns the module table or nil
	init = function(self)
		-- listen to application events
		hs.application.watcher.new(function(...)
			self:watch(...)
		end):start()

		self:bindHotkeys()

		return self
	end,

	--- Bind hotkeys to methods
	-- @param self 	The module table
	bindHotkeys = function(self)
		-- bind hotkeys to functions that move a window between screens
		hs.hotkey.bind({'command', 'alt', 'shift'}, 'right', function() self.switchScreen(true) end)
		hs.hotkey.bind({'command', 'alt', 'shift'}, 'left', function() self.switchScreen(false) end)
		hs.hotkey.bind({'command', 'alt', 'shift'}, 'up', function() self:maximizeWindow() end)
		hs.hotkey.bind({'command', 'alt', 'shift'}, 'down', function() self:restoreWindow() end)
	end,

	--- Handle application events
	-- @param self 			The module table
	-- @param appName 		The name of the application
	-- @param eventType 	The event that was triggered
	-- @param app 			An hs.application table
	watch = function(self, appName, eventType, app)
		local window
		local attempts = 0
		local maxAttempts = 25  -- about six seconds with .25 intervals

		if appName == nil then return end

		-- remove spaces from app name to match app names in config table
		appName = string.gsub(appName, " ", "")

		if eventType ~= hs.application.watcher.launched then 
			return 
		end

		-- get config data, return if missing
		local config = settings('apps')[appName]
		if not config then return end

		-- wait until window exists, then call functions that manipulate it
		hs.timer.waitUntil(function()
			-- stop timer if max attempts was reached
			if attempts >= maxAttempts then return true end
			attempts = attempts + 1

			window = app:mainWindow()

			self.log(appName, 'Waiting for application window...')

			if window == nil then return false end

			return window:isVisible()
		end, function()
			if attempts >= maxAttempts then
				self.log(appName, 'Failed to find the application window.')
				return
			end

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

		print('* [' .. os.time() .. '] ' .. appName .. msg)
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

	--- Maximize the focused window
	-- @param self 	The module table
	maximizeWindow = function(self)
		local window = hs.window.focusedWindow()

		self.windowSizes[window:id()] = window:size()

		window:maximize(0)
	end,

	--- Restore the focused window to its size prior to being maximized
	-- @param self 	The module table
	restoreWindow = function(self)
		local window = hs.window.focusedWindow()

		window:setSize(
			self.windowSizes[window:id()]
		)

		window:centerOnScreen()
	end
}