local lastTime = 0

function Server:GameTick()
    if os.time() - lastTime >= 0.5 then
        lastTime = os.time()
        
        local t = os.date("*t")
        local timeStr = string.format("[时间]%02d时:%02d分:%02d秒", t.hour, t.min, t.sec)
        
        ServerSendNetLib.EventMessage(
            "时间",
            timeStr,
            3,
            Color32(0, 0, 0, 180),
            Color32(255, 192, 203, 255),
            "",
            1,
            1,
            -780, -270
        )
    end
end