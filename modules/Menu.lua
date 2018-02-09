local Settings = require('modules/Settings')
local AppWindowManager = require('modules/AppWindowManager')
local Ternary = require('modules/Ternary')

return {
	menubar = nil,

	--- Initialize the module	
	-- @param self
	init = function(self)
		-- Create the menubar
		self.menubar = self:createMenubar()

		self:registerHandlers()
	end,

	registerHandlers = function(self)
		-- reload menu when fullscreenModeToggled URL is hit
		hs.urlevent.bind('fullscreenModeToggled', function()
			self.menubar:setMenu(self:getMenu())
		end)
	end,

	--- Create the menubar
	-- @param self
	createMenubar = function(self)
		local menubar = hs.menubar.new()
		local image = hs.image.imageFromName('NSAdvanced'):setSize({w=16,h=16})

		menubar:setIcon(image)
		menubar:setMenu(self:getMenu())

		return menubar
	end,

	--- Get menu items
	-- @param self
	getMenu = function(self)
		return {
			self:getFullscreenModeMenuItem()
		}
	end,

	--- Get the Fullscreen Mode menu item
	-- @param self
	getFullscreenModeMenuItem = function(self)
		local enabled = AppWindowManager:fullscreenModeEnabled()
		local title = Ternary(enabled, 'Disable', 'Enable') .. " Fullscreen Mode"

		return { 
			title = title,
			fn = function()
				AppWindowManager:toggleFullscreenMode(not enabled)
			end
		}
	end,

	--- Get Launch Applications menu
	-- @param self
	getLaunchAppsMenu = function(self)
		return {
			title = 'Launch Applications',
			fn = function()
				local apps = Settings.get('launchapps.apps')

				for i, app in ipairs(apps) do
					hs.application.launchOrFocus(app)
				end
			end
		}
	end
}