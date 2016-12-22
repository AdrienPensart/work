local pgmoon = require("pgmoon")
local pg = pgmoon.new({ database = "musicbot" })
assert(pg:connect())
pg:keepalive()
pg = nil
ngx.say("hello, world, test")
