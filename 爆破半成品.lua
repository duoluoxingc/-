-- C4爆破脚本
local bombData = {
    isPlanting = false,   -- 是否正在安放炸弹
    isPlanted = false,    -- 炸弹是否已安放
    isDefusing = false,   -- 是否正在拆包
    plantStart = 0,       -- 安放开始时间
    bombStart = 0,        -- 炸弹开始时间
    defuseStart = 0       -- 拆包开始时间
}

function Server:OnRconCommand(p, cmd)
    if not p then return end
    
    local player = p.Player.NetworkEntityPlayer
    if not player then return end
    
    -- 下包命令处理
    if cmd == "/下包" then
        -- 检查是否为T阵营
        if not player.Terrorist then
            ServerSendNetLib.EventMessage(p, "错误", "只有T阵营才能安放炸弹!", 0, 
                Color32(255,0,0,255), Color32(255,255,255,255), "", 0, 3)
            return
        end
        
        if bombData.isPlanted then
            ServerSendNetLib.EventMessage(p, "错误", "炸弹已安放!", 0, 
                Color32(255,0,0,255), Color32(255,255,255,255), "", 0, 3)
            return
        end
        
        -- 检查是否已经有人在安放
        if bombData.isPlanting then
            ServerSendNetLib.EventMessage(p, "错误", "已经有人在安放炸弹!", 0, 
                Color32(255,0,0,255), Color32(255,255,255,255), "", 0, 3)
            return
        end
        
        bombData.isPlanting = true
        bombData.plantStart = os.clock()
        
        ServerSendNetLib.EventMessage(p, "下包中", "正在下包...5秒后完成", 0, 
            Color32(255,255,0,255), Color32(255,255,255,255), "", 0, 5)
    end
    
    -- 拆包命令处理
    if cmd == "/拆包" then
        -- 检查炸弹是否已安放
        if not bombData.isPlanted then
            ServerSendNetLib.EventMessage(p, "错误", "没有炸弹需要拆除!", 0, 
                Color32(255,0,0,255), Color32(255,255,255,255), "", 0, 3)
            return
        end
        
        -- 检查是否为CT阵营
        local player = p.Player.NetworkEntityPlayer
        if player and player.Terrorist then
            ServerSendNetLib.EventMessage(p, "错误", "只有CT才能拆包!", 0, 
                Color32(255,0,0,255), Color32(255,255,255,255), "", 0, 3)
            return
        end
        
        -- 检查是否已经有人在拆包
        if bombData.isDefusing then
            ServerSendNetLib.EventMessage(p, "错误", "已经有人在拆包!", 0, 
                Color32(255,0,0,255), Color32(255,255,255,255), "", 0, 3)
            return
        end
        
        bombData.isDefusing = true
        bombData.defuseStart = os.clock()
        
        ServerSendNetLib.EventMessage(p, "拆包中", "正在拆包...10秒后完成", 0, 
            Color32(0,255,0,255), Color32(255,255,255,255), "", 0, 5)
    end
end

function Server:GameTick()
    local currentTime = os.clock()
    
    -- 处理下包过程
    if bombData.isPlanting then
        if currentTime - bombData.plantStart >= 5 then
            bombData.isPlanting = false
            bombData.isPlanted = true
            bombData.bombStart = currentTime
            
            -- 通知所有玩家炸弹已安放
            for _, peer in pairs(Server.playerSessions) do
                ServerSendNetLib.EventMessage(peer, "炸弹已安放", "炸弹已安放! 90秒后爆炸", 0, 
                    Color32(255,0,0,255), Color32(255,255,255,255), "", 0, 5)
            end
        end
    end
    
    -- 处理拆包过程
    if bombData.isDefusing then
        if currentTime - bombData.defuseStart >= 10 then
            bombData.isDefusing = false
            bombData.isPlanted = false
            
            RconCommands.GameOverCmd(nil)
            
            -- 通知所有玩家拆包成功
            for _, peer in pairs(Server.playerSessions) do
                ServerSendNetLib.EventMessage(peer, "拆包成功", "CT方胜利!", 0, 
                    Color32(0,255,0,255), Color32(255,255,255,255), "", 0, 5)
            end
        end
    end
    
    -- 处理炸弹倒计时
    if bombData.isPlanted then
        local timeLeft = 90 - (currentTime - bombData.bombStart)
        
        -- 最后10秒显示倒计时
        if timeLeft <= 10 and timeLeft > 0 then
            if math.floor(timeLeft) ~= math.floor(timeLeft + 0.1) then
                for _, peer in pairs(Server.playerSessions) do
                    ServerSendNetLib.EventMessage(peer, "炸弹倒计时", string.format("剩余: %d秒", math.floor(timeLeft)), 0, 
                        Color32(255,0,0,255), Color32(255,255,255,255), "", 0, 1)
                end
            end
        end
        
        -- 倒计时结束
        if timeLeft <= 0 then
            bombData.isPlanted = false
            bombData.isDefusing = false
            
            RconCommands.GameOverCmd(nil)
            
            -- 通知所有玩家炸弹爆炸
            for _, peer in pairs(Server.playerSessions) do
                ServerSendNetLib.EventMessage(peer, "炸弹爆炸", "T方胜利!", 0, 
                    Color32(255,0,0,255), Color32(255,255,255,255), "", 0, 5)
            end
        end
    end
end