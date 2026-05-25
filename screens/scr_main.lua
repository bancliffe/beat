function scr_main_init()
    global.characters={}
    global.player = player:new({x=64,y=64})
    add(global.characters, global.player)
    for i=1,3 do
        local s = snekborg:new({x=rnd(112),y=48+rnd(64)})
        add(global.characters, s)
    end
end

function scr_main_update()
    for c in all(global.characters) do
        c:update()
    end
    sort_by_y(global.characters)
end

function scr_main_draw()
    cls()
    map(0,0,0,0,128,128)
    for c in all(global.characters) do
        c:draw()
    end
    draw_gui()
end

function sort_by_y(a)
  for i=2,#a do
    local j = i
    -- compare the .y property of table elements
    while j > 1 and a[j-1].y > a[j].y do
      a[j], a[j-1] = a[j-1], a[j]
      j = j - 1
    end
  end
end

function draw_gui()
end