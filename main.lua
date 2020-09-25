push = require 'push'

-- Define game constants
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_WIDTH = 5
PADDLE_HEIGHT = 30

PADDLE_LEFT_X = VIRTUAL_WIDTH / 2 - 210
PADDLE_RIGHT_X = VIRTUAL_WIDTH / 2 + 205

PADDLE_LEFT_Y = VIRTUAL_HEIGHT / 2 - 50
PADDLE_RIGHT_Y = VIRTUAL_HEIGHT / 2 + 50

BORDER_PADDING = 2

BALL_X = VIRTUAL_WIDTH / 2
BALL_Y = VIRTUAL_HEIGHT / 2
BALL_RADIUS = 3

LEFT_SCORE_X = VIRTUAL_WIDTH - 360
RIGHT_SCORE_X = VIRTUAL_WIDTH + 330

PADDLE_SPEED = 200

BALL_VELOCITY_X = 0
BALL_VELOCITY_Y = 0

function love.load()
  love.graphics.setDefaultFilter( 'nearest', 'nearest' )

  math.randomseed(os.time())

  gameState = 'start'

  ballX = BALL_X
  ballY = BALL_Y

  ballDX = BALL_VELOCITY_X
  ballDY = BALL_VELOCITY_Y

  push:setupScreen( VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizable = false,
    vsync = true
  })

  titleFont = love.graphics.newFont( 'vcr.ttf', 10 )
  scoreFont = love.graphics.newFont( 'vcr.ttf', 8 )

  paddleLeftScore = 0
  paddleRightScore = 0

  paddleLeftY = PADDLE_LEFT_Y
  paddleRightY = PADDLE_RIGHT_Y
end

function love.keypressed( key )
  if key == 'escape' then
    love.event.quit()
  end
end

-- Here we are overwriting the love.load file
function love.update(dt)
  mainData = love.filesystem.load("main.lua")()

  if love.keyboard.isDown( 'w' ) then
    paddleLeftY = math.max( BORDER_PADDING, paddleLeftY - PADDLE_SPEED * dt )
  elseif love.keyboard.isDown( 's' ) then
    paddleLeftY = math.min( VIRTUAL_HEIGHT - PADDLE_HEIGHT - BORDER_PADDING, paddleLeftY + PADDLE_SPEED * dt )
  end

  if love.keyboard.isDown( 'up' ) then
    paddleRightY = math.max( BORDER_PADDING, paddleRightY - PADDLE_SPEED * dt )
  elseif love.keyboard.isDown( 'down' ) then
    paddleRightY = math.min( VIRTUAL_HEIGHT - PADDLE_HEIGHT - BORDER_PADDING, paddleRightY + PADDLE_SPEED * dt )
  end

  -- Need to make sure the ball trajectory guarantees it doesn't go of the top or bottom of screen on initial serve
  if love.keyboard.isDown( 'space' ) and gameState == 'start' then
    gameState = 'play'
    ballDX = math.random( 1, 2 ) == 1 and 100 or -100
    ballDY = math.random( -50, 50 )
  end

  if gameState == 'play' then
    ballX = ballX + ballDX * dt
    ballY = ballY + ballDY * dt
  end
end

function love.draw()
  push:apply( 'start' )
  love.graphics.clear(40/255, 45/255, 52/255, 255/255)
  
  love.graphics.setFont( titleFont )
  love.graphics.printf( 'Hello Pong!', 0, 20, VIRTUAL_WIDTH, 'center' )
  
  love.graphics.setFont( scoreFont )
  love.graphics.printf( 'Score: ' .. paddleLeftScore, 10, 20, LEFT_SCORE_X, 'center' )
  love.graphics.printf( 'Score: ' .. paddleRightScore, 10, 20, RIGHT_SCORE_X, 'center' )

  love.graphics.rectangle( 'fill', PADDLE_LEFT_X, paddleLeftY, PADDLE_WIDTH, PADDLE_HEIGHT )
  love.graphics.rectangle( 'fill', PADDLE_RIGHT_X, paddleRightY, PADDLE_WIDTH, PADDLE_HEIGHT )

  love.graphics.circle( 'fill', ballX, ballY, BALL_RADIUS )
  push:apply( 'end' )
end