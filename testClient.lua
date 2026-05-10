-- Ensure CC-Remote
--local CCRemoteUrl = ""
local Client = {}
local success, result = pcall(function()
    Client = require("lib/RemoteClient")
end)
if not success then
    fs.makeDir("lib")
    --shell.execute("wget", CCRemoteUrl, "lib/Client")
    --GUI = require("lib/Client")
    error("Client lib not found")
end

-- Configure client
local wrappedPeripheral = peripheral.wrap("back")
local serverId = 7
local serverPort = 1000
local responsePort = 1001
Client:init(wrappedPeripheral, serverId, serverPort, responsePort)
print("This computer's ID: " .. Client.id)
-- Configure heartbeat
local heartbeatInterval = 5
Client:heartbeat()
os.startTimer(heartbeatInterval)

-- Main loop
while true do
    event = {os.pullEvent()}
    Client:handleEvent(event)
    if event[1] == "timer" then
        Client:heartbeat()
        os.startTimer(heartbeatInterval)
    end
end
