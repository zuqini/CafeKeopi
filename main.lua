buy_bar_active = false

function love.load()
	cup_empty_src = love.graphics.newImage("assets/cup_empty.png")
	cup_full_src = love.graphics.newImage("assets/cup_full.png")
	milk_src = love.graphics.newImage("assets/milk.png")
	cream_src = love.graphics.newImage("assets/cream.png")
	jug_full_src = love.graphics.newImage("assets/coffee_jug_full.png")
	jug_empty_src = love.graphics.newImage("assets/coffee_jug_empty.png")
	jug_pouring_src = love.graphics.newImage("assets/coffee_jug_pouring.png")
	love.graphics.setNewFont(12)
	love.graphics.setBackgroundColor(.772,.647,.529)
end

function love.update(dt)
	local mouse_x = love.mouse.getX()
	if love.mouse.getX() > 680 then
		buy_bar_active = true
	else
		buy_bar_active = false
	end
end

function love.draw()
	love.graphics.setColor(1, 1, 1, 1)
	if buy_bar_active then
		love.graphics.draw(cup_empty_src, 725, 50)
		love.graphics.draw(jug_full_src, 710, 50 * 2 + 64)
		love.graphics.draw(milk_src, 720, 50 * 3 + 64 * 2)
		love.graphics.draw(cream_src, 720, 50 * 4 + 64 * 2 + 96)
	end
	-- draw table
	love.graphics.setColor(0.282, 0.188, 0.157)
	love.graphics.rectangle("fill", 200, 520, 400, 20, 10, 10)
	love.graphics.rectangle("fill", 300, 530, 20, 100, 10, 10)
	love.graphics.rectangle("fill", 500, 530, 20, 100, 10, 10)
end
