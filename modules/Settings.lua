--- Retrieves and stores settings.
-- @module Settings

local module = {

	path = hs.configdir .. '/config/settings.json',

	get = function(self, key)
		local data = hs.json.decode(
			self:readFile()
		)

		if data == nil or data[key] == nil then
			return
		end

		return data[key]
	end,

	set = function(self, key, value) 
		if key == nil or value == nil then
			print('Key and value are required.')
			return false
		end

		local data = hs.json.decode(
			self:readFile()
		)

		if data == nil then
			print('Settings data is empty.')
			return false
		end

		data[key] = value

		return self:save(data)
	end,

	--- Read content of file for the current setting namespace
	readFile = function(self)
		local file = io.open(self.path, 'r')

		-- return nil if file doesn't exist
   		if file == nil then 
   			return 	
		end

		local content = file:read('*all')

		file:close()

		return content
	end,

	--- Encode data table and write to file
	save = function(self, data)
		local file = io.open(self.path, 'w')

		file:write(
			hs.json.encode(data)
		)

		file:close()

		return true
	end

}

return {
    --- Get a setting value.
    -- @param key   Setting key
    -- @return      Returns the setting value or null if it doesn't exist
	get = function(key)
		return module:get(key)
	end,

    --- Update a setting value.
    -- @param key   Setting key
    -- @param value Value to store
    -- @return      Returns true on success
	set = function(key, value) 
		return module:set(key, value)
	end
}