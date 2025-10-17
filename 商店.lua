local ShopItems = {
    {"/1", 100, 29, "冰冻雷"},
    {"/2", 300, 28, "雪球"}, 
    {"/3", 500, 31, "燃烧瓶"}
}

function Server:OnRconCommand(p, cmd)
    if not (p and p.Player) then return end
    
    if cmd == "/商店" then
        for i, v in ipairs(ShopItems) do
            RconCommands.EventCmd(nil, string.format("\"商品%d\" \"<color=#FFC0CB>%s %s<color=#aa1>(%d$)\" \"0\" \"\" \"\" \"\" \"0\" \"8\"", i, v[1], v[4], v[2]))
        end
        return
    end
    
    for _, v in ipairs(ShopItems) do
        if cmd == v[1] then
            if p.Player.Money < v[2] then
                ServerSendNetLib.EventMessage(p, "购买失败", "钱不够！需" .. v[2] .. "$", 0, 
                    Color32(255,0,0,255), Color32(255,0,0,255), "", 0, 3)
            else
                p.Player.NetworkEntityPlayer.SignificantMoneyChange(-v[2], true)
                RconCommands.GiveCmd(nil, p.Player.Id .. " " .. v[3])
            end
            return
        end
    end
end