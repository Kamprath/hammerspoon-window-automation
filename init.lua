local MoveWindow = require('modules/MoveWindow')
local Dashboard = require('modules/Dashboard')
local UrlActions = require('modules/UrlActions')
local ShowJoe = require('modules/ShowJoe')
local AppWindowManager = require('modules/AppWindowManager')

-- require('osx-troll-client/App.lua'
-- TrollClient = App

Dashboard:init()
UrlActions:init()
ShowJoe:init()
AppWindowManager:init()
-- TrollClient:init()