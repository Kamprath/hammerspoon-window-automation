local Settings = {

	path = '../config',

	data = nil,

	--- The settings namespace, set on initialization
	namespace = nil,

	--- Initialize the module
	init = function(self, namespace) 
		self.namespace = namespace

		-- get data from config file
		self.data = hs.json.decode(
			self:readFile()
		)

		-- return nil if data file doesn't exist, otherwise return the data
		if self.data == nil then
			return nil
		end

		-- return a function that retrieves or sets a value
		return self.handle
	end,

	-- Retrieve or set a specific value of the data table
	handle = function(self, key, value)
		if value == nil then
			return self:get(key)
		else
			return self:set(key, value)
		end
	end,

	--- Return a specific property of the data table
	get = function(self, property)
		return self.data[property]
	end,

	--- Return the data table
	all = function(self)
		return self.data
	end,

	--- Set a specific property of the data table and save
	set = function(self, property, value)
		self.data[property] = value

		return self:save()
	end,

	--- Read content of file for the current setting namespace
	readFile = function(self)
		local file = io.open(self.path .. '/' .. self.namespace ,"r")

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
		local file = io.open(self.path .. '/' .. self.namespace, 'w')

		file:write(
			hs.json.encode(self.data)
		)

		file:close

		return true
	end

}

-- Return a function that returns the instantiated module
return function(namespace)
	return Settings:init(namespace)
end