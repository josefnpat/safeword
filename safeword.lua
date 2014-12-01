local safeword = {}

function safeword:draw()
  local old_color = {love.graphics.getColor()}
  love.graphics.setColor(255,0,0,127)
  local ax = love.graphics.getWidth()*self:getHorizontalAction()
  local aw = love.graphics.getWidth()-2*ax
  local ay = love.graphics.getHeight()*self:getVerticalAction()
  local ah = love.graphics.getHeight()-2*ay
  love.graphics.rectangle("fill",0,0,love.graphics.getWidth(),ay)
  love.graphics.rectangle("fill",0,ay+ah,love.graphics.getWidth(),ay)
  love.graphics.rectangle("fill",0,ay,ax,ah)
  love.graphics.rectangle("fill",ax+aw,ay,ax,ah)
  love.graphics.setColor(0,0,255,127)
  local tx = love.graphics.getWidth()*self:getHorizontalTitle()
  local tw = love.graphics.getWidth()-2*tx
  local ty = love.graphics.getHeight()*self:getVerticalTitle()
  local th = love.graphics.getHeight()-2*ty
  love.graphics.rectangle("fill",ax,ay,tw+(tx-ax)*2,ty-ay)
  love.graphics.rectangle("fill",ax,ty+th,tw+(tx-ax)*2,ty-ay)
  love.graphics.rectangle("fill",ax,ty,tx-ax,th)
  love.graphics.rectangle("fill",tx+tw,ty,tx-ax,th)

  love.graphics.setColor(255,255,255)

  love.graphics.print("Action Safe")
  love.graphics.printf( (self:getVerticalAction()*100).."%",
    0,0,love.graphics.getWidth(),"center")
  love.graphics.printf( (self:getVerticalAction()*100).."%",
    0,ah+ay,love.graphics.getWidth(),"center")
  love.graphics.printf( (self:getHorizontalAction()*100).."%",
    0,ah/2+ay,ax,"center")
  love.graphics.printf( (self:getHorizontalAction()*100).."%",
    ax+aw,ah/2+ay,ax,"center")

  love.graphics.print("Title Safe",ax,ay)
  love.graphics.printf( (self:getVerticalTitle()*100).."%",
    ax,ay,aw,"center")
  love.graphics.printf( (self:getVerticalTitle()*100).."%",
    ax,ty+th,aw,"center")
  love.graphics.printf( (self:getHorizontalTitle()*100).."%",
    ax,ty+th/2,tx-ax,"center")
  love.graphics.printf( (self:getHorizontalTitle()*100).."%",
    tx+tw,ty+th/2,tx-ax,"center")

  love.graphics.setColor(old_color)
end

function safeword._gcd(a,b)
  if b ~= 0 then
    return safeword._gcd(b, a % b)
  else
    return math.abs(a)
  end
end

safeword.modes = {
  BBC = "British Broadcasting Corporation",
  EBU = "European Broadcasting Union",
  XBOX = "Microsoft's Xbox game developer guidelines"
}

function safeword:getModes()
  return safeword.modes
end

