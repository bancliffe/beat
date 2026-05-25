class=setmetatable({
    new=function(self,tbl)
        tbl = tbl or {}
        setmetatable(tbl,{
            __index=self
        })
        return tbl  
    end
}, {__index=_ENV}) 

entity=class:new({
    x=0,
    y=0,
    update=function() end,
    draw=function() end
})

player=entity:new({
    x=0,
    y=0,
    flipped=false,
    state="idle",
    played_punch=false,
    anims={
        idle={f=2,s=0.1,{sprx=8,spry=0}},
        punch={f=2,s=0.1,{sprx=24,spry=0}},
        kick={f=2,s=0.1,{sprx=72,spry=0}},
        walk={f=2,s=0.2,{sprx=40,spry=0},{sprx=56,spry=0}}
    },
    update=function(_ENV)
        if btn(5) then
            state="punch"
            if not played_punch then
                sfx(0)
                played_punch=true
            end
        elseif btn(4) then
            state="kick"
            if not played_punch then
                sfx(0)
                played_punch=true
            end
        else
            played_punch=false
            if btn(0) then
                state="walk"
                x-=1
                flipped=true
            end
            if btn(1) then
                state="walk"
                x+=1
                flipped=false
            end
            if btn(2) then
                state="walk"
                y-=1
            end
            if btn(3) then
                state="walk"
                y+=1  
            end
            -- cap y to game area
            if y<48 then y=48 end
            if y>112 then y=112 end
            -- cap x to game area
            if x<0 then x=0 end
            if x>112 then x=112 end

            if not (btn(0) or btn(1) or btn(2) or btn(3)) then
                state="idle"
            end
        end
        anim=anims[state]
        if anim.f < #anim+1-anim.s then
            anim.f+=0.1
        else 
            anim.f=1
        end
    end,

    draw=function(_ENV)
        palt(0, false)
        palt(14, true)
        fillp(0xa5a5.1)
        ovalfill(x+2, y+14,x+12, y+16, 0x05)
        fillp()
        sspr(anim[flr(anim.f)].sprx,anim[flr(anim.f)].spry,16,16,x,y,16,16,flipped)  
        pal()
    end
})