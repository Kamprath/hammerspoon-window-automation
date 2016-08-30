local MoveWindow = require('modules/MoveWindow')
local WebView = require('modules/WebView')
local UrlActions = require('modules/UrlActions')
local ShowJoe = require('modules/ShowJoe')
local AppWindowManager = require('modules/AppWindowManager')

-- require('osx-troll-client/App.lua'
-- TrollClient = App

WebView:init()
UrlActions:init()
ShowJoe:init()
AppWindowManager:init()
-- TrollClient:init()