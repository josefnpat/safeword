safewordclass = require("safeword")

if love.filesystem.isFile("example.png") then
  example = love.graphics.newImage("example.png")
end

function love.load()
  sw = safewordclass.new()
end

function love.draw()
  if example then
    love.graphics.draw(example,0,0,0,
      love.graphics.getWidth()/example:getWidth(),
      love.graphics.getHeight()/example:getHeight())
  end
  sw:draw()
  love.graphics.printf(
    "Resolution: "..love.graphics.getWidth().."x"..love.graphics.getHeight(),
    0,0,love.graphics.getWidth(),"right")
  love.graphics.printf(
    "Action: "..sw:getActionWidth().."x"..sw:getActionHeight(),
    sw:getActionX(),sw:getActionY(),sw:getActionWidth(),"right")
  love.graphics.printf(
    "Title: "..sw:getTitleWidth().."x"..sw:getTitleHeight(),
    sw:getTitleX(),sw:getTitleY(),sw:getTitleWidth(),"right")
end

local demo_modes = {"BBC","EBU","XBOX","OUYA"}
current_res = 1
local demo_res = {
  {x=16*50,y=9*50},--16:9
  {x=16*50,y=10*50},--16:10
  {x=4*200,y=3*200},-- 4:3
}

function love.keypressed(key)
  local target = tonumber(key)
  if demo_modes[target] then
    if love.keyboard.isDown("lshift","rshift") then
      love.window.setMode(demo_res[target].x,demo_res[target].y)
    else
      love.window.setTitle("Safeword - Mode: "..
        sw:getModes()[demo_modes[target]])
      sw:setPreset(demo_modes[target])
    end
  end
end
