local lastTime = 0

function Server:GameTick()
    -- 每0.5秒更新一次坐标显示
    if os.clock() - lastTime < 1 then return end
    lastTime = os.clock()
    
    -- 为所有玩家显示当前位置坐标
    for _, peer in pairs(Server.playerSessions) do
        if peer and peer.Player then
            local player = peer.Player.NetworkEntityPlayer
            if player and not player.Dead then
                -- 获取玩家头部位置坐标
                local pos = player.Character.HeadSocket.position
                local coordText = string.format("坐标: X=%.1f Y=%.1f Z=%.1f", pos.x, pos.y, pos.z)
                
                -- 发送坐标信息到玩家屏幕
                ServerSendNetLib.EventMessage(
                    peer, 
                    "位置", 
                    coordText, 
                    0, 
                    Color32(0, 0, 0, 180), 
                    Color32(255, 192, 203, 255), 
                    "", 
                    1, 
                    0.5,
                    0, -200
                )
            end
        end
    end
end