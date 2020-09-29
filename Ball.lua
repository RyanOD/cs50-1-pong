Ball = Class{}

function Ball:init( x, y, radius, color )
  self.x = x
  self.y = y
  self.radius = radius
  self.color = color
  self.dx = math.random( 1, 2 ) == 1 and 200 or -200
  self.dy = math.random( -50, 50 )
end

function Ball:reset()
  self.x = VIRTUAL_WIDTH / 2
  self.y = VIRTUAL_HEIGHT / 2
  self.dx = math.random( 1, 2 ) == 1 and -200 or 200
  self.dy = math.random( -50, 50 )
end

function Ball:serve( player )
  
end

function Ball:update( dt )
  self.x = self.x + self.dx * dt
  self.y = self.y + self.dy * dt
end

-- Method to detect ball and paddle collisions
function Ball:paddleCollision( paddle )
  if self.x - self.radius > paddle.x + PADDLE_WIDTH or paddle.x > self.x + self.radius then
    return false
  end

  if self.y - self.radius > paddle.y + PADDLE_HEIGHT or paddle.y > self.y + self.radius then
    return false
  end

  return true
end

-- Method to detect ball and horizontal boundry collisions
function Ball:boundaryCollision()
  if self.y - self.radius > 0 and self.y + self.radius < VIRTUAL_HEIGHT then
    return false
  end

  return true
end

-- Method to reverse either x or y direction of ball
function Ball:reversal( direction )
  if direction == 'x' then
    self.dx = self.dx * -1.03
  elseif direction == 'y' then
    self.dy = self.dy * -1
  end
end

-- Method to render ball to screen
function Ball:render()
  love.graphics.setColor( self.color )
  love.graphics.circle( 'fill', self.x, self.y, self.radius )
end