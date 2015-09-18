--- SafeWord is an overscan detection library for LÖVE.
-- @module SafeWord
-- @author Josef N Patoprsty <seppi@josefnpat.com>
-- @copyright 2015
-- @license <a href="http://www.opensource.org/licenses/zlib-license.php">zlib/libpng</a>

local safeword = {
  _VERSION = "SafeWord v1.0.0",
  _DESCRIPTION = "An overscan detection library for LÖVE.",
  _URL = "https://github.com/josefnpat/safeword/",
  _LICENSE = [[
    The zlib/libpng License
    Copyright (c) 2015 Josef N Patoprsty
    This software is provided 'as-is', without any express or implied warranty. In no event will the authors be held liable for any damages arising from the use of this software.
    Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:
    1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
    2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
    3. This notice may not be removed or altered from any source distribution.
  ]]
}

--- Instansiate a new instance of SafeWord.
-- Some Examples:<br/>
-- <code>sw = safeword.new()<br/>
-- <br/>
-- sw = safeword.new({<br/>
--   horizontalAction = 0.03,<br/>
--   verticalAction = 0.03,<br/>
-- })<br/>
-- <br/>
-- sw = safeword.new{<br/>
--   horizontalAction = 0.03,<br/>
--   verticalAction = 0.03,<br/>
--   horizontalTitle = 0.07,<br/>
--   verticalTitle = 0.07,<br/>
-- }<br/></code>
-- @param init <i>Optional</i> A table containing initial values for easy usage. Available
-- overrides: <code>horizontalAction</code>, <code>horizontalTitle</code>,
-- <code>verticalAction</code> and <code>verticalTitle</code>.
-- @return Table returns the safeword class table.
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

safeword.modes = {
  BBC = "British Broadcasting Corporation",
  EBU = "European Broadcasting Union",
  XBOX = "Microsoft's Xbox game developer guidelines",
  OUYA = "OUYA SDK Example",
}

function safeword._gcd(a,b)
  if b ~= 0 then
    return safeword._gcd(b, a % b)
  else
    return math.abs(a)
  end
end

--- Main draw function
-- This is the main draw function that one would add to <code>love.draw</code>.
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

--- Get the available modes in SafeWord
-- @return Table of strings with acronyms.
-- Example:<br/>
-- <code>{OUYA = "OUYA SDK Example", XBOX = "XBOX Example" }</code>
function safeword:getModes()
  return safeword.modes
end

--- Set the current mode in SafeWord.
-- For maintainence reasons, please avoid using the string literal when using
-- this library. Indices will be maintained, but string literals are subject to
-- change.
-- Example:<br/>
-- <code>sw = safeword.new()<br/>
-- local foomode = sw:getModes().OUYA<br/>
-- sw:setMode(foomode)</code>
-- @param mode <i>Optional</i> the mode that you would like set.

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
  elseif mode == "OUYA" then
    -- https://github.com/ouya/ouya-sdk-examples/blob/master/Android/SafeAreaExample/src/tv/ouya/examples/android/safeareaexample/MainActivity.java#L83
    -- OUYA does not mention a title safe, assuming twice that.
    self:setVerticalAction(0.07)
    self:setHorizontalAction(0.07)
    self:setVerticalTitle(0.07*2)
    self:setHorizontalTitle(0.07*2)
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

--- Get the calculated X coordinate of the action safe area.
function safeword:getActionX()
  return love.graphics.getWidth()*self:getHorizontalAction()
end

--- Get the calculated Y coordinate of the action safe area.
function safeword:getActionY()
  return love.graphics.getHeight()*self:getVerticalAction()
end

--- Get the calculated width of the action safe area.
function safeword:getActionWidth()
  return love.graphics.getWidth()*(1-self:getHorizontalAction()*2)
end

--- Get the calculated height of the action safe area.
function safeword:getActionHeight()
  return love.graphics.getHeight()*(1-self:getVerticalAction()*2)
end

--- Get the calculated X coordinate of the title safe area.
function safeword:getTitleX()
  return love.graphics.getWidth()*self:getHorizontalTitle()
end

--- Get the calculated Y coordinate of the title safe area.
function safeword:getTitleY()
  return love.graphics.getHeight()*self:getVerticalTitle()
end

--- Get the calculated width of the title safe area.
function safeword:getTitleWidth()
  return love.graphics.getWidth()*(1-self:getHorizontalTitle()*2)
end

--- Get the calculated height of the title safe area.
function safeword:getTitleHeight()
  return love.graphics.getHeight()*(1-self:getHorizontalTitle()*2)
end

--- Get the currently set horizontal action safe area percentage.
-- @return Float The percent represented mathematically (e.g. 0.01 is 1%)
function safeword:getHorizontalAction()
  return self._horizontalAction
end

--- Set the current horizontal action safe area percentage.
-- @param val The percent represented mathematically (e.g. 0.01 is 1%)
function safeword:setHorizontalAction(val)
  self._horizontalAction=val
end

--- Get the currently set horizontal title safe area percentage.
-- @return Float The percent represented mathematically (e.g. 0.01 is 1%)
function safeword:getHorizontalTitle()
  return self._horizontalTitle
end

--- Set the current horizontal title safe area percentage.
-- @param val The percent represented mathematically (e.g. 0.01 is 1%)
function safeword:setHorizontalTitle(val)
  self._horizontalTitle=val
end

--- Get the currently set vertical action safe area percentage.
-- @return Float The percent represented mathematically (e.g. 0.01 is 1%)
function safeword:getVerticalAction()
  return self._verticalAction
end

--- Set the current vertical action safe area percentage.
-- @param val The percent represented mathematically (e.g. 0.01 is 1%)
function safeword:setVerticalAction(val)
  self._verticalAction=val
end

--- Get the currently set vertical title safe area percentage.
-- @return Float The percent represented mathematically (e.g. 0.01 is 1%)
function safeword:getVerticalTitle()
  return self._verticalTitle
end

--- Set the current vertical title safe area percentage.
-- @param val The percent represented mathematically (e.g. 0.01 is 1%)
function safeword:setVerticalTitle(val)
  self._verticalTitle=val
end

return safeword
