function scr_main_init()
    character.x=96
    character.y=96
    character.state="idle"
    anim=character.anims[character.state]
    played_punch=false
end

function scr_main_update()
    if btn(5) then
        character.state="punch"
        if not played_punch then
            sfx(0)
            played_punch=true
        end
    elseif btn(4) then
        character.state="kick"
        if not played_punch then
            sfx(0)
            played_punch=true
        end
    else
        played_punch=false
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
        -- cap y to half the screen
        if character.y<48 then character.y=48 end

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
    cls(5)
    palt(0, false)
    palt(14, true)
    fillp(0xa5a5.1)
    ovalfill(character.x+2, character.y+14,character.x+12,character.y+16, 0x05)
    fillp()
    sspr(anim[flr(anim.f)].sprx,anim[flr(anim.f)].spry,16,16,character.x,character.y,16,16,character.flipped)  

    pal()
end

function draw_bg()
end