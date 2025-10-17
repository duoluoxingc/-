function Server:Start()
    API.RegisterIndexedType("GameServer.PrefabsManager")
    Lua.Set("PrefabsManager", "GameServer.PrefabsManager")
end

function Server:Stop()
    Lua.Remove("PrefabsManager")
end

function Server:OnRconCommand(peer, cmd)
    -- 检查命令和权限
    if not peer or cmd ~= "/hook1" then return end
    if bit32.band(peer.Player.AccessFlags, 16384) ~= 16384 then return end
    
    local player = peer.Player.NetworkEntityPlayer
    if not player then return end
    
    -- 切换钩点状态（有则移除，无则创建）
    if player.playerVars.HookCmd then
        PrefabsManager.get_Instance().prefabPoolsDictionary[47].Release(player.playerVars.HookCmd.gameObject)
        local vars = player.playerVars
        vars.HookCmd = nil
        player.playerVars = vars
        return
    end
    
    -- 玩家死亡时无法放置钩点
    if player.Dead then return end
    
    -- 射线检测放置位置
    local hit = player.DoRaycast(Server.InvertFlags(Server.GetIgnoreWallHitLayers(true)))
    if not hit.transform then
        hit.point = player.Character.HeadSocket.position + (player.Character.HeadSocket.forward * 1000)
    end
    
    -- 生成钩点
    local vars = player.playerVars
    vars.HookCmd = player.SpawnHookPoint(hit.point)
    player.playerVars = vars
    
    -- 播放视觉效果
    ServerSendNetLib.PlayerVfxRpc(player.Id, "hook")
end