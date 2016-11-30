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
--Begin pre_process function
local function pre_process(msg)

if is_chat_msg(msg) or is_super_group(msg) then
	if msg and not is_momod(msg) and not is_whitelisted(msg.from.id) then --if regular user
	local data = load_data(_config.moderation.data)
	local print_name = user_print_name(msg.from):gsub("‮", "") -- get rid of rtl in names
	local name_log = print_name:gsub("_", " ") -- name for log
	local to_chat = msg.to.type == 'chat'
	local to_super = msg.to.type == 'channel'
	if data[tostring(msg.to.id)] and data[tostring(msg.to.id)]['settings'] then
		settings = data[tostring(msg.to.id)]['settings']
	else
		return
	end
	if settings.lock_arabic then
		lock_arabic = settings.lock_arabic
	else
		lock_arabic = 'no'
	end
	if settings.lock_rtl then
		lock_rtl = settings.lock_rtl
	else
		lock_rtl = 'no'
	end
		if settings.lock_tgservice then
		lock_tgservice = settings.lock_tgservice
	else
		lock_tgservice = 'no'
	end
	if settings.lock_link then
		lock_link = settings.lock_link
	else
		lock_link = 'no'
	end
	if settings.lock_member then
		lock_member = settings.lock_member
	else
		lock_member = 'no'
	end
	if settings.lock_spam then
		lock_spam = settings.lock_spam
	else
		lock_spam = 'no'
	end
	if settings.lock_sticker then
		lock_sticker = settings.lock_sticker
	else
		lock_sticker = 'no'
	end
	if settings.lock_contacts then
		lock_contacts = settings.lock_contacts
	else
		lock_contacts = 'no'
	end
	if settings.strict then
		strict = settings.strict
	else
		strict = 'no'
	end
		if msg and not msg.service and is_muted(msg.to.id, 'All: yes') or is_muted_user(msg.to.id, msg.from.id) and not msg.service then
			delete_msg(msg.id, ok_cb, false)
			if to_chat then
			--	kick_user(msg.from.id, msg.to.id)
			end
		end
		if msg.text then -- msg.text checks
			local _nl, ctrl_chars = string.gsub(msg.text, '%c', '')
			 local _nl, real_digits = string.gsub(msg.text, '%d', '')
			if lock_spam == "yes" and string.len(msg.text) > 2049 or ctrl_chars > 40 or real_digits > 2000 then
				delete_msg(msg.id, ok_cb, false)
				if strict == "yes" or to_chat then
					delete_msg(msg.id, ok_cb, false)
					kick_user(msg.from.id, msg.to.id)
				end
			end
			local is_link_msg = msg.text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or msg.text:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/")
			local is_bot = msg.text:match("?[Ss][Tt][Aa][Rr][Tt]=")
			if is_link_msg and lock_link == "yes" and not is_bot then
				delete_msg(msg.id, ok_cb, false)
				if strict == "yes" or to_chat then
					kick_user(msg.from.id, msg.to.id)
				end
		end
		if msg.service then 
			if lock_tgservice == "yes" then
				delete_msg(msg.id, ok_cb, false)
				if to_chat then
					return
				end
			end
		end
			local is_squig_msg = msg.text:match("[\216-\219][\128-\191]")
			if is_squig_msg and lock_arabic == "yes" then
				delete_msg(msg.id, ok_cb, false)
				if strict == "yes" or to_chat then
					kick_user(msg.from.id, msg.to.id)
				end
			end
			local print_name = msg.from.print_name
			local is_rtl = print_name:match("‮") or msg.text:match("‮")
			if is_rtl and lock_rtl == "yes" then
				delete_msg(msg.id, ok_cb, false)
				if strict == "yes" or to_chat then
					kick_user(msg.from.id, msg.to.id)
				end
			end
			if is_muted(msg.to.id, "Text: yes") and msg.text and not msg.media and not msg.service then
				delete_msg(msg.id, ok_cb, false)
				if to_chat then
					kick_user(msg.from.id, msg.to.id)
				end
			end
		end
		if msg.media then -- msg.media checks
			if msg.media.title then
				local is_link_title = msg.media.title:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/")or msg.media.caption:match("^(.+)$")or msg.media.title:match("#")or msg.media.title:match("@") or msg.media.title:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/")
				if is_link_title and lock_link == "yes" then
					delete_msg(msg.id, ok_cb, false)
					if strict == "yes" or to_chat then
						kick_user(msg.from.id, msg.to.id)
					end
				end
				local is_squig_title = msg.media.title:match("[\216-\219][\128-\191]")
				if is_squig_title and lock_arabic == "yes" then
					delete_msg(msg.id, ok_cb, false)
					if strict == "yes" or to_chat then
						kick_user(msg.from.id, msg.to.id)
					end
				end
			end
			if msg.media.description then
				local is_link_desc = msg.media.description:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or msg.media.description:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/")
				if is_link_desc and lock_link == "yes" then
					delete_msg(msg.id, ok_cb, false)
					if strict == "yes" or to_chat then
						kick_user(msg.from.id, msg.to.id)
					end
				end
				local is_squig_desc = msg.media.description:match("[\216-\219][\128-\191]")
				if is_squig_desc and lock_arabic == "yes" then
					delete_msg(msg.id, ok_cb, false)
					if strict == "yes" or to_chat then
						kick_user(msg.from.id, msg.to.id)
					end
				end
			end
			if msg.media.caption then -- msg.media.caption checks
				local is_link_caption = msg.media.caption:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/")or msg.media.caption:match("^(.+)$")or msg.media.caption:match("@")or msg.media.caption:match("#") or msg.media.caption:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/") or msg.media.caption:match("@[ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz][_ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz][_ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz][_ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz][ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz]")
				if is_link_caption and lock_link == "yes" then
					delete_msg(msg.id, ok_cb, false)
					if strict == "yes" or to_chat then
						kick_user(msg.from.id, msg.to.id)
					end
				end
				local is_squig_caption = msg.media.caption:match("[\216-\219][\128-\191]")
					if is_squig_caption and lock_arabic == "yes" then
						delete_msg(msg.id, ok_cb, false)
						if strict == "yes" or to_chat then
							kick_user(msg.from.id, msg.to.id)
						end
					end
				local is_username_caption = msg.media.caption:match("^@[%a%d]")
				if is_username_caption and lock_link == "yes" then
					delete_msg(msg.id, ok_cb, false)
					if strict == "yes" or to_chat then
						kick_user(msg.from.id, msg.to.id)
					end
				end
				if lock_sticker == "yes" and msg.media.caption:match("sticker.webp") then
					delete_msg(msg.id, ok_cb, false)
					if strict == "yes" or to_chat then
						kick_user(msg.from.id, msg.to.id)
					end
				end
			end
			if msg.media.type:match("contact") and lock_contacts == "yes" then
				delete_msg(msg.id, ok_cb, false)
				if strict == "yes" or to_chat then
					kick_user(msg.from.id, msg.to.id)
				end
			end
			local is_photo_caption =  msg.media.caption and msg.media.caption:match("photo")--".jpg",
			if is_muted(msg.to.id, 'Photo: yes') and msg.media.type:match("photo") or is_photo_caption and not msg.service then
				delete_msg(msg.id, ok_cb, false)
				if strict == "yes" or to_chat then
					--	kick_user(msg.from.id, msg.to.id)
				end
			end
			local is_gif_caption =  msg.media.caption and msg.media.caption:match(".mp4")
			if is_muted(msg.to.id, 'Gifs: yes') and is_gif_caption and msg.media.type:match("document") and not msg.service then
				delete_msg(msg.id, ok_cb, false)
				if strict == "yes" or to_chat then
					--	kick_user(msg.from.id, msg.to.id)
				end
			end
			if is_muted(msg.to.id, 'Audio: yes') and msg.media.type:match("audio") and not msg.service then
				delete_msg(msg.id, ok_cb, false)
				if strict == "yes" or to_chat then
					kick_user(msg.from.id, msg.to.id)
				end
			end
			local is_video_caption = msg.media.caption and msg.media.caption:lower(".mp4","video")
			if  is_muted(msg.to.id, 'Video: yes') and msg.media.type:match("video") and not msg.service then
				delete_msg(msg.id, ok_cb, false)
				if strict == "yes" or to_chat then
					kick_user(msg.from.id, msg.to.id)
				end
			end
			if is_muted(msg.to.id, 'Documents: yes') and msg.media.type:match("document") and not msg.service then
				delete_msg(msg.id, ok_cb, false)
				if strict == "yes" or to_chat then
					kick_user(msg.from.id, msg.to.id)
				end
			end
		end
		if msg.fwd_from then
			if msg.fwd_from.title then
				local is_link_title = msg.fwd_from.title:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/")or msg.media.caption:match("[unsupported]")or msg.media.caption:match("#")or msg.media.caption:match("@") or msg.fwd_from.title:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/")
				if is_link_title and lock_link == "yes" then
					delete_msg(msg.id, ok_cb, false)
					if strict == "yes" or to_chat then
						kick_user(msg.from.id, msg.to.id)
					end
				end
				local is_squig_title = msg.fwd_from.title:match("[\216-\219][\128-\191]")
				if is_squig_title and lock_arabic == "yes" then
					delete_msg(msg.id, ok_cb, false)
					if strict == "yes" or to_chat then
						kick_user(msg.from.id, msg.to.id)
					end
				end
			end
			if is_muted_user(msg.to.id, msg.fwd_from.peer_id) then
				delete_msg(msg.id, ok_cb, false)
			end
		end
		if msg.service then -- msg.service checks
		local action = msg.action.type
			if action == 'chat_add_user_link' then
				local user_id = msg.from.id
				local _nl, ctrl_chars = string.gsub(msg.text, '%c', '')
				if string.len(msg.from.print_name) > 70 or ctrl_chars > 40 and lock_group_spam == 'yes' then
					delete_msg(msg.id, ok_cb, false)
					if strict == "yes" or to_chat then
						kick_user(msg.from.id, msg.to.id)
					end
				end
				local print_name = msg.from.print_name
				local is_rtl_name = print_name:match("‮")
				if is_rtl_name and lock_rtl == "yes" then
					kick_user(user_id, msg.to.id)
				end
				if lock_member == 'yes' then
					kick_user(user_id, msg.to.id)
					delete_msg(msg.id, ok_cb, false)
				end
			end
			if action == 'chat_add_user' and not is_momod2(msg.from.id, msg.to.id) then
				local user_id = msg.action.user.id
				if string.len(msg.action.user.print_name) > 70 and lock_group_spam == 'yes' then
					delete_msg(msg.id, ok_cb, false)
					if strict == "yes" or to_chat then
						delete_msg(msg.id, ok_cb, false)
						kick_user(msg.from.id, msg.to.id)
					end
				end
				local print_name = msg.action.user.print_name
				local is_rtl_name = print_name:match("‮")
				if is_rtl_name and lock_rtl == "yes" then
					kick_user(user_id, msg.to.id)
				end
				if msg.to.type == 'channel' and lock_member == 'yes' then
					kick_user(user_id, msg.to.id)
					delete_msg(msg.id, ok_cb, false)
				end
			end
		end
   end
   if not is_momod(msg) and not is_whitelisted(msg.from.id) and not is_sudo(msg) and not is_owner(msg) and not is_vip(msg) then
            if msg.text:match("@[ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz][_ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz][_ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz][_ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz][ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz]") then
	            if lock_link == 'yes' then
	                if msg.to.type == 'channel' then
	                    if strict == 'no' then
		                  delete_msg(msg.id, ok_cb, false)
		                elseif strict == 'yes' then
		                  delete_msg(msg.id, ok_cb, false)
		                  kick_user(msg.from.id, msg.to.id)
		                end
		            end
		              if msg.to.type == 'chat' then
		                 kick_user(msg.from.id, msg.to.id)
	                  end
		        end
            end	
   end
	if is_chat_msg(msg) or is_super_group(msg) then
	receiver = get_receiver(msg)
	user = "user"
	chat =  "chat"
	channel = "channel"
	    if not is_momod(msg) and not is_whitelisted(msg.from.id) and not is_sudo(msg) and not is_owner(msg) and not is_admin1(msg) then
		local data = load_data(_config.moderation.data)
		if data[tostring(msg.to.id)] then
        if data[tostring(msg.to.id)]['settings'] then
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
		end
		end
		    --Media lock:
		if msg.text:match("%[(photo)%]") or msg.text:match("%[(video)%]") or msg.text:match("%[(document)%]") or msg.text:match("%[(gif)%]") or msg.text:match("%[(unsupported)%]") or msg.text:match("%[(audio)%]") then
            if lock_media == "yes" then
		        if msg.to.type == channel then
                    if lock_strict == "no" then
				        delete_msg(msg.id, ok_cb, true)
				    elseif lock_strict == "yes" then
						delete_msg(msg.id, ok_cb, true)
			            kick_user(msg.from.id, msg.to.id)
				    end
		        end
            end
		end
    --lock username
          if msg.text:match("@") then
            if username == "yes" then
            if msg.to.type == channel then
            if lock_strict == "no" then
                delete_msg(msg.id, ok_cb, true)
            elseif lock_strict == "yes" then
            delete_msg(msg.id, ok_cb, true)
                  kick_user(msg.from.id, msg.to.id)
            end
            end
            end
    end
			--Tag lock:
	    if msg.text:match("#") then
            if lock_tag == "yes" then
		        if msg.to.type == channel then
				    if lock_strict == "no" then
				        delete_msg(msg.id, ok_cb, true)
				    elseif lock_strict == "yes" then
						delete_msg(msg.id, ok_cb, true)
			            kick_user(msg.from.id, msg.to.id)
				    end
		        end
            end
		end
			--Bots lock:
	    if msg.text:match("^!!tgservice (chat_add_user)$") or msg.text:match("^!!tgservice (chat_add_user_link)$") then
		    if lock_bots == "yes" then
                local user = msg.action.user or msg.from
                if isABotBadWay(user) then
                    userId = user.id
			        chatId = msg.to.id
		            if msg.to.type == channel then
                        kickUser("user#id"..userId, "channel#id"..chatId)
                        channel_kick_user("channel#id"..msg.to.id, 'user#id'..userId, ok_cb, false)
		            end
                end
		    end
        end
			--Inline lock:
			if msg.text == "[unsupported]" then
			    if msg.to.type == channel then
			        if lock_inline == "yes" then
					    if lock_strict == "no" then
				            delete_msg(msg.id, ok_cb, true)
						elseif lock_strict == "yes" then
						    delete_msg(msg.id, ok_cb, true)
			                kick_user(msg.from.id, msg.to.id)
						end
					end
				end
			end
			--Remove filter word:
		if msg.text:match("^(.+)$") then
            name = user_print_name(msg.from)
            return list_variables2(msg, msg.text)
        end
		end
	end
