PlayState = Class{__includes = BaseState}

PIPE_SPEED = 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

function PlayState:init() 
  self.bird = Bird()
  self.pipePairs = {}
  self.spawnTime = 0

  -- stores the last y as to no repeat the same in the next pipe
  -- creating a more dynamic pipes reendering
  self.lastY = -PIPE_HEIGHT + math.random(80) + 20

  self.score = 0
end

function PlayState:update(dt)
  -- every 2 seconds insert a Pipe into the table
  self.spawnTime = self.spawnTime + dt
  if self.spawnTime > 2 then
    -- defines y limites for the pipe to spawn
    -- and where the gap can begin
    local y = math.max(-PIPE_HEIGHT + 50, math.min(self.lastY + math.random(-20,20), VIRTUAL_HEIGHT -90 -PIPE_HEIGHT))
    self.lastY = y
    table.insert(self.pipePairs, PipePair(y))
    self.spawnTime = 0
  end

  for k, pipePair in pairs(self.pipePairs) do
    -- increase score by 1 each time the bird passes through a pipepair
    if self.bird.x > pipePair.x + PIPE_WIDTH then
      if not pipePair.scored then
        self.score = self.score + 1
        pipePair.scored = true
      end
    end
    -- keep updating each pipePair present in the table 
    pipePair:update(dt)
  end
  -- check for collision between bird and pipes
  for k, pipePair in pairs(self.pipePairs) do
    for l, pipe in pairs(pipePair.pipes) do
      if self.bird:collision(pipe) then
        gStateMachine:change('gameover', {
          score = self.score
        })
      end
    end
  end
  
  -- gameover if we get to the ground
  if self.bird.y + BIRD_HEIGHT > VIRTUAL_HEIGHT or self.bird.y < 0 then
    gStateMachine:change('gameover', {
      score = self.score
    })
  end
  -- removes pipePair from table if it has trespassed the left edge of the screen
  -- another loop is recommended, beacause removing elements 
  -- while operating an update on them can cause bugs (flinch pipes)
  for k, pipePair in pairs(self.pipePairs) do
    if (pipePair.remove) then
      table.remove(self.pipePairs, k)
    end
  end

  self.bird:update(dt)
end

function PlayState:render()
  for k, pipePair in pairs(self.pipePairs) do
    pipePair:render()
  end
  self.bird:render()

  love.graphics.print('Score: ' .. tostring(self.score), 10, 10)
end

