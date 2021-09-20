local log = require("log")
local kb = libs.keyboard
local win = libs.win

local WM_COMMAND = 0x0111

local CM_FULLSCREEN = 137
local CM_SWITCHAUDIO = 145
local CM_PROGRAMGUIDE = 204
local CM_CHANNELDISPLAY = 225
local CM_ACTIVATE = 233
local CM_SERVICE_FIRST = 5000

local service = 0

-- @help TVTestを起動またはアクティベートする
actions.launch = function()
    if actions.activate() == 0 then
        local path = settings.path
        if path ~= "" then
            os.start(path)
        end
    end
end

-- @help TVTestメインウィンドウのハンドルを返す
actions.hwnd = function()
    return win.find("TVTest Window", nil)
end

-- @help TVTestメインウィンドウにコマンドを送信してウィンドウハンドルを返す
actions.command = function(cmd)
    log.trace("command(" .. cmd .. ")")
    local hwnd = actions.hwnd()
    if hwnd ~= 0 then
        win.send(hwnd, WM_COMMAND, cmd, 0)
    end
    return hwnd
end

-- @help TVTestメインウィンドウをアクティベートする
actions.activate = function()
    return actions.command(CM_ACTIVATE)
end

-- @help TVTestメインウィンドウにキーを送信する
actions.stroke = function(key)
    log.trace("stroke(" .. key .. ")")
    if actions.activate() ~= 0 then
        kb.stroke(key)
    end
end

-- @help チャンネル選択画面を表示する
actions.channeldisplay = function()
    actions.command(CM_CHANNELDISPLAY)
end

-- @help サービス1～4を切り替える
actions.service = function()
    service = (service + 1) % 4
    actions.command(CM_SERVICE_FIRST + service)
end

-- @help 音声切替
actions.switchaudio = function()
    actions.command(CM_SWITCHAUDIO)
end

-- @help EPG番組表
actions.epg = function()
    actions.command(CM_PROGRAMGUIDE)
end

-- @help 全画面表示
actions.fullscreen = function()
    actions.command(CM_FULLSCREEN)
end