end
            --Fwd lock:
        if redis:get('fwd:'..msg.to.id) and msg.fwd_from and not is_sudo(msg) and not is_owner(msg) and not is_momod(msg) and not is_admin1(msg) then
            if lock_strict == "no" then
				delete_msg(msg.id, ok_cb, true)
		    elseif lock_strict == "yes" then
				delete_msg(msg.id, ok_cb, true)
			    kick_user(msg.from.id, msg.to.id)
			end
        end
			--Cmd Lock:
		if lock_cmd == "yes" and is_cmd(msg.text) and not is_momod(msg) then
            if lock_strict == "no" then
				delete_msg(msg.id, ok_cb, true)
		    elseif lock_strict == "yes" then
				delete_msg(msg.id, ok_cb, true)
			    kick_user(msg.from.id, msg.to.id)
			end
        end
	return msg
end


 function TeleDiamond(msg, matches) 
	if is_momod(msg) then
	  if is_super_group(msg) then
	    if matches[1]:lower() == 'lock'or matches[1] == 'قفل' then
			local target = msg.to.id
			local data = load_data(_config.moderation.data)
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
        end
		
		if matches[1]:lower() == 'unlock' or matches[1] == 'بازکردن' then
			local target = msg.to.id
			local data = load_data(_config.moderation.data)
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
         end
        end
	end
 end
return {
	patterns = {
"^[!/#]([Ll][Oo][Cc][Kk]) (.*)$",
"^[!/#]([Uu][Nn][Ll][Oo][Cc][Kk]) (.*)$",
"^([Ll][Oo][Cc][Kk]) (.*)$",
"^([Uu][Nn][Ll][Oo][Cc][Kk]) (.*)$",
"^[!/#](قفل) (.*)$",
"^[!/#](بازکردن) (.*)$",
"^(قفل) (.*)$",
"^(بازکردن) (.*)$",
	},
	pre_process = pre_process,
	run = TeleDiamond
}

