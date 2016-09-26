version = 'V0.10'--LOVE - BY XAVYRR
gameStates = {
	start = {load, draw, update},
	menu = {load, draw, update},
	core = {load, draw, update},
	intro = {load, draw, update},
	dream = {load, draw, update},
}
function changeState()
	love.audio.stop()
	love.load()
end
key = { -- states: 0 not active, 1 pressed this step, 2 held
	[1] = { state = 0, key = 'right',},
	[2] = { state = 0, key = 'up',},
	[3] = { state = 0, key = 'left',},
	[4] = { state = 0, key = 'down',},
	[5] = { state = 0, key = 'a',},
	[6] = { state = 0, key = 'b',},
	[7] = { state = 0, key = 'start',},
	[8] = { state = 0, key = 'select',},
	[9] = { state = 0, key = 'l',},
	[10] = { state = 0, key = 'r',},
}
function love.keyboard.checkStates()
	for i = 1, 10, 1 do
		if love.keyboard.isDown(key[i].key) then
			idleTimer = 0
			if key[i].state == 0 then key[i].state = 1
			else key[i].state = 2 end
		else  key[i].state = 0 end
	end
end
function love.keyboard.keyState(keyToCheck)
	for i = 1, 10, 1 do
		if key[i].key == keyToCheck then
			return key[i].state
		end
	end
end


gameState = 'start'
require('start')
require('menu')
require('dream')
--require('flowey')
require('core')
require('intro')
fnt_main = love.graphics.newFont('data/fnt_main.ttf', 16)
--fnt_main_mono = love.graphics.newFont('data/fnt_main_mono.otf', 16)
fnt_small = love.graphics.newFont('data/fnt_small.ttf', 8)
img_select = love.graphics.newImage('img/menu/soul_small.png')
img_flower = love.graphics.newImage('img/dream/flower.png')
snd_menu = love.audio.newSource('snd/snd_menu.wav')
gt = 0 --gt is a substitute for dt, which only counts while in game, and not when the game is paused like when using the home menu. Prevents timer issues.
idleTimer = 0 -- value that keeps track how much time has passed since the last keypress.
allowInput = true
love.graphics.set3D(true)
math.randomseed(os.time())
function math.sign(x)
	return x>0 and 1 or x<0 and -1 or 0
end
function love.load()
	love.audio.stop()
	gameStates[gameState].load()
end

function love.draw()
	gameStates[gameState].draw()
	love.graphics.setScreen('bottom')
	if love.mouse.isDown(0) then love.graphics.setColor(255, 255, 255, 10)
	else love.graphics.setColor(255, 255, 255, 5) end
	love.graphics.rectangle('fill', 0, 0, 320, 240)
	love.graphics.setFont(fnt_small)
	love.graphics.setDepth(0)
	love.graphics.draw(img_flower, 98, 59)
end

function love.update(dt)
	if dt >= 1 then gt = 0.000001
	else gt = dt end-- gt can only increase once per tick WHILE the game is running and NOT in a paused state, unlike dt.
	idleTimer = idleTimer	+ gt
	love.keyboard.checkStates()
	gameStates[gameState].update(gt)
	if love.keyboard.isDown('select') then love.quit() end
end

function love.quit()
	love.audio.stop()
end
