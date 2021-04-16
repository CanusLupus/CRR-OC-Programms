-- APIs
local component = require("component")
local event = require("event")
local sides = require("sides")
local colors = require("colors")
local filesystem = require("filesystem")
local thread = require("thread")

-- Components
local tunnel = component.tunnel
local rs = component.redstone

-- Variables
local t01 = false
local t02 = false
local t03 = false
local t04 = false
local finish = 0

-- Get real system time
local function getTime()
    local file = io.open('/tmp/clock.dt', 'w')
    file:write('')
    file:close()
    local lastmod = tonumber(string.sub(filesystem.lastModified('/tmp/clock.dt'), 1, -4))
    local year = os.date('%Y', lastmod)
    local month = os.date('%m', lastmod)
    local day = os.date('%d', lastmod)
    local weekday = os.date('%A', lastmod)
    local hour = os.date('%H', lastmod)
    local minute  = os.date('%M', lastmod)
    local sec  = os.date('%S', lastmod)   
    local dtime = tostring(month.."/"..day.."/"..year.."-"..hour..":"..minute..":"..sec)
    return dtime
end

-- Main loop
while finish < 4 do
  if rs.getBundledInput(sides.right, colors.lightblue) > 10 and t01 == false then
    print(getTime() .. " - Track 1 arrives")
    tunnel.send("Track 1 arrives")
    t01 = true
    finish = finish + 1
  end
  if rs.getBundledInput(sides.right, colors.magenta) > 10 and t02 == false then
    print(getTime() .. " - Track 2 arrives")
    tunnel.send("Track 2 arrives")
    t02 = true
    finish = finish + 1
  end
  if rs.getBundledInput(sides.right, colors.orange) > 10 and t03 == false then
    print(getTime() .. " - Track 3 arrives")
    tunnel.send("Track 3 arrives")
    t03 = true
    finish = finish + 1
  end
  if rs.getBundledInput(sides.right, colors.white) > 10 and t04 == false then
    print(getTime() .. " - Track 4 arrives")
    tunnel.send("Track 4 arrives")
    t04 = true
    finish = finish + 1
  end
  os.sleep(0.2)
end
tunnel.send("All have arrives", "end")
