local Player = {} -- { x = 200, y = 710, speed = 150, img = nil}
local playerImage = love.graphics.newImage('assets/plane.png')

local Bullet = require "Bullet"

function Player:create (x, y, spd)
	self.__index = self
	return setmetatable({
		img = playerImage,
		x = x,
		y = y,
		speed = spd
	}, self)
end

function Player:draw ()
	love.graphics.draw(self.img, self.x, self.y)
end

function Player:update (dt)
	if love.keyboard.isDown('left', 'a') then
		if self.x > 0 then
			self.x = self.x - (self.speed * dt)
		end
	elseif love.keyboard.isDown('right', 'd') then
		if self.x < (love.graphics.getWidth() - self.img:getWidth()) then
			self.x = self.x + (self.speed * dt)
		end
	end
end

function Player:shoot()
	return Bullet:create(
		self.x + (self.img:getWidth()/2),
		self.y,
		250)
end

return Player

--[[
function player.load()
end

function player.update(dt)
	movePlayer(dt)
end

function player.draw()
end


function movePlayer(dt)
	-- move
	if love.keyboard.isDown('left', 'a') then
		if player.x > 0 then
			player.x = player.x - (player.speed * dt)
		end
	elseif love.keyboard.isDown('right', 'd') then
		if player.x < (love.graphics.getWidth() - player.img:getWidth()) then
			player.x = player.x + (player.speed * dt)
		end
	end
end

return player
]]