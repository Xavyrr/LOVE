function gameStates.core.load()
  love.graphics.setScreen('top')
  core = {} --create a table to hold variables for the core
  core.state = 0
  core.image = love.graphics.newImage('img/core/core.png') --load the core img
  core.x = (love.graphics.getWidth() / 2) - (core.image:getWidth() / 2) --center the core
  core.y = 2
  core.opacity = 255
  core.fade = 0
  function core.quit()
    love.audio.stop()
    --core.bgm = nil
    love.load()
  end
  cliff = {}
  cliff.image = love.graphics.newImage('img/core/cliff.png')
  cliff.x = 0
  cliff.y = love.graphics.getHeight() - cliff.image:getHeight()
  frisk = {}
  frisk.image = love.graphics.newImage('img/core/frisk.png')
  frisk.x = love.graphics.getWidth() - 144
  frisk.y = cliff.y - 10
  --core.bgm = love.audio.newSource('snd/mus_anothermedium.wav') --load the bgm
  --core.bgm:setLooping(true)
  --core.bgm:play()
end

function gameStates.core.draw()
  love.graphics.setBackgroundColor(0, 0, 0)
  if core.state == 1 then
  	love.graphics.setScreen('top')
  	love.graphics.setColor(255, 255, 255, core.opacity)
  	love.graphics.setDepth(4)
  	love.graphics.draw(core.image, core.x, core.y)

  	love.graphics.setColor(255, 255, 255, 255)
  	love.graphics.setDepth(1.5)
  	love.graphics.draw(cliff.image, cliff.x, cliff.y)

  	love.graphics.setDepth(1)
  	love.graphics.draw(frisk.image, frisk.x, frisk.y)
  end
end

function gameStates.core.update(gt)
  if core.state == 1 then
    core.fade = core.fade + gt
  	core.opacity = 170 + 85 * math.sin(0.5 * core.fade)
  else
    core.state = 1
  end
  if love.keyboard.isDown("b") then
    gameState = 'menu'
    love.audio.stop()
    core.quit()
  end
end
