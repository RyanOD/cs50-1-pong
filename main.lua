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

  -- Instantiate ball object
  ball = Ball( BALL_X,
               BALL_Y,
               BALL_RADIUS,
               BALL_COLOR )

  -- Instantiate left paddle object
  paddleLeft = Paddle( PADDLE_LEFT_X,
                       PADDLE_LEFT_Y,
                       PADDLE_WIDTH,
                       PADDLE_HEIGHT,
                       PADDLE_LEFT_FILL_COLOR,
                       PADDLE_LEFT_BORDER_COLOR )
  
  -- Instantiate right paddle object
  paddleRight = Paddle( PADDLE_RIGHT_X,
                        PADDLE_RIGHT_Y,
                        PADDLE_WIDTH,
                        PADDLE_HEIGHT,
                        PADDLE_RIGHT_FILL_COLOR,
                        PADDLE_RIGHT_BORDER_COLOR )
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

    -- Left paddle position controls
    if love.keyboard.isDown( 'w' ) and paddleLeft.y > 0 then
      paddleLeft:update( -dt )
    elseif love.keyboard.isDown( 's' ) and paddleLeft.y < VIRTUAL_HEIGHT - paddleLeft.height then
      paddleLeft:update( dt )
    end

    -- Right paddle position controls
    if love.keyboard.isDown( 'up' ) and paddleRight.y > 0 then
      paddleRight:update( -dt )
    elseif love.keyboard.isDown( 'down' ) and paddleRight.y < VIRTUAL_HEIGHT - paddleRight.height then
      paddleRight:update( dt )
    end

    -- Call to paddleCollision method for left paddle
    if ball:paddleCollision( paddleLeft ) then
      if ball.dx > 0 then
        ball.x = paddleLeft.x - ball.radius
      else
        ball.x = paddleLeft.x + PADDLE_WIDTH + ball.radius
      end
    
      ball:reversal( 'x' )

      ball.dy = ball.dy < 0 and -math.random( 10, 150 ) or math.random( 10, 150 )
    end

    -- Call to paddleCollision method for right paddle
    if ball:paddleCollision( paddleRight ) then
      if ball.dx > 0 then
        ball.x = paddleRight.x - ball.radius
      else
        ball.x = paddleRight.x + PADDLE_WIDTH + ball.radius
      end
    
      ball:reversal( 'x' )

      ball.dy = ball.dy < 0 and -math.random( 10, 150 ) or math.random( 10, 150 )
    end

    -- Call to boundaryCollision method
    if ball:boundaryCollision() then
      if ball.dy > 0 then
        ball.y = VIRTUAL_HEIGHT - ball.radius
      else
        ball.y = ball.radius
      end

      ball:reversal( 'y' )
    end

    if ball.x <= -ball.radius then
      paddleRightScore = paddleRightScore + 1
      gameState = 'start'
      ball:reset()
    end
    
    if ball.x >= VIRTUAL_WIDTH + ball.radius then
      paddleLeftScore = paddleLeftScore + 1
      gameState = 'start'
      ball:reset()
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
  --love.graphics.print( 'FPS: ' .. tostring(love.timer.getFPS()), 10, 10 )
  love.graphics.print( 'dx: ' .. tostring(ball.dx), 10, 10 )
end