--
-- Created by IntelliJ IDEA.
-- User: orange
-- Date: 20.07.15
-- Time: 17:35
-- To change this template use File | Settings | File Templates.
--

local M = {}

function M.get_db()
    local mysql = require "resty.mysql"

    local db, err = mysql:new()
    if not db then
        ngx.log(ngx.ERR, "failed to instantiate mysql: ", err)
        ngx.exit(500)
    end

    db:set_timeout(1000) -- 1 sec

    local ok, err, errno, sqlstate = db:connect{
        host = "127.0.0.1",
        port = 3306,
        database = "tp_db",
        user = "tp_db_user",
        password = "qwe123",
        max_packet_size = 1024 * 1024,
        pool = 'haha'}

    if not ok then
        ngx.log(ngx.ERR, "failed to connect: ", err, ": ", errno, " ", sqlstate)
        ngx.exit(500)
    end
    return db
end

return M