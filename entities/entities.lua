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
    health=3,
    update_bb=function(_ENV)
        bbw=8
        bbh=4
        bbx=x+8-(bbw/2)
        bby=y+16-bbh
    end,
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
        walk={f=2,s=0.2,{sprx=40,spry=0},{sprx=56,spry=0}},
        hit={f=2,s=0.1,{sprx=88,spry=0}},
        finisher={f=2,s=0.1,{sprx=104,spry=0}}
    },
    update=function(_ENV)
        -- keep bbox up to date
        _ENV:update_bb()

        if btn(5) then
            state="punch"
            if not played_punch then
                sfx(0)
                played_punch=true
            end
            _ENV:update_bb()
            local attack={}
            attack.bbh=4
            attack.bbw=8
            attack.bby=y+16-attack.bbh
            if flipped then
                -- facing left: attack from center to left
                attack.bbx=x+8-attack.bbw
            else
                -- facing right: attack from center to right
                attack.bbx=x+8
            end
            for o in all(global.characters) do
                if o ~= _ENV then
                    o:update_bb()
                    if aabb_overlap(attack,o) and o.state ~= "hit" then
                        o.state = "hit"
                        o.hit_timer = 8
                        o.health-=1
                        sfx(1)
                    end
                end
            end

            local collided=false
            for o in all(global.characters) do
                if o ~= _ENV then
                    o:update_bb()
                    if aabb_overlap(_ENV,o) then
                        collided=true
                        break
                    end
                end
            end

        elseif btn(4) then
            state="kick"
            if not played_punch then
                sfx(0)
                played_punch=true
            end
            -- kick uses same directional attack box as punch
            _ENV:update_bb()
            local attack_k={}
            attack_k.bbh=4
            attack_k.bbw=8
            attack_k.bby=y+16-attack_k.bbh
            if flipped then
                attack_k.bbx=x+8-attack_k.bbw
            else
                attack_k.bbx=x+8
            end
            for o in all(global.characters) do
                if o ~= _ENV then
                    o:update_bb()
                    if aabb_overlap(attack_k,o) and o.state ~= "hit" then
                        o.state = "hit"
                        o.hit_timer = 8
                        o.health-=1
                        sfx(1)
                    end
                end
            end
        else
            played_punch=false
            local moved=false
            local dx=0
            local dy=0
            if btn(0) then dx=-1 flipped=true end
            if btn(1) then dx=1 flipped=false end
            if btn(2) then dy=-1 end
            if btn(3) then dy=1 end

            if dx~=0 then
                state="walk"
                local oldx=x
                x+=dx
                _ENV:update_bb()
                local collided=false
                for o in all(global.characters) do
                    if o ~= _ENV then
                        o:update_bb()
                        if aabb_overlap(_ENV,o) then
                            collided=true
                            break
                        end
                    end
                end
                if collided then x=oldx _ENV:update_bb() end
            end

            if dy~=0 then
                state="walk"
                local oldy=y
                y+=dy
                _ENV:update_bb()
                local collided=false
                for o in all(global.characters) do
                    if o ~= _ENV then
                        o:update_bb()
                        if aabb_overlap(_ENV,o) then
                            collided=true
                            break
                        end
                    end
                end
                if collided then y=oldy _ENV:update_bb() end
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

snekborg=entity:new({
    x=0,
    y=0,
    flipped=false,
    state="idle",
    played_sound=false,
    anims={
        idle={f=2,s=0.1,{sprx=0,spry=16}},
        walk={f=2,s=0.2,{sprx=0,spry=16},{sprx=16,spry=16},{sprx=32,spry=16}},
        hit={f=2,s=0.1,{sprx=48,spry=16}},
    },

    update=function(_ENV)
        -- keep bbox current for collisions
        _ENV:update_bb()
        -- handle hit timer (frames)
        if state=="hit" then
            hit_timer = (hit_timer or 0) - 1
            if hit_timer <= 0 then
                state = "idle"
                hit_timer = nil
            end
        end

        anim=anims[state]
        if anim.f < #anim+1-anim.s then
            anim.f+=0.1
        else 
            anim.f=1
        end

        if global.player.x < x then
            flipped=false
        else
            flipped=true
        end

        if health <= 0 then
            for x=1,16 do
                for y=1,16 do
                    local c = sget(x+anim[flr(anim.f)].sprx,y+anim[flr(anim.f)].spry)
                    if c != 14 then
                        if global.player.x < _ENV.x then
                            spawn_particle(_ENV.x+x,_ENV.y+y,rnd(1),c,_ENV.y+16,global.particles)
                        else
                            spawn_particle(_ENV.x+x,_ENV.y+y,-rnd(1),c,_ENV.y+16,global.particles)
                        end
                    end
                end
            end
        end
    end,

    draw=function(_ENV)
        palt(0, false)
        palt(14, true)
        fillp(0xa5a5.1)
        if flipped then
            ovalfill(x+4, y+14,x+14, y+16, 0x05)
        else
            ovalfill(x+5, y+12,x+15, y+17, 0x05)
        end
        fillp()
        sspr(anim[flr(anim.f)].sprx,anim[flr(anim.f)].spry,16,16,x,y,16,16,flipped)  
        pal()
    end
})