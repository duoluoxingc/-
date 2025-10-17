-- 一键切换阵营脚本
function Server:OnRconCommand(p, cmd)
    -- 检查玩家和命令有效性
    if not p or not p.Player then return end
    
    -- 处理切换阵营命令
    if cmd == "/q" then
        local player = p.Player.NetworkEntityPlayer
        
        -- 切换阵营（Terrorist=true为恐怖分子，false为反恐精英）
        player.Terrorist = not player.Terrorist
        
        -- 显示切换结果
        local team = player.Terrorist and "恐怖分子" or "反恐精英"
        ServerSendNetLib.EventMessage(p, "阵营切换", "已切换到 " .. team, 0,
            Color32(0,0,0,180), Color32(255,192,203,255), "", 0, 5)
    end
end