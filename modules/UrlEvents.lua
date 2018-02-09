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

    --- Call an event.
    -- @param self
    -- @param event Event name
    call = function(event)
        hs.urlevent.openURL('hammerspoon://' .. event)
    end
}