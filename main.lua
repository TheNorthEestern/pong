require("pong")
love.load = function()
  return pong.load()
end
love.update = function(dt)
  return pong.update(dt)
end
love.draw = function()
  return pong.draw()
end
love.keypressed = function(key)
  if key == "tab" then
    local state = not love.mouse.isVisible()
    love.mouse.setVisible(state)
  end
end
