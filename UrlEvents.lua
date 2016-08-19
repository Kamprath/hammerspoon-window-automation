UrlEvents = {
	init = function(self)
		local binds = {
			showMessage = self.showMessage,
			reloadConfig = self.reloadConfig,
			showConsole = self.showConsole
		}

		self.bindEvents(binds)
	end,

	bindEvents = function(binds)
		for event, func in pairs(binds) do
			hs.urlevent.bind(event, func)
		end
 	end,

	showMessage = function(event, params)
		hs.notify.new({
			title = params.title or "URL Message",
			informativeText = params.message
		}):send()
	end,

	reloadConfig = function(event, params)
		hs.reload()
	end,

	showConsole = function(event, params)
		hs.openConsole()
	end
}