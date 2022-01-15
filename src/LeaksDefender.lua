local leak = {}
leak.__index = leak

function leak.new(event: RBXScriptSignal)
    local self = setmetatable({
        DefaultEvent = event;
        Events = {}
    }, leak)
    self:Add({
        self.DefaultEvent and self.DefaultEvent:Connect(function()
            return self:DisconnectAll()
        end) or nil
    })
    return self
end

function leak:Add(t: {RBXScriptConnection})
    for _, events: RBXScriptConnection in pairs(t) do
        table.insert(self.Events, events)
    end
end

function leak:DisconnectAll()
    for _, events: RBXScriptConnection in pairs(self.Events) do
        events:Disconnect()
        events = nil
    end
    return table.clear(self.Events)
end

return leak