require ('src.utils.dependencies')

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    math.randomseed(os.time())

    tileSprite = love.graphics.newImage('assets/sprites/match3.png')
    tileQuads = GenerateQuads(tileSprite, TILE_SIZE, TILE_SIZE)
    board = generateBoard()

    highlightedTile = false
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

    if key == 'enter' or key == 'return' then
        if not highlightedTile then
            highlightedTile = true
            highlightedX, highlightedY = selectedTile.gridX, selectedTile.gridY
        else
            local tile1 = selectedTile
            local tile2 = board[highlightedY][highlightedX]

            local tempX, tempY = tile2.x, tile2.y
            local tempgridX, tempgridY = tile2.gridX, tile2.gridY

            local tempTile = tile1
            board[tile1.gridY][tile1.gridX] = tile2
            board[tile2.gridY][tile2.gridX] = tempTile

            Timer.tween(0.2, {
                [tile2] = {x = tile1.x, y = tile1.y},
                [tile1] = {x = tempX, y = tempY}
            })

            tile2.x, tile2.y = tile1.x, tile1.y
            tile2.gridX, tile2.gridY = tile1.gridX, tile1.gridY
            tile1.x, tile1.y = tempX, tempY
            tile1.gridX, tile1.gridY = tempgridX, tempgridY

            highlightedTile = false

            selectedTile = tile2
        end
    end
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    Timer.update(dt)

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

            if highlightedTile then
                if tile.gridX == highlightedX and tile.gridY == highlightedY then
                    love.graphics.setColor(1, 1, 1, 0.5)
                    love.graphics.rectangle('fill', tile.x + offsetX, tile.y + offsetY, TILE_SIZE, TILE_SIZE, 4)
                    love.graphics.setColor(1, 1, 1, 1)
                end
            end
            
            love.graphics.setColor(1, 0, 0, 0.95)
            love.graphics.setLineWidth(4)
            love.graphics.rectangle('line', selectedTile.x + offsetX, selectedTile.y + offsetY, TILE_SIZE, TILE_SIZE, 4)
            love.graphics.setColor(1, 1, 1, 1)
        end
    end
end