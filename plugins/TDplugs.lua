
do
-- clean deleted
local function check_member_super_deleted(cb_extra, success, result)
local receiver = cb_extra.receiver
 local msg = cb_extra.msg
  local deleted = 0 
if success == 0 then
send_large_msg(receiver, "<i>first set me as admin!</i>") 
end
for k,v in pairs(result) do
  if not v.first_name and not v.last_name then
deleted = deleted + 1
 kick_user(v.peer_id,msg.to.id)
 end
 end
 send_large_msg(receiver, deleted.." <i>Deleted account removed from group!</i>") 
 end 

--PlistsFunction
local function plugin_enabled( name )
  for k,v in pairs(_config.enabled_plugins) do
    if name == v then
      return k
    end
  end
  return false
end

local function disable_plugin( name, chat )
  local k = plugin_enabled(name)
  if not k then
    return
  end
  table.remove(_config.enabled_plugins, k)
  save_config( )
end

local function enable_plugin( plugin_name )
  if plugin_enabled(plugin_name) then
    return disable_plugin( name, chat )
  end
    table.insert(_config.enabled_plugins, plugin_name)
    save_config()
end

local function plugin_exists( name )
  for k,v in pairs(plugins_names()) do
    if name..'.lua' == v then
      return true
    end
  end
  return false
end

local function getindex(t,id) 
for i,v in pairs(t) do 
if v == id then 
return i 
end 
end 
return nil 
end 
local function reload_plugins( )
  plugins = {}
  load_plugins()
end

local function saveplug(extra, success, result)
  local msg = extra.msg
  local name = extra.name
  local receiver = get_receiver(msg)
  if success then
    local file = 'plugins/'..name..'.lua'
    print('File saving to:', result)
    os.rename(result, file)
    print('File moved to:', file)
    enable_plugin(name)
    reload_plugins( )
  else
    print('Error downloading: '..msg.id)
    send_large_msg(receiver, 'Failed, please try again!', ok_cb, false)
  end
end
-- PlistsFunction
local function plugin_enabled( name )
  for k,v in pairs(_config.enabled_plugins) do
    if name == v then
      return k
    end
  end
  return false
end

-- Returns true if file exists in plugins folder
local function plugin_exists( name )
  for k,v in pairs(plugins_names()) do
    if name..'.lua' == v then
      return true
    end
  end
  return false
end

local function list_all_plugins(only_enabled)
  local text = ''
  local nsum = 0
  for k, v in pairs( plugins_names( )) do
    --  ✔ enabled, ❌ disabled
    local status = '❌'
    nsum = nsum+1
    nact = 0
    -- Check if is enabled
    for k2, v2 in pairs(_config.enabled_plugins) do
      if v == v2..'.lua' then 
        status = '✔' 
      end
      nact = nact+1
    end
    if not only_enabled or status == '✔' then
      -- get the name
      v = string.match (v, "(.*)%.lua")
      text = text..nsum..'. '..v..'  '..status..'\n'
    end
  end
  local text = text..'\n<i>There are</i> '..nsum..' <i>plugins installed.</i>\n'..nact..' <i>plugins enabled and</i> '..nsum-nact..' <i>disabled.</i>'
  return text
end

local function list_plugins(only_enabled)
  local text = ''
  local nsum = 0
  for k, v in pairs( plugins_names( )) do
    --  ✔ enabled, ❌ disabled
    local status = '❌'
    nsum = nsum+1
    nact = 0
    -- Check if is enabled
    for k2, v2 in pairs(_config.enabled_plugins) do
      if v == v2..'.lua' then 
        status = '✔' 
      end
      nact = nact+1
    end
    if not only_enabled or status == '✔' then
      -- get the name
      v = string.match (v, "(.*)%.lua")
      text = text..v..'  '..status..'\n'
    end
  end
  local text = text..'\n '..nact..' <i>plugins enabled from</i> '..nsum..' <i>plugins installed.</i>'
  return text
end

local function reload_plugins( )
  plugins = {}
  load_plugins()
  return "<b>Done !✔ </b>"
