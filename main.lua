require ('src.utils.dependencies')

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    math.randomseed(os.time())

    tileSprite = love.graphics.newImage('assets/sprites/match3.png')
    tileQuads = GenerateQuads(tileSprite, TILE_SIZE, TILE_SIZE)
    board = generateBoard()

    highlightedTile = true
    highlightedX, highlightedY = 1, 1
    selectedTile = board[1][1]

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

    local x, y = selectedTile.gridX, selectedTile.gridY
    
    if key == 'up' then
        if y > 1 then
            selectedTile = board[y - 1][x]
        end
    elseif key == 'down' then
        if y < 8 then
            selectedTile = board[y + 1][x]
        end
    elseif key == 'left' then
        if x > 1 then
            selectedTile = board[y][x - 1]
        end
    elseif key == 'right' then
        if x < 8 then
            selectedTile = board[y][x + 1]
        end
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
                x = (x - 1) * TILE_SIZE,
                y = (y - 1) * TILE_SIZE,
                gridX = x,
                gridY = y,
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
            love.graphics.setColor(1, 0, 0, 0.95)
            love.graphics.setLineWidth(4)
            love.graphics.rectangle('line', selectedTile.x + offsetX, selectedTile.y + offsetY, 32, 32, 4)
            love.graphics.setColor(1, 1, 1, 1)
        end
    end
end