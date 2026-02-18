TitleScreenState = Class{__includes = BaseState}

function TitleScreenState:update(dt) 
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    gStateMachine:change('play')
  end
end

function TitleScreenState:render()
  love.graphics.setFont(flappyFont)
  love.graphics.printf('Flappy Bird', 0, VIRTUAL_HEIGHT/2 - 30, VIRTUAL_WIDTH, 'center')
  love.graphics.setFont(mediumFont)
  love.graphics.printf('Press Enter to Play', 0, VIRTUAL_HEIGHT/2, VIRTUAL_WIDTH, 'center')
end