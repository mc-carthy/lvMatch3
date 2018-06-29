PlayState = Class{ __includes = BaseState }

local function generateBoard()
    local tiles = {}

    for y = 1, GRID_Y_SIZE do
        table.insert(tiles, {})
        for x = 1, GRID_X_SIZE do
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

local function drawBoard(offsetX, offsetY)
    for y = 1, GRID_Y_SIZE do
        for x = 1, GRID_X_SIZE do
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

function PlayState:init()
    tileSprite = love.graphics.newImage('assets/sprites/match3.png')
    tileQuads = GenerateQuads(tileSprite, TILE_SIZE, TILE_SIZE)
    board = generateBoard()

    highlightedTile = false
    highlightedX, highlightedY = 1, 1
    selectedTile = board[1][1]
end

function PlayState:enter(params)
    self.level = params.level
    self.board = params.board or Board(VIRTUAL_WIDTH - 272, 16)
    self.score = params.score or 0
    self.scoreGoal = self.level * 1.25 * 1000
end

function PlayState:update(dt)
    local x, y = selectedTile.gridX, selectedTile.gridY
    
    if love.keyboard.wasPressed('up') then
        if y > 1 then
            selectedTile = board[y - 1][x]
        end
    elseif love.keyboard.wasPressed('down') then
        if y < GRID_Y_SIZE then
            selectedTile = board[y + 1][x]
        end
    elseif love.keyboard.wasPressed('left') then
        if x > 1 then
            selectedTile = board[y][x - 1]
        end
    elseif love.keyboard.wasPressed('right') then
        if x < GRID_Y_SIZE then
            selectedTile = board[y][x + 1]
        end
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
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

function PlayState:draw()
    self.board:draw()
end