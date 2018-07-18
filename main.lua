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

local money = 10

local request_drink = true
local request_content = { milk = 0, cream = 0, coffee = 0 }
local hand_x = HAND_MIN_X

local buy_drawer_x = BUY_DRAWER_WIDTH

local drawer_speed = 25
local hand_speed = 10

local items = {}
local grabbed_item = nil

function isBuyActive()
	return love.mouse.getX() > 680
end

function generateRequest()
	request_content.coffee = math.random(100)
	request_content.milk = math.random(100 - request_content.coffee)
	request_content.cream = 100 - request_content.coffee - request_content.milk
end

function pour(to)
	if to.amount < to.capacity and grabbed_item.amount > 0 then
		grabbed_item.is_pouring = true
		grabbed_item.amount = grabbed_item.amount - 1
		to.amount = math.min(to.amount + 1, to.capacity)
		if grabbed_item.type == item_types.COFFEE then
			to.content.coffee = to.content.coffee + 1
		elseif grabbed_item.type == item_types.MILK then
			to.content.milk = to.content.milk + 1
		elseif grabbed_item.type == item_types.CREAM then
			to.content.cream = to.content.cream + 1
		end
		if to.amount == to.capacity then
			to.rsrc = cup_full_rsrc
		end
	end
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
	font = love.graphics.newImageFont("assets/font.png",
    " abcdefghijklmnopqrstuvwxyz" ..
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
    "123456789.,!?-+/():;%&`'*#=[]\"")
    love.graphics.setFont(font)
	--love.graphics.setNewFont(12)
	love.graphics.setBackgroundColor(.772,.647,.529)
	generateRequest()
end

function love.mousepressed(x, y, button, istouch)
	if button == 1 then
		if isBuyActive() then
			if grabbed_item ~= nil then
				grabbed_item = nil
			else
				if y > 50 and y < 50 + 64 then
					grabbed_item = Item(x, y, 100, 0, item_types.CUP, cup_empty_rsrc)
				elseif y > 50 * 2 + 64 and y < 50 * 2 + 64 * 2 then
					grabbed_item = Item(x, y, 300, 300, item_types.COFFEE, jug_full_rsrc)
				elseif y > 50 * 3 + 64 * 2 and y < 50 * 3 + 64 * 2 + 96 then
					grabbed_item = Item(x, y, 100, 100, item_types.MILK, milk_rsrc)
				elseif y > 50 * 4 + 64 * 2 + 96 and y < 50 * 4 + 64 * 2 + 96 * 2 then
					grabbed_item = Item(x, y, 100, 100, item_types.CREAM, cream_rsrc)
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
		grabbed_item.is_pouring = false
	end

	local item_to_remove = 0
	for i, item in ipairs(items) do
		if item.y + 50 < TABLE_HEIGHT then
			item.v = item.v + 1
		else
			item.v = 0
			if grabbed_item ~= nil and grabbed_item.type ~= item_types.CUP and
					item.type == item_types.CUP then
				if grabbed_item.x > item.x and grabbed_item.x < item.x + item.rsrc:getWidth() and
						grabbed_item.y < item.y and grabbed_item.y > item.y - 30 then
					pour(item)
				end
			end
		end
		item.y = item.y + item.v

		if request_drink and item.type == item_types.CUP and item.amount == 100 and
				item.x > 200 and item.x < 382 and
				item.y + item.rsrc:getHeight() > 150 and
				item.y + item.rsrc:getHeight() < 245 then
			request_drink = false
			item_to_remove = i
		end
	end
	if item_to_remove > 0 then
		table.remove(items, item_to_remove)
	end

	if grabbed_item ~= nil and grabbed_item.is_pouring then
		grabbed_item.r = math.max(grabbed_item.r - 0.2, - math.pi / 2)
		if grabbed_item.type == item_types.COFFEE then
			grabbed_item.rsrc = jug_pouring_rsrc
		end
	elseif grabbed_item ~= nil and not grabbed_item.is_pouring then
		grabbed_item.r = math.min(grabbed_item.r + 0.2, 0)
		if grabbed_item.type == item_types.COFFEE then
			if grabbed_item.amount > 0 and grabbed_item.type == item_types.COFFEE then
				grabbed_item.rsrc = jug_full_rsrc
			else
				grabbed_item.rsrc = jug_empty_rsrc
			end
		end
	end

	if not request_drink and hand_x == HAND_MIN_X then
		request_drink = true
		generateRequest()
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

	--love.graphics.setNewFont(16)
	love.graphics.setColor(0.8, 0, 0)
	love.graphics.print("1", 740 + buy_drawer_x, 50 + 64 + 12)
	love.graphics.print("5", 740 + buy_drawer_x, 50 * 2 + 64 * 2 + 12)
	love.graphics.print("3", 740 + buy_drawer_x, 50 * 3 + 64 * 2 + 96 + 12)
	love.graphics.print("3", 740 + buy_drawer_x, 50 * 4 + 64 * 2 + 96 * 2 + 12)

	--love.graphics.setNewFont(36)
	love.graphics.setColor(0, 0.9, 0)
	love.graphics.print(money, 20, 20)
	--love.graphics.setNewFont(24)
	love.graphics.setColor(1, 1, 1)
	love.graphics.print("GIMME " .. request_content.coffee .. "% COFFEE, " .. request_content.milk .. "% MILK, AND " .. request_content.cream .. "% CREAM!",
		20, 75)

	--love.graphics.setNewFont(12)
	for _, item in ipairs(items) do
		love.graphics.draw(item.rsrc, item.x, item.y)
		love.graphics.print(item.amount, item.x, item.y + item.rsrc:getHeight())
	end

	-- love.graphics.print(love.mouse:getX() .. " " .. love.mouse:getY(), 0 ,0)

	if grabbed_item ~= nil then
		love.graphics.draw(grabbed_item.rsrc, grabbed_item.x, grabbed_item.y, grabbed_item.r)
	end
end
