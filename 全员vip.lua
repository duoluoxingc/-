function Server:OnPlayerJoined(p)
    -- 新玩家自动获得VIP
    if p and p.PlayerNetPeer and p.PlayerNetPeer.Player then
        RconCommands.AddVIPCmd(nil, string.format("\"%s\" \"\" \"\" \"\" \"[VIP]\" \"\" \"\"", p.PlayerNetPeer.Player.username))
    end
end