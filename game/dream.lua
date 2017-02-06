function gameStates.dream.load()
  mkey = {[0] = nil, [1] = nil,}
  dream = {
    -- states = {'sleep', 'normal', 'warp', 'pause', 'interact',}, -- this table/array has no use.
    state = 'normal',
    curRoom = 0,
    fade = 0,
    frameTimer = 0,
    warp = { goto = 0, spawn = 0, transition = false, },
    pause = {
      select = 0,
      [0] = {name = 'ITEM',
        submenu = { selected = false,
          type = 'msg',
          msg = '* Besides an old phone, your pockets are empty.',
        },
      },
      [1] = {name = 'STAT',
        submenu = { selected = false, x = 10, y = 50, w =
          type = 'window',
          content = {
            [0] = { x = 10, y = 10,
            text = 'Frisk'
            }
          }
        },
      },
      [2] = {name = 'CELL',
        submenu = { selected = false,
          type = 'msg',
          msg = '* Looks like the battery is dead.',
        },
      },
    },
    },
    frisk = { x = 170, y = 140, dir = 3, frame = 0, spd = 1.5, hsp = 0, vsp = 0, checked = false,
      spr = {
        normal = {
          [0] = {
            [0] = love.graphics.newImage('img/dream/frisk/0_0.png'),
            [1] = love.graphics.newImage('img/dream/frisk/0_1.png'),
          },
          [1] = {
            [0] = love.graphics.newImage('img/dream/frisk/1_0.png'),
            [1] = love.graphics.newImage('img/dream/frisk/1_1.png'),
            [3] = love.graphics.newImage('img/dream/frisk/1_2.png'),
          },
          [2] = {
            [0] = love.graphics.newImage('img/dream/frisk/2_0.png'),
            [1] = love.graphics.newImage('img/dream/frisk/2_1.png'),
          },
          [3] = {
            [0] = love.graphics.newImage('img/dream/frisk/3_0.png'),
            [1] = love.graphics.newImage('img/dream/frisk/3_1.png'),
            [3] = love.graphics.newImage('img/dream/frisk/3_2.png'),
          },
        },
        sleep = {

        },
      },
    },
    room = {
      [0] = {
        bg = love.graphics.newImage('img/dream/room/0.png'),
        x = 90, -- room bg x offset
        y = 21, -- room bg y offset
        w = 400, --room width
        h = 240, -- room height
        wall = { --easy basic walls to set up
          [0] = 273, -- east x
          [1] = 100, -- north y
          [2] = 120, -- west x
          [3] = 272, -- south y
        },
        warp = { -- total number of warp/doors
          [0] = {x1 = 240, y1 = 200, x2 = 275, y2 = 215, goto = 1, spawn = 0,}
        },
        spawn = { --where you spawn/ arrive from a warp
          [0] = {x = 257, y = 188, dir = 1},
        },
        object = {
          [0] = {x1 = 235, y1 = 97, x2 = 276, y2 = 140,},
          [1] = {x1 = 255, y1 = 137, x2 = 276, y2 = 160,},
          [2] = {x1 = 116, y1 = 195, x2 = 241, y2 = 215,},
        },
      },
      [1] = {
        bg = love.graphics.newImage('img/dream/room/1.png'),
        x = 0,
        y = 42,
        w = 400,
        h = 240,
        wall = { --easy basic walls to set up
          [0] = 400, -- east x
          [1] = 104, -- north y
          [2] = 0 , -- west x
          [3] = 169, -- south y
        },
        warp = { -- total number of warp/doors
          [0] = {x1 = 158, y1 = 105, x2 = 182, y2 = 116, goto = 0, spawn = 0,},
        },
        spawn = { --where you spawn/ arrive from a warp
          [0] = {x = 170, y = 126, dir = 3,},
        },
        object = {
          [0] = {solid = true, x1 = 0, y1 = 105, x2 = 159, y2 = 121,
            commment = {
              [0] = nil,
            },
          },
          [1] = {solid = true, x1 = 181, y1 = 105, x2 = 368, y2 = 121,
            comment = {
              [0] = nil,
            },
          }, -- hole
          [2] = {solid = true, x1 = 258, y1 = 100, x2 = 331, y2 = 180,
            comment = {
              [0] = '* The hallway is seperated by a hole in the floor.',
              [1] = '* The gap is too wide for you to jump across.',
              [3] = '* You cannot see the bottom.',
            },
          },
        },
      },
    },
  }
  function dream.doCollision(x0, y0, hsp, vsp, curRoom)
    --make local vars
    local x1 = x0 + hsp
    local y1 = y0 + vsp
    --wall collision
    if x1 > dream.room[curRoom].wall[0] then dream.frisk.hsp = 0 end
    if x1 < dream.room[curRoom].wall[2] then dream.frisk.hsp = 0 end
    if y1 > dream.room[curRoom].wall[3] then dream.frisk.vsp = 0 end
    if y1 < dream.room[curRoom].wall[1] then dream.frisk.vsp = 0 end
    --object collision
    for  i = 0, 30, 1 do
      if hsp == 0 and vsp == 0 then break end --skip collision if you aren't moving (stopped by wall collision)
      if x1 > dream.room[curRoom].object[i].x1 and x1 < dream.room[curRoom].object[i].x2 and y0 > dream.room[curRoom].object[i].y1 and y0 < dream.room[curRoom].object[i].y2 then
        dream.frisk.hsp = 0
      end
      if x0 > dream.room[curRoom].object[i].x1 and x0 < dream.room[curRoom].object[i].x2 and y1 > dream.room[curRoom].object[i].y1 and y1 <                   dream.room[curRoom].object[i].y2 then
        dream.frisk.vsp = 0
      end
      if dream.room[curRoom].object[i+1] == nil then break end
    end
  end

  -- do warp
  function dream.doWarp(room, spawn)
    dream.curRoom = room
    dream.frisk.x = dream.room[room].spawn[spawn].x
    dream.frisk.y = dream.room[room].spawn[spawn].y
    dream.frisk.dir = dream.room[room].spawn[spawn].dir
  end
  -- check if on a warp
  function dream.checkWarp(x, y)
    for i = 0, 10, 1 do
      if x > dream.room[dream.curRoom].warp[i].x1 and x < dream.room[dream.curRoom].warp[i].x2 and y > dream.room[dream.curRoom].warp[i].y1 and y < dream.room[dream.curRoom].warp[i].y2 then
        dream.warp.goto = dream.room[dream.curRoom].warp[i].goto
        dream.warp.spawn = dream.room[dream.curRoom].warp[i].spawn
        dream.warp.transition = 0
        dream.state = 'warp'
        dream.frameTimer = 0
      end
      if dream.room[dream.curRoom].warp[i+1] == nil then break end
    end
  end
  -- check if you can interact with stuff in front of you
  function dream.doCheck(x, y, dir)
    --disable movement
    dream.frisk.hsp = 0
    dream.frisk.vsp = 0
    -- check in proper direction
    if dir == 0 then
      --facing right
    elseif dir == 1 then
      --facing up
    elseif dir == 2 then
      --facing left
    else
      --facing down
    end
    -- doInteract(obj) or something if you can interact
  end
  function dream.drawMenu(x, y, w, h, d)
    love.graphics.setScreen('top')
    love.graphics.setDepth(d)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.rectangle('fill', x, y, w, h)
    love.graphics.setDepth(d)
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.rectangle('fill', x+3, y+3, w-6, h-6)
  end
