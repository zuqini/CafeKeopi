Class = require 'modules.hump.class'

Item = Class{}

function Item:init(x, y, capacity, type, rsrc)
	self.x = x
	self.y = y
	self.v = 0
	self.capacity = capacity
	self.type = type
	self.rsrc = rsrc
end

function Item:pour()
	self.capacity = self.capacity - 1
	return self.type
end

return Item