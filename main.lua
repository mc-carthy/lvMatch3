require ('src.utils.dependencies')

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    math.randomseed(os.time())

    tileSprite = love.graphics.newImage('assets/sprites/match3.png')
    tileQuads = GenerateQuads(tileSprite, 32, 32)
    board = generateBoard()

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
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)


    love.keyboard.keysPressed = {}
end

function love.draw()
    Push:start()

    drawBoard(128, 16)
    
    Push:finish()
end

function generateBoard()
    local tiles = {}

    for y = 1, 8 do
        table.insert(tiles, {})
        for x = 1, 8 do
            table.insert(tiles[y], {
                x = (x - 1) * 32,
                y = (y - 1) * 32,
                tile = math.random(#tileQuads)
            })
        end
    end

    return tiles
end

function drawBoard(offsetX, offsetY)
    for y = 1, 8 do
        for x = 1, 8 do
            local tile = board[y][x]
            love.graphics.draw(
                tileSprite, 
                tileQuads[tile.tile],
                tile.x + offsetX, 
                tile.y + offsetY
            )
        end
    end
end