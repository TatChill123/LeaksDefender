-- LeaksDefender (made by TatChill)
-- All rights reserved
-- GitHub repo: https://github.com/TatChill123/LeaksDefender

type Function = {callback: Function}

local EVENT_NOT_FOUND: string = "Event \"%s\" is not found!"
local MISSING_ARGUMENT: string = "Argument #2 in %s must be a function, got %s"
local INCORRECT_ARGUMENT: string = "Missing callback function or not a valid type of function!"

local leak = {}
leak.__index = leak

function leak.new(): "Create a new LeaksDefender object."
    return setmetatable({
        Events = {}
    }, leak)
end

function leak:GetAvailableEvents(): "Return the current events table that is being added by the :Add() method."
    return self.Events
end

function leak:Add(t: {eventName: {RBXScriptSignal: Function}}): "Add each event and callback function as a pair, and connect the event to the specified callback."
    for key: string, events: {RBXScriptSignal: Function} in pairs(t) do
        if events[1] == nil then continue end
         self.Events[key] = {events[1], type(events[2]) == "function" and events[1]:Connect(events[2]) or warn(string.format(MISSING_ARGUMENT, key, type(events[2])))}
    end
end

function leak:Disconnect(name: string, removal: any?): "Disconnect an event that is being connected to."
    local event: {RBXScriptSignal: RBXScriptConnection} = self.Events[name]
    if not event then
        return warn(string.format(EVENT_NOT_FOUND, name))
    end
    event[2]:Disconnect()
    event[2] = nil
    if removal then
        event[1] = nil
        self.Events[name] = nil
    end
end

function leak:Reconnect(name: string, callback: Function): "Reconnect an event that is being disconnected."
    assert(type(callback) == "function", INCORRECT_ARGUMENT)

	local event: {RBXScriptSignal: RBXScriptConnection} = self.Events[name]
    if not event then
        return warn(string.format(EVENT_NOT_FOUND, name))
    end
    event[2] = event[1]:Connect(callback)
end

function leak:DisconnectAll(): "Disconnect all events and remove them from the events table."
    for key: string, events: {RBXScriptSignal: RBXScriptConnection} in pairs(self.Events) do
        events[2]:Disconnect()
        events[2] = nil
        events[1] = nil
        self.Events[key] = nil
    end
    return table.clear(self.Events)
end

return leak
