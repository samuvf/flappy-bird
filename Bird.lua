Bird = Class{}

function Bird:init()
  self.image = love.graphics.newImage('bird.png')
  self.width = self.image:getWidth()
  self.height = self.image:getHeight()

  self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
  self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)

  self.dy = 0
end

local GRAVITY = 20
function Bird:update(dt)
  self.dy = self.dy + GRAVITY * dt
  self.y = self.y + self.dy

  if love.keyboard.wasPressed('space') or love.mouse.isDown(1) then
    self.dy = -5
  end
end

function Bird:collision(pipe)
  -- AABB collision
  -- bird bounding box is shrinked to give the player
  -- a little bit of leeway with the collision
  if (self.x - 2) + (self.width - 4) >= pipe.x and self.x + 2 <= pipe.x + pipe.width then
    if (self.y - 2) + (self.height - 4) >= pipe.y and self.y + 2 <= pipe.y + pipe.height  then
      return true
    end
  end
  return false
end

function Bird:render()
  love.graphics.draw(self.image, self.x, self.y)
end