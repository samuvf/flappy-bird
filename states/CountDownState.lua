CountDownState = Class{__includes = BaseState}

function CountDownState:init()
  self.countdown = 0.1
end

function CountDownState:update(dt)
  if self.countdown > 3 then
    gStateMachine:change('play')
  end
  self.countdown = self.countdown + dt
end

function CountDownState:render()
  love.graphics.setFont(hugeFont) 
  love.graphics.printf(tostring(math.ceil(self.countdown)), 0, 100, VIRTUAL_WIDTH, 'center')
end