end


local function enable_plugin( plugin_name )
  print('checking if '..plugin_name..' exists')
  -- Check if plugin is enabled
  if plugin_enabled(plugin_name) then
    return '<i>Plugin</i>[ '..plugin_name..' ]<i>is enabled.</i>'
  end
  -- Checks if plugin exists
  if plugin_exists(plugin_name) then
    -- Add to the config table
    table.insert(_config.enabled_plugins, plugin_name)
    print(plugin_name..' added to _config table')
    save_config()
    -- Reload the plugins
    return reload_plugins( )
  else
    return '<i>Plugin</i>[ '..plugin_name..' ]<i>does not exists</i>'
  end
end

local function disable_plugin( name, chat )
  -- Check if plugins exists
  if not plugin_exists(name) then
    return '<i>Plugin</i>[ '..name..' ]<i>does not exists</i>'
  end
  local k = plugin_enabled(name)
  -- Check if plugin is enabled
  if not k then
    return '<i>Plugin</i>[ '..name..' ]<i>not enabled</i>'
  end
  -- Disable
  table.remove(_config.enabled_plugins, k)
  save_config( )
  return reload_plugins(true)    
end

local function disable_plugin_on_chat(receiver, plugin)
  if not plugin_exists(plugin) then
    return "<i>Plugin doesn't exists</i>"
  end

  if not _config.disabled_plugin_on_chat then
    _config.disabled_plugin_on_chat = {}
  end

  if not _config.disabled_plugin_on_chat[receiver] then
    _config.disabled_plugin_on_chat[receiver] = {}
  end

  _config.disabled_plugin_on_chat[receiver][plugin] = true

  save_config()
  return '<i>Plugin</i> '..plugin..' <i>disabled on this chat</i>'
end

local function reenable_plugin_on_chat(receiver, plugin)
  if not _config.disabled_plugin_on_chat then
    return '<i>There aren\'t any disabled plugins</i>'
  end

  if not _config.disabled_plugin_on_chat[receiver] then
    return '<i>There aren\'t any disabled plugins for this chat</i>'
  end

  if not _config.disabled_plugin_on_chat[receiver][plugin] then
    return '<i>This plugin is not disabled</i>'
  end

  _config.disabled_plugin_on_chat[receiver][plugin] = false
  save_config()
  return '<i>Plugin</i>[ '..plugin..' ]</i>is enabled again</i>'
end

local function savefile(extra, success, result)
  local msg = extra.msg
  local name = extra.name
  local adress = extra.adress
  local receiver = get_receiver(msg)
  if success then
    local file = './'..adress..'/'..name..''
    print('File saving to:', result)
    os.rename(result, file)
    print('File moved to:', file)
  else
    print('Error downloading: '..msg.id)
    send_large_msg(receiver, 'Failed, please try again!', ok_cb, false)
  end
end

