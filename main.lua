push = require 'push'
Class = require 'class'

require 'Bird'
require 'Pipe'
require 'PipePair'

require 'StateMachine'

require 'states/BaseState'
require 'states/PlayState'
require 'states/TitleScreenState'
require 'states/GameOverState'
require 'states/CountDownState'

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

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')

  love.window.setTitle('Flappy Bird')

  smallFont = love.graphics.newFont('font.ttf', 8)
  mediumFont = love.graphics.newFont('flappy.ttf', 14)
  flappyFont = love.graphics.newFont('flappy.ttf', 28)
  hugeFont = love.graphics.newFont('flappy.ttf', 56)
  love.graphics.setFont(flappyFont)

  sounds = {
    ['jump'] = love.audio.newSource('sound/jump.wav', 'static'),
    ['explosion'] = love.audio.newSource('sound/explosion.wav', 'static'),
    ['hurt'] = love.audio.newSource('sound/hurt.wav', 'static'),
    ['score'] = love.audio.newSource('sound/score.wav', 'static'),
    ['music'] = love.audio.newSource('sound/marios_way.mp3', 'static')
  }

  sounds['music']:setLooping(true)
  sounds['music']:play()

  math.randomseed(os.time())

  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT,{
    vsync = true,
    fullscreen = false,
    resizable = true
  }) 

  gStateMachine = StateMachine {
    ['title'] = function() return  TitleScreenState() end,
    ['play'] = function() return PlayState() end,
    ['gameover'] = function() return GameOverState() end,
    ['countdown'] = function() return CountDownState() end
  }
  gStateMachine:change('title')

  love.keyboard.keysPressed = {} -- table to store pressed keys
end

function love.resize(w, h)
  push:resize(w, h)
end

function love.update(dt)
  backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
  groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH
  
  gStateMachine:update(dt)

  love.keyboard.keysPressed = {} -- flushes whichever key is in the table as to not keep dy = -5 forever
end

function love.keypressed(key)
  love.keyboard.keysPressed[key] = true -- stores key pressed to the table andd assigns it to true

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

    gStateMachine:render()

    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)
  push:finish()
end