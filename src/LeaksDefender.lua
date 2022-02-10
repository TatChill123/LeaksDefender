local leak = {}
leak.__index = leak

type Function = {callback: Function}

function leak.new(): table
    local self = setmetatable({
        Events = {}
    }, leak)
    return self
end

function leak:GetAvailableEvents(): table
    return self.Events
end

function leak:Add(t: {eventName: {RBXScriptSignal: Function}})
    for key: string, events: {RBXScriptSignal: Function} in pairs(t) do
        if events[1] == nil then continue end
         self.Events[key] = {events[1], type(events[2]) == "function" and events[1]:Connect(events[2]) or warn(string.format("Argument #2 in %s must be a function, got %s", key, type(events[2])))}
    end
end

function leak:Disconnect(name: string, removal: any?)
    local event: {RBXScriptSignal: RBXScriptConnection} = self.Events[name]
    if not event then
        return warn(string.format("Event \"%s\" is not found!", name))
    end
    event[2]:Disconnect()
    event[2] = nil
    if removal then
        event[1] = nil
        self.Events[name] = nil
    end
end

function leak:Reconnect(name: string, callback: Function)
    assert(type(callback) == "function", "Missing callback function or not a valid function!")

	local event: {RBXScriptSignal: RBXScriptConnection} = self.Events[name]
    if not event then
        return warn(string.format("Event \"%s\" is not found!", name))
    end
    event[2] = event[1]:Connect(callback)
end

function leak:DisconnectAll()
    for key: string, events: {RBXScriptSignal: RBXScriptConnection} in pairs(self.Events) do
        events[2]:Disconnect()
        events[2] = nil
        events[1] = nil
        self.Events[key] = nil
    end
    return table.clear(self.Events)
end

return leak