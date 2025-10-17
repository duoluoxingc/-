-- 初始化武器系统索引，方便 Lua 快速访问
function Server:Start()
    API.RegisterIndexedType("GameServer.BaseWeapon")
    API.RegisterIndexedType("GameServer.InventoryUtil.Inventory")
    Lua.Set("GameManager", "GameServer.GameManager")
end

-- 武器切换事件（引擎每帧会调用）
function Server:HandleInputs()
    -- 遍历所有在线玩家
    for _, peer in pairs(Server.playerSessions) do
        if peer and peer.Player and peer.Player.NetworkEntityPlayer then
            local player = peer.Player.NetworkEntityPlayer
            local inv    = player.PlayerInventory
            if not inv then goto continue end

            local weapon = inv.SelectedWeapon
            if weapon and weapon.AmmoCapacity then
                -- 发现子弹不满立即补满
                if weapon.Ammo         ~= 9999 or
                   weapon.PredictedAmmo ~= 9999 or
                   weapon.AmmoCapacity  ~= 9999 then

                    weapon.AmmoCapacity = 9999
                    weapon.Ammo         = 9999
                    weapon.PredictedAmmo= 9999
                end
            end
        end
        ::continue::
    end
end