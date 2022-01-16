local leak = {}
leak.__index = leak

type Function = {callback: Function}

function leak.new(event: RBXScriptSignal)
    local self = setmetatable({
        DefaultEvent = event;
        Events = {}
    }, leak)
    self:Add({
        dfe = self.DefaultEvent and self.DefaultEvent:Connect(function()
            return self:DisconnectAll()
        end) or nil
    })
    return self
end

function leak:Add(t: {RBXScriptConnection})
    for key: string, events: RBXScriptConnection in pairs(t) do
        self.Events[key] = events
    end
end

function leak:Disconnect(name: string, removal: any?)
    local event: RBXScriptConnection = self.Events[name]
    if not event then
        return warn(string.format("Event \"%s\" is not exists!", name))
    end
    event:Disconnect()
    if removal then
        self.Events[name] = nil
    end
end

function leak:Reconnect(name: string, callback: Function)
    assert(type(callback) == "function", "Missing callback function or not a valid function!")
    return self.Events[name] and self.Events[name]:Connect(callback) or warn(string.format("Event \"%s\" is not found!", name))
end

function leak:DisconnectAll()
    for key: string, events: RBXScriptConnection in pairs(self.Events) do
        events:Disconnect()
        self.Events[key] = nil
    end
    return table.clear(self.Events)
end

return leak