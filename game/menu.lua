function gameStates.menu.load()
  allowInput = true
  inputTimer = 0
  idleTimer = 0
  menu = {} --create a table to hold variables for the menu
  menu.state = false
  menu.timer = 0
  menu.keyDelay = 0
  menu.img_door = love.graphics.newImage('img/menu/door.png')
  menu.img_patch = love.graphics.newImage('img/menu/patch.png')
  menu.img_tori0 = love.graphics.newImage('img/menu/tori0.png')
  menu.img_tori1 = love.graphics.newImage('img/menu/tori1.png')
  menu.list = { {string, selected}, {string, selected} }
  menu.list[1].string = 'Start'
  menu.list[1].selected = true
  menu.list[1].goto = 'dream'
  menu.list[2].string = 'Quit'
  menu.list[2].selected = false
  menu.list[2].goto = 'quit'
  menu.select = 1
  menu.playing = false
  menu.fade = 0
  menu.bgm = love.audio.newSource('snd/mus_menu0.wav')
  menu.bgm:setLooping(false)
  function menu.quit()
    menu = {} --create a table to hold variables for the menu
    menu.state = nil
    menu.timer = nil
    menu.keyDelay = nil
    menu.img_tori0 = nil
    menu.img_tori1 = nil
    menu.list = { {string, selected}, {string, selected} }
    menu.list[1].string = nil
    menu.list[1].selected = nil
    menu.list[1].goto = nil
    menu.list[2].string = nil
    menu.list[2].selected = nil
    menu.list[2].goto = nil
    menu.select = nil
    menu.playing = nil
    menu.bgm = nil
    --allowInput = true
  end
  function menu.introTimout(gt)
    allowInput = false
    if menu.fade < 255 then
      menu.fade = menu.fade + 85 * gt
    end
    if menu.fade > 255 then menu.fade = 255 end
    if menu.fade == 255 then
      menu.quit()
      gameState = 'intro'
      love.load()
    end
  end
end


function gameStates.menu.draw()
  love.graphics.setScreen('top')
  love.graphics.setFont(fnt_main)
  love.graphics.setDepth(-1)
  love.graphics.setColor(255, 255, 255, 255)
  for i = 1, 2, 1 do
    if menu.list[i].selected then love.graphics.setColor(255, 255, 0, 255)
    else love.graphics.setColor(255, 255, 255, 255) end
    love.graphics.print(menu.list[i].string, 125 + (i - 1) * 90, 114)
  end
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.setScreen('top')
  love.graphics.setDepth(4)
  love.graphics.draw(menu.img_door, 149, 0)
  love.graphics.setDepth(2)
  love.graphics.draw(menu.img_patch, 121, 179)

  if menu.state == true then
    love.graphics.draw(menu.img_tori1, 173, 141)
  else
    love.graphics.draw(menu.img_tori0, 173, 141)
  end
  love.graphics.setDepth(1)
  love.graphics.setColor(255, 255, 255, 150)
  love.graphics.setFont(fnt_small)
  love.graphics.printf('LOVE ' .. version .. ' BY XAVYRR - UNDERTALE ASSETS (C) TOBY FOX', 0, love.graphics.getHeight()-10, love.graphics.getWidth(), 'center')
  love.graphics.setDepth(0)
  love.graphics.setColor(0, 0, 0, menu.fade)
  --black bars on sides of art to prevent 'bleeding off canvas'
  love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
end

function gameStates.menu.update(gt)
  if menu.playing == false then
    love.audio.stop()
    menu.playing = true
    menu.bgm:setLooping(true)
    menu.bgm:play()
  end
  if idleTimer >= 20 then menu.introTimout(gt)
  else
    menu.timer = menu.timer + gt
    if menu.keyDelay > 0 then
      menu.keyDelay = menu.keyDelay - gt
    elseif menu.keyDelay < 0 then
      menu.keyDelay = 0
    end
    if menu.timer >= 1.5 then
      menu.state = not menu.state
      menu.timer = 0
    end
    if menu.keyDelay == 0 then
      if allowInput then
        if love.keyboard.isDown("a") then
          menu.keyDelay = .5
          if menu.list[menu.select].goto == 'quit' then love.event.quit()
          else
            gameState = menu.list[menu.select].goto
            menu.quit()
            changeState()
          end
        end
        if love.keyboard.isDown("right") or love.keyboard.isDown("KEY_CPAD_RIGHT") then
          menu.keyDelay = .2
          menu.list[menu.select].selected = false
          menu.select = menu.select + 1
          if menu.select > 2 then menu.select = 1 end
          menu.list[menu.select].selected = true
        end
        if love.keyboard.isDown("left") or love.keyboard.isDown("KEY_CPAD_LEFT") then
          menu.keyDelay = .2
          menu.list[menu.select].selected = false
          menu.select = menu.select - 1
          if menu.select < 1 then menu.select = 2 end
          menu.list[menu.select].selected = true
        end
        --if love.keyboard.isDown("b") then
          --menu.keyDelay = .5
          --gameState = 'start'
          --love.audio.stop()
          --menu.quit()
          --changeState()
        --end
      end
    end
  end
end
