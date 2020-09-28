--[[
Pong clone written by Ryan O'Donnell for CSE50 through edx.org. Based on work by instructor, Colton Ogden.
Copyright 2020
All rights reserved
--]]

push = require 'push'
Class = require 'class'

require 'config'
require 'Paddle'
require 'Ball'

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

  ball = Ball( BALL_X, BALL_Y, BALL_RADIUS, BALL_COLOR )
  paddleLeft = Paddle( PADDLE_LEFT_X, PADDLE_LEFT_Y, PADDLE_WIDTH, PADDLE_HEIGHT, PADDLE_LEFT_COLOR )
  paddleRight = Paddle( PADDLE_RIGHT_X, PADDLE_RIGHT_Y, PADDLE_WIDTH, PADDLE_HEIGHT, PADDLE_RIGHT_COLOR )
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
  --mainData = love.filesystem.load("main.lua")()

  if gameState == 'play' then
    ball:update( dt )

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

    if( ball:collision( paddleLeft ) or ball:collision( paddleRight )) then
      ball:reversal()
    end
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

  displayFPS()

  push:apply( 'end' )
end

function displayFPS()
  love.graphics.setFont( scoreFont )
  love.graphics.setColor( 0, 255, 0, 255 )
  love.graphics.print( 'FPS: ' .. tostring(love.timer.getFPS()), 10, 10 )
end