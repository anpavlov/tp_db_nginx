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

function M.error_encode(code, msg)
    local cjson = require "cjson"
    local str = cjson.encode({code=code, response=msg})
    return str
end

function M.is_not_bool(var)
    if var == true or var == false then
        return false
    else
        return true
    end
end

function M.user_exists(email)
    local db = M.get_db()
    local query = s:format('SELECT 1 as a FROM User WHERE email=%s', email)

    local res, err, errno, sqlstate =
    db:query(query)
    if not res then
        ngx.log(ngx.ERR, "bad result: ", err, ": ", errno, ": ", sqlstate, ".")
        ngx.exit(500)
    end

    if res[1].a == 1 then
        return true
    else
        return false
    end

end

return M