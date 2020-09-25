Paddle = Class{}

function Paddle:init( x, y, width, height )
  self.x = x
  self.y = y
  self.width = width
  self.height = height
end

function Paddle:update( dt )
  self.y = self.y + PADDLE_SPEED * dt
end

function Paddle:render( x, y )
  love.graphics.rectangle( 'fill', self.x, self.y, self.width, self.height )
end