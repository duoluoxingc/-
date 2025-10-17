-- 道具配置表：数量、ID、属性名、提示消息
local items = {
    ["/sd"] = {255, 14, "SandBagsCount", "已获得255个沙袋"},
    ["/mj"] = {1, 15, "GasMasksCount", "已获得1个防毒面具"},
    ["/jg"] = {64, 13, "LaserMinesCount", "已获得1个激光地雷"},
}

-- 处理玩家指令
function Server:OnRconCommand(p, cmd)
    if not p then return end
    
    local item = items[cmd]
    if item then
        -- 增加玩家道具数量
        p.Player[item[3]] = p.Player[item[3]] + item[1]
        -- 同步道具到客户端
        ServerSendNetLib.ShopItemBought(p, item[2])
        
        -- 发送提示消息
        ServerSendNetLib.EventMessage(
            p, "INFO", item[4], 0,
            Color32(255,105,180,255),
            Color32(255,182,193,255),
            "", 0, 10
        )
    end
end