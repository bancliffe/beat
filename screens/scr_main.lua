function scr_main_init()
    character.x=64
    character.y=64
    character.state="idle"
    anim=character.anims[character.state]
end

function scr_main_update()
    if btn(5) then
        character.state="attack"
    else
        if btn(0) then
            character.state="walk"
            character.x-=1
            character.flipped=true
        end
        if btn(1) then
            character.state="walk"
            character.x+=1
            character.flipped=false
        end
        if btn(2) then
            character.state="walk"
            character.y-=1
        end
        if btn(3) then
            character.state="walk"
            character.y+=1  
        end
        if not (btn(0) or btn(1) or btn(2) or btn(3)) then
            character.state="idle"
        end
    end
    anim=character.anims[character.state]
    if anim.f < #anim+1-anim.s then
        anim.f+=0.1
    else 
        anim.f=1
    end
end

function scr_main_draw()
    cls()
    print(character.state,0,0)
    print(anim[1].sprx..","..anim[1].spry,0,8)
    print(anim.f,0,16)
    sspr(anim[flr(anim.f)].sprx,anim[flr(anim.f)].spry,16,16,character.x,character.y,16,16,character.flipped)  
end