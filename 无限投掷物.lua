-- 物品发放配置：{ID,间隔}
config = {{25,0.1},{26,5},{27,0.1}}

function Server:Start()
    -- 为每个物品创建发放协程
    for _,v in ipairs(config) do
        Coroutine(function()
            RconCommands.GiveCmd(nil,"all "..v[1])  -- 给所有玩家物品
            return v[2]  -- 返回间隔时间
        end)
    end
end