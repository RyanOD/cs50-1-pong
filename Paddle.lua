Paddle = Class{}

function Paddle:init( x, y, width, height, fillColor, borderColor )
  self.x = x
  self.y = y
  self.fillColor = fillColor
  self.borderColor = borderColor
  self.width = width
  self.height = height
end

function Paddle:update( dt )
  self.y = self.y + PADDLE_SPEED * dt
end

function Paddle:render( x, y )
  love.graphics.setColor( self.fillColor )
  love.graphics.rectangle( 'fill', self.x, self.y, self.width, self.height )
  love.graphics.setColor( self.borderColor)
  love.graphics.rectangle( 'line', self.x, self.y, self.width, self.height )
end