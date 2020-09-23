push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- Here we are overwriting the love.load file

function love.load()
  love.window.setMode( WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizable = false,
    vsync = true
  })
end

function love.draw()
  love.graphics.printf( 'Hello, Pong!', 0, WINDOW_HEIGHT / 2 - 6, WINDOW_WIDTH, 'center' )
end
