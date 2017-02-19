do
local function pre_process(msg)
 local hash = 'muteall:'..msg.to.id
  if redis:get(hash) and msg.to.type == 'channel' and not is_momod(msg)  then
   delete_msg(msg.id, ok_cb, false)
       end
    return msg
 end
 
local function run(msg, matches)
 if matches[1] == 'muteall' and is_momod(msg) then
       local hash = 'muteall:'..msg.to.id
       if not matches[2] then
              redis:set(hash, true)
             return "قفل گروه فعال شد"
 else

local num = tonumber(matches[2]) * 60
 redis:setex(hash, num, true)
 return "گروه برای "..matches[2].." دقیقه قفل شد. "
 end
 end
if matches[1] == 'unmuteall' and is_momod(msg) then
               local hash = 'muteall:'..msg.to.id
        redis:del(hash)
          return "قفل گروه غیرفعال شد"
  end
end
return {
   patterns = {
      '^[/!#](muteall)$',
      '^[/!#](unmuteall)$',
      '^[/!#](muteall) (.*)$',
     '^(muteall)$',
      '^(unmuteall)$',
   '^(muteall) (.*)$',
 },
run = run,
  pre_process = pre_process
}
end

-- by : @Mrr619
-- ch : @TeleDiamondCh