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

  gameState = 'select'

  love.window.setTitle( 'Pong' )

  push:setupScreen( VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizable = true,
    vsync = true
  })

  titleFont = love.graphics.newFont( 'fonts/vcr.ttf', 10 )
  servingFont = love.graphics.newFont( 'fonts/vcr.ttf', 6 )
  scoreFont = love.graphics.newFont( 'fonts/vcr.ttf', 8 )

  paddleLeftScore = 0
  paddleRightScore = 0

  sounds = {
    ['paddleHit'] = love.audio.newSource( 'sounds/bounce.wav', 'static' ),
    ['barrierHit'] = love.audio.newSource( 'sounds/block.wav', 'static' ),
    ['score'] = love.audio.newSource( 'sounds/idea.wav', 'static' )
  }

  servingPlayer = 'right'

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
  -- Quit game
  if key == 'escape' then
    love.event.quit()
  end

  -- The following is a rudimentary finite state machine

  -- 'select' state where number of active players is set
  if gameState == 'select' then
    if key == '1' or key == '2' then
      playerCount = key
      gameState = 'start'
    end
  end

  -- 'start' state where the game is waiting for the initial serve
  if gameState == 'start' then
    if key == 'space' then
      gameState = 'play'
    end
  end
  
  -- 'serve' state the happens after each score until the winning score is achieved
  if gameState == 'serve' then
    if key == 'space' then
      gameState = 'play'
    end
  end

  -- 'done' state waits for player to decide whether to play again and resets or quits
  if gameState == 'done' then
    if key == 'y' then
      gameState = 'select'
      paddleLeftScore = 0
      paddleRightScore = 0
      paddleLeft.y = PADDLE_LEFT_Y
      paddleRight.y = PADDLE_RIGHT_Y
      ball:reset()
    elseif key == 'n' then
      love.event.quit()
    end
  end
end

function love.resize( w, h )
  push:resize( w, h )
end

-- Here we are overwriting the love.load file
function love.update(dt)
  --mainData = love.filesystem.load("main.lua")()

  if gameState == 'serve' then
    if servingPlayer == 'Left' then
      ball.dx = math.abs( ball.dx )
    elseif servingPlayer == 'Right' then
      ball.dx = -1 * math.abs( ball.dx )
    end

  elseif gameState == 'play' then
      ball:update( dt )

    -- Left paddle position controls

    if playerCount == '1' then
      if ball.y > paddleLeft.y and ball.dx < 0 then
        paddleLeft:update( dt )
      elseif ball.y < paddleLeft.y and ball.dx < 0 then
        paddleLeft:update( -dt )
      end
    elseif playerCount == '2' then
      if love.keyboard.isDown( 'w' ) and paddleLeft.y > 0 then
        paddleLeft:update( -dt )
      elseif love.keyboard.isDown( 's' ) and paddleLeft.y < VIRTUAL_HEIGHT - paddleLeft.height then
        paddleLeft:update( dt )
      end
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

      sounds['paddleHit']:play()
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
    
      sounds['paddleHit']:play()
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

      sounds['barrierHit']:play()
      ball:reversal( 'y' )
    end

    if ball.x <= -ball.radius then
      sounds['score']:play()
      paddleRightScore = paddleRightScore + 1
      if( paddleRightScore == WINNING_SCORE ) then
        winningPlayer = 'Right'
        servingPlayer = 'Left'
        gameState = 'done'
      else
        gameState = 'serve'
        ball:reset()
      end
    end
    
    if ball.x >= VIRTUAL_WIDTH + ball.radius then
      sounds['score']:play()
      paddleLeftScore = paddleLeftScore + 1
      if( paddleLeftScore == WINNING_SCORE ) then
        winningPlayer = 'Left'
        servingPlayer = 'Right'
        gameState = 'done'
      else
        gameState = 'serve'
        ball:reset()
      end
    end
  end
end

function love.draw()
  push:apply( 'start' )
  love.graphics.clear(40/255, 45/255, 52/255, 255/255)
  
  love.graphics.setFont( titleFont )
  love.graphics.printf( 'Hello Pong!', 0, 20, VIRTUAL_WIDTH, 'center' )

  if gameState == 'select' then
    love.graphics.setFont( scoreFont )
    love.graphics.printf( 'Press 1 for single player or 2 for two player', 0, 130, VIRTUAL_WIDTH, 'center' )
  end
  
  if gameState == 'start' then
    love.graphics.setFont( scoreFont )
    love.graphics.printf( 'Press the space bar to serve!', 0, 130, VIRTUAL_WIDTH, 'center' )
  end

  if gameState == 'start' or gameState == 'play' or gameState == 'serve' or gameState == 'done' then
    love.graphics.setFont( servingFont )
    if playerCount == '1' then
      love.graphics.printf( 'Player 1 Score: ' .. tostring(paddleLeftScore), 10, 20, LEFT_SCORE_X, 'center' )
    elseif playerCount == '2' then
      love.graphics.printf( 'Player 1 Score: ' .. tostring(paddleLeftScore), 10, 20, LEFT_SCORE_X, 'center' )
    end
    love.graphics.printf( 'Player 2 Score: ' .. tostring(paddleRightScore), 10, 20, RIGHT_SCORE_X, 'center' )
  end

  if gameState == 'play' or gameState == 'serve' then
    love.graphics.printf( 'Serving player = ' .. servingPlayer, 0, 40, VIRTUAL_WIDTH, 'center' )
    love.graphics.setFont( scoreFont )
  end

  if gameState == 'done' then
    love.graphics.setFont( titleFont )
    love.graphics.printf( 'The player on the '  .. winningPlayer .. ' wins!', 0, 100, VIRTUAL_WIDTH, 'center' )
    love.graphics.setFont( scoreFont )
    love.graphics.printf( 'Press "y" to play again or "n" to quit...', 0, 130, VIRTUAL_WIDTH, 'center' )
  end

  if playerCount == 1 or playerCount == 2 then
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)
  end

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
  --love.graphics.print( 'dx: ' .. tostring(ball.dx), 10, 10 )
  love.graphics.print( 'Game State: ' .. gameState, 10, 10 )
end