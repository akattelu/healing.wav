return {
  --- Manages health and drawing health bar
  --- @param tlx number left corner x of where the box should be drawn
  --- @param tly number left corner y of where the box should be drawn
  --- @return table
  new = function(tlx, tly)
    return {
      health = 5,
      maxhealth = 5,

      -- Position
      h = 10,
      w = 32,
      x = tlx,
      y = tly,

      draw = function(self)
        love.graphics.push("all")
        love.graphics.setColor(0, 255, 0, 1)
        love.graphics.rectangle("fill", self.x + 16, self.y, self.w, self.h)
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
      end
    }
  end
}
