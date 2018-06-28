Push = require('src.lib.push')
Timer = require 'src.lib.timer'
Class = require('src.lib.class')
require('src.lib.stateMachine')
require('src.utils.utils')
require('src.utils.constants')
require('src.states.baseState')
require('src.states.startState')
require('src.states.playState')

sounds = {
    ['music'] = love.audio.newSource('assets/audio/music3.mp3', 'static'),
    ['select'] = love.audio.newSource('assets/audio/select.wav', 'static'),
    ['error'] = love.audio.newSource('assets/audio/error.wav', 'static'),
    ['match'] = love.audio.newSource('assets/audio/match.wav', 'static'),
    ['clock'] = love.audio.newSource('assets/audio/clock.wav', 'static'),
    ['game-over'] = love.audio.newSource('assets/audio/game-over.wav', 'static'),
    ['next-level'] = love.audio.newSource('assets/audio/next-level.wav', 'static')
}

fonts = {
    ['small'] = love.graphics.newFont('assets/fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('assets/fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('assets/fonts/font.ttf', 32)
}