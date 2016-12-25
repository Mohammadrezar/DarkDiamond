local function pre_process(msg)
local hash = 'muteall:'..msg.to.id
        if redis:get(hash) and not is_sudo(msg) and not is_owner(msg) and not is_momod(msg) and not is_admin1(msg) then
            delete_msg(msg.id, ok_cb, false)
        end
 return msg
end
local function run(msg, matches)
if matches[1]:lower() == 'muteall' and matches[2] and is_owner(msg) then
      local hash = 'muteall:'..msg.to.id
      redis:setex(hash, tonumber(matches[2]) * 60, true)
    local text = '<i>چت در گروه برای مدت زمان '..matches[2]..' دقیقه ممنوع شد و کسی بجز مدیران و صاحب ربات قادر به چت در گروه نمیباشد</i>'
    reply_msg(msg.id, text, ok_cb, false)
            end
        if matches[1]:lower() == 'unmuteall' and is_momod(msg) then
      local hash = 'muteall:'..msg.to.id
      redis:del(hash)
            local text = '<i>گروه مصوت شد و هم اکنون همه قادر به چت در گروه هستند</i>'
            reply_msg(msg.id, text, ok_cb, false)
        end
   end
   return {
  patterns = {
      "^[!/#]([Mm][Uu][Tt][Ee][Aa][Ll][Ll]) (.*)$",
      "^([Mm][Uu][Tt][Ee][Aa][Ll][Ll]) (.*)$",
      "^[!/#]([Uu][Nn][Mm][Uu][Tt][Ee][Aa][Ll][Ll])$",
      "^([Uu][Nn][Mm][Uu][Tt][Ee][Aa][Ll][Ll])$",
      },
      run = run,
      pre_process = pre_process
}
-- by @mrr619