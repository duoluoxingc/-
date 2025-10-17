-- 公告配置
local cfg = {
    text = "[公告]/cd 查看本房功能",
    color = Color32(255,192,203,255),
    bg = Color32(0,0,0,200),
    time = 25
}

local lastTime = 0

-- 新玩家加入时显示公告
function Server:OnPlayerJoined(p)
    ServerSendNetLib.EventMessage(p.PlayerNetPeer,"",cfg.text,0,cfg.bg,cfg.color,"",1001,cfg.time,0,0,0,0,0,0,20)
end

-- 服务器启动时给所有玩家显示公告
function Server:Start()
    for _,v in pairs(Server.playerSessions) do
        ServerSendNetLib.EventMessage(v,"",cfg.text,0,cfg.bg,cfg.color,"",1001,cfg.time,0,0,0,0,0,0,20)
    end
end

-- 每30秒重发公告
function Server:GameTick()
    if os.time() - lastTime >= 28 then
        lastTime = os.time()
        for _,v in pairs(Server.playerSessions) do
            ServerSendNetLib.EventMessage(v,"",cfg.text,0,cfg.bg,cfg.color,"",1001,cfg.time,0,0,0,0,0,0,20)
        end
    end
end