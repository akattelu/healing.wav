return {
  --- Manages health and drawing health bar
  --- @param tlx number left corner x of where the box should be drawn
  --- @param tly number left corner y of where the box should be drawn
  --- @return table
  new = function(tlx, tly)
    return {
      health = 3,
      maxhealth = 5,

      -- Position
      h = 10,
      w = 32,
      x = tlx,
      y = tly,

      draw = function(self)
        love.graphics.push("all")

        -- Draw green part
        local greenWidth = self.w * (self.health / self.maxhealth)
        love.graphics.setColor(0, 255, 0, 1)
        love.graphics.rectangle("fill", self.x + 16, self.y, greenWidth, self.h)

        -- Draw red part
        local redWidth = self.w * (1 - (self.health / self.maxhealth))
        love.graphics.setColor(255, 0, 0, 1)
        love.graphics.rectangle("fill", self.x + 16 + greenWidth, self.y, redWidth, self.h)

        -- Draw black border
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.setLineWidth(3)
        love.graphics.rectangle("line", self.x + 16, self.y, self.w, self.h)
        love.graphics.pop()
      end,


      isDead = function(self)
        return self.health == 0
      end,

      setTopLeft = function(self, x, y)
        self.x = x
        self.y = y
      end,

      damage = function(self, dmg)
        self.health = self.health - dmg
        if (self.health < 0) then
          self.health = 0
        end
      end
    }
  end
}
