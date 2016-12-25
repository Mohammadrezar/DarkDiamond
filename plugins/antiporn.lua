do
local function nuditycheck(msg, success, result)
  local data = load_data(_config.moderation.data)
    if data[tostring(msg.to.id)]['settings']['lock_porn'] == 'yes' then
  if success then
local file = 'data/toTeleDiamond/'..string.sub(result, 38)
os.rename(result, file)
  local curl = 'curl -X POST "https://api.sightengine.com/1.0/nudity.json" -F "api_user=1331214104" -F "api_secret=HWJM2GH36Zg4esNG" -F "photo=@'..file..'"'
  local jcmd = io.popen(curl)

  local res = jcmd:read('*all')
  local jdat = json:decode(res)
	      if jdat.status then
    if jdat.status == 'failure' then
	     send_large_msg(get_receiver(msg), jdat.error_message, ok_cb, false)
    elseif jdat.status == 'success' then
    if jdat.nudity.result then
	     send_large_msg(get_receiver(msg), "🚷اخراج شد!\nدلیل: ارسال تصاویر پورن   (Porn +18)", ok_cb, false)
		 kick_user(msg.from.id, msg.to.id)
         end
    end
end
  else
    print('Error downloading: '..msg.id)
    send_large_msg(get_receiver(msg), 'خطا!لطفا بعدا امتحان کنید', ok_cb, false)
end
end
end
local function run(msg)
		      if msg.media then
            if msg.media.type == 'photo' then
                    load_photo(msg.id, nuditycheck, msg)
                end
            end
        end

return {
  patterns = {
		"%[(photo)%]",
    },
  run = run,
}

end
