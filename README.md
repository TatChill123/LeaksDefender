# LeaksDefender: Protect your game's memory in a single module!

Have you ever experienced lag when playing some games for a long time? Or the game your developing seems to be too laggy?
This module will help you prevent them!

----------------------------------------------------------------------------------------------------------------------------------------------------------

[INTRODUCTION]:
    - As you may know, using too many connections and not disconencting them when you don't need will cause the memory usage to goes up!
    From that it can cause performance effects and will affects user experiences! LeaksDefender is a module which stores RBXScriptSignal and RBXScriptConnection in a cache, later will disconnect and clear all of them when they are no more needed! So later you don't have to struggle to find a way to garbage collecting them!
    LeaksDefender can be used on tools, instances, functions, and even classes!

[INSTRUCTION_API]:
    - This module works the exact same way as other libraries. We start off by creating a [LeaksDefender] object:

    local leakModule = require(pathname.LeaksDefender).new(event: RBXScriptSignal)


- event (optional): This will be the default event for the object, if the event fires, it will trigger the DisconnectAll() method to clear all events
Now we would like to add some events for it:


    leakModule:Add({
        obbyTouch = {Instance.new("Part", workspace).Touched, (function()
            print("touched")},
        end),
        playerDeath = {humanoid.Running, someCallback}
    })


- The method takes 1 parameter is the table contains all events you would like to add, each event will contain another table to store the event itself, and a function use to be its callback (this can also be your workspace to work with events too!)
- You need to remove an event? Let's use the Disconnect() method:


    leakModule:Disconnect(name: string, removal: number)


- name: Use to search inside the list to find the specific event, return nil if not exists
- removal (optional): Use to remove the event entirely from the list (leave empty if you don't want to)

    Wait, that's my mistake! I want to reconnect it! Don't worry, you can use Reconnect() method:


    leakModule:Reconnect(name: string, callback: function)


- name: The event's name
- callback (require): The function you want it to connect to (missing this will cause an error)

- To see all available events, use the GetAvailableEvents() method:
    
    leakModule:GetAvailableEvents()

    - To remove all the connections simply call the method DisconnectAll():

    leakModule:DisconnectAll()

[NOTES]: This module is new, except non-existing methods

[CONTRIBUTE]: All contributions are all appreciated to improve this module

[LICENSE]: Under MIT license
