local Bullet = {}
local bulletImg = love.graphics.newImage('assets/bullet.png')

function Bullet:create(x, y, spd)
	self.__index = self
	return setmetatable({
		img = bulletImg,
		x = x - bulletImg:getWidth()/2,
		y = y,
		speed = spd
	}, self)
end

function Bullet:update(dt)
	self.y = self.y - (self.speed * dt)
end

function Bullet:canDespawn()
	return self.y < (0 - self.img:getHeight())
end

function Bullet:draw()
	love.graphics.draw(self.img, self.x, self.y)
end

return Bullet