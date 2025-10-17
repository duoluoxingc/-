function Server:OnRconCommand(p, cmd)
    if p and p.Player and cmd == "/星野和樱" then
        p.Player.NetworkEntityPlayer.SignificantMoneyChange(50000, true)
    end
end