end

function gameStates.dream.draw()
  love.graphics.setScreen('top')
  love.graphics.setFont(fnt_main)
  love.graphics.setDepth(0)
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.draw(dream.room[dream.curRoom].bg, dream.room[dream.curRoom].x, dream.room[dream.curRoom].y)
  if dream.frisk.spr.normal[dream.frisk.dir][dream.frisk.frame] == nil then
    love.graphics.draw(dream.frisk.spr.normal[dream.frisk.dir][0], dream.frisk.x - 9, dream.frisk.y - 26)
  else
    love.graphics.draw(dream.frisk.spr.normal[dream.frisk.dir][dream.frisk.frame], dream.frisk.x - 9, dream.frisk.y - 26)
  end
  if dream.state == 'warp' then -- draw black screen fade
    love.graphics.setColor(0, 0, 0, dream.fade)
    love.graphics.rectangle('fill', -5, -5, 405, 245)
  end
  if dream.state == 'pause' then
    dream.drawMenu(26, 26, 70, 55, -2)
    dream.drawMenu(26, 94, 70, 75, -2)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setDepth(-3)
    love.graphics.setFont(fnt_main)
    love.graphics.print("Frisk", 35, 28)
    love.graphics.setDepth(-2)
    love.graphics.setFont(fnt_small)
    love.graphics.print("LV", 35, 47)
    love.graphics.print("HP", 35, 56)
    love.graphics.print("G", 35, 65)
    love.graphics.print("1", 52, 47)
    love.graphics.print("20/20", 52, 56)
    love.graphics.print("0", 52, 65)

    love.graphics.setFont(fnt_main)
    love.graphics.print(dream.pause[0].name, 50, 101)
    love.graphics.print("STAT", 50, 119)
    love.graphics.print("CELL", 50, 137)
  end
end

