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
    self.boardHighlightX = 0
    self.boardHighlightY = 0
    self.rectHighlighted = false
    self.canInput = true
    self.highlightedTile = nil

    Timer.every(0.5, function()
        self.rectHighlighted = not self.rectHighlighted
    end)
end

function PlayState:enter(params)
    self.level = params.level
    self.board = params.board or Board(VIRTUAL_WIDTH - 272, 16)
    self.score = params.score or 0
    self.scoreGoal = self.level * 1.25 * 1000
end

function PlayState:calculateMatches()
    self.highlightedTile = nil

    local matches = self.board:calculateMatches()
    
    if matches then
        sounds['match']:stop()
        sounds['match']:play()

        for k, match in pairs(matches) do
            self.score = self.score + #match * 50
        end

        self.board:removeMatches()

        local tilesToFall = self.board:getFallingTiles()

        Timer.tween(0.25, tilesToFall):finish(function()
            self:calculateMatches()
        end)
    else
        self.canInput = true
    end
end

function PlayState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    if self.canInput then
        if love.keyboard.wasPressed('up') then
            self.boardHighlightY = math.max(0, self.boardHighlightY - 1)
            sounds['select']:play()
        elseif love.keyboard.wasPressed('down') then
            self.boardHighlightY = math.min(7, self.boardHighlightY + 1)
            sounds['select']:play()
        elseif love.keyboard.wasPressed('left') then
            self.boardHighlightX = math.max(0, self.boardHighlightX - 1)
            sounds['select']:play()
        elseif love.keyboard.wasPressed('right') then
            self.boardHighlightX = math.min(7, self.boardHighlightX + 1)
            sounds['select']:play()
        end

        if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
            local x = self.boardHighlightX + 1
            local y = self.boardHighlightY + 1
            
            if not self.highlightedTile then
                self.highlightedTile = self.board.tiles[y][x]
            elseif self.highlightedTile == self.board.tiles[y][x] then
                self.highlightedTile = nil
            elseif math.abs(self.highlightedTile.gridX - x) + math.abs(self.highlightedTile.gridY - y) > 1 then
                sounds['error']:play()
                self.highlightedTile = nil
            else
                local tempX = self.highlightedTile.gridX
                local tempY = self.highlightedTile.gridY

                local newTile = self.board.tiles[y][x]

                self.highlightedTile.gridX = newTile.gridX
                self.highlightedTile.gridY = newTile.gridY
                newTile.gridX = tempX
                newTile.gridY = tempY
                
                Timer.tween(0.1, {
                    [self.highlightedTile] = {x = newTile.x, y = newTile.y},
                    [newTile] = {x = self.highlightedTile.x, y = self.highlightedTile.y}
                }):finish(function()
                    self:calculateMatches()
                end)

                self.board.tiles[self.highlightedTile.gridY][self.highlightedTile.gridX] =
                    self.highlightedTile
                self.board.tiles[newTile.gridY][newTile.gridX] = newTile
                self.highlightedTile = nil

            end
        end
    end
    Timer.update(dt)
end

function PlayState:draw()
    self.board:draw()

    if self.highlightedTile then
        love.graphics.setBlendMode('add')

        love.graphics.setColor(1, 1, 1, 0.35)
        love.graphics.rectangle('fill', (self.highlightedTile.gridX - 1) * 32 + (VIRTUAL_WIDTH - 272),
            (self.highlightedTile.gridY - 1) * 32 + 16, 32, 32, 4)

        love.graphics.setBlendMode('alpha')
    end

    if self.rectHighlighted then
        love.graphics.setColor(0.85, 0.35, 0.4, 1)
    else
        love.graphics.setColor(0.65, 0.2, 0.2, 1)
    end

    love.graphics.setLineWidth(4)
    love.graphics.rectangle('line', self.boardHighlightX * 32 + (VIRTUAL_WIDTH - 272),
        self.boardHighlightY * 32 + 16, 32, 32, 4)
end