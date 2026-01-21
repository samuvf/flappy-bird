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
local pipes = {}
local time = 0

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
  backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT

  groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH
  
  -- every 2 seconds insert a Pipe into the table
  time = time + dt
  if time > 2 then
    table.insert(pipes, Pipe())
    time = 0
  end

  for k, pipe in pairs(pipes) do
    pipe:update(dt)
    if (pipe.x < -pipe.width) then
      table.remove(pipe, k)
    end
  end

  bird:update(dt)

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

    for k, pipe in pairs(pipes) do
      pipe:render()
    end

    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    bird:render()

  push:finish()
end