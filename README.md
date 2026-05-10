## CC-Remote
Computercraft-Tweaked utility to remote-control turtles, pocket computers and regular computers of said modpack.

Can be used to get sensor data from remote sensors, or interact with redstone remotely.

## Setup
To install CC-Remote, enter these commands on the server:
```
wget https://raw.githubusercontent.com/LD-Reborn/CC-Remote/refs/heads/main/testServer.lua
mkdir lib
cd lib
wget https://raw.githubusercontent.com/LD-Reborn/CC-Remote/refs/heads/main/lib/RemoteServer.lua
cd ..
```
And this on the client:
```
wget https://raw.githubusercontent.com/LD-Reborn/CC-Remote/refs/heads/main/testClient.lua
mkdir lib
cd lib
wget https://raw.githubusercontent.com/LD-Reborn/CC-Remote/refs/heads/main/lib/RemoteClient.lua
cd ..
```

## Usage
I recommend starting with setting up the client first, as this is straight-forward.
### Client
After installing CC-Remote on the client, I recommend the following steps:
- Set a unique label for the computer (e.g. "spawner_zombie") using the command: `label set yourLabelName`
- To make the client run automatically once the computer starts, rename `testClient.lua` to `startup.lua` using the following command: `mv testClient.lua startup.lua`

Now the client will accept commands and return the results to the server.

At this point you might want to note the ID of the computer, as shown on the screen.
### Server
To make use of CC-Remote in your own scripts you need to follow these steps:
- Import the server library: `Server = require("lib/RemoteServer")`
- Initialize the server with your modem and a port you want to use: `Server:init(wrappedPeripheral, listenPort)`
- In your main loop, where you pull the events (e.g. `event = {os.pullEvent()}`) you need to pass the event to Server like this: `Server:handleEvent(event)`
- Send requests like this: `Server:sendRequest(computerId, code, params, callbackFunction)` where callbackFunction is a function that will be called once the request is responded.

Please refer to `testServer.lua` as a usage example.
## FAQ
### I want to get the value in-line instead of via a callback function. Is that possible?
Only with a workaround. Support for this is planned though.

1. Initialize a temporary global variable: `temporaryAcceptPacketGlobal = []`
2. Set up a function that manipulates the temporary variable:
```lua
function acceptPacket(packet)
    temporaryAcceptPacketGlobal = packet
end
```
3. Send the request
4. In a while loop check for `temporaryAcceptPacketGlobal.result == nil`:
```lua
while temporaryAcceptPacketGlobal.result == nil do
    event = {os.pullEvent("modem_message")}
    Server:handleEvent(event)
    sleep(0.01) -- to prevent unnecessary CPU usage, wait 10 milliseconds
end
```