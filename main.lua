--[[
Pong clone based on work by 
--]]
push = require 'push'
Class = require 'class'

require 'Paddle'
require 'Ball'

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

  love.window.setTitle( 'Pong' )
  
  --ballX = BALL_X
  --ballY = BALL_Y

  --ballDX = BALL_VELOCITY_X
  --ballDY = BALL_VELOCITY_Y

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

  ball = Ball( BALL_X, BALL_Y, BALL_RADIUS )
  paddleLeft = Paddle( PADDLE_LEFT_X, PADDLE_LEFT_Y, PADDLE_WIDTH, PADDLE_HEIGHT )
  paddleRight = Paddle( PADDLE_RIGHT_X, PADDLE_RIGHT_Y, PADDLE_WIDTH, PADDLE_HEIGHT )
end

function love.keypressed( key )
  if key == 'escape' then
    love.event.quit()
  elseif key == 'space' then
    if gameState == 'start' then
      gameState = 'play'
    else
      gameState = 'start'
      ball:reset()
    end
  end
end

-- Here we are overwriting the love.load file
function love.update(dt)
  mainData = love.filesystem.load("main.lua")()

  if love.keyboard.isDown( 'w' ) and paddleLeft.y > BORDER_PADDING then
    paddleLeft:update( -dt )
  elseif love.keyboard.isDown( 's' ) and paddleLeft.y < VIRTUAL_HEIGHT - paddleLeft.height - BORDER_PADDING then
    paddleLeft:update( dt )
  end

  if love.keyboard.isDown( 'up' ) and paddleRight.y > BORDER_PADDING then
    paddleRight:update( -dt )
  elseif love.keyboard.isDown( 'down' ) and paddleRight.y < VIRTUAL_HEIGHT - paddleRight.height - BORDER_PADDING then
    paddleRight:update( dt )
  end

  if gameState == 'play' then
    ball:update( dt )
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

  paddleLeft:render()
  paddleRight:render()

  ball:render()

  push:apply( 'end' )
end