function safeword:setPreset(mode)

  if mode ~= nil then
    local valid_mode = false
    for mode_name,_ in pairs(self:getModes()) do
      if mode_name == mode then
        valid_mode = true
        break
      end
    end
    assert(valid_mode,"Error: safeword:setPreset() Invalid mode, `"..mode.."`.")
  end

  -- Calculate the current screen ratio
  local gcd = safeword._gcd(love.graphics.getWidth(),love.graphics.getHeight())
  local ratio = love.graphics.getWidth()/gcd..":"..love.graphics.getHeight()/gcd
  local mode_set = false
  -- http://en.wikipedia.org/wiki/Overscan#Overscan_amounts
  if mode == "BBC" then
    if ratio == "4:3" then
      self:setVerticalAction(0.035)
      self:setHorizontalAction(0.033)
      self:setVerticalTitle(0.05)
      self:setHorizontalTitle(0.067)
      mode_set = true
    elseif ratio == "16:9" then
      self:setVerticalAction(0.035)
      self:setHorizontalAction(0.035)
      self:setVerticalTitle(0.05)
      self:setHorizontalTitle(0.10)
      mode_set = true
    end
  elseif mode == "EBU" then
    if ratio == "16:9" then
      self:setVerticalAction(0.035)
      self:setHorizontalAction(0.035)
      self:setVerticalTitle(0.05)
      self:setHorizontalTitle(0.10)
      mode_set = true
    end
  elseif mode == "XBOX" then
    -- GDC 2004: Cross-Platform User Interface Development
    -- wiki does not mention action, just title. Assuming half that.
    self:setVerticalAction(0.075/2)
    self:setHorizontalAction(0.075/2)
    self:setVerticalTitle(0.075)
    self:setHorizontalTitle(0.075)
    mode_set = true
  else -- no mode given
    mode_set = true
  end

  if not mode_set then
    print("Warning: safeword:setPreset will not work on ratio "..
      ratio.." in mode "..(mode or "DEFAULT")..". Action and title unchanged.")
  end

  return mode_set

end

function safeword:getActionX()
  return love.graphics.getWidth()*self:getHorizontalAction()
end

function safeword:getActionY()
  return love.graphics.getHeight()*self:getVerticalAction()
end

function safeword:getActionWidth()
  return love.graphics.getWidth()*(1-self:getHorizontalAction()*2)
end

function safeword:getActionHeight()
  return love.graphics.getHeight()*(1-self:getVerticalAction()*2)
end

function safeword:getTitleX()
  return love.graphics.getWidth()*self:getHorizontalTitle()
end

function safeword:getTitleY()
  return love.graphics.getHeight()*self:getVerticalTitle()
end

function safeword:getTitleWidth()
  return love.graphics.getWidth()*(1-self:getHorizontalTitle()*2)
end

function safeword:getTitleHeight()
  return love.graphics.getHeight()*(1-self:getHorizontalTitle()*2)
end

-- LuaClassGen pregenerated functions

function safeword.new(init)
  init = init or {}
  local self={}
  self.draw=safeword.draw
  self.setPreset=safeword.setPreset
  self.getModes=safeword.getModes

  self.getActionX=safeword.getActionX
  self.getActionY=safeword.getActionY
  self.getActionWidth=safeword.getActionWidth
  self.getActionHeight=safeword.getActionHeight

  self.getTitleX=safeword.getTitleX
  self.getTitleY=safeword.getTitleY
  self.getTitleWidth=safeword.getTitleWidth
  self.getTitleHeight=safeword.getTitleHeight

  self._horizontalAction=init.horizontalAction or 0.035
  self.getHorizontalAction=safeword.getHorizontalAction
  self.setHorizontalAction=safeword.setHorizontalAction
  self._horizontalTitle=init.horizontalTitle or 0.07
  self.getHorizontalTitle=safeword.getHorizontalTitle
  self.setHorizontalTitle=safeword.setHorizontalTitle
  self._verticalAction=init.verticalAction or 0.035
  self.getVerticalAction=safeword.getVerticalAction
  self.setVerticalAction=safeword.setVerticalAction
  self._verticalTitle=init.verticalTitle or 0.07
  self.getVerticalTitle=safeword.getVerticalTitle
  self.setVerticalTitle=safeword.setVerticalTitle

  self:setPreset()

  return self
end

function safeword:getHorizontalAction()
  return self._horizontalAction
end

function safeword:setHorizontalAction(val)
  self._horizontalAction=val
end

function safeword:getHorizontalTitle()
  return self._horizontalTitle
end

function safeword:setHorizontalTitle(val)
  self._horizontalTitle=val
end

function safeword:getVerticalAction()
  return self._verticalAction
end

function safeword:setVerticalAction(val)
  self._verticalAction=val
end

function safeword:getVerticalTitle()
  return self._verticalTitle
end

function safeword:setVerticalTitle(val)
  self._verticalTitle=val
end

return safeword
