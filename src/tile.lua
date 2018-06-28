Tile = Class{}

function Tile:init(x, y, color, variety)
    self.gridX = x
    self.gridY = y

    self.x = (self.gridX - 1) * 32
    self.y = (self.gridY - 1) * 32

    self.color = color
    self.variety = variety
end

function Tile:update(dt)

end

function Tile:swap(tile)

end

function Tile:draw(x, y)
    love.graphics.setColor(0.12, 0.12, 0.2, 1)
    love.graphics.draw(textures['main'], frames['tiles'][self.color][self.variety],
        self.x + x + 2, self.y + y + 2)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(textures['main'], frames['tiles'][self.color][self.variety],
        self.x + x, self.y + y)
end