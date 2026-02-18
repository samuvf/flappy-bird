PlayState = Class{__includes = BaseState}

require 'Bird'
require 'PipePair'
require 'Pipe'

function PlayState:init() 
  bird = Bird()
  pipePairs = {}
  spawnTime = 0

  -- stores the last y as to no repeat the same in the next pipe
  -- creating a more dynamic pipes reendering
  lastY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)
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

function PlayState:render()
  for k, pipePair in pairs(pipePairs) do
    pipePair:render()
  end
  bird:render()
end