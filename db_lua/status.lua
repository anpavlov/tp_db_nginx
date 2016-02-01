--
-- Created by IntelliJ IDEA.
-- User: orange
-- Date: 20.07.15
-- Time: 13:38
-- To change this template use File | Settings | File Templates.
--

local cjson = require "cjson"
--[[local mysql = require "resty.mysql"

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
--]]

if ngx.req.get_method() ~= "GET" then
    ngx.exit(501)
end


local common = require('common')
local db = common.get_db()
--ngx.say("connected to mysql<br>")

local res, err, errno, sqlstate =
db:query("SELECT COUNT(*) as c FROM Post")
if not res then
    ngx.log(ngx.ERR, "bad result: ", err, ": ", errno, ": ", sqlstate, ".")
    ngx.exit(500)
end

local posts = res[1].c

local res, err, errno, sqlstate =
db:query("SELECT COUNT(*) as c FROM User")
if not res then
    ngx.log(ngx.ERR, "bad result: ", err, ": ", errno, ": ", sqlstate, ".")
    ngx.exit(500)
end

local users = res[1].c

local res, err, errno, sqlstate =
db:query("SELECT COUNT(*) as c FROM Thread")
if not res then
    ngx.log(ngx.ERR, "bad result: ", err, ": ", errno, ": ", sqlstate, ".")
    ngx.exit(500)
end

local threads = res[1].c

local res, err, errno, sqlstate =
db:query("SELECT COUNT(*) as c FROM Forum")
if not res then
    ngx.log(ngx.ERR, "bad result: ", err, ": ", errno, ": ", sqlstate, ".")
    ngx.exit(500)
end

local forums = res[1].c

--local reused = db:get_reused_times()

local ok, err = db:set_keepalive()
if not ok then
    ngx.log(ngx.ERR, "failed to instantiate mysql: ", err)
    ngx.exit(500)
end

local result = {code = 0, response = {forum = forums, post = posts, thread = threads, user = users}}
ngx.say(cjson.encode(result))

--ngx.say("Conn reused: " .. reused)
