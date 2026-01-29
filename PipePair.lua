PipePair = Class {}

local GAP_HEIGTH = 90

function PipePair:init(y) 
  self.x = VIRTUAL_WIDTH + 32 -- pipe pair will spawn 32 pixels after the right side of the screen
  self.y = y

  self.pipes = {
    top = Pipe('top', self.y),
    botton = Pipe('botton', self.y + PIPE_HEIGHT + GAP_HEIGTH) -- already pulls the y to its right position if botton pipe
  }

  self.remove = false
end

function PipePair:update(dt)
  if self.x > -PIPE_WIDTH then
    self.x = self.x - 60 * dt
    self.pipes['top'].x = self.x
    self.pipes['botton'].x = self.x
  else
    self.remove = true
  end
end

function PipePair:render()
  for k, pipe in pairs(self.pipes) do
    pipe:render()
  end
end