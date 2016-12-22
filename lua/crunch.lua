local pgmoon = require("pgmoon")
local pg = pgmoon.new({ database = "musicbot", password = "Ahgoh(d3bo" })

local function connect(pg)
    return pcall(pg['connect'], pg)
end
ok, err = connect(pg)

if ok then
    pg:keepalive()
    pg = nil
else
    ngx.say(err)
    return
end
ngx.say("hello, world, test")

