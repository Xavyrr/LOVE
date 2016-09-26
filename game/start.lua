function gameStates.start.load()
  start = {}
  start.timer = -3
  start.state = 0
  start.image0 = love.graphics.newImage('img/start/start0.png')
  start.image1 = love.graphics.newImage('img/start/start1.png')
  start.image2 = love.graphics.newImage('img/start/start2.png')
  start.image3 = love.graphics.newImage('img/start/start3.png')
  start.noise = love.audio.newSource('snd/snd_intronoise.wav')
  start.noise:setLooping(false)
end

function gameStates.start.draw()
  love.graphics.setScreen('top')
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.setDepth(0)
  if start.state == 1 then
    love.graphics.draw(start.image0, 0, 0)
    love.graphics.setDepth(-2)
    love.graphics.draw(start.image1, 0, 0)
  elseif start.state == 2 then
    love.graphics.draw(start.image2, 0, 0)
    love.graphics.setDepth(-2)
    love.graphics.draw(start.image3, 0, 0)
  end
end

function gameStates.start.update(gt)
  start.timer = start.timer + gt
  if start.timer >= 0 and start.state == 0 then
    start.state = 1
    start.noise:play()
  elseif start.timer >= 5 and start.state == 1 then
    start.state = start.state + 1
    start.depth = 0
    start.noise:play()
  elseif start.timer >= 10 and start.state == 2 then
    start.state = start.state + 1
    start.depth = 0
    start.noise:play()
  elseif start.timer >= 13 and start.state == 3 then
    gameState = 'menu'
    start.noise = nil
    love.load()
  elseif love.keyboard.isDown("a") then
    gameState = 'menu'
    love.audio.stop()
    love.load()
  end
end
