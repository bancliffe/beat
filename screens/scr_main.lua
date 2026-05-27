function scr_main_init()
    global.characters={}
    global.player = player:new({x=64,y=64})
    global.particles={}
    add(global.characters, global.player)
    for i=1,3 do
        local s = snekborg:new({x=rnd(112),y=48+rnd(64)})
        add(global.characters, s)
    end
end

function scr_main_update()
    for c in all(global.characters) do
        c:update()
        if c.health <= 0 then
            del(global.characters,c)
        end
    end
    for p in all(global.particles) do
        p:update()
        if p.life<=0 then
            del(global.particles,p)
        end
    end
    sort_by_y(global.characters)
end

function scr_main_draw()
    cls()
    map(0,0,0,0,128,128)
    for c in all(global.characters) do
        c:draw()
    end
    for p in all(global.particles) do
        p:draw()
    end
    draw_gui()
end

function draw_gui()
end