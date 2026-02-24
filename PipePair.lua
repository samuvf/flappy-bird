PipePair = Class {}

function PipePair:init(y) 
  self.x = VIRTUAL_WIDTH + 32 -- pipe pair will spawn 32 pixels after the right side of the screen
  self.y = y

  self.gap_height = math.random(65, 85)

  self.pipes = {
    ['top'] = Pipe('top', self.y),
    ['botton'] = Pipe('botton', self.y + PIPE_HEIGHT + self.gap_height) -- already pulls the y to its right position if botton pipe
  }

  self.remove = false

  self.scored = false
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