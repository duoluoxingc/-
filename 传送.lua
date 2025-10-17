function Server:OnRconCommand(p, cmd)
    -- 检查是否为传送命令和管理员权限
    if p and p.Player and cmd == "/tp" then
        -- 检查管理员权限 (hook权限标志位)
        if bit32.band(p.Player.AccessFlags, 16384) ~= 16384 then return end
        
        -- 获取玩家实体
        local player = p.Player.NetworkEntityPlayer
        
        -- 进行射线检测，获取目标位置
        local hit = player.DoRaycast(Server.InvertFlags(Server.GetIgnoreWallHitLayers(true)))
        
        -- 计算传送位置：如果射线命中则使用命中点，否则使用玩家前方1500单位的位置
        local targetPos = hit.transform and hit.point or 
                         (player.Character.HeadSocket.position + player.Character.HeadSocket.forward * 1500)
        
        -- 播放传送特效
        ServerSendNetLib.PlayerVfxRpc(player.Id, "teleport")
        ServerSendNetLib.EffectRpc(targetPos, 1, player.Id)
        
        -- 执行传送
        player.transform.position = targetPos
    end
end