Push = require('src.lib.push')
Timer = require('src.lib.timer')
Class = require('src.lib.class')
require('src.lib.stateMachine')
require('src.utils.utils')
require('src.utils.constants')
require('src.board')
require('src.tile')
require('src.states.baseState')
require('src.states.startState')
require('src.states.playState')
require('src.states.beginGameState')
require('src.states.gameOverState')

sounds = {
    ['music'] = love.audio.newSource('assets/audio/music3.mp3', 'static'),
    ['select'] = love.audio.newSource('assets/audio/select.wav', 'static'),
    ['error'] = love.audio.newSource('assets/audio/error.wav', 'static'),
    ['match'] = love.audio.newSource('assets/audio/match.wav', 'static'),
    ['clock'] = love.audio.newSource('assets/audio/clock.wav', 'static'),
    ['gameOver'] = love.audio.newSource('assets/audio/game-over.wav', 'static'),
    ['nextLevel'] = love.audio.newSource('assets/audio/next-level.wav', 'static')
}

fonts = {
    ['small'] = love.graphics.newFont('assets/fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('assets/fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('assets/fonts/font.ttf', 32)
}

textures = {
    ['main'] = love.graphics.newImage('assets/sprites/match3.png'),
    ['background'] = love.graphics.newImage('assets/sprites/background.png')
}

frames = {
    ['tiles'] = GenerateTileQuads(textures['main'])
}