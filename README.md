# LeaksDefender: Protect your game's memory in a single module!

Have you ever experienced lag when playing some games for a long time? Or the game your developing seems to be too laggy?
This module will help you prevent them!

----------------------------------------------------------------------------------------------------------------------------------------------------------

[INTRODUCTION]:
    - As you may know, using too many connections and not disconencting them when you don't need will cause the memory usage to goes up!
    From that it can cause performance effects and will affects user experiences! LeaksDefender is a module which stores RBXScriptSignal and RBXScriptConnection in a cache, later will disconnect and clear all of them when they are no more needed! So later you don't have to struggle to find a way to garbage collecting them!
    LeaksDefender can be used on tools, instances, functions, and even classes!

[INSTRUCTION_API]:
    This module works the exact same way as Janitor, Maid or any other helper modules. We start off by creating a [LeaksDefender] object:

    local leakModule = require(pathname.LeaksDefender).new(event: RBXScriptSignal)

    - event (optional): This will be the default event for the object, if the event fires, it will trigger the DisconnectAll() method to clear all events
    Now we would like to add some events for it:

    leakModule:Add({
        Instance.new("Part", workspace).Touched:Connect(function()
            print("touched")
        end),
        humanoid.Running:Connect(someCallback)
    })

    The method takes 1 parameter is the table contains all events you would like to add (this can also be your workspace to work with events too!)

    To remove all the connections simply call the method DisconnectAll():

    leakModule:DisconnectAll()

[NOTES]: This module is new, except not-existing methods that are needed
[CONTRIBUTE]: All contributions are all appreciated to improve this module

[LICENSE]: Under MIT license
