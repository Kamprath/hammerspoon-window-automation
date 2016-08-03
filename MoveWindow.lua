MoveWindow = {
	--- Move the active window
	-- @param x 		Pixels to move the window horizontally
	-- @param y 		Pixels to move the window vertically
	-- @param increase	(Optional) If true, increase axes values
	moveWindow = function(this, x, y, increase)
		if increase == nil then 
			increase = false 
		end

		local win = hs.window.focusedWindow()
		local f = win:frame()

		if increase then
			f.x = f.x + x
			f.y = f.y + y
		else
			f.x = f.x - x
			f.y = f.y - y
		end

		win:setFrame(f)
	end,

	--- Bind a key so that it moves the active window
	-- @param key 		A letter key to bind. The key is used in combination with alt and shift.
	-- @param x 		Pixels to move the window horizontally
	-- @param y 		Pixels to move the window vertically
	-- @param increase	(Optional) If true, increase axes values by x and y, otherwise decreases
	bindButton = function(this, key, x, y, increase)
		local modifiers = {'alt', 'shift'}

		hs.hotkey.bind(modifiers, key, function()
			this:moveWindow(x, y, increase)
		end)
	end,

	--- Bind keys in a table to moveWindow 
	-- @param binds 	A table whose keys indicate a keyboard key and whose values are tables containing
	--					an X value, Y value, and a boolean indicating whether to increase window position
	--					by X and Y values
	bind = function(this, binds)
		for key, val in pairs(binds) do
	        this:bindButton(key, val[1], val[2], val[3])
	    end
	end
}