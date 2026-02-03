push = require 'push'

Class = require 'class'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage('background.png')
local backgroundScroll = 0

local ground = love.graphics.newImage('ground.png')
local groundScroll = 0

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

local BACKGROUND_LOOPING_POINT = 413 -- similar to the begining of the image as to not be noticeable

require 'Bird'
local bird = Bird()

require 'Pipe'

require 'PipePair'

local pipePairs = {}
local spawnTime = 0

-- stores the last y as to no repeat the same in the next pipe
-- creating a more dynamic pipes reendering
local lastY = -PIPE_HEIGHT + math.random(80) + 20

-- keep scrollling if true else pause game
local scrolling = true

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')

  love.window.setTitle('Flappy Bird')

  math.randomseed(os.time())

  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT,{
    vsync = true,
    fullscreen = false,
    resizable = true
  }) 

  love.keyboard.keysPressed = {} -- table to store pressed keys
end

function love.resize(w, h)
  push:resize(w, h)
end

function love.update(dt)
  if scrolling then
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT

    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH
    
    -- every 2 seconds insert a Pipe into the table
    spawnTime = spawnTime + dt
    if spawnTime > 2 then
      -- defines y limites for the pipe to spawn
      -- and where the gap can begin
      local y = math.max(-PIPE_HEIGHT + 10, math.min(lastY + math.random(-20,20), VIRTUAL_HEIGHT -90 -PIPE_HEIGHT))
      lastY = y

      table.insert(pipePairs, PipePair(y))
      spawnTime = 0
    end

    -- keep updating each pipePair present in the table 
    for k, pipePair in pairs(pipePairs) do
      pipePair:update(dt)
      -- check for collision between bird and pipes
      for l, pipe in pairs(pipePair.pipes) do
        if bird:collision(pipe) then
          -- pauses game
          scrolling = false
        end
      end
    end
    -- removes pipePair from table if it has trespassed the left edge of the screen
    -- another loop is recommended, beacause removing elements 
    -- while operating an update on them can cause bugs (flinch pipes)
    for k, pipePair in pairs(pipePairs) do
      if (pipePair.remove) then
        table.remove(pipePair, k)
      end
    end

    bird:update(dt)
  end

  love.keyboard.keysPressed = {} -- flushes whichever key is in the table as to not keep dy = -5 forever
end

function love.keypressed(key)
  love.keyboard.keysPressed[key] = true -- stores key pressed to the table andd assignes it to true

  if key == 'escape' then
    love.event.quit()
  end
end

function love.keyboard.wasPressed(key)
  return love.keyboard.keysPressed[key] -- returns true or false depending if key exist in the table
end

function love.draw()
  push:start()
    love.graphics.draw(background, -backgroundScroll, 0)

    for k, pipePair in pairs(pipePairs) do
      pipePair:render()
    end

    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    bird:render()

  push:finish()
end