BeginGameState = Class{ __includes = BaseState }

function BeginGameState:init()
    self.transitionAlpha = 1

    self.board = Board(VIRTUAL_WIDTH - 272, 16)

    self.levelLabelY = -64
end

function BeginGameState:enter()
    Timer.tween(1, {
        [self] = {transitionAlpha = 0}
    })
    :finish(function()
        Timer.tween(0.25, {
            [self] = {levelLabelY = VIRTUAL_HEIGHT / 2 - 8}
        })
        :finish(function()
            Timer.after(1, function()
                Timer.tween(0.25, {
                    [self] = {levelLabelY = VIRTUAL_HEIGHT + 30}
                })
                :finish(function()
                    stateMachine:change('play')
                end)
            end)
        end)
    end)
end

function BeginGameState:update(dt)
    Timer.update(dt)
end

function BeginGameState:draw()
    self.board:draw()

    love.graphics.setColor(0.4, 0.8, 0.9, 0.8)
    love.graphics.rectangle('fill', 0, self.levelLabelY - 8, VIRTUAL_WIDTH, 48)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(fonts['large'])
    love.graphics.printf('Level ' .. tostring(self.level),
        0, self.levelLabelY, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(1, 1, 1, self.transitionAlpha)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end