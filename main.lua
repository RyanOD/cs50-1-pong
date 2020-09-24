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

BALL_X = VIRTUAL_WIDTH / 2
BALL_Y = VIRTUAL_HEIGHT / 2
BALL_RADIUS = 3

LEFT_SCORE_X = VIRTUAL_WIDTH - 360
RIGHT_SCORE_X = VIRTUAL_WIDTH + 330

PADDLE_SPEED = 200

-- Here we are overwriting the love.load file
function love.update(dt)
  mainData = love.filesystem.load("main.lua")()

  if love.keyboard.isDown( 'w' ) then
    paddleLeftY = player1Y - PADDLE_SPEED * dt
  elseif love.keyboard.isDown( 's' ) then
    paddleLeftY = paddleLeftY + PADDLE_SPEED * dt
  end

  if love.keyboard.isDown( 'up' ) then
    paddleRightY = paddleRightY - PADDLE_SPEED * dt
  elseif love.keyboard.isDown( 'down' ) then
    paddleRightY = paddleRightY - PADDLE_SPEED * dt
  end
end

function love.load()
  love.graphics.setDefaultFilter( 'nearest', 'nearest' )

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

function love.draw()
  push:apply( 'start' )
  love.graphics.clear(40/255, 45/255, 52/255, 255/255)
  love.graphics.setFont( titleFont )
  love.graphics.printf( 'Hello Pong!', 0, 20, VIRTUAL_WIDTH, 'center' )
  love.graphics.setFont( scoreFont )
  love.graphics.printf( 'Score: ' .. paddleLeftScore, 10, 20, LEFT_SCORE_X, 'center' )
  love.graphics.printf( 'Score: ' .. paddleRightScore, 10, 20, RIGHT_SCORE_X, 'center' )
  love.graphics.rectangle( 'fill', PADDLE_LEFT_X, PADDLE_LEFT_Y, PADDLE_WIDTH, PADDLE_HEIGHT )
  love.graphics.rectangle( 'fill', PADDLE_RIGHT_X, PADDLE_RIGHT_Y, PADDLE_WIDTH, PADDLE_HEIGHT )
  love.graphics.circle( 'fill', BALL_X, BALL_Y, BALL_RADIUS )
  push:apply( 'end' )
end
