--Begin supergrpup.lua
--Check members #Add supergroup
local function check_member_super(cb_extra, success, result)
  local receiver = cb_extra.receiver
  local data = cb_extra.data
  local msg = cb_extra.msg
  if success == 0 then
	send_large_msg(receiver, "Promote me to admin first!")
  end
  for k,v in pairs(result) do
    local member_id = v.peer_id
    if member_id ~= our_id then
      -- SuperGroup configuration
      data[tostring(msg.to.id)] = {
        group_type = 'SuperGroup',
		long_id = msg.to.peer_id,
		moderators = {},
        set_owner = member_id ,
        settings = {
          set_name = string.gsub(msg.to.title, '_', ' '),
		  lock_arabic = 'no',
		  lock_link = "no",
          flood = 'yes',
		  lock_spam = 'yes',
		  lock_media = 'no',
		  lock_fwd = 'no',
		  lock_tag = 'no',
		  lock_bots = 'no',
		  lock_audio = 'no',
		  lock_photo = 'no',
		  lock_video = 'no',
		  lock_documents = 'no',
		  lock_text = 'no',
		  lock_all = 'no',
		  lock_gifs = 'no',
		  lock_inline = 'no',
		  lock_cmd = 'no',
		  lock_sticker = 'no',
		  member = 'no',
		  public = 'no',
		  lock_tgservice = 'yes',
		  lock_contacts = 'no',
		  strict = 'no'
        }
      }
      save_data(_config.moderation.data, data)
      local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = {}
        save_data(_config.moderation.data, data)
      end
      data[tostring(groups)][tostring(msg.to.id)] = msg.to.id
      save_data(_config.moderation.data, data)
      local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
   return reply_msg(msg.id,'<code>》ربات اد شد:\n》به گروه:</code> '..msg.to.title..'\n<code>》توسط:</code> @'..msg.from.username..'\n', ok_cb, false)
   else
    return reply_msg(msg.id,'<i>》bot has been Added\n》in Group:</i> '..msg.to.title..'\n<i>》Order By: </i>@'..msg.from.username..'\n', ok_cb, false)
    end
  end
end
end

--Check Members #rem supergroup
local function check_member_superrem(cb_extra, success, result)
  local receiver = cb_extra.receiver
  local data = cb_extra.data
  local msg = cb_extra.msg
  for k,v in pairs(result) do
    local member_id = v.id
    if member_id ~= our_id then
	  -- Group configuration removal
      data[tostring(msg.to.id)] = nil
      save_data(_config.moderation.data, data)
      local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = nil
        save_data(_config.moderation.data, data)
      end
      data[tostring(groups)][tostring(msg.to.id)] = nil
      save_data(_config.moderation.data, data)
  local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
   return reply_msg(msg.id,'<code>》ربات حذف شد:\n》از گروه:</code> '..msg.to.title..'\n<code>》توسط:</code> @'..msg.from.username..'\n', ok_cb, false)
   else
    return reply_msg(msg.id,'<i>》bot has been removed\n》Group: '..msg.to.title..'\n》Order By: </i>@'..msg.from.username..'\n', ok_cb, false)
    end
  end
end
end
--Function to Add supergroup
local function superadd(msg)
	local data = load_data(_config.moderation.data)
	local receiver = get_receiver(msg)
    channel_get_users(receiver, check_member_super,{receiver = receiver, data = data, msg = msg})
end

--Function to remove supergroup
local function superrem(msg)
	local data = load_data(_config.moderation.data)
    local receiver = get_receiver(msg)
    channel_get_users(receiver, check_member_superrem,{receiver = receiver, data = data, msg = msg})
end

--Get and output admins and bots in supergroup
local function callback(cb_extra, success, result)
local i = 1
local chat_name = string.gsub(cb_extra.msg.to.print_name, "_", " ")
local member_type = cb_extra.member_type
local text = member_type.." for "..chat_name..":\n"
for k,v in pairsByKeys(result) do
if not v.first_name then
	name = " "
else
	vname = v.first_name:gsub("‮", "")
	name = vname:gsub("_", " ")
	end
		text = text.."\n"..i.." - "..name.."["..v.peer_id.."]"
		i = i + 1
	end
    send_large_msg(cb_extra.receiver, text)
end

local function callback_clean_bots (extra, success, result)
	local msg = extra.msg
	local receiver = 'channel#id'..msg.to.id
	local channel_id = msg.to.id
	for k,v in pairs(result) do
		local bot_id = v.peer_id
		kick_user(bot_id,channel_id)
	end
end

--Get and output info about supergroup
local function callback_info(cb_extra, success, result)
local title ="Info for SuperGroup: ["..result.title.."]\n\n"
local admin_num = "Admin count: "..result.admins_count.."\n"
local user_num = "User count: "..result.participants_count.."\n"
local kicked_num = "Kicked user count: "..result.kicked_count.."\n"
local channel_id = "ID: "..result.peer_id.."\n"
if result.username then
	channel_username = "Username: @"..result.username
else
	channel_username = ""
end
local text = title..admin_num..user_num..kicked_num..channel_id..channel_username
    send_large_msg(cb_extra.receiver, text)
end

--Get and output members of supergroup
local function callback_who(cb_extra, success, result)
local text = "Members for "..cb_extra.receiver
local i = 1
for k,v in pairsByKeys(result) do
if not v.print_name then
	name = " "
else
	vname = v.print_name:gsub("‮", "")
	name = vname:gsub("_", " ")
end
	if v.username then
		username = " @"..v.username
	else
		username = ""
	end
	text = text.."\n"..i.." - "..name.." "..username.." [ "..v.peer_id.." ]\n"
	--text = text.."\n"..username
	i = i + 1
end
    local file = io.open("./system/chats/lists/supergroups/"..cb_extra.receiver..".txt", "w")
    file:write(text)
    file:flush()
    file:close()
    send_document(cb_extra.receiver,"./system/chats/lists/supergroups/"..cb_extra.receiver..".txt", ok_cb, false)
	post_msg(cb_extra.receiver, text, ok_cb, false)
end

--Get and output list of kicked users for supergroup
local function callback_kicked(cb_extra, success, result)
--vardump(result)
local text = "Kicked Members for SuperGroup "..cb_extra.receiver.."\n\n"
local i = 1
for k,v in pairsByKeys(result) do
if not v.print_name then
	name = " "
else
	vname = v.print_name:gsub("‮", "")
	name = vname:gsub("_", " ")
end
	if v.username then
		name = name.." @"..v.username
	end
	text = text.."\n"..i.." - "..name.." [ "..v.peer_id.." ]\n"
	i = i + 1
end
    local file = io.open("./system/chats/lists/supergroups/kicked/"..cb_extra.receiver..".txt", "w")
    file:write(text)
    file:flush()
    file:close()
    send_document(cb_extra.receiver,"./system/chats/lists/supergroups/kicked/"..cb_extra.receiver..".txt", ok_cb, false)
	--send_large_msg(cb_extra.receiver, text)
end

