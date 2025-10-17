-- 帮助命令配置
local C = {
    cmd = "/cd",
    t1 = "输入/商店 打开投掷物商店",
    t2 = "输入/sd得255沙袋 输入/jg得1激光陷阱 输入/mj得防毒面具",
    t3 = "输入/wx得无限子弹 每把枪输入一次",
    c = "#FFC0CB",  -- 文字颜色（粉色）
    d = 5       -- 显示时长（秒）
}

-- 处理帮助命令
function Server:OnRconCommand(p,c)
    if p and p.Player and c==C.cmd then
        -- 显示三条帮助信息
        RconCommands.EventCmd(nil, string.format("\"%s\" \"<color=%s>%s</color>\" \"0\" \"\" \"\" \"\" \"0\" \"%d\"", "功能1",C.c,C.t1,C.d))
        RconCommands.EventCmd(nil, string.format("\"%s\" \"<color=%s>%s</color>\" \"0\" \"\" \"\" \"\" \"0\" \"%d\"", "功能2",C.c,C.t2,C.d))
        RconCommands.EventCmd(nil, string.format("\"%s\" \"<color=%s>%s</color>\" \"0\" \"\" \"\" \"\" \"0\" \"%d\"", "功能3",C.c,C.t3,C.d))
    end
end