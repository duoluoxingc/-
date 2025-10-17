function Server:Start()
    API.RegisterIndexedType("GameServer.BaseWeapon")
    API.RegisterIndexedType("GameServer.InventoryUtil.Inventory")
    API.RegisterIndexedType("IBaseWeapon.WeaponModel")
end

function Server:OnRconCommand(p, cmd)
    if p and cmd == "/刀" then
        local player = p.Player.NetworkEntityPlayer
        player.KnifeWeapon.SetWeaponModel(player, 42)
    end
end