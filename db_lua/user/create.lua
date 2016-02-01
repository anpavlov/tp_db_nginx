
local cjson = require "cjson.safe"
local common = require "common"

if ngx.req.get_method() ~= "POST" then
    ngx.exit(501)
end

ngx.req.read_body()

local income = ngx.req.get_body_data()
if not income then
    ngx.say(common.error_encode(2, 'No data'))
    return
end

local req_json = cjson.decode(income)
if not req_json then
    ngx.say(common.error_encode(2, 'Cant parse JSON'))
    return
end

if not req_json.username and req_json.about and req_json.name and req_json.email then
    ngx.say(common.error_encode(3, 'Wrong parameters'))
    return
end

local new_user_username = req_json.username
local new_user_about = req_json.about
local new_user_name = req_json.name
local new_user_email = req_json.email
local new_user_is_anon = req_json.isAnonymous

if new_user_is_anon then
    if common.is_not_bool(new_user_is_anon) then
        ngx.say(common.error_encode(3, 'Wrong parameters'))
        return
    end
else
    new_user_is_anon = false
end

local db = common.get_db()

if common.user_exists(req_json.email) then
    ngx.say(common.error_encode(5, 'User with such email already exists!'))
    return
end

local query = s:format('INSERT INTO User VALUES (null,%s,%s,%s,%s,%s)',
    new_user_about, new_user_email, new_user_is_anon, new_user_name, new_user_username)

local res, err, errno, sqlstate =
db:query(query)
if not res then
    ngx.log(ngx.ERR, "bad result: ", err, ": ", errno, ": ", sqlstate, ".")
    ngx.exit(500)
end

local resp = {
    email = new_user_email,
    username = new_user_username,
    about = new_user_about,
    name = new_user_name,
    isAnonymous = new_user_is_anon,
    id = res.insert_id,
}

ngx.say(cjson.encode(resp))

--local reused = db:get_reused_times()

local ok, err = db:set_keepalive()
if not ok then
    ngx.log(ngx.ERR, "failed to instantiate mysql: ", err)
    ngx.exit(500)
end