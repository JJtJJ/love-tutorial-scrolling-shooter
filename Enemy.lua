local Enemy = {}
local enemyImg = love.graphics.newImage('assets/enemy.png')

function Enemy:create(x, y, spd, img)
	self.__index = self
	return setmetatable({
		img = img or enemyImg,
		x = x,
		y = y,
		speed = spd
	}, self)
end

function Enemy:update(dt)
	self.y = self.y + self.speed * dt
end

function Enemy:canDespawn()
	return self.y > love.graphics.getHeight()
end

return Enemy