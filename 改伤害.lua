function Server:Start()
    API.RegisterIndexedType("GameServer.BaseWeapon")
    API.RegisterIndexedType("GameServer.InventoryUtil.Inventory")
    Lua.Set("GameManager", "GameServer.GameManager")
end

function Server:OnRconCommand(p, cmd)
    if p and cmd == "/秒杀" then
        p.Player.NetworkEntityPlayer.PlayerInventory.SelectedWeapon.Damage = 999999999999999999999999999
    end
end