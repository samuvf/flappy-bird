GameOverState = Class{__includes = BaseState}

highestScore = 0

function GameOverState:update(dt)
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    gStateMachine:change('title')
    if highestScore < score then
      highestScore = score
    end
    score = 0
  end
end

function GameOverState:render() 
  love.graphics.setFont(hugeFont)
  love.graphics.printf('Game Over', 0, 64, VIRTUAL_WIDTH, 'center')
  love.graphics.setFont(mediumFont)
  love.graphics.printf('Score: ' .. tostring(score), 0, 150, VIRTUAL_WIDTH, 'center')
  love.graphics.printf('Press Enter to Restart', 0, 200, VIRTUAL_WIDTH, 'center')
end