Paddle = Class{}

function Paddle:init( x, y, width, height, color )
  self.x = x
  self.y = y
  self.color = color
  self.width = width
  self.height = height
end

function Paddle:update( dt )
  self.y = self.y + PADDLE_SPEED * dt
end

function Paddle:render( x, y )
  love.graphics.setColor( self.color )
  love.graphics.rectangle( 'fill', self.x, self.y, self.width, self.height )
end