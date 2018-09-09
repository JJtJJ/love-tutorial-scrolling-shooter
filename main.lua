debug = true

local Player = require "Player"
local Enemy = require "Enemy"

local player = Player:create(200, 710, 250)

isAlive = true
score = 0

canShoot = true
canShootTimerMax = 0.2
canShootTimer = canShootTimerMax

bulletImg = nil
bulletSpeed = 250
bullets = {}

createEnemyTimerMax = 0.4
createEnemyTimer = createEnemyTimerMax

enemyImg = nil
enemyDefSpeed = 200
enemies = {}

audGunshot = nil
audMusic = nil
muted = false

-- Collision detection taken function from http://love2d.org/wiki/BoundingBox.lua
-- Returns true if two boxes overlap, false if they don't
-- x1,y1 are the left-top coords of the first box, while w1,h1 are its width and height
-- x2,y2,w2 & h2 are the same, but for the second box
function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

function love.load(arg)
	enemyImg = love.graphics.newImage('assets/enemy.png')
	audGunshot = love.audio.newSource('assets/gun-sound.wav', 'static')
	audMusic = love.audio.newSource('assets/cloudkicker_beacons_2.mp3', 'stream')
	audMusic:play()
	toggleMute()
end

function love.update(dt)
	-- exit game
	if love.keyboard.isDown('escape') then
		love.event.push('quit')
	end

	player:update(dt)

	-- 
	canShootTimer = canShootTimer - dt
	if canShootTimer < 0 then
		canShoot = true
	end

	if love.keyboard.isDown('space', 'rctrl', 'lctrl') and canShoot then
		newBullet = player:shoot()
		table.insert(bullets, newBullet)
		audGunshot:play()
		canShoot = false
		canShootTimer = canShootTimerMax
	end

	for i, bullet in ipairs(bullets) do
		bullet:update(dt)
		if bullet:canDespawn() then
			table.remove(bullets, i)
		end
	end

	createEnemyTimer = createEnemyTimer - dt
	if createEnemyTimer < 0 then
		createEnemyTimer = createEnemyTimerMax

		randomNum = math.random(10, love.graphics.getWidth() - enemyImg:getWidth() - 10)
		newEnemy = Enemy:create(randomNum, -enemyImg:getHeight(), enemyDefSpeed, enemyImg)
		table.insert(enemies, newEnemy)
	end

	for i, enemy in ipairs(enemies) do
		enemy:update(dt)
		if enemy:canDespawn() then
			table.remove(enemies, i)
		end
	end

	for i, enemy in ipairs(enemies) do
		for j, bullet in ipairs(bullets) do
			if CheckCollision(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), bullet.x, bullet.y, bullet.img:getWidth(), bullet.img:getHeight()) then
				table.remove(bullets, j)
				table.remove(enemies, i)
				score = score + 1
			end
		end

		if CheckCollision(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), player.x, player.y, player.img:getWidth(), player.img:getHeight()) 
		and isAlive then
			table.remove(enemies, i)
			isAlive = false
		end
	end

end

function love.keypressed(key)
	if key == 'm' then
		toggleMute()
	end
	if key == 'r' and not isAlive then
		restart()
	end
end

function restart()
	bullets = {}
	enemies = {}
	canShootTimer = canShootTimerMax
	createEnemyTimer = createEnemyTimerMax
	player = Player:create(50, 710, 250)
	score = 0
	isAlive = true
end

function toggleMute()
	muted = not muted
	if muted then
		audGunshot:setVolume(0)
		audMusic:setVolume(0)
	else
		audGunshot:setVolume(1)
		audMusic:setVolume(1)
	end
end

function love.draw(dt)
	love.graphics.print("enemies "..table.getn(enemies), 10, 30)
	love.graphics.print("bullets "..table.getn(bullets), 10, 50)
	if isAlive then
		player:draw()
	else
		love.graphics.print("Press 'R' to restart", love.graphics:getWidth()/2-50, love.graphics:getHeight()/2-10)
	end

	for _, bullet in ipairs(bullets) do
		bullet:draw()
	end

	for _, enemy in ipairs(enemies) do
		love.graphics.draw(enemy.img, enemy.x, enemy.y)
	end

	love.graphics.print("Score: " .. score, 10, 10)
end