GameOverState = Class{__includes = BaseState}

GOLD_MEDAL_IMAGE = love.graphics.newImage('goldMedal.png')
SILVER_MEDAL_IMAGE = love.graphics.newImage('silverMedal.png')
COOPER_MEDAL_IMAGE = love.graphics.newImage('cooperMedal.png')

function GameOverState:enter(params)
  self.score = params.score
end

function GameOverState:update(dt)
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    gStateMachine:change('countdown')
  end
end

function GameOverState:render() 
  love.graphics.setFont(hugeFont)
  love.graphics.printf('Game Over', 0, 64, VIRTUAL_WIDTH, 'center')
  love.graphics.setFont(mediumFont)
  love.graphics.printf('Score: ' .. tostring(self.score), 0, 150, VIRTUAL_WIDTH, 'center')

  if self.score >= 15 then
    love.graphics.draw(GOLD_MEDAL_IMAGE, VIRTUAL_WIDTH/2 - (GOLD_MEDAL_IMAGE:getWidth()/2), 165)
  elseif self.score >= 10 then
    love.graphics.draw(SILVER_MEDAL_IMAGE, VIRTUAL_WIDTH/2 - (SILVER_MEDAL_IMAGE:getWidth()/2), 165)
  elseif self.score >= 5 then
    love.graphics.draw(COOPER_MEDAL_IMAGE, VIRTUAL_WIDTH/2 - (GOLD_MEDAL_IMAGE:getWidth()/2), 165)
  end

  love.graphics.printf('Press Enter to Restart', 0, 200, VIRTUAL_WIDTH, 'center')
end