local function clean_msg(extra, suc, result)
  for i=1, #result do
    delete_msg(result[i].id, ok_cb, false)
  end
  if tonumber(extra.con) == #result then
    send_msg(extra.chatid, ''..#result..' پیام اخیر گروه حذف شد', ok_cb, false)
  else
    send_msg(extra.chatid, '<i>Error Deleting messages\nBecause of the limitation of telegram Clean this amount of messages is impossible</i>\n<code>به دلیل محدودیت های تلگرام حذف این مقدار پیام ممکن  نیس</code>', ok_cb, false)  
end 
end
-- To ...
local function topng(msg, success, result)
  local receiver = get_receiver(msg)
  if success then
    local file = './data/toTeleDiamond/'..msg.from.id..'.png'
    print('File downloaded to:', result)
    os.rename(result, file)
    print('File moved to:', file)
    send_document(get_receiver(msg), file, ok_cb, false)
    redis:del("photo:png")
  else
    print('Error downloading: '..msg.id)
    send_large_msg(receiver, 'Failed, please try again!', ok_cb, false)
  end
end
local function toaudio(msg, success, result)
  local receiver = get_receiver(msg)
  if success then
    local file = './data/toTeleDiamond/'..msg.from.id..'.mp3'
    print('File downloaded to:', result)
    os.rename(result, file)
    print('File moved to:', file)
    send_audio(get_receiver(msg), file, ok_cb, false)
    redis:del("video:audio")
  else
    print('Error downloading: '..msg.id)
    send_large_msg(receiver, 'Failed, please try again!', ok_cb, false)
  end
end
local function tovoice(msg, success, result) 
  local receiver = get_receiver(msg) 
  if success then 
    local file = './data/toTeleDiamond/'..msg.from.id..'.ogg' 
    print('File downloaded to:', result) 
    os.rename(result, file) 
    print('File moved to:', file) 
    send_audio(get_receiver(msg), file, ok_cb, false) 
    redis:del("video:audio") 
  else 
    print('Error downloading: '..msg.id) 
    send_large_msg(receiver, 'Failed, please try again!', ok_cb, false) 
  end 
end 

local function tomkv(msg, success, result)
  local receiver = get_receiver(msg)
  if success then
    local file = './data/toTeleDiamond/'..msg.from.id..'.mkv'
    print('File downloaded to:', result)
    os.rename(result, file)
    print('File moved to:', file)
    send_document(get_receiver(msg), file, ok_cb, false)
    redis:del("video:document")
  else
    print('Error downloading: '..msg.id)
    send_large_msg(receiver, 'Failed, please try again!', ok_cb, false)
  end
end
local function togif(msg, success, result) 
  local receiver = get_receiver(msg) 
  if success then 
    local file = './data/toTeleDiamond/'..msg.from.id..'.mp4' 
    print('File downloaded to:', result) 
    os.rename(result, file) 
    print('File moved to:', file) 
    send_document(get_receiver(msg), file, ok_cb, false) 
    redis:del("video:gif") 
  else 
    print('Error downloading: '..msg.id) 
    send_large_msg(receiver, 'Failed, please try again!', ok_cb, false) 
  end 
end 
local function tovideo(msg, success, result)
  local receiver = get_receiver(msg)
  if success then
    local file = './data/toTeleDiamond/'..msg.from.id..'.gif'
    print('File downloaded to:', result)
    os.rename(result, file)
    print('File moved to:', file)
    send_video(get_receiver(msg), file, ok_cb, false)
    redis:del("gif:video")
  else
    print('Error downloading: '..msg.id)
    send_large_msg(receiver, 'Failed, please try again!', ok_cb, false)
  end
end
local function toimage(msg, success, result)
  local receiver = get_receiver(msg)
  if success then
    local file = './data/toTeleDiamond/'..msg.from.id..'.jpg'
    print('File downloaded to:', result)
    os.rename(result, file)
    print('File moved to:', file)
    send_photo(get_receiver(msg), file, ok_cb, false)
    redis:del("sticker:photo")
  else
    print('Error downloading: '..msg.id)
    send_large_msg(receiver, 'Failed, please try again!', ok_cb, false)
  end
end
local function tosticker(msg, success, result)
  local receiver = get_receiver(msg)
  if success then
    local file = './data/toTeleDiamond/'..msg.from.id..'.webp'
    print('File downloaded to:', result)
    os.rename(result, file)
    print('File moved to:', file)
    send_document(get_receiver(msg), file, ok_cb, false)
    redis:del("photo:sticker")
  else
    print('Error downloading: '..msg.id)
    send_large_msg(receiver, 'Failed, please try again!', ok_cb, false)
  end
end
-- weather
local function get_weather(location)
  print("Finding weather in ", location)
  local BASE_URL = "http://api.openweathermap.org/data/2.5/weather"
  local url = BASE_URL
  url = url..'?q='..location..'&APPID=eedbc05ba060c787ab0614cad1f2e12b'
  url = url..'&units=metric'
  local b, c, h = http.request(url)
  if c ~= 200 then return nil end

   local weather = json:decode(b)
   local city = weather.name
   local country = weather.sys.country
   local temp = 'دمای شهر '..city..' هم اکنون '..weather.main.temp..' درجه سانتی گراد می باشد\n____________________'
   local conditions = 'شرایط فعلی آب و هوا : '

   if weather.weather[1].main == 'Clear' then
     conditions = conditions .. 'آفتابی☀'
   elseif weather.weather[1].main == 'Clouds' then
     conditions = conditions .. 'ابری ☁☁'
   elseif weather.weather[1].main == 'Rain' then
     conditions = conditions .. 'بارانی ☔'
   elseif weather.weather[1].main == 'Thunderstorm' then
     conditions = conditions .. 'طوفانی ☔☔☔☔'
 elseif weather.weather[1].main == 'Mist' then
     conditions = conditions .. 'مه 💨'
  end

  return temp .. '\n' .. conditions
end
-- calc
local function calc(exp)
   url = 'http://api.mathjs.org/v1/'
  url = url..'?expr='..URL.escape(exp)
   b,c = http.request(url)
   text = nil
  if c == 200 then
    text = 'Result = '..b..'\n_____________________'
  elseif c == 400 then
    text = b
  else
    text = 'Unexpected error\n'
      ..'Is api.mathjs.org up?'
  end
  return text
end
-- rmsg
function run(msg, matches) 
  if matches[1]:lower() == 'clean' and matches[2]:lower() == "msg" and is_momod(msg) or matches[1] == 'حذف' and matches[2] == "پیام ها" and is_momod(msg) or matches[1]:lower() == 'rm' and matches[2]:lower() == "sg" and is_momod(msg) then
    if msg.to.type == "user" then 
      return 
      end
    if msg.to.type == 'chat' then
      return  "Only in the Super Group" 
      end
    if not is_momod(msg) then 
      return "》<i>You Are Not Allow To clean Msgs!</i>\n》شما مدیر ربات نیستید"
      end
    if tonumber(matches[3]) > 200 or tonumber(matches[3]) < 1 then
      return "》<i>maximum clean is 200</i>\n<code>》حداکثر تا 200 پیام قابل حذف است.</code>"
      end
   get_history(msg.to.peer_id, matches[3] + 1 , clean_msg , { chatid = msg.to.peer_id,con = matches[3]})
   end
--del plug --@mrr619
      if matches[1]:lower() == "dl" and matches[2]:lower() == "plugin" and is_sudo(msg) then
     if not is_sudo(msg) then
    return "<i>You Are Not Allow To Download Plugins!</i>"
  end
   receiver = get_receiver(msg)
      send_document(receiver, "./plugins/"..matches[3]..".lua", ok_cb, false)
      send_document(receiver, "./plugins/"..matches[3], ok_cb, false)
    end
-- calc
if matches[1]:lower() == "calc" and is_momod(msg) or matches[1] == "ماشین حساب" and is_momod(msg) and matches[2] and is_sudo(msg) then 
    if msg.to.type == "user" then 
       return 
       end
    return calc(matches[2])
end
-- weather
if matches[1]:lower() == 'weather' and is_momod(msg) or matches[1] == 'هواشناسی' and is_momod(msg) then
    city = matches[2]
  local wtext = get_weather(city)
  if not wtext then
    wtext = 'مکان وارد شده صحیح نیست'
  end
  return wtext
end
-- time
if matches[1]:lower() == 'time' and is_momod(msg) or matches[1] == 'زمان' and is_momod(msg) then
local url , res = http.request('http://api.gpmod.ir/time/')
if res ~= 200 then
 return "No connection"
  end
  local colors = {'blue','green','yellow','magenta','Orange','DarkOrange','red'}
  local fonts = {'mathbf','mathit','mathfrak','mathrm'}
local jdat = json:decode(url)
local url = 'http://latex.codecogs.com/png.download?'..'\\dpi{600}%20\\huge%20\\'..fonts[math.random(#fonts)]..'{{\\color{'..colors[math.random(#colors)]..'}'..jdat.ENtime..'}}'
local file = download_to_file(url,'time.webp')
send_document(get_receiver(msg) , file, ok_cb, false)

end
-- voice
if matches[1] == 'voice' and is_momod(msg) or matches[1] == 'وویس' and is_momod(msg) then
 local text = matches[2]

  local b = 1

  while b ~= 0 do
    textc = text:trim()
    text,b = text:gsub(' ','.')
    
    
  if msg.to.type == 'user' then 
      return nil
      else
  local url = "http://tts.baidu.com/text2audio?lan=en&ie=UTF-8&text="..textc
  local receiver = get_receiver(msg)
  local file = download_to_file(url,'mohamad.ogg')
 send_audio('channel#id'..msg.to.id, file, ok_cb , false)
end
end
end
-- setsudo
    if tonumber (msg.from.id) ==219201071  then 
       if matches[1]:lower() == "setsudo" then 
          table.insert(_config.sudo_users, tonumber(matches[2])) 
      print(matches[2]..' <i>added to sudo users</i>') 
     save_config() 
     reload_plugins(true) 
      return matches[2]..' <i>added to sudo users</i>' 
	 end
	 end
    if matches[1]:lower() == "remsudo" then 
      local k = tonumber(matches[2]) 
          table.remove(_config.sudo_users, getindex( _config.sudo_users, k)) 
      print(matches[2]..' <i>removed from sudo users</i>') 
     save_config() 
     reload_plugins(true) 
      return matches[2]..' <i>removed from sudo users</i>' 
      end 
-- to ... TeleDiamond V3
 local receiver = get_receiver(msg)
    local group = msg.to.id
    if msg.reply_id then
       if msg.to.type == 'document' and redis:get("sticker:photo") then
        if redis:set("sticker:photo", "waiting") then
        end
       end
    
      if matches[1]:lower() == "photo" and is_momod(msg) or matches[1] == 'عکس' and is_momod(msg) then
     redis:get("sticker:photo")
    send_large_msg(receiver, '', ok_cb, false)
        load_document(msg.reply_id, toimage, msg)
    end
end
	    local receiver = get_receiver(msg)
    local group = msg.to.id
    if msg.reply_id then
       if msg.to.type == 'photo' and redis:get("photo:sticker") then
        if redis:set("photo:sticker", "waiting") then
        end
       end
      if matches[1]:lower() == "sticker" and is_momod(msg) or matches[1] == 'استیکر' and is_momod(msg) then
     redis:get("photo:sticker")  
    send_large_msg(receiver, '', ok_cb, false)
        load_photo(msg.reply_id, tosticker, msg)
    end
end
local receiver = get_receiver(msg)
    local group = msg.to.id
    if msg.reply_id then
       if msg.to.type == 'video' and redis:get("video:audio") then
        if redis:set("video:audio", "waiting") then
        end
       end
      if matches[1]:lower() == "audio" and is_momod(msg) or matches[1] == 'آهنگ' and is_momod(msg) then
     redis:get("video:audio")  
    send_large_msg(receiver, '', ok_cb, false)
        load_audio(msg.reply_id, toaudio, msg)
    end
end
  local receiver = get_receiver(msg) 
    local group = msg.to.id 
    if msg.reply_id then 
       if msg.to.type == 'video' and redis:get("video:audio") then 
        if redis:set("video:audio", "waiting") then 
        end 
       end 
      if matches[1]:lower() == "voice" and is_momod(msg) or matches[1]:lower() == "وویس" and is_momod(msg) then 
     redis:get("video:audio") 
    send_large_msg(receiver, '', ok_cb, false) 
        load_audio(msg.reply_id, tovoice, msg) 
    end
end

local receiver = get_receiver(msg)
    local group = msg.to.id
    if msg.reply_id then
       if msg.to.type == 'document' and redis:get("gif:video") then
        if redis:set("gif:video", "waiting") then
        end
       end
      if matches[1]:lower() == "video" and is_momod(msg) or matches[1] == 'فیلم' and is_momod(msg) then
     redis:get("gif:video")  
    send_large_msg(receiver, '', ok_cb, false)
        load_document(msg.reply_id, tovideo, msg)
    end
end
local receiver = get_receiver(msg)
    local group = msg.to.id
    if msg.reply_id then
       if msg.to.type == 'video' and redis:get("video:document") then
        if redis:set("video:document", "waiting") then
        end
       end
      if matches[1]:lower() == "mkv" and is_momod(msg) then
     redis:get("video:document")  
    send_large_msg(receiver, '', ok_cb, false)
        load_video(msg.reply_id, tomkv, msg)
    end
end

  if matches[1]:lower() == "gif" and is_momod(msg) or matches[1] =="گیف" then 
local text = URL.escape(matches[2]) 
  local url2 = 'http://www.flamingtext.com/net-fu/image_output.cgi?_comBuyRedirect=false&script=blue-fire&text='..text..'&symbol_tagname=popular&fontsize=70&fontname=futura_poster&fontname_tagname=cool&textBorder=15&growSize=0&antialias=on&hinting=on&justify=2&letterSpacing=0&lineSpacing=0&textSlant=0&textVerticalSlant=0&textAngle=0&textOutline=off&textOutline=false&textOutlineSize=2&textColor=%230000CC&angle=0&blueFlame=on&blueFlame=false&framerate=75&frames=5&pframes=5&oframes=4&distance=2&transparent=off&transparent=false&extAnim=gif&animLoop=on&animLoop=false&defaultFrameRate=75&doScale=off&scaleWidth=240&scaleHeight=120&&_=1469943010141' 
  local title , res = http.request(url2) 
  local jdat = json:decode(title) 
  local gif = jdat.src 
     local  file = download_to_file(gif,'t2g.gif') 
   send_document(get_receiver(msg), file, ok_cb, false) 
  end 
  
local receiver = get_receiver(msg) 
    local group = msg.to.id 
    if msg.reply_id then 
       if msg.to.type == 'video' and redis:get("video:gif") then 
        if redis:set("video:gif", "waiting") then 
        end 
       end 
      if matches[1]:lower() == "gif" and is_momod(msg) or matches[1] =="گیف" and is_momod(msg)  then 
     redis:get("video:gif") 
    send_large_msg(receiver, '', ok_cb, false) 
        load_video(msg.reply_id, togif, msg) 
    end 
end 
-- clean deleted
    if matches[1] == "cleandeleted" and is_momod(msg) or matches[1] == "حذف دیلیت اکانتی ها" and is_momod(msg) then
	 local receiver = get_receiver(msg) 
channel_get_users(receiver, check_member_super_deleted,{receiver = receiver, msg = msg})
 end
-- serverinfo
    if matches[1] == "serverinfo" and is_sudo(msg) then
     local f = io.popen("sh /root/darkdiamond/plugins/tdserver.sh") 
     return ( f:read("*a") ) 
  end

-- send plug
local mohammad = 219201071
if matches[1]:lower() == "send" and msg.from.id == tonumber(mohammad) then 
    local file = matches[2] 
    if is_sudo(msg) or is_vip(msg) then 
      local receiver = get_receiver(msg) 
      send_document(receiver, "./plugins/"..file..".lua", ok_cb, false) 
    end 
  end 
-- list plug
  if matches[1]:lower() == 'plugins' and is_sudo(msg) then
    return list_all_plugins()
  end
  -- Enable a plugin
  if matches[1] == 'p' and  matches[2] == '+' and is_sudo(msg) then
    local plugin_name = matches[3]
    print("enable: "..matches[3])
    return enable_plugin(plugin_name)
  end
  -- Disable a plugin
  if matches[1]:lower() == 'p' and  matches[2] == '-' and is_sudo(msg) then 
    if matches[3]:lower() == 'plugins' then
    	return '<b>This plugin can\'t be disabled </b>'
    end
    print("disable: "..matches[3])
    return disable_plugin(matches[3])
  end
  -- save plug
  if matches[1]:lower() == "save" and matches[2] and is_sudo(msg) then
    local receiver = get_receiver(msg)
    local group = msg.to.id
    if msg.reply_id then
     local name = matches[2]
     load_document(msg.reply_id, saveplug, {msg=msg,name=name})
      return reply_msg(msg.reply_id, '<i>Plugin</i>[ '..name..' ]<i>has been saved.</i>', ok_cb, false)
    end
end
-- kick me
if matches[1] == 'kickme' then
local hash = 'kick:'..msg.to.id..':'..msg.from.id
     redis:set(hash, "waite")
      return '<code>🔖کاربر عزیز</code> ('..msg.from.username..')\n<code>شما درخواست اخراج خود از گروه را ارسال کردید\nاگر با این درخواست موافقت دارید عبارت yes را ارسال کنید</code>'
    end

    if msg.text then
	local hash = 'kick:'..msg.to.id..':'..msg.from.id
      if msg.text:match("^yes$") and redis:get(hash) == "waite" then
	  redis:set(hash, "ok")
	elseif msg.text:match("^no$") and redis:get(hash) == "waite" then
	send_large_msg(get_receiver(msg), "<code>در خواست حذف از گروه لغو شد.</code>")
	  redis:del(hash, true)
      end
    end
	local hash = 'kick:'..msg.to.id..':'..msg.from.id
	 if redis:get(hash) then
        if redis:get(hash) == "ok" then
         channel_kick("channel#id"..msg.to.id, "user#id"..msg.from.id, ok_cb, false)
         return '<code>❌کاربر مورد نظر بنابر درخواست خود از گروه</code> ('..msg.to.title..') <code>اخراج شد</code>'
        end
      end
-- to ..
local receiver = get_receiver(msg)
    local group = msg.to.id
    if msg.reply_id then
       if msg.to.type == 'photo' and redis:get("photo:sticker") then
        if redis:set("photo:png", "waiting") then
        end
       end
      if matches[1]:lower() == "png" and is_momod(msg) then
     redis:get("photo:png")  
    send_large_msg(receiver, '', ok_cb, false)
        load_photo(msg.reply_id, topng, msg)
    end
end
-- leave
    if matches[1] == 'leave' and is_admin1(msg) then
       bot_id = our_id 
       receiver = get_receiver(msg)
       chat_del_user("chat#id"..msg.to.id, 'user#id'..bot_id, ok_cb, false)
	   leave_channel(receiver, ok_cb, false)
    elseif msg.service and msg.action.type == "chat_add_user" and msg.action.user.id == tonumber(bot_id) and not is_admin1(msg) then
       send_large_msg(receiver, '<i>This is not one of my groups.</i>', ok_cb, false)
       chat_del_user(receiver, 'user#id'..bot_id, ok_cb, false)
	   leave_channel(receiver, ok_cb, false)
    end
-- del plug
if matches[1]:lower() == "delplugin" and is_sudo(msg) then
	      if not is_sudo(msg) then 
             return "<i>You Are Not Allow To Delete Plugins!</i>"
             end 
        io.popen("cd plugins && rm "..matches[2]..".lua")
        return "<i>Delete plugin successful</i>"
     end
end
end
return {           
patterns = {
   "^[#!/]([Ss][Aa][Vv][Ee]) (.*)$",
   "^[#!/]([Pp][Ll][Uu][Gg][Ii][Nn][Ss])$",
   "^[#!/]([Pp]) (+) (.*)$",
   "^[#!/]([Pp]) (-) (.*)$",
   "^[!#/]([Cc][Ll][Ee][Aa][Nn]) ([Mm][Ss][Gg]) (%d*)$",
   "^[!#/]([Rr][Mm])([Ss][Gg]) (%d*)$",
   "^[!#/](حذف) (پیام ها) (%d*)$",
   "^[!#/]([Dd][Ee][Ll][Pp][Ll][Uu][Gg][Ii][Nn]) (.*)$",
   "^[!/#](weather) (.*)$",
   "^[!/#](هواشناسی) (.*)$",
   "^[#!/](calc) (.*)$",
   "^[#!/](ماشین حساب) (.*)$",
   "^[#!/]([Tt][Ii][Mm][Ee])$",
   "^([Pp][Ll][Uu][Gg][Ii][Nn][Ss])$",
   "^([Pp]) (+) (.*)$",
   "^([Pp]) (-) (.*)$",
   "^[#!/](زمان)$",
   "^[!/#]([Vv][Oo][Ii][Cc][Ee]) +(.*)$",
   "^[!/#](وویس) +(.*)$",
   "^[#!/](gif)$", 
   "^[#!/]([Ss][Tt][Ii][Cc][Kk][Ee][Rr])$",
   "^[#!/]([Pp][Hh][Oo][Tt][Oo])$",
   "^[#!/]([Vv][Ii][Dd][Ee][Oo])$",
   "^[#!/](mkv)$",
   "^[#!/]([Aa][Uu][Dd][Ii][Oo])$",
   "^[#!/]([Vv][Oo][Ii][Cc][Ee])$",
   "^[!/#]([Ss][Ee][Nn][Dd]) (.*)$", 
   "^[!/#](leave)$",
   "^(leave)$",
   "^[!/#](serverinfo)$",
   "^(serverinfo)$",
   "^[#!/](استیکر)$",
   "^[#!/](عکس)$",
   "^[#!/](گیف)$",
   "^[#!/](فیلم)$",
   "^[#!/](آهنگ)$",
   "^[#!/](وویس)$",
   "^[#!/]([Gg][Ii][Ff]) (.*)$", 
   "^[#!/](png)$",
   "^([Ss][Aa][Vv][Ee]) (.*)$",
   "^([Cc][Ll][Ee][Aa][Nn]) ([Mm][Ss][Gg]) (%d*)$",
   "^([Rr][Mm])([Ss][Gg]) (%d*)$",
   "^(حذف) (پیام ها) (%d*)$",
   "^([Dd][Ee][Ll][Pp][Ll][Uu][Gg][Ii][Nn]) (.*)$",
   "^(weather) (.*)$",
   "^(هواشناسی) (.*)$",
   "^(calc) (.*)$",
   "^(ماشین حساب) (.*)$",
   "^([Tt][Ii][Mm][Ee])$",
   "^([Pp][Ll][Uu][Gg][Ii][Nn][Ss])$",
   "^([Pp]) (+) (.*)$",
   "^([Pp]) (-) (.*)$",
   "^(زمان)$",
   "^([Vv][Oo][Ii][Cc][Ee]) +(.*)$",
   "^(وویس) +(.*)$",
   "^(gif)$", 
   "^([Ss][Tt][Ii][Cc][Kk][Ee][Rr])$",
   "^([Pp][Hh][Oo][Tt][Oo])$",
   "^[#!/](kickme)$",
   "^(kickme)$",
"^([Vv][Ii][Dd][Ee][Oo])$",
"^(mkv)$",
"^([Aa][Uu][Dd][Ii][Oo])$",
"^[!/#]([Ss]etsudo) (%d+)$", 
"^[!/#]([Rr]emsudo) (%d+)$" ,
"^([Ss]etsudo) (%d+)$", 
"^([Rr]emsudo) (%d+)$" ,
  "^yes$",
  "^no$",
"^(cleandeleted)$",
"^(حذف دیلیت اکانتی ها)$",
"^[!#/](حذف دیلیت اکانت ها)$",
"^[!#/](cleandeleted)$",
"^([Vv][Oo][Ii][Cc][Ee])$",
   "^([Ss][Ee][Nn][Dd]) (.*)$", 
   "^(استیکر)$",
   "^(عکس)$",
   "^([!/#])(filter) (.*)$",
   "^([!/#])(unfilter) (.*)$",
   "^([!/#])(unfilter)$",
   "^(گیف)$",
"^(فیلم)$",
"^(آهنگ)$",
"^(وویس)$",
   "^([Gg][Ii][Ff]) (.*)$", 
"^(png)$",
"^([Pp][Hh][Oo][Tt][Oo])$",
 "^([Ss][Tt][Ii][Cc][Kk][Ee][Rr])$",
   "%[(document)%]",
   "%[(photo)%]",
"%[(video)%]",
   "%[(audio)%]",
 }, 
run = run,
}


-- by @mrr619
-- channel @TeleDiamondch

