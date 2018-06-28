Board = Class{}

function Board:init(x, y)
    self.x = x
    self.y = y
    self.matches = {}

    self:initializeTiles()
end

function Board:initializeTiles()
    self.tiles = {}

    for tileY = 1, 8 do
        table.insert(self.tiles, {})
        for tileX = 1, 8 do
            table.insert(self.tiles[tileY], Tile(tileX, tileY, math.random(18), math.random(6)))
        end
    end
end

function Board:draw()
    for y = 1, #self.tiles do
        for x = 1, #self.tiles[1] do
            self.tiles[y][x]:draw(self.x, self.y)
        end
    end
end