local server = require("resty.websocket.server")
local pgmoon = require("pgmoon")
local pg = pgmoon.new({ database = "musicbot", password = "Ahgoh(d3bo" })

pg:keep()

local function connect(pg)
    return pcall(pg['connect'], pg)
end

local function wait(pg)
    return pcall(pg['wait'], pg)
end

local ok, err = connect(pg)
if not ok then
    ngx.say(err)
    return
end
pg:query("listen changes;")

local wb, err = server:new{
    timeout = 5000,
    max_payload_len = 65535,
}
if not wb then
    ngx.log(ngx.ERR, "failed to new websocket: ", err)
    return ngx.exit(444)
end

while true do
    local notif = pg:wait_for_notification()
    if not notif then
        ngx.log(ngx.ERR, "disconnected")
        return
    end

    local bytes, err = wb:send_text(notif.payload)
    if not bytes then
        ngx.log(ngx.ERR, "failed to send a text frame: ", err)
        return ngx.exit(444)
    end
end

wb:send_close()
