GameOverState = Class{ __includes = BaseState }

function GameOverState:enter(params)
    self.score = params.score 
end

function GameOverState:init()

end

function GameOverState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        stateMachine:change('start')
    end
end

function GameOverState:draw()
    love.graphics.setFont(fonts['large'])

    love.graphics.setColor(0.2, 0.2, 0.2, 0.9)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 64, 64, 128, 136, 4)

    love.graphics.setColor(0.4, 0.6, 1, 1)
    love.graphics.printf('GAME OVER', VIRTUAL_WIDTH / 2 - 64, 64, 128, 'center')
    love.graphics.setFont(fonts['medium'])
    love.graphics.printf('Your Score: ' .. tostring(self.score), VIRTUAL_WIDTH / 2 - 64, 140, 128, 'center')
    love.graphics.printf('Press Enter', VIRTUAL_WIDTH / 2 - 64, 180, 128, 'center')
end