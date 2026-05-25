function scr_main_init()
    global.characters={}
    local c = player:new({x=64,y=64})
    add(global.characters, c)
end

function scr_main_update()
    for c in all(global.characters) do
        c:update()
    end
end

function scr_main_draw()
    cls()
    draw_bg()
    for c in all(global.characters) do
        c:draw()
    end
end

function draw_bg()
    map(0,0,0,0,128,128)
end