GameOverState = Class{__includes = BaseState}

function GameOverState:update(dt)
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    gStateMachine:change('play')
  end
end

function GameOverState:render() 
  love.graphics.setFont(hugeFont)
  love.graphics.printf('Game Over', 0, 64, VIRTUAL_WIDTH, 'center')
  love.graphics.setFont(mediumFont)
  love.graphics.printf('Press Enter to Restart', 0, 100, VIRTUAL_WIDTH, 'center')
end