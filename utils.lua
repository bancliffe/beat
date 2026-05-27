-- axis-aligned bbox overlap check
function aabb_overlap(a,b)
    if not (a.bbx and b.bbx) then return false end
    return not (a.bbx+a.bbw <= b.bbx or b.bbx+b.bbw <= a.bbx or a.bby+a.bbh <= b.bby or b.bby+b.bbh <= a.bby)
end

function check_collision(a,b)
    a:update_bb()
    b:update_bb()
    return aabb_overlap(a,b)
end

function spawn_particle(x,y,direction,colour,floor,particles)
    local p = {
        x=x,
        y=y,
        dx=direction*(2+rnd(1)),
        dy=rnd(1),
        c=colour,
        floor=floor,
        life=1+rnd(120),
        angle=rnd(1),
        update=function(self)
            -- apply gravity
            self.dy+=0.2

            -- integrate velocity
            -- integrate velocity
            self.x+=self.dx
            self.y+=self.dy

            -- collide with particle floor (if numeric)
            if self.floor and type(self.floor) == "number" and self.y >= self.floor then
                self.y = self.floor
                -- bounce with restitution when moving downwards
                if self.dy > 0 then
                    self.dy = -self.dy * 0.6
                    -- apply horizontal damping on bounce
                    self.dx = self.dx * 0.75
                    -- if bounce is very small, settle the particle
                    if abs(self.dy) < 0.3 then
                        self.dy = 0
                        self.dx = self.dx * 0.5
                    end
                end
            end

            -- apply floor friction when sitting on the floor
            if self.floor and type(self.floor) == "number" and abs(self.y - self.floor) < 0.01 then
                -- friction coefficient (per-frame)
                self.dx = self.dx * 0.85
                if abs(self.dx) < 0.05 then
                    self.dx = 0
                end
                -- if fully settled, mark for deletion
                if self.dx == 0 and self.dy == 0 then
                    self.life = 0
                end
            end

            self.life-=1
                end,
                draw=function(self)
                    pset(self.x,self.y,self.c)
                end
        }
    add(particles,p)
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