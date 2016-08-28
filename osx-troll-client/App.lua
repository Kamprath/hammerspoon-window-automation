dofile 'osx-troll-client/Defender.lua'

App = {
	Defender = nil,

	init = function(self)
		-- Initialize components
		self.Defender = Defender:init()
	end
}