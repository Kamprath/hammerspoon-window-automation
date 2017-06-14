local Settings = require('modules/Settings')

return {
	init = function(self)
		-- bind URL to methods that they trigger
		self.bindEvents({
			notify = self.notify,
			reloadConfig = self.reloadConfig,
			showConsole = self.showConsole,
			log = self.log,
			launchApps = self.launchApps
		})
	end,

	bindEvents = function(binds)
		for event, func in pairs(binds) do
			hs.urlevent.bind(event, func)
		end
 	end,

	notify = function(event, params)
		local notification = hs.notify.new({
			title = params.title or "URL Message",
			informativeText = params.message
		})

		-- set notification's image if an 'image' parameter is provided
		if params.image ~= nil then
			local path = hs.configdir .. '/images/' .. params.image
			local image = hs.image.imageFromPath(path)

			if image ~= nil then 
				notification:contentImage(image)
			end
		end

		-- play system sound if 'sound' parameter is provided
		if params.sound ~= nil then
			hs.sound.getByName(params.sound):play()
		end

		notification:send()
	end,

	reloadConfig = function(event, params)
		hs.reload()
	end,

	log = function(event, params)
		print('* ' .. params.message)
	end,

	showConsole = function(event, params)
		hs.openConsole()
		hs.execute('open hammerspoon://closeWebView')
	end
}