-- 刷钱指令配置
local CMD = "/刷钱"       -- 触发指令
local MONEY = 65000       -- 刷钱金额
local DURATION = 2        -- 提示显示时长
local BG_COLOR = Color32(255, 182, 193, 255) -- 背景颜色
local TXT_COLOR = Color32(255, 255, 255, 255) -- 文字颜色

-- 玩家输入指令时触发
function Server:OnRconCommand(p, cmd)
    -- 检查指令是否匹配
    if cmd == CMD and p and p.Player then
        -- 给玩家加钱
        p.Player.NetworkEntityPlayer.SignificantMoneyChange(MONEY, true)
        -- 显示提示
        ServerSendNetLib.EventMessage(
            p, 
            "", 
            "😋 " .. MONEY .. " 到账！", 
            4, 
            BG_COLOR, 
            TXT_COLOR, 
            "", 
            0, 
            DURATION
        )
    end
end