function gameStates.dream.update(gt)
  if dream.state == 'normal' then
    dream.frisk.hsp = 0
    dream.frisk.vsp = 0
    dream.frameTimer = dream.frameTimer + 5 * gt
    dream.frisk.frame = 0
    if not love.keyboard.isDown('a') then dream.frisk.checked = false end
    if love.keyboard.isDown('right') then dream.frisk.hsp = dream.frisk.hsp + dream.frisk.spd end
    if love.keyboard.isDown('left') then dream.frisk.hsp = dream.frisk.hsp - dream.frisk.spd end
    if love.keyboard.isDown('up') then dream.frisk.vsp = dream.frisk.vsp - dream.frisk.spd end
    if love.keyboard.isDown('down') then dream.frisk.vsp = dream.frisk.vsp + dream.frisk.spd end
    if love.keyboard.isDown('a') and dream.frisk.checked == false then
      dream.doCheck(dream.frisk.x, dream.frisk.y, dream.frisk.dir)
    end
    -- 'advanced' direction code, manages parent and child keys for direction (mkey[0] and mkey[1])
    if mkey[0] == nil then -- if mkey[0] is not set then...
      if love.keyboard.isDown('right') then mkey[0] = 0
      elseif  love.keyboard.isDown('up') then mkey[0] = 1
      elseif  love.keyboard.isDown('left') then mkey[0] = 2
      elseif  love.keyboard.isDown('down') then mkey[0] = 3
      else mkey[0] = nil end
    else -- if mkey[0] is set then...
      -- check if parent key is pressed, and if not, clear mkey[0]
      if mkey[0] == 0 and not love.keyboard.isDown('right') then mkey[0] = nil
      elseif mkey[0] == 1 and not love.keyboard.isDown('up') then mkey[0] = nil
      elseif mkey[0] == 2 and not love.keyboard.isDown('left') then mkey[0] = nil
      elseif mkey[0] == 3 and not love.keyboard.isDown('down') then mkey[0] = nil
      else end -- do nothing
    end
    if mkey[1] == nil and mkey[0] ~= nil then
      if mkey[0] == 0 then
        if love.keyboard.isDown('up') then mkey[1] = 1
        elseif love.keyboard.isDown('left') then mkey[1] = 2
        elseif love.keyboard.isDown('down') then mkey[1] = 3
        else end
      elseif mkey[0] == 1 then
        if love.keyboard.isDown('right') then mkey[1] = 0
        elseif love.keyboard.isDown('left') then mkey[1] = 2
        elseif love.keyboard.isDown('down') then mkey[1] = 3
        else end
      elseif mkey[0] == 2 then
        if love.keyboard.isDown('right') then mkey[1] = 0
        elseif love.keyboard.isDown('up') then mkey[1] = 1
        elseif love.keyboard.isDown('down') then mkey[1] = 3
        else end
      elseif mkey[0] == 3 then
        if love.keyboard.isDown('right') then mkey[1] = 0
        elseif love.keyboard.isDown('up') then mkey[1] = 1
        elseif love.keyboard.isDown('left') then mkey[1] = 2
        else end
      end
    else -- if mkey[1] ~= nil then -- if mkey[1] is set then...
      -- check if child key is pressed, and if not, clear mkey[1]
      if mkey[1] == 0 and not love.keyboard.isDown('right') then mkey[1] = nil
      elseif mkey[1] == 1 and not love.keyboard.isDown('up') then mkey[1] = nil
      elseif mkey[1] == 2 and not love.keyboard.isDown('left') then mkey[1] = nil
      elseif mkey[1] == 3 and not love.keyboard.isDown('down') then mkey[1] = nil
      end
    end
    if mkey[0] == nil then -- if mkey[0] is cleared...
      mkey[0] = mkey[1] -- make the child key the new parent key
      mkey[1] = nil -- clear the child key
    end
    if mkey[0] ~= nil then dream.frisk.dir = mkey[0] end -- set direction
    -- check warp and collision
    dream.checkWarp(dream.frisk.x, dream.frisk.y)
    dream.doCollision(dream.frisk.x, dream.frisk.y, dream.frisk.hsp, dream.frisk.vsp, dream.curRoom)
    -- do movement and frame timer
    if dream.frisk.vsp ~= 0 or dream.frisk.hsp ~= 0 then
      dream.frisk.x = dream.frisk.x + dream.frisk.hsp
      dream.frisk.y = dream.frisk.y + dream.frisk.vsp
      if dream.frameTimer >= 4 then dream.frameTimer = 0 end
      if dream.frameTimer >= 2 and (dream.frisk.dir == 0 or dream.frisk.dir == 2 ) then dream.frameTimer = 0 end
      dream.frisk.frame = math.floor(dream.frameTimer)
    else
      dream.frameTimer = 0
    end
    if love.keyboard.keyState('start') == 1 then
      dream.state = 'pause'
      snd_menu:play()
    end
  -- if interacting
  elseif dream.state == 'interact' then
    dream.checkWarp(dream.frisk.x, dream.frisk.y)
  -- if paused
  elseif dream.state == 'pause' then
    if love.keyboard.keyState('start') == 1 then
      dream.state = 'normal'
    end
  -- if warping
  elseif dream.state == 'warp' then
    if dream.warp.transition then
      if dream.frameTimer < 1 then
        dream.frameTimer = dream.frameTimer + 2 * gt
      else
        dream.doWarp(dream.warp.goto, dream.warp.spawn)
        dream.warp.transition = false
        dream.frameTimer = 1
      end
    else
      if dream.frameTimer > 0 then
        dream.frameTimer = dream.frameTimer - 2 * gt
      else
        dream.frameTimer = 0
        dream.state = 'normal'
      end
    end
    dream.fade = 255 * dream.frameTimer
    if dream.fade > 255 then dream.fade = 255 end
    if dream.fade < 0 then dream.fade = 0 end
  end
end
