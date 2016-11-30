do
local function run(msg, matches, callback, extra)
local hash = 'group:'..msg.to.id
local group_lang = redis:hget(hash,'lang')
if matches[1] == 'setlang' and  matches[2] == 'en' and is_owner(msg) then 
    
   redis:hdel(hash,'lang')
        return '<b>group lang set to : en</b>'
end



if matches[1] == 'setlang' and matches[2] == 'fa' and is_owner(msg) then
redis:hset(hash,'lang',matches[2])
        return '<code>زبان گروه تنظیم شد به : FA</code>'
end
if matches[1] == 'lang' then
if group_lang then 
return "<code>زبان گروه شما هم اکنون بر روی فارسی قرار دارد</code>"
else
return "<b>Group lang : en</b>"
end
end
end
return {
  patterns = {
    "^[!#/]([Ss][Ee][Tt][Ll][Aa][Nn][Gg]) ([Ff][Aa])$",
  "^[!#/]([Ss][Ee][Tt][Ll][Aa][Nn][Gg]) ([Ee][Nn])$",
  "^[!#/]([Ll][Aa][Nn][Gg])"
  },
  run = run
}
end
