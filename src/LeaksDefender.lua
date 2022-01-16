local leak = {}
leak.__index = leak

type Function = {callback: Function}

function leak.new(event: RBXScriptSignal)
    local self = setmetatable({
        DefaultEvent = event;
        Events = {}
    }, leak)
    self:Add({
        dfe = {self.DefaultEvent ~= nil and self.DefaultEvent or nil, (function()
            return self:DisconnectAll()
        end)}
    })
    return self
end

function leak:GetAvailableEvents()
    local i = 0
    for key, _ in pairs(self.Events) do
        i += 1
        print(i, key.." event")
    end
    i = nil
end

function leak:Add(t: {RBXScriptSignal: Function})
    for key: string, events: {RBXScriptSignal: Function} in pairs(t) do
         self.Events[key] = {events[1], events[1] ~= nil and type(events[2]) == "function" and events[1]:Connect(events[2])}
    end
end

function leak:Disconnect(name: string, removal: any?)
    local event: {RBXScriptSignal: RBXScriptConnection} = self.Events[name]
    if not event then
        return warn(string.format("Event \"%s\" is not exists!", name))
    end
    if event[2] then event[2]:Disconnect() end
    event[2] = nil
    if removal then
        event[1] = nil
        self.Events[name] = nil
    end
end

function leak:Reconnect(name: string, callback: Function)
    assert(type(callback) == "function", "Missing callback function or not a valid function!")

	local event: {RBXScriptSignal: RBXScriptConnection} = self.Events[name]
    if event == nil then
        return warn(string.format("Event \"%s\" is not found!", name))
    end
    event[2] = event[1]:Connect(callback)
end

function leak:DisconnectAll()
    for key: string, events: {RBXScriptSignal: RBXScriptConnection} in pairs(self.Events) do
        if events[2] then events[2]:Disconnect() end
        events[2] = nil
        events[1] = nil
        self.Events[key] = nil
    end
    return table.clear(self.Events)
end

return leak