--Begin supergroup locks
local function lock_group_links(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_link_lock = data[tostring(target)]['settings']['lock_link']
  if group_link_lock == 'yes' then
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
   return reply_msg(msg.id,'<b>》قفل لینڪ دَږ سۅپږگږۊه ازقبل فَعال بود🔒\n》توسط: </b>@'..msg.from.username..'', ok_cb, false)
   else
    return reply_msg(msg.id,'<i>》Link Posting is already locked🔒\n》Order By: </i>@'..msg.from.username..'', ok_cb, false)
    end
    end
    data[tostring(target)]['settings']['lock_link'] = 'yes'
    save_data(_config.moderation.data, data)
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
  return reply_msg(msg.id,'》قفل لینڪ دَږ سۅپږگږۊه فعال شُد🔒\n》توسط: '..msg.from.username..' ', ok_cb, false)
     else
    return reply_msg(msg.id, '<i>》Link Posting Has Been Locked🔒 \n》Order By: </i>@'..msg.from.username..' ', ok_cb, false)
  end
end

local function unlock_group_links(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_link_lock = data[tostring(target)]['settings']['lock_link']
  if group_link_lock == 'no' then
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
   return reply_msg(msg.id,'》قفل لینڪ دَږ سۅپږگږۊه غیږفعال شُده بود🔓 \n》توسط: @'..msg.from.username..' ', ok_cb, false)
    else 
   return reply_msg(msg.id,'<i>》Link Posting is already Unlocked🔓 \n》Order By: </i>@'..msg.from.username..' ', ok_cb, false)
    end
    end
    data[tostring(target)]['settings']['lock_link'] = 'no'
    save_data(_config.moderation.data, data)
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
    return reply_msg(msg.id,'》قفل لینڪ دَږ سۅپږگږۊه غیږفعال شُد🔓 \n》توسط: @'..msg.from.username..' ', ok_cb, false)
     else 
   return reply_msg(msg.id,'<i>》Link Posting Hasbeen unLocked🔓 \n》Order By: </i>@'..msg.from.username..' ', ok_cb, false)
  end
end

  local function lock_group_media(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_media_lock = data[tostring(target)]['settings']['lock_media']
  if group_media_lock == 'yes' then
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
    return '》قُفل فیلم،عکس،آهنگ دږ سۅپږگږوه فعال بود🔒 \n》توسط: @'..msg.from.username..' '
    else
    return '<i>》Media is already locked🔒 \n》Order By: </i>@'..msg.from.username..' '
  end
  end
    data[tostring(target)]['settings']['lock_media'] = 'yes'
    save_data(_config.moderation.data, data)
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
    return '》قُفل فیلم،عکس،آهنگ دږ سۅپږگږوه فعال شُڍ🔒 \n》توسط: @'..msg.from.username..' '
    else 
    return '<i>》Media has been locked🔒 \n》Order By: </i>@'..msg.from.username..' '
  end
end

local function unlock_group_media(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_media_lock = data[tostring(target)]['settings']['lock_media']
  if group_media_lock == 'no' then
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
   return  '》قُفل فیلم،عکس،آهنگ دږ سۅپږگږوه غیر فعال بود🔓 \n》توسط: @'..msg.from.username..' '
   else
    return '<i>》Media is not locked🔓 \n》Order By: </i>@'..msg.from.username..' '
    end
    end
    data[tostring(target)]['settings']['lock_media'] = 'no'
    save_data(_config.moderation.data, data)
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
    return '》قُفل فیلم،عکس،آهنگ دږ سۅپږگږوه غیر فعال شُڍ🔓 \n》توسط: '..msg.from.username..' '
    else
    return '<i>》Media has been unlocked🔓 \n》Order By: </i>@'..msg.from.username..' '
  end
end
    
  local function lock_group_fwd(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_fwd_lock = data[tostring(target)]['settings']['lock_fwd']
  if group_fwd_lock == 'yes' then
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
  return ' 》قُفل فۅږواږد دږ سوپږ گرۅه فعال بود🔒 \n》توسط: @'..msg.from.username..' '
  else
    return '<i>》fwd posting is already locked🔒\n》Order By: </i>@'..msg.from.username..' '
  end
  end
    data[tostring(target)]['settings']['lock_fwd'] = 'yes'
    save_data(_config.moderation.data, data)
    local hash = 'fwd:'..msg.to.id
    redis:set(hash, true)
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
    return '》قفل فۅږۅاږد دږ سۅپږ گږۅة فعاڶ شُد🔒 \n》توسط: @'..msg.from.username..' '
    else
    return '<i>》Fwd has been locked🔐 \n》Order By: </i>@'..msg.from.username..' '
  end
end

local function unlock_group_fwd(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_fwd_lock = data[tostring(target)]['settings']['lock_fwd']
  if group_fwd_lock == 'no' then
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
    return '》قفل فۅږۅاږد دږ سۅپږگږۅة از قبل غیږ فعاڶ شُدہ بۅڍ🔒 \n》توسط: @'..msg.from.username..' '
  else
  return '<i>》Fwd is not locked🔓 \n》Order By: </i>@'..msg.from.username..' '
  end
  end
    data[tostring(target)]['settings']['lock_fwd'] = 'no'
    save_data(_config.moderation.data, data)
    local hash = 'fwd:'..msg.to.id
    redis:del(hash)
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
    return '》قفل فۅږۅاږد دږ سۅپږ گږۅة غیرفعاڶ شُد🔒 \n》توسط: @'..msg.from.username..' '
    else
    return '<i>》Fwd has been unlocked🔓 \n》Order By: </i>@'..msg.from.username..' '
  end
end

local function lock_group_tag(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_tag_lock = data[tostring(target)]['settings']['lock_tag']
  if group_tag_lock == 'yes' then
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
  return 'قُفل هشتگ(#) دږ سوپږگږوه فعال بود🔒 \n》توسط: @'..msg.from.username..' '
  else
    return '<i>》Tag is already locked🔒 \n》Order By: </i>@'..msg.from.username..' '
  end
  end
    data[tostring(target)]['settings']['lock_tag'] = 'yes'
    save_data(_config.moderation.data, data)
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
  return '》قُفل هشتگ(#) دږ سوپږگږوه فعال شُد🔒 \n》توسط: @'..msg.from.username..' '
  else
    return '<i>》Tag has been locked🔒 \n》Order By: </i>@'..msg.from.username..' '
  end
end

local function unlock_group_tag(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_tag_lock = data[tostring(target)]['settings']['lock_tag']
  if group_tag_lock == 'no' then
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
  return '》قُفل هشتگ(#) دږ سوپږگږوه غیر فعال بود🔓 \n》توسط: @'..msg.from.username..' '
  else
    return '<i>》Tag is not locked🔓\n》Order By: </i>@'..msg.from.username..' '
  end
  end
    data[tostring(target)]['settings']['lock_tag'] = 'no'
    save_data(_config.moderation.data, data)
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
  return '》قُفل هشتگ(#) دږ سوپږگږوه غیر فعال شُد🔓 \n》توسط: @'..msg.from.username..' '
  else
    return '<i>》Tag has been unlocked🔓 \n》Order By: </i>@'..msg.from.username..' '
  end
end

local function lock_group_bots(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_bots_lock = data[tostring(target)]['settings']['lock_bots']
  if group_bots_lock == 'yes' then
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
    return '》قفل وږوڍ رباټ هاے مُخَرِب بہ سوپږگږۅه فعال شُده بوڍ🔒 \n》توسط: @'..msg.from.username..' '
  else
  return '<i>》Bots protection is already enabled🔐 \n》Order By: </i>@'..msg.from.username.. ' '
  end
  end
    data[tostring(target)]['settings']['lock_bots'] = 'yes'
    save_data(_config.moderation.data, data)
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
    return '》قفل وږوڍ رباټ هاے مُخَرِب بہ سوپږگږۅه فعال شُد🔒 \n》توسط: @'..msg.from.username..' '
    else
    return '<i>》Bots protection has been enabled🔐 \n》Order By: </i>@'..msg.from.username.. ' '
  end
end

local function unlock_group_bots(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_bots_lock = data[tostring(target)]['settings']['lock_bots']
  if group_bots_lock == 'no' then
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
    return '》قفل وږوڍ رباټ هاے مُخَرِب بہ سوپږگږۅه غیر فعال شُده بود🔓 \n》توسط: @'..msg.from.username..' '
  else
  return '<i>》Bots protection is already disabled🔓 \n》Order By: </i>@'..msg.from.username.. ' '
  end
  end
    data[tostring(target)]['settings']['lock_bots'] = 'no'
    save_data(_config.moderation.data, data)
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
    return '》قفل وږوڍ رباټ هاے مُخَرِب بہ سوپږگږۅه غیر فعال شُد🔓 \n》توسط: @'..msg.from.username..' '
    else
    return '<i>》Bots protection has been disabled🔓 \n》Order By: </i>@'..msg.from.username.. ' '
  end
end
 -- by @mrr619 TeleDiamond
  local function lock_group_audio(msg, data, target)
    local msg_type = 'Audio'
    local chat_id = msg.to.id
  if not is_momod(msg) then
    return
  end
  local group_audio_lock = data[tostring(target)]['settings']['lock_audio']
  if group_audio_lock == 'yes' and is_muted(chat_id, msg_type..': yes') then
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
   return reply_msg(msg.id,'》قفل آهنگ دَږ سۅپږگږۊه ازقبل فَعال بود🔒 \n》توسط: @'..msg.from.username..' ', ok_cb, false)
   else
    return reply_msg(msg.id,'<i>》Lock Audio is already on🔒\n》Order By</i> @'..msg.from.username..' ', ok_cb, false)
  end
  end
    if not is_muted(chat_id, msg_type..': yes') then
    mute(chat_id, msg_type)
    data[tostring(target)]['settings']['lock_audio'] = 'yes'
    save_data(_config.moderation.data, data)
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
   return reply_msg(msg.id,'》قفل آهنگ دَږ سۅپږگږۊه فَعال شد🔒\n》توسط: @'..msg.from.username..' ', ok_cb, false)
   else
    return reply_msg(msg.id,'<i>》Audio posting has Been locked🔒\n》Order By</i> @'..msg.from.username..' ', ok_cb, false)
    end
  end
end

local function unlock_group_audio(msg, data, target)
  local chat_id = msg.to.id
  local msg_type = 'Audio'
  if not is_momod(msg) then
    return
  end
  local group_audio_lock = data[tostring(target)]['settings']['lock_audio']
  if group_audio_lock == 'no' and not is_muted(chat_id, msg_type..': yes') then
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
   return reply_msg(msg.id,'》قفل آهنگ دَږ سۅپږگږۊه از قبل غیږفعال بود🔓 \n》توسط: @'..msg.from.username..' ', ok_cb, false)
    else 
   return reply_msg(msg.id,'<i>》Audio Posting is already Unlocked🔓 \n》Order By: </i>@'..msg.from.username..' ', ok_cb, false)
  end
  end
    if is_muted(chat_id, msg_type..': yes') then
    unmute(chat_id, msg_type)
    data[tostring(target)]['settings']['lock_audio'] = 'no'
    save_data(_config.moderation.data, data)
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
   return reply_msg(msg.id,'》قفل آهنگ دَږ سۅپږگږۊه غیږفعال شُد🔓 \n》توسط: @'..msg.from.username..' ', ok_cb, false)
    else 
   return reply_msg(msg.id,'<i>》Audio Posting has Been Unlocked🔓 \n》Order By: </i>@'..msg.from.username..' ', ok_cb, false)
    end
  end
end

  local function lock_group_photo(msg, data, target)
    local msg_type = 'Photo'
    local chat_id = msg.to.id
  if not is_momod(msg) then
    return
  end
  local group_photo_lock = data[tostring(target)]['settings']['lock_photo']
  if group_photo_lock == 'yes' and is_muted(chat_id, msg_type..': yes') then
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
   return reply_msg(msg.id,'》قفل عکس دَږ سۅپږگږۊه ازقبل فَعال بود🔒 \n》توسط: @'..msg.from.username..' ', ok_cb, false)
   else
    return reply_msg(msg.id,'<i>》Lock Photo is already on🔒\n》Order By</i> @'..msg.from.username..' ', ok_cb, false)
  end
  end
    if not is_muted(chat_id, msg_type..': yes') then
    mute(chat_id, msg_type)
    data[tostring(target)]['settings']['lock_photo'] = 'yes'
    save_data(_config.moderation.data, data)
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
   return reply_msg(msg.id,'》قفل عکس دَږ سۅپږگږۊه فَعال شد🔒\n》توسط: @'..msg.from.username..' ', ok_cb, false)
   else
    return reply_msg(msg.id,'<i>》Photo posting has Been locked🔒\n》Order By</i> @'..msg.from.username..' ', ok_cb, false)
    end
  end
end

local function unlock_group_photo(msg, data, target)
  local chat_id = msg.to.id
  local msg_type = 'Photo'
  if not is_momod(msg) then
    return
  end
  local group_photo_lock = data[tostring(target)]['settings']['lock_photo']
  if group_photo_lock == 'no' and not is_muted(chat_id, msg_type..': yes') then
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
   return reply_msg(msg.id,'》قفل عکس دَږ سۅپږگږۊه از قبل غیږفعال بود🔓 \n》توسط: @'..msg.from.username..' ', ok_cb, false)
    else 
   return reply_msg(msg.id,'<i>》Photo Posting is already Unlocked🔓 \n》Order By: </i>@'..msg.from.username..' ', ok_cb, false)
  end
  end
    if is_muted(chat_id, msg_type..': yes') then
    unmute(chat_id, msg_type)
    data[tostring(target)]['settings']['lock_photo'] = 'no'
    save_data(_config.moderation.data, data)
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
   return reply_msg(msg.id,'》قفل عکس دَږ سۅپږگږۊه غیږفعال شُد🔓 \n》توسط: @'..msg.from.username..' ', ok_cb, false)
    else 
   return reply_msg(msg.id,'<i>》Photo Posting has Been Unlocked🔓 \n》Order By: </i>@'..msg.from.username..' ', ok_cb, false)
    end
  end
end

  local function lock_group_video(msg, data, target)
    local msg_type = 'Video'
    local chat_id = msg.to.id
  if not is_momod(msg) then
    return
  end
  local group_video_lock = data[tostring(target)]['settings']['lock_video']
  if group_video_lock == 'yes' and is_muted(chat_id, msg_type..': yes') then
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
   return reply_msg(msg.id,'》قفل فیلم دَږ سۅپږگږۊه ازقبل فَعال بود🔒 \n》توسط: @'..msg.from.username..' ', ok_cb, false)
   else
    return reply_msg(msg.id,'<i>》Lock Video is already on🔒\n》Order By</i> @'..msg.from.username..' ', ok_cb, false)
  end
  end
    if not is_muted(chat_id, msg_type..': yes') then
    mute(chat_id, msg_type)
    data[tostring(target)]['settings']['lock_video'] = 'yes'
    save_data(_config.moderation.data, data)
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
   return reply_msg(msg.id,'》قفل فیلم دَږ سۅپږگږۊه فَعال شد🔒\n》توسط: @'..msg.from.username..' ', ok_cb, false)
   else
    return reply_msg(msg.id,'<i>》Video posting has Been locked🔒\n》Order By</i> @'..msg.from.username..' ', ok_cb, false)
    end
  end
end

local function unlock_group_video(msg, data, target)
  local chat_id = msg.to.id
  local msg_type = 'Video'
  if not is_momod(msg) then
    return
  end
  local group_video_lock = data[tostring(target)]['settings']['lock_video']
  if group_video_lock == 'no' and not is_muted(chat_id, msg_type..': yes') then
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
   return reply_msg(msg.id,'》قفل فیلم دَږ سۅپږگږۊه از قبل غیږفعال بود🔓 \n》توسط: @'..msg.from.username..' ', ok_cb, false)
    else 
   return reply_msg(msg.id,'<i>》Video Posting is already Unlocked🔓 \n》Order By: </i>@'..msg.from.username..' ', ok_cb, false)
  end
  end
    if is_muted(chat_id, msg_type..': yes') then
    unmute(chat_id, msg_type)
    data[tostring(target)]['settings']['lock_video'] = 'no'
    save_data(_config.moderation.data, data)
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
   return reply_msg(msg.id,'》قفل فیلم دَږ سۅپږگږۊه غیږفعال شُد🔓 \n》توسط: @'..msg.from.username..' ', ok_cb, false)
    else 
   return reply_msg(msg.id,'<i>》Video Posting has Been Unlocked🔓 \n》Order By: </i>@'..msg.from.username..' ', ok_cb, false)
    end
  end
end

  local function lock_group_documents(msg, data, target)
    local msg_type = 'Documents'
    local chat_id = msg.to.id
  if not is_momod(msg) then
    return
  end
  local group_documents_lock = data[tostring(target)]['settings']['lock_documents']
  if group_documents_lock == 'yes' and is_muted(chat_id, msg_type..': yes') then
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
   return reply_msg(msg.id,'》قفل فایل دَږ سۅپږگږۊه ازقبل فَعال بود🔒 \n》توسط: @'..msg.from.username..' ', ok_cb, false)
   else
    return reply_msg(msg.id,'<i>》Lock Documents is already on🔒\n》Order By: </i>@'..msg.from.username..' ', ok_cb, false)
  end
  end
    if not is_muted(chat_id, msg_type..': yes') then
    mute(chat_id, msg_type)
    data[tostring(target)]['settings']['lock_documents'] = 'yes'
    save_data(_config.moderation.data, data)
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
   return reply_msg(msg.id,'》قفل فایل دَږ سۅپږگږۊه فَعال شد🔒\n》توسط: @'..msg.from.username..' ', ok_cb, false)
   else
    return reply_msg(msg.id,'<i>》Documents posting has Been locked🔒\n》Order By: </i>@'..msg.from.username..' ', ok_cb, false)
    end
  end
end

local function unlock_group_documents(msg, data, target)
  local chat_id = msg.to.id
  local msg_type = 'Documents'
  if not is_momod(msg) then
    return
  end
  local group_documents_lock = data[tostring(target)]['settings']['lock_documents']
  if group_documents_lock == 'no' and not is_muted(chat_id, msg_type..': yes') then
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
   return reply_msg(msg.id,'》قفل فایل دَږ سۅپږگږۊه از قبل غیږفعال بود🔓 \n》توسط: @'..msg.from.username..' ', ok_cb, false)
    else 
   return reply_msg(msg.id,'<i>》Documents Posting is already Unlocked🔓 \n》Order By: </i>@'..msg.from.username..' ', ok_cb, false)
  end
  end
    if is_muted(chat_id, msg_type..': yes') then
    unmute(chat_id, msg_type)
    data[tostring(target)]['settings']['lock_documents'] = 'no'
    save_data(_config.moderation.data, data)
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
   return reply_msg(msg.id,'》قفل فایل دَږ سۅپږگږۊه غیږفعال شُد🔓 \n》توسط: @'..msg.from.username..' ', ok_cb, false)
    else 
   return reply_msg(msg.id,'<i>》Documents Posting has Been Unlocked🔓 \n》Order By: </i>@'..msg.from.username..' ', ok_cb, false)
    end
  end
end

  local function lock_group_text(msg, data, target)
    local msg_type = 'Text'
    local chat_id = msg.to.id
  if not is_momod(msg) then
    return
  end
  local group_text_lock = data[tostring(target)]['settings']['lock_text']
  if group_text_lock == 'yes' and is_muted(chat_id, msg_type..': yes') then
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
   return reply_msg(msg.id,'》قفل متن دَږ سۅپږگږۊه ازقبل فَعال بود🔒 \n》توسط: @'..msg.from.username..' ', ok_cb, false)
   else
    return reply_msg(msg.id,'<i>》Lock Text is already on🔒\n》Order By: </i>@'..msg.from.username..' ', ok_cb, false)
  end
  end
    if not is_muted(chat_id, msg_type..': yes') then
    mute(chat_id, msg_type)
    data[tostring(target)]['settings']['lock_text'] = 'yes'
    save_data(_config.moderation.data, data)
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
   return reply_msg(msg.id,'》قفل متن دَږ سۅپږگږۊه فَعال شد🔒\n》توسط: @'..msg.from.username..' ', ok_cb, false)
   else
    return reply_msg(msg.id,'<i>》Text posting has Been locked🔒\n》Order By: </i>@'..msg.from.username..' ', ok_cb, false)
    end
  end
end

local function unlock_group_text(msg, data, target)
  local chat_id = msg.to.id
  local msg_type = 'Text'
  if not is_momod(msg) then
    return
  end
  local group_text_lock = data[tostring(target)]['settings']['lock_text']
  if group_text_lock == 'no' and not is_muted(chat_id, msg_type..': yes') then
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
   return reply_msg(msg.id,'》قفل متن دَږ سۅپږگږۊه از قبل غیږفعال بود🔓 \n》توسط: @'..msg.from.username..' ', ok_cb, false)
    else 
   return reply_msg(msg.id,'<i>》Text Posting is already Unlocked🔓 \n》Order By: </i>@'..msg.from.username..' ', ok_cb, false)
  end
  end
    if is_muted(chat_id, msg_type..': yes') then
    unmute(chat_id, msg_type)
    data[tostring(target)]['settings']['lock_text'] = 'no'
    save_data(_config.moderation.data, data)
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
   return reply_msg(msg.id,'》قفل متن دَږ سۅپږگږۊه غیږفعال شُد🔓 \n》توسط: @'..msg.from.username..' ', ok_cb, false)
    else 
   return reply_msg(msg.id,'<i>》Text Posting has Been Unlocked🔓 \n》Order By: </i>@'..msg.from.username..' ', ok_cb, false)
    end
  end
end

  local function lock_group_all(msg, data, target)
    local msg_type = 'All'
    local chat_id = msg.to.id
  if not is_momod(msg) then
    return
  end
  local group_all_lock = data[tostring(target)]['settings']['lock_all']
  if group_all_lock == 'yes' and is_muted(chat_id, msg_type..': yes') then
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
   return reply_msg(msg.id,'》قفل چت از قبل فعال بود🔒 \n》توسط: @'..msg.from.username..' ', ok_cb, false)
   else
    return reply_msg(msg.id,'<i>》All locks is already on🔒\n》Order By: </i>@'..msg.from.username..' ', ok_cb, false)
  end
  end
    if not is_muted(chat_id, msg_type..': yes') then
    mute(chat_id, msg_type)
    data[tostring(target)]['settings']['lock_all'] = 'yes'
    save_data(_config.moderation.data, data)
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
   return reply_msg(msg.id,'》قفل چت فعال شد🔒\n》توسط: @'..msg.from.username..' ', ok_cb, false)
   else
    return reply_msg(msg.id,'<i>》All locks has Been on🔒\n》Order By: </i>@'..msg.from.username..' ', ok_cb, false)
    end
  end
end

local function unlock_group_all(msg, data, target)
  local chat_id = msg.to.id
  local msg_type = 'All'
  if not is_momod(msg) then
    return
  end
  local group_all_lock = data[tostring(target)]['settings']['lock_all']
  if group_all_lock == 'no' and not is_muted(chat_id, msg_type..': yes') then
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
   return reply_msg(msg.id,'》قفل چت غیرفعالل بود🔓 \n》توسط: @'..msg.from.username..' ', ok_cb, false)
    else 
   return reply_msg(msg.id,'<i>》All Posting is already Unlocked🔓 \n》Order By: </i>@'..msg.from.username..' ', ok_cb, false)
  end
  end
    if is_muted(chat_id, msg_type..': yes') then
    unmute(chat_id, msg_type)
    data[tostring(target)]['settings']['lock_all'] = 'no'
    save_data(_config.moderation.data, data)
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
   return reply_msg(msg.id,'》قفل چت غیری فعال شد🔓 \n》توسط: @'..msg.from.username..' ', ok_cb, false)
    else 
   return reply_msg(msg.id,'<i>》All Posting has Been Unlocked🔓 \n》Order By: </i>@'..msg.from.username..' ', ok_cb, false)
    end
  end
end

  local function lock_group_gifs(msg, data, target)
    local msg_type = 'Gifs'
    local chat_id = msg.to.id
  if not is_momod(msg) then
    return
  end
  local group_gifs_lock = data[tostring(target)]['settings']['lock_gifs']
  if group_gifs_lock == 'yes' and is_muted(chat_id, msg_type..': yes') then
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
   return reply_msg(msg.id,'》قفل گیف دَږ سۅپږگږۊه ازقبل فَعال بود🔒 \n》توسط: @'..msg.from.username..' ', ok_cb, false)
   else
    return reply_msg(msg.id,'<i>》Lock Gif is already on🔒\n》Order By</i> @'..msg.from.username..' ', ok_cb, false)
  end
  end
    if not is_muted(chat_id, msg_type..': yes') then
    mute(chat_id, msg_type)
    data[tostring(target)]['settings']['lock_gifs'] = 'yes'
    save_data(_config.moderation.data, data)
    ute(chat_id, msg_type)
  local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
   return reply_msg(msg.id,'》قفل گیف دَږ سۅپږگږۊه فَعال شد🔒\n》توسط: @'..msg.from.username..' ', ok_cb, false)
   else
    return reply_msg(msg.id,'<i>》Gif posting has Been locked🔒\n》Order By</i> @'..msg.from.username..' ', ok_cb, false)
    end
  end
end

local function unlock_group_gifs(msg, data, target)
  local chat_id = msg.to.id
  local msg_type = 'Gifs'
  if not is_momod(msg) then
    return
  end
  local group_gifs_lock = data[tostring(target)]['settings']['lock_gifs']
  if group_gifs_lock == 'no' and not is_muted(chat_id, msg_type..': yes') then
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
   return reply_msg(msg.id,'》قفل گیف دَږ سۅپږگږۊه از قبل غیږفعال بود🔓 \n》توسط: @'..msg.from.username..' ', ok_cb, false)
    else 
   return reply_msg(msg.id,'<i>》Gif Posting is already Unlocked🔓 \n》Order By: </i>@'..msg.from.username..' ', ok_cb, false)
  end
  end
    if is_muted(chat_id, msg_type..': yes') then
    unmute(chat_id, msg_type)
    data[tostring(target)]['settings']['lock_gifs'] = 'no'
    save_data(_config.moderation.data, data)
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
   return reply_msg(msg.id,'》قفل گیف دَږ سۅپږگږۊه غیږفعال شُد🔓 \n》توسط: @'..msg.from.username..' ', ok_cb, false)
    else 
   return reply_msg(msg.id,'<i>》Gif Posting has Been Unlocked🔓 \n》Order By: </i>@'..msg.from.username..' ', ok_cb, false)
    end
  end
end

local function lock_group_inline(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_inline_lock = data[tostring(target)]['settings']['lock_inline']
  if group_inline_lock == 'yes' then
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
    return '》قفل دکمه شیشه ای فعال بود🔒\n》توسط: @'..msg.from.username..''
  else
    return '<i>》Inline Posting is already locked🔒 \n》Order By: </i>@'..msg.from.username..' '
    end
    end
    data[tostring(target)]['settings']['lock_inline'] = 'yes'
    save_data(_config.moderation.data, data)
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
    return '》قفله دکمه شیشه ای فعال شد🔒 \n》توسط: @'..msg.from.username..' '
     else
    return '<i>》Inline Posting Has Been Locked🔒 \n》Order By: </i>@'..msg.from.username..' '
  end
end

local function unlock_group_inline(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_inline_lock = data[tostring(target)]['settings']['lock_inline']
  if group_inline_lock == 'no' then
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
  return '》قفل دکمه شیشه ای فعال بود🔒\n》توسط: @'..msg.from.username..' '
    else 
    return '<i>》Inline Posting is already Unlocked🔓 \n》Order By: </i>@'..msg.from.username..' '
    end
    end
    data[tostring(target)]['settings']['lock_inline'] = 'no'
    save_data(_config.moderation.data, data)
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
    return '》قفل دکمه شیشه ای غیز فعال شد🔓 \n》توسط: @'..msg.from.username..' '
     else 
     return '<i>》Inline Posting Hasbeen unLocked🔓 \n》Order By: </i>@'..msg.from.username..' '
  end
end
-- TeleDiamond
local function lock_group_cmd(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_cmd_lock = data[tostring(target)]['settings']['lock_cmd']
  if group_cmd_lock == 'yes' then
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
   return '》قفل دستورات بسته بود🔒 \n》توسط: @'..msg.from.username..' '
   else
    return '<i>》cmds Posting is already locked🔒 \n》Order By: </i>@'..msg.from.username..' '
    end
    end
    data[tostring(target)]['settings']['lock_cmd'] = 'yes'
    save_data(_config.moderation.data, data)
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
    return '》قفل دستورات بسته شد🔒 \n》توسط: @'..msg.from.username..' '
     else
    return '<i>》cmds Posting Has Been Locked🔒 \n》Order By: </i>@'..msg.from.username..' '
  end
end

local function unlock_group_cmd(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_cmd_lock = data[tostring(target)]['settings']['lock_cmd']
  if group_cmd_lock == 'no' then
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
    return '》قفل دستورات غیرفعال بود🔓 \n》توسط: @'..msg.from.username..' '
    else 
    return '<i>》cmds Posting is already Unlocked🔓 \n》Order By: </i>@'..msg.from.username..' '
    end
    end
    data[tostring(target)]['settings']['lock_cmd'] = 'no'
    save_data(_config.moderation.data, data)
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
    return '》قفل دستورات غیر فعال شد🔓 \n》توسط: @'..msg.from.username..' '
     else 
     return '<i>》cmds Posting Hasbeen unLocked🔓 \n》Order By: </i>@'..msg.from.username..' '
  end
end 

local function is_cmd(jtext)
    if jtext:match("^[/#!](.*)$") then
        return true
    end
    return false
end

    local function isABotBadWay (user)
      local username = user.username or ''
      return username:match("[Bb]ot$")
    end
  
  local function get_variables_hash(msg)

    return 'chat:'..msg.to.id..':badword'

end 

local function list_variablesbad(msg)
  local hash = get_variables_hash(msg)

  if hash then
    local names = redis:hkeys(hash)
    local text = 'List of words :\n\n'
    for i=1, #names do
      text = text..'> '..names[i]..'\n'
    end
    return text
  else
  return 
  end
end

local function list_variables2(msg, value)
  local hash = get_variables_hash(msg)
  
  if hash then
    local names = redis:hkeys(hash)
    local text = ''
    for i=1, #names do
  if string.match(value, names[i]) and not is_momod(msg) then
  if msg.to.type == 'channel' then
  delete_msg(msg.id,ok_cb,false)
  else
  kick_user(msg.from.id, msg.to.id)

  end
return 
end
      --text = text..names[i]..'\n'
    end
  end
end

local function lock_group_spam(msg, data, target)
  if not is_momod(msg) then
    return
  end
  if not is_owner(msg) then
    return "Owners only!"
  end
  local group_spam_lock = data[tostring(target)]['settings']['lock_spam']
  if group_spam_lock == 'yes' then
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
    return '》قُفل اِسپَم دَږ سۅپږگږۅہ از قَبڶ فعاڶ بۅد🔐 \n》توسط: @'..msg.from.username..' '
  else
  return '<i>》spam posting is already locked🔒 \n》Order By: </i>@'..msg.from.username..' '
  end
  end
    data[tostring(target)]['settings']['lock_spam'] = 'yes'
    save_data(_config.moderation.data, data)
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
    return '》قُفل اِسپَم دَږ سۅپږ گږۅہ فعاڶ شُڍ🔐 \n》توسط: @'..msg.from.username..' '
    else
    return '<i>》spam posting hasBeen locked🔒 \n》Order By: </i>@'..msg.from.username..' '
  end
end

local function unlock_group_spam(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_spam_lock = data[tostring(target)]['settings']['lock_spam']
  if group_spam_lock == 'no' then
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
    return '》قُفل اِسپَم دَږ سۅپږگږۅہ از قَبڶ غیرفعاڶ بۅد🔐 \n》توسط: @'..msg.from.username..' '
  else
  return '<i>》spam posting is already unlocked🔒 \n》Order By: </i>@'..msg.from.username..' '
  end
  end
    data[tostring(target)]['settings']['lock_spam'] = 'no'
    save_data(_config.moderation.data, data)
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
    return '》قُفل اِسپَم دَږ سۅپږ گږۅہ غیر فعاڶ شُڍ🔐\n》توسط: @'..msg.from.username..' '
    else
    return '<i>》spam posting hasBeen unlocked🔒 \n》Order By: </i>@'..msg.from.username..' '
  end
end

local function lock_group_username(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_username_lock = data[tostring(target)]['settings']['username']
  if group_username_lock == 'yes' then
  local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
  return '》قُفل یوزرنیم(@) دږ سوپرگږوه فعال بود🔒 \n》توسط: @'..msg.from.username..' '
  else
    return '<i>》Username is already locked🔒 \n》Order By: </i>@'..msg.from.username..' '
  end
  end
    data[tostring(target)]['settings']['username'] = 'yes'
    save_data(_config.moderation.data, data)
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
  return '》قُفل یوزرنیم(@) دږ سوپرگږوه فعال شد🔒 \n》توسط: @'..msg.from.username..' '
  else
    return '<i>》Username has been locked🔒 \n》Order By: </i>@'..msg.from.username..' '
  end
end

local function unlock_group_username(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_username_lock = data[tostring(target)]['settings']['username']
  if group_username_lock == 'no' then
  local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
  return '》قُفل یوزرنیم(@) دږ سوپرگږوه غیږفعال بود🔒 \n》توسط: @'..msg.from.username..' '
  else
    return '<i>》Username is not locked🔓 \n》Order By: </i>@'..msg.from.username..' '
  end
  end
    data[tostring(target)]['settings']['username'] = 'no'
    save_data(_config.moderation.data, data)
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
  return '》قُفل یوزرنیم(@) دږ سوپرگږوه غیږفعال شد🔒 \n》توسط: @'..msg.from.username..' '
  else
    return '<i>》Username has been unlocked🔓 \n》Order By: </i>@'..msg.from.username..' '
  end
end


local function lock_group_flood(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_flood_lock = data[tostring(target)]['settings']['flood']
  if group_flood_lock == 'yes' then
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
    return '》قُفل فِلۅڍ دَږ سۅپږ گږۅہ از قبل فعاڶ شُڍه بود🔐 \n》توسط: @'..msg.from.username..' '
  else
  return '<i>》flood is already locked🔒 \n》Order By: </i>@'..msg.from.username..' '
  end
  end
    data[tostring(target)]['settings']['flood'] = 'yes'
    save_data(_config.moderation.data, data)
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
    return '》قُفل فِلۅڍ دَږ سۅپږ گږۅہ فعاڶ شُڍ🔐 \n》توسط: @'..msg.from.username..' '
    else
    return '<i>》flood has been locked🔒 \n》Order By: </i>@'..msg.from.username..' '
  end
end

local function unlock_group_flood(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_flood_lock = data[tostring(target)]['settings']['flood']
  if group_flood_lock == 'no' then
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
    return '》قُفل فِلۅڍ دَږ سۅپږ گږۅہ ازقبڶ غیږفعاڶ  شُڍه بۏد🔓 \n》توسط: @'..msg.from.username..' '
  else
  return '<i>》flood is not locked🔓 \n》Order By: </i>@'..msg.from.username..' '
  end
  end
    data[tostring(target)]['settings']['flood'] = 'no'
    save_data(_config.moderation.data, data)
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
    return '》قُفل فِلۅڍ دَږ سۅپږ گږۅہ غیږفعاڶ شُڍ🔓 \n》توسط: @'..msg.from.username..' '
    else
    return '<i>》flood has been unlocked🔓 \n》Order By: </i>@'..msg.from.username..' '
  end
end

local function lock_group_arabic(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_arabic_lock = data[tostring(target)]['settings']['lock_arabic']
  if group_arabic_lock == 'yes' then
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
    return '》قُفل چت به زبان عربی/فارسی در سوپر گروه از قبل فعال بود🔐 \n》توسط: @'..msg.from.username..' '
  else
  return '<i>》Arabic/persion is already locked🔒 \n》Order By: </i>@'..msg.from.username..' '
  end
  end
    data[tostring(target)]['settings']['lock_arabic'] = 'yes'
    save_data(_config.moderation.data, data)
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
    return '》قُفل چت به زبان عربی/فارسی در سوپر گروه فعال شد🔐 \n》توسط: @'..msg.from.username..' '
    else
    return '<i>》Arabic/Persion has been locked🔒 \n》Order By: </i>@'..msg.from.username..' '
  end
end

local function unlock_group_arabic(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_arabic_lock = data[tostring(target)]['settings']['lock_arabic']
  if group_arabic_lock == 'no' then
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
    return '》قُفل چت به زبان عربی/فارسی در سوپر گروه غیرفعال بود🔓 \n》توسط: @'..msg.from.username..' '
  else
  return '<i>》Arabic/persion is not locked🔓 \n》Order By: </i>@'..msg.from.username..' '
  end
  end
    data[tostring(target)]['settings']['lock_arabic'] = 'no'
    save_data(_config.moderation.data, data)
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
    return '》قُفل چت به زبان عربی/فارسی غیرفعال شد🔓 \n》توسط: @'..msg.from.username..' '
    else
    return '<i>》Arabic/persion has been unlocked🔓 \n》Order By: </i>@'..msg.from.username..' '
  end
end

local function lock_group_membermod(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_member_lock = data[tostring(target)]['settings']['lock_member']
  if group_member_lock == 'yes' then
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
    return '》قفل اضافہ ڪردن اعضٵ بہ سۅپږ گږۅه از قبڶ فعاڶ شُده بۅڍ🔒 \n》توسط: @'..msg.from.username..' '
  else
  return '<i>》addMember is already locked🔒 \n》Order By: </i>@'..msg.from.username..' '
  end
  end
    data[tostring(target)]['settings']['lock_member'] = 'yes'
    save_data(_config.moderation.data, data)
  local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
  return '》قفل اضافہ ڪردن اعضٵ بہ سۅپږ گږۅه فعاڶ شُد🔒 \n》توسط: @'..msg.from.username..' '
  else
  return '<i>》addMember HasBeen locked🔒 \n》Order By: </i>@'..msg.from.username..' '
  end
end

local function unlock_group_membermod(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_member_lock = data[tostring(target)]['settings']['lock_member']
  if group_member_lock == 'no' then
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
    return '》قفل اضافہ ڪردن اعضٵ بہ سۅپږ گږۅه از قَبڶ غیږفعاڶ شُده بۅد🔓 \n》توسط: @'..msg.from.username..' '
  else
  return '<i>》AddMember is not locked🔓 \n》Order By: </i>@'..msg.from.username..' '
  end
  end
    data[tostring(target)]['settings']['lock_member'] = 'no'
    save_data(_config.moderation.data, data)
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
    return '》قفل اضافہ ڪردن اعضٵ بہ سۅپږ گږۅه غیرفعاڶ شُد🔓 \n》توسط: @'..msg.from.username..' '
    else
    return '<i>》AddMember hasBeen UNlocked🔓 \n》Order By: </i>@'..msg.from.username..' '
  end
end

local function lock_group_tgservice(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_tgservice_lock = data[tostring(target)]['settings']['lock_tgservice']
  if group_tgservice_lock == 'yes' then
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
  return ' 》قُفل Tgservice در سوپږ گږوه فعال بود🔒 \n》توسط: @'..msg.from.username..' '
  else
    return '🔐TGservice is already locked🔐 \n》Order By: '..msg.from.username..' '
  end
  end
    data[tostring(target)]['settings']['lock_tgservice'] = 'yes'
    save_data(_config.moderation.data, data)
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
  return ' 》قُفل Tgservice در سوپږ گږوه فعال شد🔒 \n》توسط: @'..msg.from.username..' '
  else
    return '🔐TGservice has been locked🔐 \n》Order By: '..msg.from.username.. ' '
  end
end

local function unlock_group_tgservice(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_tgservice_lock = data[tostring(target)]['settings']['lock_tgservice']
  if group_tgservice_lock == 'no' then
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
  return '》قُفل Tgservice در سوپږ گږوه غیر فعال بود🔓 \n》توسط: @'..msg.from.username..' '
  else
    return '<i>》TGService Is Not Locked!🔓 \n》Order By: </i>@'..msg.from.username.. ' '
  end
  end
    data[tostring(target)]['settings']['lock_tgservice'] = 'no'
    save_data(_config.moderation.data, data)
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
  return ' 》قُفل Tgservice در سوپږ گږوه غیر فعال شد🔓 \n》توسط: @'..msg.from.username..' '
  else
    return '<i>》TGservice has been unlocked🔓\n》Order By: </i>@'..msg.from.username.. ' '
  end
end

local function lock_group_sticker(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_sticker_lock = data[tostring(target)]['settings']['lock_sticker']
  if group_sticker_lock == 'yes' then
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
    return '》قفل استیڪږ دږ سۅپږ گږۅه از قبڶ فعاڶ شُڍه بۅڍ🔐 \n》توسط: @'..msg.from.username..' '
  else
  return '<i>》sticker posting is already locked🔒 \n》Order By: </i>@'..msg.from.username.. ' '
  end
  end
    data[tostring(target)]['settings']['lock_sticker'] = 'yes'
    save_data(_config.moderation.data, data)
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
    return '》قفل استیڪږ دږ سۅپږ گږۅه فعاڶ شُڍ🔐 \n》توسط: @'..msg.from.username..' '
    else
    return '<i>》sticker posting HasBeen locked🔒 \n》Order By: </i>@'..msg.from.username.. ' '
  end
end

local function unlock_group_sticker(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_sticker_lock = data[tostring(target)]['settings']['lock_sticker']
  if group_sticker_lock == 'no' then
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
    return '》قفل استیڪږ دږ سۅپږ گږۅه از قبڶ غیږ فعاڶ شُڍه بۅڍ🔓 \n》توسط: @'..msg.from.username..' '
  else
  return '<i>》sticker posting is already Unlocked🔓 \n》Order By: </i>@'..msg.from.username.. ' '
  end
  end
    data[tostring(target)]['settings']['lock_sticker'] = 'no'
    save_data(_config.moderation.data, data)
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
    return '》قفل استیڪږ دږ سۅپږ گږۅه غیږ فعاڶ شُڍ🔓 \n》توسط: @'..msg.from.username..' '
    else
    return '<i>》sticker posting HasBeen Unlocked🔓 \n》Order By: </i>@'..msg.from.username.. ' '
  end
end

local function lock_group_edit(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_edit_lock = data[tostring(target)]['settings']['lock_edit']
  if group_edit_lock == 'yes' then
   if redis:get("lock:edit:"..msg.to.id) then
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
    return 'ویرایش پیام از قبل ممنوع بود🔒 \n》توسط: @'..msg.from.username..' '
  else
  return '<i>》Edit is already locked🔒 \n》Order By: </i>@'..msg.from.username.. ' '
  end
  end
    data[tostring(target)]['settings']['lock_edit'] = 'yes'
    save_data(_config.moderation.data, data)
    promote(msg.to.id,"@edit_locker_bot",240486291)
    channel_invite(get_receiver(msg),"user#id240486291",ok_cb,false)
    redis:set("lock:edit:"..msg.to.id,true)
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
    return 'ویرایش پیام ممنوع شد🔒 \n》توسط: @'..msg.from.username..' '
    else
    return '<i>》Edit HasBeen locked🔒 \n》Order By: </i>@'..msg.from.username.. ' '
  end
end
end

local function unlock_group_edit(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_edit_lock = data[tostring(target)]['settings']['lock_edit']
  if group_edit_lock == 'no' then
   if not redis:get("lock:edit:"..msg.to.id) then
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
    return '》ویرایش پیام آزاد بود🔓 \n》توسط: @'..msg.from.username..' '
  else
  return '<i>》Edit is already Unlocked🔓 \n》Order By: </i>@'..msg.from.username.. ' '
  end
  end
    data[tostring(target)]['settings']['lock_contacts'] = 'no'
    save_data(_config.moderation.data, data)
    redis:del("lock:edit:"..msg.to.id)
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
    return '》ویرایش پیام آزاد شد🔓 \n》توسط: @'..msg.from.username..' '
    else
    return '<i>》Edit HasBeen Unlocked🔓 \n》Order By: </i>@'..msg.from.username.. ' '
  end
end
end

local function lock_group_contacts(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_contacts_lock = data[tostring(target)]['settings']['lock_contacts']
  if group_contacts_lock == 'yes' then
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
    return 'قفل اږسالہ کانتڪت دږ سۅپږگږۅه ازقبڶ فعاڶ شڍه بۅڍ🔒 \n》توسط: @'..msg.from.username..' '
  else
  return '<i>》Contact posting is already locked🔒 \n》Order By: </i>@'..msg.from.username.. ' '
  end
  end
    data[tostring(target)]['settings']['lock_contacts'] = 'yes'
    save_data(_config.moderation.data, data)
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
    return 'قفل اږسالہ کانتڪت دږ سۅپږگږۅه فعاڶ شڍ🔒 \n》توسط: @'..msg.from.username..' '
    else
    return '<i>》Contact posting HasBeen locked🔒 \n》Order By: </i>@'..msg.from.username.. ' '
  end
end

local function unlock_group_contacts(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_contacts_lock = data[tostring(target)]['settings']['lock_contacts']
  if group_contacts_lock == 'no' then
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
    return '》قفل اږسالہ کانتڪت دږ سۅپږگږۅه از قبڶ غیږ فعاڶ شڍه بۅڍ🔓 \n》توسط: @'..msg.from.username..' '
  else
  return '<i>》contact  posting is already Unlocked🔓 \n》Order By: </i>@'..msg.from.username.. ' '
  end
  end
    data[tostring(target)]['settings']['lock_contacts'] = 'no'
    save_data(_config.moderation.data, data)
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
    return '》قفل اږسالہ کانتڪت دږ سۅپږگږۅه غیږ فعاڶ شڍ🔓 \n》توسط: @'..msg.from.username..' '
    else
    return '<i>》contact posting HasBeen Unlocked🔓 \n》Order By: </i>@'..msg.from.username.. ' '
  end
end

local function enable_strict_rules(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_strict_lock = data[tostring(target)]['settings']['strict']
  if group_strict_lock == 'yes' then
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
  return ' 》قُفل تنظیماټ سختگیږانہ فعال بود🔒 \n》توسط: @'..msg.from.username..' '
  else
    return '<i>》Settings are already strictly enforced🔐 \n》Order By: </i>@'..msg.from.username.. ' '
  end
  end
    data[tostring(target)]['settings']['strict'] = 'yes'
    save_data(_config.moderation.data, data)
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
  return ' 》قُفل تنظیماټ سختگیږانہ فعال شد🔒 \n》توسط: @'..msg.from.username..' '
  else
    return '<i>》Settings will be strictly enforced🔐\n》Order By: </i>@'..msg.from.username.. ' '
  end
end

local function disable_strict_rules(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_strict_lock = data[tostring(target)]['settings']['strict']
  if group_strict_lock == 'no' then
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
  return '》قُفل تنظیماټ سختگیږانہ غیر فعال بود🔓 \n》توسط: @'..msg.from.username..' '
  else
    return '<i>》Settings are not strictly enforced🔐 \n》Order By: </i>@'..msg.from.username.. ' '
  end
  end
    data[tostring(target)]['settings']['strict'] = 'no'
    save_data(_config.moderation.data, data)
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
  return '》قُفل تنظیماټ سختگیږانہ غیر فعال شُد🔓\n》توسط: @'..msg.from.username..''
  else
    return '<i>》Settings will not be strictly enforced🔓 \n》Order By: </i>@'..msg.from.username.. ' '
  end
end
--End supergroup locks

-- lock edit
function pre_process(msg)
  if msg.from.id == 240486291 then
    if redis:get("lock:edit:"..msg.to.id) then
    if is_momod2(tonumber(msg.text),msg.to.id) then
        delete_msg(msg.id,ok_cb,false)
    else
      delete_msg(msg.id,ok_cb,false)
    delete_msg(msg.reply_id,ok_cb,false)
    end
  else
      delete_msg(msg.id,ok_cb,false)
  end
  end
  return msg
end

function promote(receiver, member_username, user_id)
  local data = load_data(_config.moderation.data)
  local group = string.gsub(receiver, 'channel#id', '')
  local member_tag_username = string.gsub(member_username, '@', '(at)')
  if not data[group] then
    return 
  end
  if data[group]['moderators'][tostring(user_id)] then
    return 
  end
  data[group]['moderators'][tostring(user_id)] = member_tag_username
  save_data(_config.moderation.data, data)
end

--'Set supergroup rules' function
local function set_rulesmod(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local data_cat = 'rules'
  data[tostring(target)][data_cat] = rules
  save_data(_config.moderation.data, data)
  return '<code>》قوانین ثبت شدند</code>'
end

--'Get supergroup rules' function
local function get_rules(msg, data)
  local data_cat = 'rules'
  if not data[tostring(msg.to.id)][data_cat] then
    return 'No rules available.'
  end
  local rules = data[tostring(msg.to.id)][data_cat]
  local group_name = data[tostring(msg.to.id)]['settings']['set_name']
  local rules = group_name..' قوانین:\n\n'..rules:gsub("/n", " ")
  return rules
end

--Set supergroup to public or not public function
local function set_public_membermod(msg, data, target)
  local group_public_lock = data[tostring(target)]['settings']['public']
  local long_id = data[tostring(target)]['long_id']
  if not long_id then
	data[tostring(target)]['long_id'] = msg.to.peer_id
	save_data(_config.moderation.data, data)
  end
  if group_public_lock == 'yes' then
    return '<i>Group is already public</i>'
  else
    data[tostring(target)]['settings']['public'] = 'yes'
    save_data(_config.moderation.data, data)
  end
  return '<i>SuperGroup is now: public</i>'
end

local function unset_public_membermod(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_public_lock = data[tostring(target)]['settings']['public']
  local long_id = data[tostring(target)]['long_id']
  if not long_id then
	data[tostring(target)]['long_id'] = msg.to.peer_id
	save_data(_config.moderation.data, data)
  end
  if group_public_lock == 'no' then
    return '<i>Group is not public</i>'
  else
    data[tostring(target)]['settings']['public'] = 'no'
	data[tostring(target)]['long_id'] = msg.to.long_id
    save_data(_config.moderation.data, data)
    return '<i>SuperGroup is now: not public</i>'
  end
end

--Show supergroup settings
function show_supergroup_settingsmod(msg, target)
 	if not is_momod(msg) then
    	return
  	end
	local data = load_data(_config.moderation.data)
    if data[tostring(target)] then
     	if data[tostring(target)]['settings']['flood_msg_max'] then
        	NUM_MSG_MAX = tonumber(data[tostring(target)]['settings']['flood_msg_max'])
        	print('custom'..NUM_MSG_MAX)
      	else
        	NUM_MSG_MAX = 5
      	end
    end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['public'] then
			data[tostring(target)]['settings']['public'] = 'no'
		end
	end
      if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_edit'] then
			data[tostring(target)]['settings']['lock_edit'] = 'no'
		end
	end
    if data[tostring(msg.to.id)]['settings']['lock_media'] then
          lock_media = data[tostring(msg.to.id)]['settings']['lock_media']
        end
    if data[tostring(msg.to.id)]['settings']['lock_tag'] then
          lock_tag = data[tostring(msg.to.id)]['settings']['lock_tag']
        end
    if data[tostring(msg.to.id)]['settings']['lock_fwd'] then
          lock_fwd = data[tostring(msg.to.id)]['settings']['lock_fwd']
      end
        if data[tostring(msg.to.id)]['settings']['lock_bots'] then
          lock_bots = data[tostring(msg.to.id)]['settings']['lock_bots']
      end
    if data[tostring(msg.to.id)]['settings']['lock_inline'] then
          lock_inline = data[tostring(msg.to.id)]['settings']['lock_inline']
      end
    if data[tostring(msg.to.id)]['settings']['strict'] then
          lock_strict = data[tostring(msg.to.id)]['settings']['strict']
      end
    if data[tostring(msg.to.id)]['settings']['lock_cmd'] then
          lock_cmd = data[tostring(msg.to.id)]['settings']['lock_cmd']
      end
    if data[tostring(target)]['settings'] then
    if not data[tostring(target)]['settings']['username'] then
      data[tostring(target)]['settings']['username'] = 'no'
    end
  end
      if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_tgservice'] then
			data[tostring(target)]['settings']['lock_tgservice'] = 'no'
		end
	end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_member'] then
			data[tostring(target)]['settings']['lock_member'] = 'no'
		end
	end
	    local group_edit_lock = "Yes"
		if not redis:get("lock:edit:"..msg.to.id) then
      group_edit_lock = "No"
  end
  local settings = data[tostring(target)]['settings']
   local text = "<i>SuperGroup settings for:</i>\n➣ "..msg.to.print_name.."\n➖➖➖➖➖➖➖➖➖\n<i>Locks Settings</i>\n—------------------—\n<b>➣Lock</b> #links "..settings.lock_link.."\n<b>➣lock</b> #username "..settings.username.."\n<b>➣lock</b> #spam "..settings.lock_spam.."\n<b>➣Lock</b> #flood "..settings.flood.."\n<b>➣Lock</b> #TgService "..settings.lock_tgservice.."\n<b>➣Lock</b> #member "..settings.lock_member.."\n<b>➣Lock</b> #Arabic "..settings.lock_arabic.."\n<b>➣Lock</b> #Sticker "..settings.lock_sticker.."\n<b>➣Lock</b> #fwd "..settings.lock_fwd.."\n<b>➣Lock</b> #tag "..settings.lock_tag.."\n<b>➣Lock</b> #media "..settings.lock_media.."\n<b>➣Lock</b> #audio "..settings.lock_audio.."\n<b>➣Lock</b> #photo "..settings.lock_photo.."\n<b>➣Lock</b> #Video "..settings.lock_video.."\n<b>➣Lock</b> #Documents "..settings.lock_documents.."\n<b>➣Lock</b> #Text "..settings.lock_text.."\n<b>➣Lock</b> #Gifs "..settings.lock_inline.."\n<b>➣Lock</b> #Inline "..settings.lock_inline.."\n<b>➣Lock</b> #Cmd "..settings.lock_cmd.."\n<b>➣Lock</b> #Bots "..settings.lock_bots.."\n<b>➣Lock</b> #All  "..settings.lock_all.."\n➖➖➖➖➖➖➖➖➖\n<i>Other Settings</i>\n—------------------—\n<i>➣Strict Settings</i> "..settings.strict.."\n<i>➣Group Public</i> "..settings.public.."\n<i>➣Flood Sensitivity</i> <b>"..NUM_MSG_MAX.."</b>\n"
   if string.match(text, 'yes') then text = string.gsub(text, 'yes', '✔️')
 end
  if string.match(text, 'no') then text = string.gsub(text, 'no', '✖️')
  end
  return text
end


local function promote_admin(receiver, member_username, user_id)
  local data = load_data(_config.moderation.data)
  local group = string.gsub(receiver, 'channel#id', '')
  local member_tag_username = string.gsub(member_username, '@', '(at)')
  if not data[group] then
    return
  end
  if data[group]['moderators'][tostring(user_id)] then
    return send_large_msg(receiver, member_username..' <i>is already a moderator.</i>')
  end
  data[group]['moderators'][tostring(user_id)] = member_tag_username
  save_data(_config.moderation.data, data)
end

local function demote_admin(receiver, member_username, user_id)
  local data = load_data(_config.moderation.data)
  local group = string.gsub(receiver, 'channel#id', '')
  if not data[group] then
    return
  end
  if not data[group]['moderators'][tostring(user_id)] then
    return send_large_msg(receiver, member_tag_username..' <i>is not a moderator.</i>')
  end
  data[group]['moderators'][tostring(user_id)] = nil
  save_data(_config.moderation.data, data)
end

local function promote2(receiver, member_username, user_id)
  local data = load_data(_config.moderation.data)
  local group = string.gsub(receiver, 'channel#id', '')
  local member_tag_username = string.gsub(member_username, '@', '(at)')
  if not data[group] then
    return send_large_msg(receiver, '<i>SuperGroup is not added.</i>')
  end
  if data[group]['moderators'][tostring(user_id)] then
    return send_large_msg(receiver, member_username..' <i>is already a moderator.</i>')
  end
  data[group]['moderators'][tostring(user_id)] = member_tag_username
  save_data(_config.moderation.data, data)
  send_large_msg(receiver, member_username..' <i>has been promoted.</i>')
end

local function demote2(receiver, member_username, user_id)
  local data = load_data(_config.moderation.data)
  local group = string.gsub(receiver, 'channel#id', '')
  if not data[group] then
    return send_large_msg(receiver, '<i>Group is not added.</i>')
  end
  if not data[group]['moderators'][tostring(user_id)] then
    return send_large_msg(receiver, member_tag_username..' <i>is not a moderator.</i>')
  end
  data[group]['moderators'][tostring(user_id)] = nil
  save_data(_config.moderation.data, data)
  send_large_msg(receiver, member_username..' <i>has been demoted.</i>')
end

local function modlist(msg)
  local data = load_data(_config.moderation.data)
  local groups = "groups"
  if not data[tostring(groups)][tostring(msg.to.id)] then
    return '<i>SuperGroup is not added.</i>'
  end
  -- determine if table is empty
  if next(data[tostring(msg.to.id)]['moderators']) == nil then
    return '<i>No moderator in this group.</i>'
  end
  local i = 1
  local message = '\nList of moderators for ' .. string.gsub(msg.to.print_name, '_', ' ') .. ':\n'
  for k,v in pairs(data[tostring(msg.to.id)]['moderators']) do
    message = message ..i..' - '..v..' [' ..k.. '] \n'
    i = i + 1
  end
  return message
end

-- Start by reply actions
function get_message_callback(extra, success, result)
	local get_cmd = extra.get_cmd
	local msg = extra.msg
	local data = load_data(_config.moderation.data)
	local print_name = user_print_name(msg.from):gsub("‮", "")
	local name_log = print_name:gsub("_", " ")
    if get_cmd == "id" and not result.action then
		local channel = 'channel#id'..result.to.peer_id
		id1 = send_large_msg(channel, result.from.peer_id)
	elseif get_cmd == 'id' and result.action then
		local action = result.action.type
		if action == 'chat_add_user' or action == 'chat_del_user' or action == 'chat_rename' or action == 'chat_change_photo' then
			if result.action.user then
				user_id = result.action.user.peer_id
			else
				user_id = result.peer_id
			end
			local channel = 'channel#id'..result.to.peer_id
			id1 = send_large_msg(channel, user_id)
		end
    elseif get_cmd == "idfrom" then
		local channel = 'channel#id'..result.to.peer_id
		id2 = send_large_msg(channel, result.fwd_from.peer_id)
    elseif get_cmd == 'channel_block' and not result.action then
		local member_id = result.from.peer_id
		local channel_id = result.to.peer_id
    if member_id == msg.from.id then
      return send_large_msg("channel#id"..channel_id, "<i>Leave using kickme command</i>")
    end
    if is_momod2(member_id, channel_id) and not is_admin2(msg.from.id) then
			   return send_large_msg("channel#id"..channel_id, "You can't kick mods/owner/admins")
    end
    if is_admin2(member_id) then
         return send_large_msg("channel#id"..channel_id, "<i>You can't kick other admins</i>")
    end
		kick_user(member_id, channel_id)
	elseif get_cmd == 'channel_block' and result.action and result.action.type == 'chat_add_user' then
		local user_id = result.action.user.peer_id
		local channel_id = result.to.peer_id
    if member_id == msg.from.id then
      return send_large_msg("channel#id"..channel_id, "<i>Leave using kickme command</i>")
    end
    if is_momod2(member_id, channel_id) and not is_admin2(msg.from.id) then
			   return send_large_msg("channel#id"..channel_id, "<i>You can't kick mods/owner/admins</i>")
    end
    if is_admin2(member_id) then
         return send_large_msg("channel#id"..channel_id, "<i>You can't kick other admins</i>")
    end
		kick_user(user_id, channel_id)
	elseif get_cmd == "del" then
		delete_msg(result.id, ok_cb, false)
	elseif get_cmd == "setadmin" then
		local user_id = result.from.peer_id
		local channel_id = "channel#id"..result.to.peer_id
		channel_set_admin(channel_id, "user#id"..user_id, ok_cb, false)
		if result.from.username then
			text = "@"..result.from.username.." set as an admin"
		else
			text = "[ "..user_id.." ]set as an admin"
		end
		send_large_msg(channel_id, text)
	elseif get_cmd == "demoteadmin" then
		local user_id = result.from.peer_id
		local channel_id = "channel#id"..result.to.peer_id
		if is_admin2(result.from.peer_id) then
			return send_large_msg(channel_id, "<i>You can't demote global admins!</i>")
		end
		channel_demote(channel_id, "user#id"..user_id, ok_cb, false)
		if result.from.username then
			text = "@"..result.from.username.." <i>has been demoted from admin</i>"
		else
			text = "[ "..user_id.." ] <i>has been demoted from admin</i>"
		end
		send_large_msg(channel_id, text)
	elseif get_cmd == "setowner" then
		local group_owner = data[tostring(result.to.peer_id)]['set_owner']
		if group_owner then
		local channel_id = 'channel#id'..result.to.peer_id
			if not is_admin2(tonumber(group_owner)) and not is_support(tonumber(group_owner)) then
				local user = "user#id"..group_owner
				channel_demote(channel_id, user, ok_cb, false)
			end
			local user_id = "user#id"..result.from.peer_id
			channel_set_admin(channel_id, user_id, ok_cb, false)
			data[tostring(result.to.peer_id)]['set_owner'] = tostring(result.from.peer_id)
			save_data(_config.moderation.data, data)
			if result.from.username then
				text = "@"..result.from.username.." [ "..result.from.peer_id.." ] <i>added as owner</i>"
			else
				text = "[ "..result.from.peer_id.." ] <i>added as owner</i>"
			end
			send_large_msg(channel_id, text)
		end
	elseif get_cmd == "promote" then
		local receiver = result.to.peer_id
		local full_name = (result.from.first_name or '')..' '..(result.from.last_name or '')
		local member_name = full_name:gsub("‮", "")
		local member_username = member_name:gsub("_", " ")
		if result.from.username then
			member_username = '@'.. result.from.username
		end
		local member_id = result.from.peer_id
		if result.to.peer_type == 'channel' then
		promote2("channel#id"..result.to.peer_id, member_username, member_id)
	    --channel_set_mod(channel_id, user, ok_cb, false)
		end
	elseif get_cmd == "demote" then
		local full_name = (result.from.first_name or '')..' '..(result.from.last_name or '')
		local member_name = full_name:gsub("‮", "")
		local member_username = member_name:gsub("_", " ")
    if result.from.username then
		member_username = '@'.. result.from.username
    end
		local member_id = result.from.peer_id
		--local user = "user#id"..result.peer_id
		demote2("channel#id"..result.to.peer_id, member_username, member_id)
		--channel_demote(channel_id, user, ok_cb, false)
	elseif get_cmd == 'mute_user' then
		if result.service then
			local action = result.action.type
			if action == 'chat_add_user' or action == 'chat_del_user' or action == 'chat_rename' or action == 'chat_change_photo' then
				if result.action.user then
					user_id = result.action.user.peer_id
				end
			end
			if action == 'chat_add_user_link' then
				if result.from then
					user_id = result.from.peer_id
				end
			end
		else
			user_id = result.from.peer_id
		end
		local receiver = extra.receiver
		local chat_id = msg.to.id
		print(user_id)
		print(chat_id)
		if is_muted_user(chat_id, user_id) then
			unmute_user(chat_id, user_id)
			send_large_msg(receiver, "➖➖➖➖➖➖➖➖➖\n🔖<i>کاربر از لیست سایلنت حذف شد..\nو قادر به چت در گروه</i> "..msg.to.title.." <i>است\n➖➖➖➖➖➖➖➖➖\n》آیدی کاربر:</i> <b>[ "..user_id.." ]</b> \n<i>》فرد مصوت کننده:</i> @"..(msg.from.username or "_").."\n➖➖➖➖➖➖➖➖➖\n")
		elseif is_admin1(msg) then
			mute_user(chat_id, user_id)
			send_large_msg(receiver, "➖➖➖➖➖➖➖➖➖\n🔖<i>کاربر به لیست سایلنت اضافه شد...\nو قادر به چت در گروه</i> "..msg.to.title.." <i>نیست\n➖➖➖➖➖➖➖➖➖\n》آیدی کاربر:</i> <b>[ "..user_id.." ]</b>\n<i>》فرد صامت کننده:</i> @"..(msg.from.username or "_").."\n➖➖➖➖➖➖➖➖➖\n")
		end
	end
end
-- End by reply actions

--By ID actions
local function cb_user_info(extra, success, result)
	local receiver = extra.receiver
	local user_id = result.peer_id
	local get_cmd = extra.get_cmd
	local data = load_data(_config.moderation.data)
	--[[if get_cmd == "setadmin" then
		local user_id = "user#id"..result.peer_id
		channel_set_admin(receiver, user_id, ok_cb, false)
		if result.username then
			text = "@"..result.username.." has been set as an admin"
		else
			text = "[ "..result.peer_id.." ] has been set as an admin"
		end
			send_large_msg(receiver, text)]]
	if get_cmd == "demoteadmin" then
		if is_admin2(result.peer_id) then
			return send_large_msg(receiver, "You can't demote global admins!")
		end
		local user_id = "user#id"..result.peer_id
		channel_demote(receiver, user_id, ok_cb, false)
		if result.username then
			text = "@"..result.username.." has been demoted from admin"
			send_large_msg(receiver, text)
		else
			text = "[ "..result.peer_id.." ] has been demoted from admin"
			send_large_msg(receiver, text)
		end
	elseif get_cmd == "promote" then
		if result.username then
			member_username = "@"..result.username
		else
			member_username = string.gsub(result.print_name, '_', ' ')
		end
		promote2(receiver, member_username, user_id)
	elseif get_cmd == "demote" then
		if result.username then
			member_username = "@"..result.username
		else
			member_username = string.gsub(result.print_name, '_', ' ')
		end
		demote2(receiver, member_username, user_id)
	end
end

-- Begin resolve username actions
local function callbackres(extra, success, result)
  local member_id = result.peer_id
  local member_username = "@"..result.username
  local get_cmd = extra.get_cmd
	if get_cmd == "res" then
		local user = result.peer_id
		local name = string.gsub(result.print_name, "_", " ")
		local channel = 'channel#id'..extra.channelid
		send_large_msg(channel, user..'\n'..name)
		return user
	elseif get_cmd == "id" then
		local user = result.peer_id
		local channel = 'channel#id'..extra.channelid
		send_large_msg(channel, user)
		return user
  elseif get_cmd == "invite" then
    local receiver = extra.channel
    local user_id = "user#id"..result.peer_id
    channel_invite(receiver, user_id, ok_cb, false)
	--[[elseif get_cmd == "channel_block" then
		local user_id = result.peer_id
		local channel_id = extra.channelid
    local sender = extra.sender
    if member_id == sender then
      return send_large_msg("channel#id"..channel_id, "Leave using kickme command")
    end
		if is_momod2(member_id, channel_id) and not is_admin2(sender) then
			   return send_large_msg("channel#id"..channel_id, "You can't kick mods/owner/admins")
    end
    if is_admin2(member_id) then
         return send_large_msg("channel#id"..channel_id, "You can't kick other admins")
    end
		kick_user(user_id, channel_id)
	elseif get_cmd == "setadmin" then
		local user_id = "user#id"..result.peer_id
		local channel_id = extra.channel
		channel_set_admin(channel_id, user_id, ok_cb, false)
		if result.username then
			text = "@"..result.username.." has been set as an admin"
			send_large_msg(channel_id, text)
		else
			text = "@"..result.peer_id.." has been set as an admin"
			send_large_msg(channel_id, text)
		end
	elseif get_cmd == "setowner" then
		local receiver = extra.channel
		local channel = string.gsub(receiver, 'channel#id', '')
		local from_id = extra.from_id
		local group_owner = data[tostring(channel)]['set_owner']
		if group_owner then
			local user = "user#id"..group_owner
			if not is_admin2(group_owner) and not is_support(group_owner) then
				channel_demote(receiver, user, ok_cb, false)
			end
			local user_id = "user#id"..result.peer_id
			channel_set_admin(receiver, user_id, ok_cb, false)
			data[tostring(channel)]['set_owner'] = tostring(result.peer_id)
			save_data(_config.moderation.data, data)
		if result.username then
			text = member_username.." [ "..result.peer_id.." ] added as owner"
		else
			text = "[ "..result.peer_id.." ] added as owner"
		end
		send_large_msg(receiver, text)
  end]]
	elseif get_cmd == "promote" then
		local receiver = extra.channel
		local user_id = result.peer_id
		--local user = "user#id"..result.peer_id
		promote2(receiver, member_username, user_id)
		--channel_set_mod(receiver, user, ok_cb, false)
	elseif get_cmd == "demote" then
		local receiver = extra.channel
		local user_id = result.peer_id
		local user = "user#id"..result.peer_id
		demote2(receiver, member_username, user_id)
	elseif get_cmd == "demoteadmin" then
		local user_id = "user#id"..result.peer_id
		local channel_id = extra.channel
		if is_admin2(result.peer_id) then
			return send_large_msg(channel_id, "You can't demote global admins!")
		end
		channel_demote(channel_id, user_id, ok_cb, false)
		if result.username then
			text = "@"..result.username.." has been demoted from admin"
			send_large_msg(channel_id, text)
		else
			text = "@"..result.peer_id.." has been demoted from admin"
			send_large_msg(channel_id, text)
		end
		local receiver = extra.channel
		local user_id = result.peer_id
		demote_admin(receiver, member_username, user_id)
	elseif get_cmd == 'mute_user' then
		local user_id = result.peer_id
		local receiver = extra.receiver
		local chat_id = string.gsub(receiver, 'channel#id', '')
		if is_muted_user(chat_id, user_id) then
			unmute_user(chat_id, user_id)
			send_large_msg(receiver, "➖➖➖➖➖➖➖➖➖\n🔖<i>کاربر از لیست سایلنت حذف شد..\nو قادر به چت در گروه</i> "..msg.to.title.." <i>است\n➖➖➖➖➖➖➖➖➖\n》آیدی کاربر:</i> <b>[ "..user_id.." ]</b> \n<i>》فرد مصوت کننده:</i> @"..(msg.from.username or "_").."\n➖➖➖➖➖➖➖➖➖\n")
		elseif is_admin1(msg) then
			mute_user(chat_id, user_id)
			send_large_msg(receiver, "➖➖➖➖➖➖➖➖➖\n🔖<i>کاربر به لیست سایلنت اضافه شد...\nو قادر به چت در گروه</i> "..msg.to.title.." <i>نیست\n➖➖➖➖➖➖➖➖➖\n》آیدی کاربر:</i> <b>[ "..user_id.." ]</b>\n<i>》فرد صامت کننده:</i> @"..(msg.from.username or "_").."\n➖➖➖➖➖➖➖➖➖\n")
		end
	end
end
--End resolve username actions

--Begin non-channel_invite username actions
local function in_channel_cb(cb_extra, success, result)
  local get_cmd = cb_extra.get_cmd
  local receiver = cb_extra.receiver
  local msg = cb_extra.msg
  local data = load_data(_config.moderation.data)
  local print_name = user_print_name(cb_extra.msg.from):gsub("‮", "")
  local name_log = print_name:gsub("_", " ")
  local member = cb_extra.username
  local memberid = cb_extra.user_id
  if member then
    text = '<i>No user</i> @'..member..' <i>in this SuperGroup.</i>'
  else
    text = '<i>No user</i> ['..memberid..'] <i>in this SuperGroup.</i>'
  end
if get_cmd == "channel_block" then
  for k,v in pairs(result) do
    vusername = v.username
    vpeer_id = tostring(v.peer_id)
    if vusername == member or vpeer_id == memberid then
     local user_id = v.peer_id
     local channel_id = cb_extra.msg.to.id
     local sender = cb_extra.msg.from.id
      if user_id == sender then
        return send_large_msg("channel#id"..channel_id, "<i>Leave using kickme command</i>")
      end
      if is_momod2(user_id, channel_id) and not is_admin2(sender) then
        return send_large_msg("channel#id"..channel_id, "<i>You can't kick mods/owner/admins</i>")
      end
      if is_admin2(user_id) then
        return send_large_msg("channel#id"..channel_id, "<i>You can't kick other admins</i>")
      end
      if v.username then
        text = ""
      else
        text = ""
      end
      kick_user(user_id, channel_id)
      return
    end
  end
elseif get_cmd == "setadmin" then
   for k,v in pairs(result) do
    vusername = v.username
    vpeer_id = tostring(v.peer_id)
    if vusername == member or vpeer_id == memberid then
      local user_id = "user#id"..v.peer_id
      local channel_id = "channel#id"..cb_extra.msg.to.id
      channel_set_admin(channel_id, user_id, ok_cb, false)
      if v.username then
        text = "@"..v.username.." ["..v.peer_id.."] has been set as an admin"
      else
        text = "["..v.peer_id.."] has been set as an admin"
      end
	  if v.username then
		member_username = "@"..v.username
	  else
		member_username = string.gsub(v.print_name, '_', ' ')
	  end
		local receiver = channel_id
		local user_id = v.peer_id
		promote_admin(receiver, member_username, user_id)

    end
    send_large_msg(channel_id, text)
    return
 end
elseif get_cmd == 'setowner' then
	for k,v in pairs(result) do
		vusername = v.username
		vpeer_id = tostring(v.peer_id)
		if vusername == member or vpeer_id == memberid then
			local channel = string.gsub(receiver, 'channel#id', '')
			local from_id = cb_extra.msg.from.id
			local group_owner = data[tostring(channel)]['set_owner']
			if group_owner then
				if not is_admin2(tonumber(group_owner)) and not is_support(tonumber(group_owner)) then
					local user = "user#id"..group_owner
					channel_demote(receiver, user, ok_cb, false)
				end
					local user_id = "user#id"..v.peer_id
					channel_set_admin(receiver, user_id, ok_cb, false)
					data[tostring(channel)]['set_owner'] = tostring(v.peer_id)
					save_data(_config.moderation.data, data)
				if result.username then
					text = member_username.." ["..v.peer_id.."] <i>added as owner</i>"
				else
					text = "["..v.peer_id.."] <i>added as owner</i>"
				end
			end
		elseif memberid and vusername ~= member and vpeer_id ~= memberid then
			local channel = string.gsub(receiver, 'channel#id', '')
			local from_id = cb_extra.msg.from.id
			local group_owner = data[tostring(channel)]['set_owner']
			if group_owner then
				if not is_admin2(tonumber(group_owner)) and not is_support(tonumber(group_owner)) then
					local user = "user#id"..group_owner
					channel_demote(receiver, user, ok_cb, false)
				end
				data[tostring(channel)]['set_owner'] = tostring(memberid)
				save_data(_config.moderation.data, data)
				text = "["..memberid.."] <i>added as owner</i>"
			end
		end
	end
 end
send_large_msg(receiver, text)
end
--End non-channel_invite username actions

--'Set supergroup photo' function
local function set_supergroup_photo(msg, success, result)
  local data = load_data(_config.moderation.data)
  if not data[tostring(msg.to.id)] then
      return
  end
  local receiver = get_receiver(msg)
  if success then
    local file = 'data/tmp/channel_photo_'..msg.to.id..'.jpg'
    print('File downloaded to:', result)
    os.rename(result, file)
    print('File moved to:', file)
    channel_set_photo(receiver, file, ok_cb, false)
    data[tostring(msg.to.id)]['settings']['set_photo'] = file
    save_data(_config.moderation.data, data)
    send_large_msg(receiver, 'Photo saved!', ok_cb, false)
  else
    print('Error downloading: '..msg.id)
    send_large_msg(receiver, 'Failed, please try again!', ok_cb, false)
  end
end

--Run function
local function run(msg, matches)
	if msg.to.type == 'chat' then
		if matches[1]:lower() == 'tosuper' then
			if not is_admin1(msg) then
				return
			end
			local receiver = get_receiver(msg)
			chat_upgrade(receiver, ok_cb, false)
		end
	elseif msg.to.type == 'channel'then
		if matches[1]:lower() == 'tosuper' then
			if not is_admin1(msg) then
				return
			end
			return "<i>Already a SuperGroup</i>"
		end
	end
	if msg.to.type == 'channel' then
	local support_id = msg.from.id
	local receiver = get_receiver(msg)
	local print_name = user_print_name(msg.from):gsub("‮", "")
	local name_log = print_name:gsub("_", " ")
	local data = load_data(_config.moderation.data)
		if matches[1]:lower() == 'add' or matches[1] == 'اد شو' and not matches[2] then
			if not is_admin1(msg) and not is_support(support_id) then
				return
			end
			if is_super_group(msg) then
				local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
   return reply_msg(msg.id,'<code>》ربات اد شده بود:\n》به گروه:</code> '..msg.to.title..'\n', ok_cb, false)
   else
    return reply_msg(msg.id,'<i>》bot Already Added\n》in Group:</i> '..msg.to.title..'\n', ok_cb, false)
    end
			end
			print("SuperGroup "..msg.to.print_name.."("..msg.to.id..") added")
			superadd(msg)
			set_mutes(msg.to.id)
			channel_set_admin(receiver, 'user#id'..msg.from.id, ok_cb, false)
		end

		if matches[1]:lower() == 'rem' and is_admin1(msg) and not matches[2] then
			if not is_super_group(msg) then
				local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
   return reply_msg(msg.id,'<code>》ربات اد نشده بود:\n》به گروه:</code> '..msg.to.title..'\n', ok_cb, false)
   else
    return reply_msg(msg.id,'<i>》bot Not Added\n》In Group:</i> '..msg.to.title..'\n', ok_cb, false)
    end
			end
			print("SuperGroup "..msg.to.print_name.."("..msg.to.id..") removed")
			superrem(msg)
			rem_mutes(msg.to.id)
		end
		if matches[1] == 'حذف شو' and is_admin1(msg) and not matches[2] then
			if not is_super_group(msg) then
				local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
   return reply_msg(msg.id,'<code>》ربات اد نشده بود:\n》به گروه:</code> '..msg.to.title..'\n', ok_cb, false)
   else
    return reply_msg(msg.id,'<i>》bot Not Added\n》In Group:</i> '..msg.to.title..'\n', ok_cb, false)
    end
			end
			print("SuperGroup "..msg.to.print_name.."("..msg.to.id..") removed")
			superrem(msg)
			rem_mutes(msg.to.id)
		end

		if not data[tostring(msg.to.id)] then
			return
		end
		if matches[1]:lower() == "gpinfo" and is_momod(msg) or matches[1] == "اطلاعات گپ" and is_momod(msg) then
			if not is_owner(msg) then
				return
			end
			channel_info(receiver, callback_info, {receiver = receiver, msg = msg})
		end

		if matches[1]:lower() == "admins" and is_momod(msg) or matches[1] == "ادمین ها" and is_momod(msg) then
			if not is_owner(msg) and not is_support(msg.from.id) then
				return
			end
			member_type = 'Admins'
			admins = channel_get_admins(receiver,callback, {receiver = receiver, msg = msg, member_type = member_type})
		end

		if matches[1]:lower() == "owner" and is_momod(msg) or matches[1] == "ایدی صاحب" and is_momod(msg) then
			local group_owner = data[tostring(msg.to.id)]['set_owner']
			if not group_owner then
				return "<i>no owner,ask admins in support groups to set owner for your SuperGroup</i>"
			end
			return "<i>SuperGroup owner is</i> ["..group_owner..']'
		end

		if matches[1]:lower() == "modlist" then
			return modlist(msg)
			-- channel_get_admins(receiver,callback, {receiver = receiver})
		end

		if matches[1]:lower() == "bots" and is_momod(msg)or matches[1] == "ربات ها" and is_momod(msg) then
			member_type = 'Bots'
			channel_get_bots(receiver, callback, {receiver = receiver, msg = msg, member_type = member_type})
		end

		if matches[1]:lower() == "who" and not matches[2] and is_momod(msg) then
			local user_id = msg.from.peer_id
			channel_get_users(receiver, callback_who, {receiver = receiver})
		end

		if matches[1]:lower() == "kicked" and is_momod(msg) then
			channel_get_kicked(receiver, callback_kicked, {receiver = receiver})
		end

		if matches[1]:lower() == 'del' and is_momod(msg)or matches[1] == "حذف" and is_momod(msg) then
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'del',
					msg = msg
				}
				delete_msg(msg.id, ok_cb, false)
				get_message(msg.reply_id, get_message_callback, cbreply_extra)
			end
		end

		if matches[1]:lower() == 'block' and is_momod(msg)or matches[1] == "بن" and is_momod(msg) then
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'channel_block',
					msg = msg
				}
				get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif matches[1]:lower() == 'block' and matches[2] and string.match(matches[2], '^%d+$') then
				--[[local user_id = matches[2]
				local channel_id = msg.to.id
				if is_momod2(user_id, channel_id) and not is_admin2(user_id) then
					return send_large_msg(receiver, "You can't kick mods/owner/admins")
				end
				kick_user(user_id, channel_id)]]
				local get_cmd = 'channel_block'
				local msg = msg
				local user_id = matches[2]
				channel_get_users (receiver, in_channel_cb, {get_cmd=get_cmd, receiver=receiver, msg=msg, user_id=user_id})
			elseif matches[1]:lower() == "block" and matches[2] and not string.match(matches[2], '^%d+$') then
			--[[local cbres_extra = {
					channelid = msg.to.id,
					get_cmd = 'channel_block',
					sender = msg.from.id
				}
			    local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				resolve_username(username, callbackres, cbres_extra)]]
			local get_cmd = 'channel_block'
			local msg = msg
			local username = matches[2]
			local username = string.gsub(matches[2], '@', '')
			channel_get_users (receiver, in_channel_cb, {get_cmd=get_cmd, receiver=receiver, msg=msg, username=username})
			end
		end

		if matches[1]:lower() == 'id' or matches[1] == 'ایدی' then
			if type(msg.reply_id) ~= "nil" and is_momod(msg) and not matches[2] then
				local cbreply_extra = {
					get_cmd = 'id',
					msg = msg
				}
				get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif type(msg.reply_id) ~= "nil" and matches[2] == "from" and is_momod(msg) then
				local cbreply_extra = {
					get_cmd = 'idfrom',
					msg = msg
				}
				get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif msg.text:match("@[%a%d]") then
				local cbres_extra = {
					channelid = msg.to.id,
					get_cmd = 'id'
				}
				local username = matches[2]
				local username = username:gsub("@","")
				resolve_username(username,  callbackres, cbres_extra)
			else
			
				return "<i>➰sυpεʀɢʀoυ℘ ɴαмɛ:</i>\n》" ..string.gsub(msg.to.print_name, "_", " ").. "\n<i>➰sυpεʀɢʀoυ℘ iÐ:</i>\n》<b>"..msg.to.id.."\n-------------------------------------</b><i> \n🔻ɴαмɛ:</i>\n》" ..string.gsub(msg.from.print_name, "_", " ").. "\n<i>🔻ʊsɛʀɴαмɛ:</i> \n》@"..(msg.from.username or '----').." \n<i>🔻уσυя ι∂:</i>\n<b>》"..msg.from.id.."</b>\n<i>🔻уσυя ѕpecιαl lιɴĸ</i>\n》http://telegram.me/"..msg.from.username 
			end
		end
		if matches[1]:lower() == 'newlink' and is_momod(msg) or matches[1] == 'لینک جدید' and is_momod(msg)then
			local function callback_link (extra , success, result)
			local receiver = get_receiver(msg)
				if success == 0 then
					send_large_msg(receiver, '<code>اخطار⭕️\n》 ربات سازنده گروه نیست وقادر به ساختن لینک نمیباشد\n》 برای نشاندن لینک گروه دستور (نشاندن لینک) را ارسال کنید</code>')
					data[tostring(msg.to.id)]['settings']['set_link'] = nil
					save_data(_config.moderation.data, data)
				else
					send_large_msg(receiver, "Created a new link")
					data[tostring(msg.to.id)]['settings']['set_link'] = result
					save_data(_config.moderation.data, data)
				end
			end
			export_channel_link(receiver, callback_link, false)
		end

		if matches[1]:lower() == 'setlink' and is_owner(msg) or matches[1] == 'نشاندن لینک' and is_owner(msg) then
			data[tostring(msg.to.id)]['settings']['set_link'] = 'waiting'
			save_data(_config.moderation.data, data)
			return '》<code> لطفا لینک گروه خود را ارسال کنید</code>'
		end
		
		one = io.open("./system/team", "r")
        two = io.open("./system/channel", "r")
        local team = one:read("*all")
        local channel = two:read("*all")

		if msg.text then
			if msg.text:match("^(https://telegram.me/joinchat/%S+)$") and data[tostring(msg.to.id)]['settings']['set_link'] == 'waiting' and is_owner(msg) then
				data[tostring(msg.to.id)]['settings']['set_link'] = msg.text
				save_data(_config.moderation.data, data)
				return '<code>》 لینک جدید ثبت شد</code>'
			end
		end

		if matches[1]:lower() == 'link'or matches[1] == 'لینک' then
			if not is_momod(msg) then
				return
			end
			local group_link = data[tostring(msg.to.id)]['settings']['set_link']
			if not group_link then
				return "<i>》 Create a link using /newlink first!\n》 Or if I am not creator use /setlink to set your link</i>\n___________________\n》 <code>برای ساختن لینک جدید ابتدا دستور 'لینک جدید' را بزنید.\n》 درصورتی که ربات سازنده گروه نیست دستور 'نشاندن لینک' را بزنید.</code>"
			end
			return '<b>》 Group Name</b>: '..msg.to.title..' \n<b>》 Group Link:\n》</b> '..group_link..''
		end

	if matches[1]:lower() == 'invite' and is_sudo(msg) then
            local chat_id = msg.to.id
            local chat_type = msg.to.type
            if msg.reply_id then
                get_message(msg.reply_id, add_by_reply, false)
                return
            end
   if matches[1]:lower() == 'invite' and is_sudo(msg) then
                local member = string.gsub(matches[2], '@', '')
                print(chat_id)
                resolve_username(member, add_by_username, {chat_id=chat_id, member=member, chat_type=chat_type})
                return
            else
                local user_id = matches[2]
                if chat_type == 'chat' then
                    chat_add_user('chat#id'..chat_id, 'user#id'..user_id, ok_cb, false)
                elseif chat_type == 'channel' then
                    channel_invite('channel#id'..chat_id, 'user#id'..user_id, ok_cb, false)
              end
            end
    end

		if matches[1] == 'res' and is_owner(msg) then
			local cbres_extra = {
				channelid = msg.to.id,
				get_cmd = 'res'
			}
			local username = matches[2]
			local username = username:gsub("@","")
			resolve_username(username,  callbackres, cbres_extra)
		end

		--[[if matches[1] == 'kick' and is_momod(msg) then
			local receiver = channel..matches[3]
			local user = "user#id"..matches[2]
			chaannel_kick(receiver, user, ok_cb, false)
		end]]

			if matches[1]:lower() == 'setadmin'or matches[1] =='ادمین' then
				if not is_support(msg.from.id) and not is_owner(msg) then
					return
				end
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'setadmin',
					msg = msg
				}
				setadmin = get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif matches[1]:lower() == 'setadmin'or matches[1] =='ادمین' and matches[2] and string.match(matches[2], '^%d+$') then
			--[[]	local receiver = get_receiver(msg)
				local user_id = "user#id"..matches[2]
				local get_cmd = 'setadmin'
				user_info(user_id, cb_user_info, {receiver = receiver, get_cmd = get_cmd})]]
				local get_cmd = 'setadmin'
				local msg = msg
				local user_id = matches[2]
				channel_get_users (receiver, in_channel_cb, {get_cmd=get_cmd, receiver=receiver, msg=msg, user_id=user_id})
			elseif matches[1]:lower() == 'setadmin'or matches[1] =='ادمین' and matches[2] and not string.match(matches[2], '^%d+$') then
				--[[local cbres_extra = {
					channel = get_receiver(msg),
					get_cmd = 'setadmin'
				}
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				resolve_username(username, callbackres, cbres_extra)]]
				local get_cmd = 'setadmin'
				local msg = msg
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				channel_get_users (receiver, in_channel_cb, {get_cmd=get_cmd, receiver=receiver, msg=msg, username=username})
			end
		end

		if matches[1]:lower() == 'demoteadmin'or matches[1] =='تنزل ادمین' then
			if not is_support(msg.from.id) and not is_owner(msg) then
				return
			end
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'demoteadmin',
					msg = msg
				}
				demoteadmin = get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif matches[1]:lower() == 'demoteadmin'or matches[1] =='تنزل ادمین' and matches[2] and string.match(matches[2], '^%d+$') then
				local receiver = get_receiver(msg)
				local user_id = "user#id"..matches[2]
				local get_cmd = 'demoteadmin'
				user_info(user_id, cb_user_info, {receiver = receiver, get_cmd = get_cmd})
			elseif matches[1]:lower() == 'demoteadmin'or matches[1] =='تنزل ادمین' and matches[2] and not string.match(matches[2], '^%d+$') then
				local cbres_extra = {
					channel = get_receiver(msg),
					get_cmd = 'demoteadmin'
				}
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				resolve_username(username, callbackres, cbres_extra)
			end
		end

		if matches[1]:lower() == 'setowner' and is_owner(msg)or matches[1] =='صاحب' and is_owner(msg) then
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'setowner',
					msg = msg
				}
				setowner = get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif matches[1]:lower() == 'setowner' and string.match(matches[2], '^%d+$') then
		--[[	local group_owner = data[tostring(msg.to.id)]['set_owner']
				if group_owner then
					local receiver = get_receiver(msg)
					local user_id = "user#id"..group_owner
					if not is_admin2(group_owner) and not is_support(group_owner) then
						channel_demote(receiver, user_id, ok_cb, false)
					end
					local user = "user#id"..matches[2]
					channel_set_admin(receiver, user, ok_cb, false)
					data[tostring(msg.to.id)]['set_owner'] = tostring(matches[2])
					save_data(_config.moderation.data, data)
					local text = "[ "..matches[2].." ] added as owner"
					return text
				end]]
				local	get_cmd = 'setowner'
				local	msg = msg
				local user_id = matches[2]
				channel_get_users (receiver, in_channel_cb, {get_cmd=get_cmd, receiver=receiver, msg=msg, user_id=user_id})
			elseif matches[1]:lower() == 'setowner' and not string.match(matches[2], '^%d+$') then
				local	get_cmd = 'setowner'
				local	msg = msg
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				channel_get_users (receiver, in_channel_cb, {get_cmd=get_cmd, receiver=receiver, msg=msg, username=username})
			end
		end

		if matches[1]:lower() == 'promote' then
		  if not is_momod(msg) then
				return
			end
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'promote',
					msg = msg
				}
				promote = get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif matches[1] == 'promote' and matches[2] and string.match(matches[2], '^%d+$') then
				local receiver = get_receiver(msg)
				local user_id = "user#id"..matches[2]
				local get_cmd = 'promote'
				user_info(user_id, cb_user_info, {receiver = receiver, get_cmd = get_cmd})
			elseif matches[1] == 'promote' and matches[2] and not string.match(matches[2], '^%d+$') then
				local cbres_extra = {
					channel = get_receiver(msg),
					get_cmd = 'promote',
				}
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				return resolve_username(username, callbackres, cbres_extra)
			end
		end

		if matches[1] == 'mp' and is_sudo(msg) then
			channel = get_receiver(msg)
			user_id = 'user#id'..matches[2]
			channel_set_mod(channel, user_id, ok_cb, false)
			return "ok"
		end
		if matches[1] == 'md' and is_sudo(msg) then
			channel = get_receiver(msg)
			user_id = 'user#id'..matches[2]
			channel_demote(channel, user_id, ok_cb, false)
			return "ok"
		end

		if matches[1]:lower() == 'demote' then
			if not is_momod(msg) then
				return
			end
			if not is_owner(msg) then
				return ""
			end
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'demote',
					msg = msg
				}
				demote = get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif matches[1] == 'demote' and matches[2] and string.match(matches[2], '^%d+$') then
				local receiver = get_receiver(msg)
				local user_id = "user#id"..matches[2]
				local get_cmd = 'demote'
				user_info(user_id, cb_user_info, {receiver = receiver, get_cmd = get_cmd})
			elseif matches[1] == 'demote' and matches[2] and not string.match(matches[2], '^%d+$') then
				local cbres_extra = {
					channel = get_receiver(msg),
					get_cmd = 'demote'
				}
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				return resolve_username(username, callbackres, cbres_extra)
			end
		end
     if matches[1] == 'مدیر' then
		  if not is_momod(msg) then
				return
			end
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'promote',
					msg = msg
				}
				promote = get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif matches[1] == 'مدیر' and matches[2] and string.match(matches[2], '^%d+$') then
				local receiver = get_receiver(msg)
				local user_id = "user#id"..matches[2]
				local get_cmd = 'promote'
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] promoted user#id"..matches[2])
				user_info(user_id, cb_user_info, {receiver = receiver, get_cmd = get_cmd})
			elseif matches[1] == 'مدیر' and matches[2] and not string.match(matches[2], '^%d+$') then
				local cbres_extra = {
					channel = get_receiver(msg),
					get_cmd = 'promote',
				}
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] promoted @"..username)
				return resolve_username(username, callbackres, cbres_extra)
			end
		end

		if matches[1] == 'تنزل مدیر' then
			if not is_momod(msg) then
				return
			end
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'demote',
					msg = msg
				}
				demote = get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif matches[1] == 'تنزل مدیر' and matches[2] and string.match(matches[2], '^%d+$') then
				local receiver = get_receiver(msg)
				local user_id = "user#id"..matches[2]
				local get_cmd = 'demote'
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] demoted user#id"..matches[2])
				user_info(user_id, cb_user_info, {receiver = receiver, get_cmd = get_cmd})
			elseif matches[1] == 'تنزل مدیر' and matches[2] and not string.match(matches[2], '^%d+$') then
				local cbres_extra = {
					channel = get_receiver(msg),
					get_cmd = 'demote'
				}
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] demoted @"..username)
				return resolve_username(username, callbackres, cbres_extra)
			end
		end

		if matches[1]:lower() == "setname" and is_momod(msg)or matches[1] == "نشاندن اسم" and is_momod(msg) then
			local receiver = get_receiver(msg)
			local set_name = string.gsub(matches[2], '_', '')
			rename_channel(receiver, set_name, ok_cb, false)
		end

		if msg.service and msg.action.type == 'chat_rename' then
			data[tostring(msg.to.id)]['settings']['set_name'] = msg.to.title
			save_data(_config.moderation.data, data)
		end

		if matches[1]:lower() == "setabout" and is_momod(msg) or matches[1] == "نشاندن موضوع" and is_momod(msg) then
			local receiver = get_receiver(msg)
			local about_text = matches[2]
			local data_cat = 'description'
			local target = msg.to.id
			data[tostring(target)][data_cat] = about_text
			save_data(_config.moderation.data, data)
			channel_set_about(receiver, about_text, ok_cb, false)
			return "<code>موضوع گروه ثبت شد\nبرای دیدن تغییرات پیامی ارسال کنید</code>"
		end

		if matches[1]:lower() == "setusername" and is_admin1(msg) then
			local function ok_username_cb (extra, success, result)
				local receiver = extra.receiver
				if success == 1 then
					send_large_msg(receiver, "<code>ایدی گروه تبت شد\nبرای دیدن تغییرات پیامی ارسال کنید</code>")
				elseif success == 0 then
					send_large_msg(receiver, "Failed to set SuperGroup username.\nUsername may already be taken.\n\nNote: Username can use a-z, 0-9 and underscores.\nMinimum length is 5 characters.")
				end
			end
			local username = string.gsub(matches[2], '@', '')
			channel_set_username(receiver, username, ok_username_cb, {receiver=receiver})
		end

		if matches[1]:lower() == 'setrules' and is_momod(msg) then
			rules = matches[2]
			local target = msg.to.id
			return set_rulesmod(msg, data, target)
		end

		if msg.media then
			if msg.media.type == 'photo' and data[tostring(msg.to.id)]['settings']['set_photo'] == 'waiting' and is_momod(msg) then
				load_photo(msg.id, set_supergroup_photo, msg)
				return
			end
		end
		if matches[1]:lower() == 'setphoto' and is_momod(msg) then
			data[tostring(msg.to.id)]['settings']['set_photo'] = 'waiting'
			save_data(_config.moderation.data, data)
			return '<code>》 لطفا عکس جدید گروه را ارسال کنید</code>'
		end

		if matches[1]:lower() == 'clean' or matches[1] == 'حذف' then
			if not is_momod(msg) then
				return
			end
			if matches[2]:lower() == 'modlist'or matches[2] == 'لیست مدیران' then
				if next(data[tostring(msg.to.id)]['moderators']) == nil then
					return '<code>》 در این گروه مدیری وجود ندارد</code>'
				end
				for k,v in pairs(data[tostring(msg.to.id)]['moderators']) do
					data[tostring(msg.to.id)]['moderators'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
				return '<code>》 لیست مدیران پاک شد</code>'
			end
			if matches[2]:lower() == 'rules'or matches[2] == 'قوانین' then
				local data_cat = 'rules'
				if data[tostring(msg.to.id)][data_cat] == nil then
					return "<code>》 قوانین ثبت شدند</code>"
				end
				data[tostring(msg.to.id)][data_cat] = nil
				save_data(_config.moderation.data, data)
				return '<code>》 قوانین پاک شدند</code>'
			end
			if matches[2]:lower() == 'about'or matches[2] == 'موضوع' then
				local receiver = get_receiver(msg)
				local about_text = ' '
				local data_cat = 'description'
				if data[tostring(msg.to.id)][data_cat] == nil then
					return '<code>》 موضوع گروه ثبت شد</code>'
				end
				data[tostring(msg.to.id)][data_cat] = nil
				save_data(_config.moderation.data, data)
				channel_set_about(receiver, about_text, ok_cb, false)
				return "<code>》 موضوع گروه پاک شد</code>"
			end
			if matches[2]:lower() == 'silentlist'or matches[2] == 'لیست صامت شدگان' then
				chat_id = msg.to.id
				local hash =  'mute_user:'..chat_id
					redis:del(hash)
				return "<code>》 لیست صامت شدگان پاک شد\nاکنون همه اعضا قادر به چت در گروه هستند</code>"
			end
			if matches[2]:lower() == 'username'or matches[2] == 'ایدی' and is_admin1(msg) then
				local function ok_username_cb (extra, success, result)
					local receiver = extra.receiver
					if success == 1 then
						send_large_msg(receiver, "SuperGroup username cleaned.")
					elseif success == 0 then
						send_large_msg(receiver, "Failed to clean SuperGroup username.")
					end
				end
				local username = ""
				channel_set_username(receiver, username, ok_username_cb, {receiver=receiver})
			end
			if matches[2] == "bots" and is_momod(msg) then
				channel_get_bots(receiver, callback_clean_bots, {msg = msg})
			end
		end

		if matches[1]:lower() == 'lock' and is_momod(msg)or matches[1] == 'قفل' and is_momod(msg) then
			local target = msg.to.id
			if matches[2] == 'links'or matches[2] == 'لینک' then
				return lock_group_links(msg, data, target)
			end
			if matches[2] == 'spam'or matches[2] == 'اسپم' then
				return lock_group_spam(msg, data, target)
			end
			if matches[2] == 'flood'or matches[2] == 'فلود' then
				return lock_group_flood(msg, data, target)
			end
			if matches[2] == 'arabic'or matches[2] == 'عربی' then
				return lock_group_arabic(msg, data, target)
			end
			if matches[2] == 'member'or matches[2] == 'ممبر' then
				return lock_group_membermod(msg, data, target)
			end
			if matches[2] == 'tgservice'or matches[2] == 'ورودوخروج' then
				return lock_group_tgservice(msg, data, target)
			end
			if matches[2] == 'sticker'or matches[2] == 'استیکر' then
				return lock_group_sticker(msg, data, target)
			end
			if matches[2] == 'contacts'or matches[2] == 'مخاطب' then
				return lock_group_contacts(msg, data, target)
			end
			if matches[2] == "edit"or matches[2] == 'ویرایش' then
			    return lock_group_edit(msg, data, target)
			end
			if matches[2] == 'username'or matches[2] == 'ایدی' then
			    return lock_group_username(msg, data, target)
		    end
      if matches[2] == 'media'or matches[2] == 'رسانه' then
        return lock_group_media(msg, data, target)
      end
      if matches[2] == 'fwd'or matches[2] == 'فوروارد' then
        return lock_group_fwd(msg, data, target)
      end
      if matches[2] == 'tag'or matches[2] == 'هشتگ' then
        return lock_group_tag(msg, data, target)
      end
      if matches[2] == 'bots'or matches[2] == 'ربات ها' then
        return lock_group_bots(msg, data, target)
      end
      if matches[2] == 'audio'or matches[2] == 'آهنگ' then
        return lock_group_audio(msg, data, target)
      end
      if matches[2] == 'photo'or matches[2] == 'عکس' then
        return lock_group_photo(msg, data, target)
      end
      if matches[2] == 'video'or matches[2] == 'فیلم' then
        return lock_group_video(msg, data, target)
      end
      if matches[2] == 'documents'or matches[2] == 'فایل' then
        return lock_group_documents(msg, data, target)
      end
      if matches[2] == 'text'or matches[2] == 'متن' then
        return lock_group_text(msg, data, target)
      end
      if matches[2] == 'all'or matches[2] == 'همه' then
        return lock_group_all(msg, data, target)
      end
      if matches[2] == 'gifs'or matches[2] == 'گیف' then
        return lock_group_gifs(msg, data, target)
      end
      if matches[2] == 'inline'or matches[2] == 'اینلاین' then
        return lock_group_inline(msg, data, target)
      end
      if matches[2] == 'cmd'or matches[2] == 'دستورات' then
        return lock_group_cmd(msg, data, target)
      end
			if matches[2] == 'strict'or matches[2] == 'سختگیرانه' then
				return enable_strict_rules(msg, data, target)
			end
		end

		if matches[1]:lower() == 'unlock' and is_momod(msg) or matches[1] == 'بازکردن' and is_momod(msg) then
			local target = msg.to.id
			if matches[2] == 'links'or matches[2] == 'لینک' then
				return unlock_group_links(msg, data, target)
			end
			if matches[2] == 'spam'or matches[2] == 'اسپم' then
				return unlock_group_spam(msg, data, target)
			end
			if matches[2] == 'flood'or matches[2] == 'فلود' then
				return unlock_group_flood(msg, data, target)
			end
			if matches[2] == 'arabic'or matches[2] == 'عربی' then
				return unlock_group_arabic(msg, data, target)
			end
			if matches[2] == 'member'or matches[2] == 'ممبر' then
				return unlock_group_membermod(msg, data, target)
			end
				if matches[2] == 'tgservice'or matches[2] == 'ورودوخروج' then
				return unlock_group_tgservice(msg, data, target)
			end
			if matches[2] == 'sticker'or matches[2] == 'استیکر' then
				return unlock_group_sticker(msg, data, target)
			end
			if matches[2] == 'contacts'or matches[2] == 'مخاطب' then
				return unlock_group_contacts(msg, data, target)
			end
			if matches[2] == 'edit'or matches[2] == 'ویرایش' then
			    return unlock_group_edit(msg, data, target)
		    end
			if matches[2] == 'username'or matches[2] == 'ایدی' then
			    return unlock_group_username(msg, data, target)
		    end
      if matches[2] == 'media'or matches[2] == 'رسانه' then
        return unlock_group_media(msg, data, target)
      end
      if matches[2] == 'fwd'or matches[2] == 'فوروراد' then
        return unlock_group_fwd(msg, data, target)
      end
      if matches[2] == 'tag'or matches[2] == 'هشتگ' then
        return unlock_group_tag(msg, data, target)
      end
      if matches[2] == 'bots'or matches[2] == 'ربات ها' then
        return unlock_group_bots(msg, data, target)
      end
      if matches[2] == 'audio'or matches[2] == 'آهنگ' then
        return unlock_group_audio(msg, data, target)
      end
      if matches[2] == 'photo'or matches[2] == 'عکس' then
        return unlock_group_photo(msg, data, target)
      end
      if matches[2] == 'video'or matches[2] == 'فیلم' then
        return unlock_group_video(msg, data, target)
      end
      if matches[2] == 'documents'or matches[2] == 'فایل' then
        return unlock_group_documents(msg, data, target)
      end
      if matches[2] == 'text'or matches[2] == 'متن' then
        return unlock_group_text(msg, data, target)
      end
      if matches[2] == 'all'or matches[2] == 'همه' then
        return unlock_group_all(msg, data, target)
      end
      if matches[2] == 'gifs'or matches[2] == 'گیف' then
        return unlock_group_gifs(msg, data, target)
      end
      if matches[2] == 'inline'or matches[2] == 'اینلاین' then
        return unlock_group_inline(msg, data, target)
      end
      if matches[2] == 'cmd' or matches[2] == 'دستورات' then
        return unlock_group_cmd(msg, data, target)
      end
			if matches[2] == 'strict' or matches[2] == 'سختگیرانه' then
				return disable_strict_rules(msg, data, target)
			end
		end

		if matches[1]:lower() == 'setflood' or matches[1] == 'تنظیم حساسیت' then
			if not is_momod(msg) then
				return
			end
			if tonumber(matches[2]) < 5 or tonumber(matches[2]) > 20 then
				return "Wrong number,range is [5-20]"
			end
			local flood_max = matches[2]
			data[tostring(msg.to.id)]['settings']['flood_msg_max'] = flood_max
			save_data(_config.moderation.data, data)
			return 'Flood has been set to: '..matches[2]
		end
		if matches[1]:lower() == 'public' and is_momod(msg) or matches[1] == 'عمومی' and is_momod(msg) then
			local target = msg.to.id
			if matches[2] == 'yes' or matches[2] == 'باشد' then
				return set_public_membermod(msg, data, target)
			end
			if matches[2] == 'no' or matches[2] == 'نباشد' then
				return unset_public_membermod(msg, data, target)
			end
		end

		if matches[1]:lower() == "silent" and is_momod(msg) or matches[1] =='صامت' and is_momod(msg) or matches[1]:lower() == "unsilent" and is_momod(msg) or matches[1] =='مصوت' and is_momod(msg) then
			local chat_id = msg.to.id
			local hash = "mute_user"..chat_id
			local user_id = ""
			if type(msg.reply_id) ~= "nil" then
				local receiver = get_receiver(msg)
				local get_cmd = "mute_user"
				muteuser = get_message(msg.reply_id, get_message_callback, {receiver = receiver, get_cmd = get_cmd, msg = msg})
			elseif matches[1]:lower() == "silent"or matches[1] =='صامت' or matches[1] == "unsilent"or matches[1] =='مصوت' and string.match(matches[2], '^%d+$') then
				local user_id = matches[2]
				if is_muted_user(chat_id, user_id) then
					unmute_user(chat_id, user_id)
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] removed ["..user_id.."] from the muted users list")
					return "➖➖➖➖➖➖➖➖➖\n🔖<i>کاربر از لیست سایلنت حذف شد..\nو قادر به چت در گروه</i> "..msg.to.title.." <i>است\n➖➖➖➖➖➖➖➖➖\n》آیدی کاربر:</i> <b>[ "..user_id.." ]</b> \n<i>》فرد مصوت کننده:</i> @"..(msg.from.username or "_").."\n➖➖➖➖➖➖➖➖➖\n"
				elseif is_momod(msg) then
				mute_user(chat_id, user_id)
				local mutedhash = 'muted:'..msg.from.id..':'..msg.to.id
        redis:incr(mutedhash)
        local mutedhash = 'muted:'..msg.from.id..':'..msg.to.id
        local muted = redis:get(mutedhash)
	--savelog(msg.to.id, name_log.." ["..msg.from.id.."] added ["..user_id.."] to the muted users list")
					return "➖➖➖➖➖➖➖➖➖\n🔖<i>کاربر به لیست سایلنت اضافه شد...\nو قادر به چت در گروه</i> "..msg.to.title.." <i>نیست\n➖➖➖➖➖➖➖➖➖\n》آیدی کاربر:</i> <b>[ "..user_id.." ]</b>\n<i>》فرد صامت کننده:</i> @"..(msg.from.username or "_").."\n➖➖➖➖➖➖➖➖➖\n"
				end
			elseif matches[1]:lower() == "silent"or matches[1] =='صامت' or matches[1]:lower() == "unsilent" and not string.match(matches[2], '^%d+$') then
				local receiver = get_receiver(msg)
				local get_cmd = "mute_user"
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				resolve_username(username, callbackres, {receiver = receiver, get_cmd = get_cmd, msg=msg})
			end
		end

		if matches[1]:lower() == "silentlist" and is_momod(msg) or matches[1] == "لیست صامت شدگان" and is_momod(msg) then
			local chat_id = msg.to.id
			return muted_user_list(chat_id)
		end

		if matches[1]:lower() == 'settings' and is_momod(msg) or matches[1] == 'تنظیمات' and is_momod(msg) then
			local target = msg.to.id
			return show_supergroup_settingsmod(msg, target)
		end

		if matches[1]:lower() == 'rules' or matches[1] == 'قوانین' then
			return get_rules(msg, data)
		end

		if matches[1] == 'peer_id' and is_admin1(msg)then
			text = msg.to.peer_id
			reply_msg(msg.id, text, ok_cb, false)
			post_large_msg(receiver, text)
		end

		if matches[1] == 'msg.to.id' and is_admin1(msg) then
			text = msg.to.id
			reply_msg(msg.id, text, ok_cb, false)
			post_large_msg(receiver, text)
		end

		--Admin Join Service Message
		if msg.service then
		local action = msg.action.type
			if action == 'chat_add_user_link' then
				if is_owner2(msg.from.id) then
					local receiver = get_receiver(msg)
					local user = "user#id"..msg.from.id
					channel_set_admin(receiver, user, ok_cb, false)
				end
				if is_support(msg.from.id) and not is_owner2(msg.from.id) then
					local receiver = get_receiver(msg)
					local user = "user#id"..msg.from.id
					channel_set_mod(receiver, user, ok_cb, false)
				end
			end
			if action == 'chat_add_user' then
				if is_owner2(msg.action.user.id) then
					local receiver = get_receiver(msg)
					local user = "user#id"..msg.action.user.id
					channel_set_admin(receiver, user, ok_cb, false)
				end
				if is_support(msg.action.user.id) and not is_owner2(msg.action.user.id) then
					local receiver = get_receiver(msg)
					local user = "user#id"..msg.action.user.id
					channel_set_mod(receiver, user, ok_cb, false)
				end
			end
		end
		if matches[1] == 'msg.to.peer_id' and is_sudo(msg) then
			post_large_msg(receiver, msg.to.peer_id)
		end
	end
end

local function pre_process(msg)
  if not msg.text and msg.media then
    msg.text = '['..msg.media.type..']'
  end
  return msg
end

return {
  patterns = {
	"^[#!/]([Aa][Dd][Dd])$",
	"^[#!/]([Rr][Ee][Mm])$",
	"^[#!/]([Mm]ove) (.*)$",
	"^[#!/]([Gg][Pp]{Ii][Nn][Ff][Oo])$",
	"^[#!/]([Aa][Dd][Mm][Ii][Nn][Ss])$",
	"^[#!/]([Oo][Ww][Nn][Ee][Rr])$",
	"^[#!/]([Mm][Oo][Dd][Ll][Ii][Ss][Tt])$",
	"^[#!/]([Bb][Oo][Tt][Ss])$",
	"^[#!/]([Ww][Hh][Oo])$",
	"^[#!/]([Kk][Ii][Cc][Kk][Ee][Dd])$",
    "^[#!/]([Bb][Ll][Oo][Cc][Kk]) (.*)",
	"^[#!/]([Bb][Ll][Oo][Cc][Kk])",
	"^[#!/]([Tt][Oo][Ss][Uu][Pp][Ee][Rr])$",
	"^[#!/]([Ii][Dd])$",
	"^[#!/]([Ii][Dd]) (.*)$",
	"^[#!/]([Kk][Ii][Cc][Kk][Mm][Ee])$",
	"^[#!/]([Nn][Ee][Ww][Ll][Ii][Nn][Kk])$",
	"^[#!/]([Ss][Ee][Tt][Ll][Ii][Nn][Kk])$",
	"^[#!/]([Ll][Ii][Nn][Kk])$",
	"^[#!/]([Rr][Re][Ss]) (.*)$",
	"^[#!/]([Ss][Ee][Tt][Aa][Dd][Mm][Ii][Nn]) (.*)$",
	"^[#!/]([Ss][Ee][Tt][Aa][Dd][Mm][Ii][Nn])",
	"^[#!/]([Dd][Ee][Mm][Oo][Tt][Aa][Dd][Mm][Ii][Nn]) (.*)$",
	"^[#!/]([Dd][Ee][Mm][Oo][Tt][Aa][Dd][Mm][Ii][Nn])",
	"^[#!/]([Ss][Ee][Tt][Oo][Ww][Nn][Ee][Rr]) (.*)$",
	"^[#!/]([Ss][Ee][Tt][Oo][Ww][Nn][Ee][Rr])$",
	"^[#!/]([Pp][Rr][Oo][Mm][Oo][Tt][Ee]) (.*)$",
	"^[#!/]([Pp][Rr][Oo][Mm][Oo][Tt][Ee])",
	"^[#!/]([Dd][Ee][Mm][Oo][Tt][Ee]) (.*)$",
	"^[#!/]([Dd][Ee][Mm][Oo][Tt][Ee])",
	"^[#!/]([Ss][Ee][Tt][Nn][Aa][Mm][Ee]) (.*)$",
	"^[#!/]([Ss][Ee][Tt][Aa][Bb][Oo][Uu][Tt]) (.*)$",
	"^[#!/]([Ss][Ee][Tt][Rr][Uu][Ll][Ee][Ss]) (.*)$",
	"^[#!/]([Ss][Ee][Tt][Pp][Hh][Oo][Tt][Oo])$",
	"^[#!/]([Ss]etusername) (.*)$",
	"^[!#/]([Ii][Nn][Vv][Ii][Tt][Ee])",
	"^[#!/]([Dd][Ee][Ll])$",
	"^[#!/]([Ll][Oo][Cc][Kk]) (.*)$",
	"^[#!/]([Uu][Nn][Ll][Oo][Cc][Kk]) (.*)$",
	"^[#!/]([Ss][Ii][Ll][Ee][Nn][Tt])$",
	"^[#!/]([Ss][Ii][Ll][Ee][Nn][Tt]) (.*)$",
	"^[#!/]([Uu][Un][Ss][Ii][Ll][Ee][Nn][Tt])$",
	"^[#!/]([Uu][Nn][Ss][Ii][Ll][Ee][Nn][Tt]) (.*)$",
	"^[#!/]([Pp][Uu][Bb][Ll][Ii][Cc]) (.*)$",
	"^[#!/]([Ss][Ee][Tt][Tt][Ii][Nn][Gg][Ss])$",
	"^[#!/]([Rr][Uu][Ll][Ee][Ss])$",
	"^[!#/]([Ss][Ee][Tt][Ff][Ll][Oo][Oo][Dd]) (%d+)$",
	"^[#!/]([Cc][Ll][Ee][Aa][Nn]) (.*)$",
	"^[#!/]([Ss][Ii][Ll][Ee][Nn][Tt][Ll][Ii][Ss][Tt])$",
    "[#!/](mp) (.*)",
	"[#!/](md) (.*)",
	"^([Aa][Dd][Dd])$",
	"^([Rr][Ee][Mm])$",
	"^([Mm]ove) (.*)$",
	"^([Gg][Pp]{Ii][Nn][Ff][Oo])$",
	"^([Aa][Dd][Mm][Ii][Nn][Ss])$",
	"^([Oo][Ww][Nn][Ee][Rr])$",
	"^([Mm][Oo][Dd][Ll][Ii][Ss][Tt])$",
	"^([Bb][Oo][Tt][Ss])$",
	"^([Ww][Hh][Oo])$",
	"^([Kk][Ii][Cc][Kk][Ee][Dd])$",
    "^([Bb][Ll][Oo][Cc][Kk]) (.*)",
	"^([Bb][Ll][Oo][Cc][Kk])",
	"^([Tt][Oo][Ss][Uu][Pp][Ee][Rr])$",
	"^([Ii][Dd])$",
	"^([Ii][Dd]) (.*)$",
	"^([Ii][Nn][Vv][Ii][Tt][Ee])",
	"^([Kk][Ii][Cc][Kk][Mm][Ee])$",
	"^([Nn][Ee][Ww][Ll][Ii][Nn][Kk])$",
	"^([Ss][Ee][Tt][Ll][Ii][Nn][Kk])$",
	"^([Ll][Ii][Nn][Kk])$",
	"^([Rr][Re][Ss]) (.*)$",
	"^([Ss][Ee][Tt][Aa][Dd][Mm][Ii][Nn]) (.*)$",
	"^([Ss][Ee][Tt][Aa][Dd][Mm][Ii][Nn])",
	"^([Dd][Ee][Mm][Oo][Tt][Aa][Dd][Mm][Ii][Nn]) (.*)$",
	"^([Dd][Ee][Mm][Oo][Tt][Aa][Dd][Mm][Ii][Nn])",
	"^([Ss][Ee][Tt][Oo][Ww][Nn][Ee][Rr]) (.*)$",
	"^([Ss][Ee][Tt][Oo][Ww][Nn][Ee][Rr])$",
	"^([Pp][Rr][Oo][Mm][Oo][Tt][Ee]) (.*)$",
	"^([Pp][Rr][Oo][Mm][Oo][Tt][Ee])",
	"^([Dd][Ee][Mm][Oo][Tt][Ee]) (.*)$",
	"^([Dd][Ee][Mm][Oo][Tt][Ee])",
	"^([Ss][Ee][Tt][Nn][Aa][Mm][Ee]) (.*)$",
	"^([Ss][Ee][Tt][Aa][Bb][Oo][Uu][Tt]) (.*)$",
	"^([Ss][Ee][Tt][Rr][Uu][Ll][Ee][Ss]) (.*)$",
	"^([Ss][Ee][Tt][Pp][Hh][Oo][Tt][Oo])$",
	"^([Ss]etusername) (.*)$",
	"^([Dd][Ee][Ll])$",
	"^([Ll][Oo][Cc][Kk]) (.*)$",
	"^([Uu][Nn][Ll][Oo][Cc][Kk]) (.*)$",
	"^([Ss][Ii][Ll][Ee][Nn][Tt])$",
	"^([Ss][Ii][Ll][Ee][Nn][Tt]) (.*)$",
	"^([Uu][Un][Ss][Ii][Ll][Ee][Nn][Tt])$",
	"^([Uu][Nn][Ss][Ii][Ll][Ee][Nn][Tt]) (.*)$",
	"^([Pp][Uu][Bb][Ll][Ii][Cc]) (.*)$",
	"^([Ss][Ee][Tt][Tt][Ii][Nn][Gg][Ss])$",
	"^([Rr][Uu][Ll][Ee][Ss])$",
	"^([Ss][Ee][Tt][Ff][Ll][Oo][Oo][Dd]) (%d+)$",
	"^([Cc][Ll][Ee][Aa][Nn]) (.*)$",
	"^([Ss][Ii][Ll][Ee][Nn][Tt][Ll][Ii][Ss][Tt])$",
	"^(اد شو)$",
	"^(حذف شو)$",
	"^(اطلاعات گپ)$",
	"^(ادمین ها)$",
	"^(ایدی صاحب)$",
	"^(مدیران)$",
	"^(ربات ها)$",
	"^(اعضای گروه)$",
    "^(بلاک) (.*)",
	"^(بلاک)",
	"^(دعوت)",
	"^(تبدیل)$",
	"^(ایدی)$",
	"^(ایدی) (.*)$",
	"^(لینک جدید)$",
	"^(نشاندن لینک)$",
	"^(لینک)$",
	"^(ادمین) (.*)$",
	"^(ادمین)",
	"^(تنزل ادمین) (.*)$",
	"^(تنزل ادمین)",
	"^(صاحب) (.*)$",
	"^(صاحب)$",
	"^(مدیر) (.*)$",
	"^(مدیر)",
	"^(تنزل مدیر) (.*)$",
	"^(تنزل مدیر)",
	"^(نشاندن اسم) (.*)$",
	"^(نشاندن موضوع) (.*)$",
	"^(نشاندن قوانین) (.*)$",
	"^(نشاندن عکس)$",
	"^(حذف)$",
	"^(قفل) (.*)$",
	"^(بازکردن) (.*)$",
	"^(صامت)$",
	"^(صامت) (.*)$",
	"^(مصوت)$",
	"^(مصوت) (.*)$",
	"^(عمومی) (.*)$",
	"^(تنظیمات)$",
    "^(قوانین)$",
	"^(تنظیم حساسیت) (%d+)$",
	"^(حذف) (.*)$",
	"^(لیست صامت شدگان)$",
	"^[#!/](اد شو)$",
	"^[#!/](حذف شو)$",
	"^[#!/](اطلاعات گپ)$",
	"^[#!/](ادمین ها)$",
	"^[#!/](ایدی صاحب)$",
	"^[#!/](مدیران)$",
	"^[#!/](ربات ها)$",
	"^[#!/](اعضای گروه)$",
    "^[#!/](بلاک) (.*)",
	"^[#!/](بلاک)",
    "^[!#/](دعوت)",
	"^[#!/](تبدیل)$",
	"^[#!/](ایدی)$",
	"^[#!/](ایدی) (.*)$",
	"^[#!/](لینک جدید)$",
	"^[#!/](نشاندن لینک)$",
	"^[#!/](لینک)$",
	"^[#!/](ادمین) (.*)$",
	"^[#!/](ادمین)",
	"^[#!/](تنزل ادمین) (.*)$",
	"^[#!/](تنزل ادمین)",
	"^[#!/](صاحب) (.*)$",
	"^[#!/](صاحب)$",
	"^[#!/](مدیر) (.*)$",
	"^[#!/](مدیر)",
	"^[#!/](تنزل مدیر) (.*)$",
	"^[#!/](تنزل مدیر)",
	"^[#!/](نشاندن اسم) (.*)$",
	"^[#!/](نشاندن موضوع) (.*)$",
	"^[#!/](نشاندن قوانین) (.*)$",
	"^[#!/](نشاندن عکس)$",
	"^[#!/](حذف)$",
	"^[#!/](قفل) (.*)$",
	"^[#!/](بازکردن) (.*)$",
	"^[#!/](صامت)$",
	"^[#!/](صامت) (.*)$",
	"^[#!/](مصوت)$",
	"^[#!/](مصوت) (.*)$",
	"^[#!/](عمومی) (.*)$",
	"^[#!/](تنظیمات)$",
	"^[#!/](تنظیم حساسیت) (%d+)$",
	"^[#!/](حذف) (.*)$",
    "^[!#/](قوانین)$",
	"^[#!/](لیست صامت شدگان)$",
    "^(https://telegram.me/joinchat/%S+)$",
	"msg.to.peer_id",
	"%[(document)%]",
	"%[(photo)%]",
	"%[(video)%]",
	"%[(audio)%]",
	"%[(contact)%]",
	"^!!tgservice (.+)$",
  },
  run = run,
  pre_process = pre_process
}

--By @MRR619
-- Ch @TeleDiamondch
