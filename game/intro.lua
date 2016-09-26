function gameStates.intro.load()
  allowInput = true
  love.graphics.setScreen('top')
  intro = {}
  intro.x = 100
  intro.y = 25
  fnt_mono = love.graphics.newFont('data/fnt_main_mono.oft', 16)
  intro.art = {
    [0] = {
      [1] = nil,
      [2] = love.graphics.newImage('img/intro/intro_0+2.png')
    },
    [1] = {
      [0] = love.graphics.newImage('img/intro/intro_1.png'),
      [1] = love.graphics.newImage('img/intro/intro_1+1.png'),
      [2] = love.graphics.newImage('img/intro/intro_1+2.png'),
    },
    [2] = {
      [-4] = love.graphics.newImage('img/intro/intro_2-4.png'),
      [-3] = love.graphics.newImage('img/intro/intro_2-3.png'),
      [-2] = love.graphics.newImage('img/intro/intro_2-2.png'),
      [-1] = love.graphics.newImage('img/intro/intro_2-1.png'),
      [0] = love.graphics.newImage('img/intro/intro_2.png'),
    },
    [3] = {
      [0] = love.graphics.newImage('img/intro/intro_3.png'),
    },
    [4] = {
      [0] = nil
    },
    [5] = {
      [-4] = love.graphics.newImage('img/intro/intro_5-4.png'),
      [-1] = love.graphics.newImage('img/intro/intro_5-1.png'),
      [0] = love.graphics.newImage('img/intro/intro_5.png'),
    },
    [6] = {
      [0] = love.graphics.newImage('img/intro/intro_6.png'),
    },
    [7] = {
      [-3] = love.graphics.newImage('img/intro/intro_7-3.png'),
      [-2] = love.graphics.newImage('img/intro/intro_7-2.png'),
      [0] = love.graphics.newImage('img/intro/intro_7.png'),
      [2] = love.graphics.newImage('img/intro/intro_7+2.png'),
      [3] = love.graphics.newImage('img/intro/intro_7+3.png'),
    },
    [8] = {
      [0] = love.graphics.newImage('img/intro/intro_8.png'),
    },
    [9] = {
      [0] = love.graphics.newImage('img/intro/intro_9.png'),
    },

    pos = {
      [0] = { [1] = { x = nil, y = nil }, [2] = { x = 35, y = 13 } },
      [1] = {
        [0] = {x = 0, y = 0},
        [1] = {x = -2, y = 31},
        [2] = {x = 18, y = 1},
      },
      [2] = {
        [-4] = {x = -8, y = 0},
        [-3] = {x = -6, y = 5},
        [-2] = {x = -4, y = 26},
        [-1] = {x = -3, y = 33},
        [0] = {x = 0, y = 64},
      },
      [3] = {
        [0] = {x = 0, y = 0},
      },
      [4] = nil,
      [5] = {
        [-4] = {x = -5, y = 0},
        [-1] = {x = -2, y = 71},
        [0] = {x = 53, y = 68},
      },
      [6] = {
        [0] = {x = 0, y = 0},
      },
      [7] = {
        [-3] = {x = 0, y = 38},
        [-2] = {x = 0, y = 0},
        [0] = {x = 0, y = 45},
        [2] = {x = 48, y = 0},
        [3] = {x = 15, y = 42},
      },
      [8] = {
        [0] = {x = 0, y = 0},
      },
      [9] = {
        [0] = {x = 0, y = 0},
      },
    },
  }


  nbsp = '\160'
  intro.string = {
    [0] = ('Long ago, two races ' .. nbsp:rep(2) .. ' ruled over Earth: ' .. nbsp:rep(4) .. ' HUMANS and MONSTERS.'),
    [1] = ('One day, war broke ' .. nbsp:rep(3) .. ' out between the two ' .. nbsp:rep(2) .. ' races.'),
    [2] = ('After a long battle, ' .. nbsp .. ' the humans were ' .. nbsp:rep(6) .. ' victorious.'),
    [3] = ('They sealed the ' .. nbsp:rep(6) .. ' monsters undergound ' .. nbsp:rep(2) .. ' with a magic spell.'),
    [4] = ('Many years later...'),
    [5] = (nbsp:rep(6) .. ' MT. EBOTT ' .. nbsp:rep(5) .. ' ' .. nbsp:rep(8) .. ' 201X' ),
    [6] = ('Legends say that those who climb the mountain never return.'),
    [7] = (' '),
    [8] = (' '),
    [9] = (' '),
  }
  intro.state = 0
  intro.timer = -4
  intro.curLen = 0
  intro.fade = 255
  intro.textSound = love.audio.newSource('snd/snd_text.wav')
  len = 0
  intro.pause = false
  function intro.doString(gt)
    len = string.len(intro.string[intro.state])
    if string.sub(intro.string[intro.state], intro.curLen, intro.curLen) == '%'  or string.sub(intro.string[intro.state], intro.curLen, intro.curLen) == '\160'then intro.curLen = intro.curLen + 1 end
    if string.sub(intro.string[intro.state], intro.curLen, intro.curLen) == ','  or string.sub(intro.string[intro.state], intro.curLen, intro.curLen) == ':'then intro.timer = intro.timer - (gt / 1.10) end
    if string.sub(intro.string[intro.state], intro.curLen, intro.curLen + 1) == '..' then intro.timer = intro.timer - (gt / 1.05) end
    if intro.timer > .05 and intro.curLen < len then
      intro.curLen = intro.curLen + 1
      intro.timer = 0
      if string.sub(intro.string[intro.state], intro.curLen, intro.curLen) ~= ' ' then
        intro.textSound:play()
      end
    end
    if intro.timer > 4 then
      intro.curLen = 0
      intro.state = intro.state + 1
      if intro.state < 7 then intro.textSound:play() end
      intro.timer = -4
    end
  end
  function intro.drawArt()
    love.graphics.setScreen('top')
    for i = -4, 4, 1 do
      if intro.art[intro.state][i] ~= nil then --draw art if it exists
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.setDepth(-i)
        love.graphics.draw(intro.art[intro.state][i], intro.art.pos[intro.state][i].x + intro.x, intro.art.pos[intro.state][i].y + intro.y)
      elseif i == 0 and intro.state ~= 4 then --bg draw when there is no art
        love.graphics.setDepth(0)
        love.graphics.setColor(192, 130, 38, 255)
        love.graphics.rectangle('fill', 100, 25, 200, 110)
      end
    end
    love.graphics.setDepth(0)
    love.graphics.setColor(0, 0, 0, 255)
    --black bars on sides of art to prevent 'bleeding off canvas'
    love.graphics.rectangle('fill', 0, 25, 100, 110)
    love.graphics.rectangle('fill', 300, 25, 100, 110)
    --art fading by drawing over art
    love.graphics.setColor(0, 0, 0, intro.fade)
    love.graphics.rectangle('fill', 90, 15, 210, 120)
    love.graphics.setColor(255, 255, 255, 255)
  end
  function intro.drawString()
    love.graphics.setScreen('top')
    love.graphics.setDepth(-1)
    love.graphics.setColor(255, 255, 255, 255)
    if intro.string[intro.state] ~= nil then
      love.graphics.printf(string.sub(intro.string[intro.state], 1, intro.curLen) .. ' ' .. nbsp:rep(len - intro.curLen), 99, 150, 202, 'left')
    end
  end
  function intro.quit()
    love.audio.stop()
    love.load()
  end
