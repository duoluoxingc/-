-- ========= 可改参数 =========
local CFG = {
    PLANT_TIME  = 5,        -- 下包秒数
    DEFUSE_TIME = 5,        -- 拆包秒数
    BOMB_FUSE   = 30,       -- 爆炸倒计时
    DEFUSE_RANGE= 2,        -- 拆包距离（脚底）
    TEAM_CHECK  = true,     -- 是否检测阵营
    COLOR_T     = Color32(255,200,0,255),
    COLOR_CT    = Color32(0,200,255,255),
    COLOR_WARN  = Color32(255,0,0,255),
}

-- ========= 状态 =========
local Bomb = { planted=false, planting=false, defusing=false, endTime=0, lastWarn=-1 }

-- ========= 广播 =========
local function Broadcast(title,text,color)
    for _,peer in pairs(Server.playerSessions) do
        ServerSendNetLib.EventMessage(peer,title,text,0,color,Color32(255,255,255,255),"",0,2)
    end
end

-- ========= 指令入口 =========
function Server:OnRconCommand(p,cmd)
    if not p then return end
    local pl=p.Player.NetworkEntityPlayer

    if cmd=="/下包" then
        if Bomb.planted or Bomb.planting then return end
        if CFG.TEAM_CHECK and not pl.Terrorist then Broadcast("提示","只有 T 能下包！",CFG.COLOR_WARN); return end
        Bomb.planting=true; Bomb.endTime=os.clock()+CFG.PLANT_TIME
        Broadcast("下包","开始安放… 5 秒后完成",CFG.COLOR_T)
        return
    end

    if cmd=="/拆包" then
        if not Bomb.planted or Bomb.defusing then return end
        if CFG.TEAM_CHECK and pl.Terrorist then Broadcast("提示","只有 CT 能拆包！",CFG.COLOR_WARN); return end
        local bp=Vector3(pl.transform.position.x, pl.transform.position.y-1, pl.transform.position.z)
        if Vector3.Distance(pl.transform.position,bp)>CFG.DEFUSE_RANGE then Broadcast("提示","请靠近炸弹 2 米内再拆包！",CFG.COLOR_WARN); return end
        Bomb.defusing=true; Bomb.endTime=os.clock()+CFG.DEFUSE_TIME
        Broadcast("拆包","开始拆除… 5 秒后完成",CFG.COLOR_CT)
        return
    end
end

-- ========= 每帧 =========
function Server:GameTick()
    local now=os.clock()

    if Bomb.planting and now>=Bomb.endTime then
        Bomb.planting,Bomb.planted=false,true; Bomb.endTime=now+CFG.BOMB_FUSE
        Broadcast("炸弹已安放",string.format("%d 秒后爆炸",CFG.BOMB_FUSE),CFG.COLOR_WARN)
    end

    if Bomb.defusing and now>=Bomb.endTime then
        Bomb.defusing,Bomb.planted=false,false; Broadcast("拆包成功","CT 胜利！",CFG.COLOR_CT); RconCommands.GameOverCmd(nil)
    end

    if Bomb.planted and now>=Bomb.endTime then
        Bomb.planted=false; Broadcast("炸弹爆炸","T 胜利！",CFG.COLOR_T); RconCommands.GameOverCmd(nil)
    end

    local left=math.floor(Bomb.endTime-now+0.5)
    if Bomb.planted and left<=10 and left~=Bomb.lastWarn then Bomb.lastWarn=left; Broadcast("倒计时",string.format("爆炸倒计时 %d 秒",left),CFG.COLOR_WARN) end
end
