StartState = Class{ __includes = BaseState }

local positions = {}

function StartState:init()
    self.currentMenuItem = 1

    self.colors = {
        [1] = {0.85, 0.35, 0.4, 1},
        [2] = {95, 0.8, 0.9, 1},
        [3] = {1, 0.95, 0.5, 1},
        [4] = {0.45, 0.25, 0.5, 1},
        [5] = {0.6, 0.9, 0.35, 1},
        [6] = {0.9, 0.45, 0.15, 1}
    }

    self.letterTable = {
        {'M', -108},
        {'A', -64},
        {'T', -28},
        {'C', 2},
        {'H', 40},
        {'3', 112}
    }

    self.colorTimer = Timer.every(0.075, function()
        self.colors[0] = self.colors[6]

        for i = 6, 1, -1 do
            self.colors[i] = self.colors[i - 1]
        end
    end)

    for i = 1, 64 do
        table.insert(positions, frames['tiles'][math.random(18)][math.random(6)])
    end

    self.transitionAlpha = 0

    self.pauseInput = false
end

function StartState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
    
    if not self.pauseInput then
        if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
            self.currentMenuItem = self.currentMenuItem == 1 and 2 or 1
            sounds['select']:play()
        end
        if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
            if self.currentMenuItem == 1 then
                Timer.tween(1, {
                    [self] = {transitionAlpha = 255}
                }):finish(function()
                    stateMachine:change('beginGame', {
                        level = 1
                    })
                    self.colorTimer:remove()
                end)
            else
                love.event.quit()
            end
            self.pauseInput = true
        end
    end
    Timer.update(dt)
end

function StartState:draw()
    for y = 1, 8 do
        for x = 1, 8 do
            love.graphics.setColor(0, 0, 0, 1)
            love.graphics.draw(textures['main'], positions[(y - 1) * x + x], 
                (x - 1) * 32 + 128 + 3, (y - 1) * 32 + 16 + 3)

            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.draw(textures['main'], positions[(y - 1) * x + x], 
                (x - 1) * 32 + 128, (y - 1) * 32 + 16)
        end
    end

    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

    self:drawMatch3Text(-60)
    self:drawOptions(12)

    love.graphics.setColor(1, 1, 1, self.transitionAlpha)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end

function StartState:drawMatch3Text(y)
    love.graphics.setColor(1, 1, 1, 0.5)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 76, VIRTUAL_HEIGHT / 2 + y - 11, 150, 58, 6)

    love.graphics.setFont(fonts['large'])
    self:drawTextShadow('MATCH 3', VIRTUAL_HEIGHT / 2 + y)

    for i = 1, 6 do
        love.graphics.setColor(self.colors[i])
        love.graphics.printf(self.letterTable[i][1], 0, VIRTUAL_HEIGHT / 2 + y,
            VIRTUAL_WIDTH + self.letterTable[i][2], 'center')
    end
end

function StartState:drawOptions(y)
    love.graphics.setColor(1, 1, 1, 0.5)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 76, VIRTUAL_HEIGHT / 2 + y, 150, 58, 6)

    love.graphics.setFont(fonts['medium'])
    self:drawTextShadow('Start', VIRTUAL_HEIGHT / 2 + y + 8)
    
    if self.currentMenuItem == 1 then
        love.graphics.setColor(0.4, 0.6, 1, 1)
    else
        love.graphics.setColor(0.2, 0.4, 0.5, 1)
    end
    
    love.graphics.printf('Start', 0, VIRTUAL_HEIGHT / 2 + y + 8, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(fonts['medium'])
    self:drawTextShadow('Quit Game', VIRTUAL_HEIGHT / 2 + y + 33)
    
    if self.currentMenuItem == 2 then
        love.graphics.setColor(99, 155, 1, 1)
    else
        love.graphics.setColor(48, 0.4, 0.5, 1)
    end
    
    love.graphics.printf('Quit Game', 0, VIRTUAL_HEIGHT / 2 + y + 33, VIRTUAL_WIDTH, 'center')
end

function StartState:drawTextShadow(text, y)
    love.graphics.setColor(0.12, 0.12, 0.2, 1)
    love.graphics.printf(text, 2, y + 1, VIRTUAL_WIDTH, 'center')
    love.graphics.printf(text, 1, y + 1, VIRTUAL_WIDTH, 'center')
    love.graphics.printf(text, 0, y + 1, VIRTUAL_WIDTH, 'center')
    love.graphics.printf(text, 1, y + 2, VIRTUAL_WIDTH, 'center')
end