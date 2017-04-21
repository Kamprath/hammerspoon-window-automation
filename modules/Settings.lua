local module = {

	dir = hs.configdir .. '/config',

	path = nil,

	data = nil,

	--- The settings namespace, set on initialization
	namespace = nil,

	--- Instantiate the module
	new = function(self, namespace) 
		self.namespace = namespace
		self.path = self.dir .. '/' .. self.namespace .. '.json'

		-- get data from config file
		self.data = hs.json.decode(
			self:readFile()
		)

		-- return nil if data file doesn't exist, otherwise return the data
		if self.data == nil then
			return nil
		end

		-- return the module
		return self
	end,

	--- Return a specific property of the data table
	get = function(self, property)
		return self.data[property]
	end,

	--- Set a specific property of the data table and save
	set = function(self, property, value)
		self.data[property] = value

		return self:save()
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
	save = function(self)
		local file = io.open(self.path, 'w')

		file:write(
			hs.json.encode(self.data)
		)

		file:close()

		return true
	end

}

return function(namespace)
	local settings = module:new(namespace)

	return function(key, value)
		if value == nil then
			return settings:get(key)
		else
			return settings:set(key, value)
		end
	end
end