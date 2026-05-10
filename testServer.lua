-- Ensure GUI
--  CC-GUI is used for the button rendering and click event handling 
local GUI = {}
local CCGUIUrl = "https://raw.githubusercontent.com/LD-Reborn/CC-GUI/refs/heads/main/GUI.lua"
local success, result = pcall(function()
    GUI = require("lib/GUI")
end)
if not success then
    fs.makeDir("lib")
    shell.execute("wget", CCGUIUrl, "modules/GUI")
    GUI = require("modules/GUI")
end

-- Ensure CC-Remote
--local CCRemoteUrl = ""
local Server = {}
local success, result = pcall(function()
    Server = require("lib/RemoteServer")
end)
if not success then
    fs.makeDir("lib")
    --shell.execute("wget", CCRemoteUrl, "lib/Server")
    --GUI = require("lib/RemoteServer")
    error("Server lib not found")
end
local wrappedPeripheral = peripheral.wrap("back")
local listenPort = 1000
Server:init(wrappedPeripheral, listenPort)

-- Functions and definitions
local remoteLightComputerId = "spawner_zombie"

function toggleRemoteLight(param)
    id = param.id
    state = param.state
    code = 'redstone.setOutput("bottom", state)'
    params = {state = state}
    Server:sendRequest(remoteLightComputerId, code, params, nil)
end

term.clear()

buttonsToggleRemoteLight = GUI.createButton("flash remote", 10, 7, 15, 5, colors.white, colors.blue, colors.white, colors.green)
buttonsToggleRemoteLight.onClick = toggleRemoteLight
buttonsToggleRemoteLight.toggle = true

GUI.drawAll()

-- Main loop
while true do
    --GUI.drawAll()
    event = {os.pullEvent()}
    GUI.handleEvent(event)
    Server:handleEvent(event)
end
