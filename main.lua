Item = require "item"

local item_types = {
	COFFEE = {},
	MILK = {},
	CREAM = {},
	CUP = {}
}

local HAND_MIN_X = -384
local BUY_DRAWER_WIDTH = 90
local TABLE_HEIGHT = 400

local request_drink = true
local hand_x = HAND_MIN_X

local buy_drawer_x = BUY_DRAWER_WIDTH

local drawer_speed = 25
local hand_speed = 10

local items = {}
local grabbed_item = nil

function isBuyActive()
	return love.mouse.getX() > 680
end

function love.load()
	cup_empty_rsrc = love.graphics.newImage("assets/cup_empty.png")
	cup_full_rsrc = love.graphics.newImage("assets/cup_full.png")
	milk_rsrc = love.graphics.newImage("assets/milk.png")
	cream_rsrc = love.graphics.newImage("assets/cream.png")
	jug_full_rsrc = love.graphics.newImage("assets/coffee_jug_full.png")
	jug_empty_rsrc = love.graphics.newImage("assets/coffee_jug_empty.png")
	jug_pouring_rsrc = love.graphics.newImage("assets/coffee_jug_pouring.png")
	hand_rsrc = love.graphics.newImage("assets/hand.png")
	love.graphics.setNewFont(12)
	love.graphics.setBackgroundColor(.772,.647,.529)
end

function love.mousepressed(x, y, button, istouch)
	if button == 1 then
		if isBuyActive() then
			if grabbed_item ~= nil then
				grabbed_item = nil
			else
				if y > 50 and y < 50 + 64 then
					grabbed_item = Item(x, y, 0, item_types.CUP, cup_empty_rsrc)
				elseif y > 50 * 2 + 64 and y < 50 * 2 + 64 * 2 then
					grabbed_item = Item(x, y, 200, item_types.COFFEE, jug_full_rsrc)
				elseif y > 50 * 3 + 64 * 2 and y < 50 * 3 + 64 * 2 + 96 then
					grabbed_item = Item(x, y, 200, item_types.MILK, milk_rsrc)
				elseif y > 50 * 4 + 64 * 2 + 96 and y < 50 * 4 + 64 * 2 + 96 * 2 then
					grabbed_item = Item(x, y, 200, item_types.CREAM, cream_rsrc)
				end
			end
		else
			if grabbed_item ~= nil then
				table.insert(items, grabbed_item)
				grabbed_item = nil
			else
				local index_to_grab = 0
				for i, item in ipairs(items) do
					if x >= item.x and x <= item.x + item.rsrc:getWidth() and
						y >= item.y and y <= item.y + item.rsrc:getHeight() then
						index_to_grab = i
					end
				end
				grabbed_item = items[index_to_grab]
				table.remove(items, index_to_grab)
			end
		end
	end
end

function love.update(dt)
	local mouse_x = love.mouse.getX()
	if isBuyActive() then
		buy_drawer_x = math.max(buy_drawer_x - drawer_speed, 0)
	else
		buy_drawer_x = math.min(buy_drawer_x + drawer_speed, BUY_DRAWER_WIDTH)
	end
	if request_drink and hand_x < 0 then
		hand_x = math.min(hand_x + hand_speed, 0)
	elseif request_drink == false and hand_x > HAND_MIN_X then
		hand_x = math.max(hand_x - hand_speed, HAND_MIN_X)
	end

	if grabbed_item ~= nil then
		grabbed_item.x = love.mouse.getX() - grabbed_item.rsrc:getWidth() / 2
		grabbed_item.y = love.mouse.getY() - grabbed_item.rsrc:getHeight() / 2
	end

	for _, item in ipairs(items) do
		if item.y + 50 < TABLE_HEIGHT then
			item.v = item.v + 1
		else
			item.v = 0
		end
		item.y = item.y + item.v
	end
end

function love.draw()
	-- draw table
	love.graphics.setColor(0.282, 0.188, 0.157)
	love.graphics.rectangle("fill", 0, TABLE_HEIGHT, 800, 300, 10, 10)

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(hand_rsrc, hand_x, 150)
	love.graphics.draw(cup_empty_rsrc, 725 + buy_drawer_x, 50)
	love.graphics.draw(jug_full_rsrc, 710 + buy_drawer_x, 50 * 2 + 64)
	love.graphics.draw(milk_rsrc, 720 + buy_drawer_x, 50 * 3 + 64 * 2)
	love.graphics.draw(cream_rsrc, 720 + buy_drawer_x, 50 * 4 + 64 * 2 + 96)

	for _, item in ipairs(items) do
		love.graphics.draw(item.rsrc, item.x, item.y)
	end

	if grabbed_item ~= nil then
		love.graphics.draw(grabbed_item.rsrc, grabbed_item.x, grabbed_item.y)
	end
end
