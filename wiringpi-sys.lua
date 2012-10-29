require "wiringpi"
wiringpi.wiringPiSetupSys()

function wiringpi.checkPins(t)
    t = t or {}
    local ret = true
    local msg = ""
    local a,p
    for k,v in pairs(t) do
        if type(k) == "number" then
            p = wiringpi.getPinNumber(k)
            a = wiringpi.pinGetMode(p)
            if a ~= v then
                msg = msg .. "Pin " .. k .. " (gpio " .. p .. ")"
                if a == -1 then
                    msg = msg .. " not set"
                elseif a == 0 then
                    msg = msg .. " set as INPUT"
                elseif a == 1 then
                    msg = msg .. " set as OUTPUT"
                else
                    msg = msg .. " unknown"
                end
                msg = msg .. ", expecting "
                if v == -1 then
                    msg = msg .. " not set"
                elseif v == 0 then
                    msg = msg .. " INPUT"
                elseif v == 1 then
                    msg = msg .. " OUTPUT"
                else
                    msg = msg .. " unknown"
                end
                msg = msg .. "\n"
                ret = false
            end
        end
    end
    assert(ret, msg)
end

do

-- reverse lookup table for physical pins
local __phys = {}
__phys[11] = 17
__phys[12] = 18
__phys[13] = 21
__phys[15] = 22
__phys[16] = 23
__phys[18] = 24
__phys[22] = 25
__phys[7] = 4
__phys[3] = 0
__phys[5] = 1
__phys[24] = 8
__phys[26] = 7
__phys[19] = 10
__phys[21] = 9
__phys[23] = 11
__phys[8] = 14
__phys[10] = 15

wiringpi.getPinNumber = wiringpi.wpiPinToGpio

function wiringpi.pinNumbersBy(t)
    t = t:lower()
    if t == "gpio" then
        wiringpi.getPinNumber = function (p) return p end
    elseif t == "wpi" then
        wiringpi.getPinNumber = wiringpi.wpiPinToGpio
    elseif t == "physical" then
        wiringpi.getPinNumber = function (p) return __phys[p] end
    else
        assert(false,"Unknown pin encoding scheme " .. t)
    end
    return true
end

local __dw = wiringpi.digitalWrite
local __dr = wiringpi.digitalRead

function wiringpi.digitalWrite(p,k)
    return __dw(wiringpi.getPinNumber(p),k)
end

function wiringpi.digitalRead(p)
    return __dr(wiringpi.getPinNumber(p))
end

end
