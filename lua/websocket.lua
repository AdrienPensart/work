local server = require("resty.websocket.server")
local pgmoon = require("pgmoon")
local pg = pgmoon.new({ database = "musicbot", password = "Ahgoh(d3bo" })

--local function connect(pg)
--    return pcall(pg['connect'], pg)
--end
--
--local function wait(pg)
--    return pcall(pg['wait'], pg)
--end
--
--local ok, err = connect(pg)
--if not ok then
--    ngx.say(err)
--    return
--end

assert(pg:connect())
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
    ngx.log(ngx.ERR, pg)
    --local ok, err, notif = wait(pg)
    --if not ok then
    --    ngx.log(ngx.ERR, err)
    --    return
    --end
    local notif = pg:wait_for_notification()

    local bytes, err = wb:send_text(notif)
    if not bytes then
        ngx.log(ngx.ERR, "failed to send a text frame: ", err)
        return ngx.exit(444)
    end
end

wb:send_close()
--pg:keepalive()
--pg = nil
