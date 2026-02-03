Pipe = Class{}

local PIPE_IMAGE = love.graphics.newImage('pipe.png')

PIPE_WIDTH = 70
PIPE_HEIGHT = 288

function Pipe:init(orientation, y)
  self.x = VIRTUAL_WIDTH
  self.y = y

  self.width = PIPE_IMAGE:getWidth()
  self.height =  PIPE_IMAGE:getHeight()

  self.orientation = orientation
end

function Pipe:update(dt) 

end

function Pipe:render() 
  love.graphics.draw(
    PIPE_IMAGE, 
    self.x,
    self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y, -- plus PIPE_HEIGHT because when the inversion happens the y goes above the screen
    0, -- rotation
    1, -- x scale
    self.orientation == 'top' and -1 or 1 -- y scale (-1 inverts)
  )
end