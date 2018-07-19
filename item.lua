Class = require 'modules.hump.class'

Item = Class{}

function Item:init(x, y, capacity, amount, type, rsrc)
	self.x = x
	self.y = y
	self.v = 0
	self.r = 0
	self.capacity = capacity
	self.amount = amount
	self.content = { milk = 0, cream = 0, coffee = 0 }
	self.type = type
	self.rsrc = rsrc
end

return Item
