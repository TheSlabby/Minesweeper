gamestate = require('hump.gamestate')
menu = require('menu')
game = require('game')

function love.load()
	print('minigolf beta running, developed by walker')
    gamestate.registerEvents()
    gamestate.switch(game)

    --start server code
    thread = love.thread.newThread('server.lua')
    thread:start()
end
