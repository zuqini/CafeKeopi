buy_bar_active = false

request_drink = true
HAND_MIN_X = -384
hand_x = HAND_MIN_X

BUY_DRAWER_WIDTH = 90
buy_drawer_x = BUY_DRAWER_WIDTH

drawer_speed = 25
hand_speed = 30

function isBuyActive()
	return love.mouse.getX() > 680
end

function love.load()
	cup_empty_src = love.graphics.newImage("assets/cup_empty.png")
	cup_full_src = love.graphics.newImage("assets/cup_full.png")
	milk_src = love.graphics.newImage("assets/milk.png")
	cream_src = love.graphics.newImage("assets/cream.png")
	jug_full_src = love.graphics.newImage("assets/coffee_jug_full.png")
	jug_empty_src = love.graphics.newImage("assets/coffee_jug_empty.png")
	jug_pouring_src = love.graphics.newImage("assets/coffee_jug_pouring.png")
	hand_src = love.graphics.newImage("assets/hand.png")
	love.graphics.setNewFont(12)
	love.graphics.setBackgroundColor(.772,.647,.529)
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
end

function love.draw()
	-- draw table
	love.graphics.setColor(0.282, 0.188, 0.157)
	love.graphics.rectangle("fill", 0, 400, 800, 300, 10, 10)

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(hand_src, hand_x, 150)
	love.graphics.draw(cup_empty_src, 725 + buy_drawer_x, 50)
	love.graphics.draw(jug_full_src, 710 + buy_drawer_x, 50 * 2 + 64)
	love.graphics.draw(milk_src, 720 + buy_drawer_x, 50 * 3 + 64 * 2)
	love.graphics.draw(cream_src, 720 + buy_drawer_x, 50 * 4 + 64 * 2 + 96)
end
