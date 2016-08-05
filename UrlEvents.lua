UrlEvents = {
	init = function(self)
		local binds = {
			showMessage = self.showMessage
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
			title = "URL Message",
			informativeText = params.message
		}):send()
	end
}