script_properties('work-in-pause')

local effil_check, effil 					= pcall(require, 'effil')
local encoding										= require('encoding')
encoding.default									= 'CP1251'
u8 = encoding.UTF8

assert(effil_check, "module 'Effil' not found")

local SETTINGS = {}

-->> Local Functions
local requestRunner = function()
    return effil.thread(function(u, a)
        local https = require 'ssl.https'
        local ok, result = pcall(https.request, u, a)
        if ok then
            return {true, result}
        else
            return {false, result}
        end
    end)
end

local threadHandle = function(runner, url, args, resolve, reject)
    local t = runner(url, args)
    local r = t:get(0)
    while not r do
        r = t:get(0)
        wait(0)
    end
    local status = t:status()
    if status == 'completed' then
        local ok, result = r[1], r[2]
        if ok then resolve(result) else reject(result) end
    elseif err then
        reject(err)
    elseif status == 'canceled' then
        reject(status)
    end
    t:cancel(0)
end

local async_http_request = function(url, args, resolve, reject)
    local runner = requestRunner()
    if not reject then reject = function() end end
    lua_thread.create(function()
        threadHandle(runner, url, args, resolve, reject)
    end)
end

local urlencode = function(text)
	local text = tostring(text):gsub('{......}', '')
	local text = tostring(text):gsub(' ', '%+')
	local text = tostring(text):gsub('\n', '%%0A')
	local text = tostring(text):gsub('&gt;', '>')
	local text = tostring(text):gsub('&lt;', '<')
	local text = tostring(text):gsub('&quot;', '"')
	return text
end

local getMessageLongPoll = function()
	while SETTINGS.server == nil do wait(0) end
	while true do wait(0)
		local url = string.format('%s?act=a_check&key=%s&ts=%s&wait=25', SETTINGS.server, SETTINGS.key, SETTINGS.ts)
		threadHandle(requestRunner(), url, nil, function(result)
			if result then
				local t = decodeJson(result)
				if t.failed then
					-->> Получаем новый ключ для получения сообщений. Причина: Истекло время действия ключа.
					array.getLongPollServer()
					return
				end
				if t.ts then SETTINGS.ts = t.ts end
				if t.updates and type(t.updates) == 'table' then
					for k, v in ipairs(t.updates) do
						if v.type == 'message_new' and v.object.message then
							array.getMessage(v)
						end
					end
				end
			end
		end, function() end)
	end
end

lua_thread.create(getMessageLongPoll)

-->> Library Functions
array	= {}

array.botAuthorization = function(group, token, version)
	SETTINGS.group 		= group
	SETTINGS.token 		= token
	SETTINGS.version 	= version

	return (token and group and version) and 'Parameters are saved!' or 'One of the arguments is empty!'
end

array.createRequest = function(method, parameters)
	parameters.access_token 	= SETTINGS.token
	parameters.v 							= SETTINGS.version

	local text = ''
	for k, v in pairs(parameters) do
		text = string.format('%s%s=%s&', text, k, v)
	end

	local url = string.format('https://api.vk.com/method/%s?%s', method, text:sub(1, #text - 1))
	return url
end

array.sendRequest = function(url, callback)
	async_http_request(url, nil, function(resolve) if type(callback) == 'function' then callback(resolve) end end)
end

array.getLongPollServer = function(callback)
	local url = array.createRequest('groups.getLongPollServer', {['group_id'] = SETTINGS.group})
	async_http_request(url, nil, function(resolve)
		local t = decodeJson(resolve)
		SETTINGS.key = t.response.key
		SETTINGS.server = t.response.server
		SETTINGS.ts = t.response.ts
		if type(callback) == 'function' then callback(encodeJson(t)) end
	end)
end

array.sendMessage = function(text, chat, buttons, callback)
	local keyboard = (type(buttons) == 'table' and '&keyboard=' .. encodeJson(buttons) or '')
	local url = array.createRequest('messages.send', {
		['message'] = u8(urlencode(tostring(text) .. keyboard)),
		['random_id'] = '0',
		['peer_id'] = chat
	})
	async_http_request(url, nil, function(resolve) if type(callback) == 'function' then callback(resolve) end end)
end

array.getMessage = function(array) return array end

return array
