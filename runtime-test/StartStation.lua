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
local mmsg1 = ""
local mmsg2 = ""
local Tmin = 0
local Tsec = 0
local TSmin = 0
local TSsec = 0
local TAmin = 0
local TAsec = 0
local TravelT = 0
local TSD = 0


-- Modem thread
local tmodem = thread.create(function()
   while true do
     local _, _, from, port, _, msg1, msg2 = event.pull("modem_message")
     mmsg1 = msg1
     mmsg2 = msg2
   end
end)

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
    Tmin = minute
    Tsec = sec
    return dtime
end

-- Dispatch trains
print(getTime() .. " - Dispatching Trains")
rs.setBundledOutput(sides.right, colors.red, 255)
rs.setBundledOutput(sides.right, colors.red, 0)
os.sleep(20)

-- Release Trains
print(getTime() .. " - Started")
TSmin = Tmin
TSsec = Tsec
rs.setBundledOutput(sides.right, colors.white, 255)
os.sleep(5)
rs.setBundledOutput(sides.right, colors.white, 0)
print("\nWaiting for arrivels:")

-- Main loop
while mmsg2 ~= "end" do
  if mmsg1 ~= "" then
    getTime()
    TAmin = (Tmin - TSmin) - 1
    TAsec = (60 - TSsec) + Tsec
    TSD = TAsec / 60
    if TSD >= 1 then
      TAmin = TAmin + 1
      TAsec = TAsec - 60
    end
    TravelT = (TAmin * 60) + TAsec
    print(getTime() .. " - " .. mmsg1 .. " - Travel time: " .. TAmin .. ":" .. TAsec .. " - " .. TravelT .. " sec")
    mmsg1 = ""
  end
  os.sleep(0.5)
end
print("\n" .. getTime() .. " - Test End")
tmodem:kill()