end

function gameStates.intro.draw()
  --love.graphics.setBackgroundColor(0, 0, 0)
  love.graphics.setFont(fnt_mono)
  --love.graphics.print('fade=' .. intro.fade .. 'timer=' .. intro.timer, 5, 10)
  intro.drawArt()
  intro.drawString()
  love.graphics.setScreen('bottom')
  love.graphics.setDepth(0)
  love.graphics.setColor(255, 255, 255, 100)
  love.graphics.printf('-Press (A) to pause/unpause-', 0, 60, love.graphics.getWidth(), 'center')
  if intro.pause then
    love.graphics.setColor(255, 255, 255, 60)
    love.graphics.printf('PAUSED', 0, love.graphics.getHeight()/2, love.graphics.getWidth(), 'center')
  end
end

function gameStates.intro.update(gt)
  if not intro.pause then
    intro.timer = intro.timer + gt
    if intro.timer < 0 and intro.timer > -3 and intro.fade > 0 then
      intro.fade = intro.fade - gt * 255
    end
    if intro.fade < 0 then intro.fade = 0 end
    if intro.timer > 3 and intro.fade < 255 then
      intro.fade = intro.fade + gt * 255
    end
    if intro.fade > 255 then intro.fade = 255 end
    intro.doString(gt)
  end
  if love.keyboard.keyState('a') == 1  then
    intro.pause = not(intro.pause)
  end
  if intro.state > 9 or love.keyboard.isDown('start') then
    love.audio.stop()
    gameState = 'start'
    intro.quit()
  end
end
