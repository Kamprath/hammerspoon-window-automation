--- Binds URL events and calls handlers.
-- @module UrlEvents

--- URLs mapped to handler functions.
-- @table events
local events = {
    log = require('events/log'),
    notify = require('events/notify')
}

return {
    --- Bind events to handlers.
    bind = function()
        for event, func in pairs(events) do
            hs.urlevent.bind(event, func)
        end
    end,

    --- Trigger a URL event.
    -- @param self
    -- @param event Event name
    trigger = function(event)
        hs.urlevent.openURL('hammerspoon://' .. event)
    end
}