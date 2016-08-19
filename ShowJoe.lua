ShowJoe = {
	showingJoe = false,
	delay = .1,

	init = function(self)
		hs.hotkey.bind({'alt', 'shift'}, 'j', function()
			if (self.showingJoe) then
				self.showingJoe = false
			else
				self.showingJoe = true

				hs.timer.doUntil(function()
					return not self.showingJoe
				end, self.showJoe, self.delay)
			end
		end)
	end,

	showJoe = function()
		local img = hs.image.imageFromPath('/Users/johnny.kamprath/Pictures/joe_militia.png')
		local num = math.random(100, 900)
		
		local position = {
			x = math.random(-3000, 2500),
			y = math.random(-200, 1800)
		}

		-- randomly position them on the screen
		local drawing = hs.drawing.image(hs.geometry.rect({position.x, position.y, num, num}), img)

		drawing:setSize({h=num, w=num})
		drawing:rotateImage(math.random(1, 360))
		drawing:show()
	end
}