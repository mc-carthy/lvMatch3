StartState = Class{ __includes = BaseState }

function StartState:init()

end

function StartState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        stateMachine:change('play')
    end
end

function StartState:draw()

end