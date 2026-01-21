Pipe = Class{}

local PIPE_IMAGE = love.graphics.newImage('pipe.png')

function Pipe:init() 
  self.x = VIRTUAL_WIDTH
  self.y = math.random(VIRTUAL_HEIGHT - 50, VIRTUAL_HEIGHT / 4)

  self.width = PIPE_IMAGE:getWidth()
end

local pipeScroll = -60
function Pipe:update(dt)
  self.x = self.x + pipeScroll * dt
end

function Pipe:render() 
  love.graphics.draw(PIPE_IMAGE, self.x, self.y)
end