require ('src.utils.dependencies')

local backgroundImage = love.graphics.newImage('assets/sprites/background.png')
local backgroundX = 0
local backgroundScrollSpeed = 80

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    math.randomseed(os.time())

    stateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['beginGame'] = function () return BeginGameState() end,
        ['play'] = function() return PlayState() end,
        ['gameOver'] = function() return GameOverState() end
    }

    stateMachine:change('start')

    Push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
    
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    backgroundX = backgroundX - backgroundScrollSpeed * dt
    
    if backgroundX <= -1024 + VIRTUAL_WIDTH - 4 + 51 then
        backgroundX = 0
    end

    stateMachine:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    Push:start()

    love.graphics.draw(backgroundImage, backgroundX, 0)

    stateMachine:draw()

    Push:finish()
end