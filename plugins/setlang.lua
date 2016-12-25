do
local function run(msg, matches, callback, extra)
local hash = 'group:'..msg.to.id
local group_lang = redis:hget(hash,'lang')
if matches[1] == 'setlang' and  matches[2] == 'en' and is_owner(msg) then 
    
   redis:hdel(hash,'lang')
        return '<i>group lang set to : english</i>'
end



if matches[1] == 'setlang' and matches[2] == 'fa' and is_owner(msg) then
redis:hset(hash,'lang',matches[2])
        return '<i>زبان گروه تنظیم شد به : فارسی</i>'
end
if matches[1] == 'lang' then
if group_lang then 
return "<i>زبان گروه شما هم اکنون بر روی فارسی قرار دارد</i>"
else
return "<i>Group lang : english</i>"
end
end
end
return {
  patterns = {
    "^[!#/]([Ss][Ee][Tt][Ll][Aa][Nn][Gg]) ([Ff][Aa])$",
  "^[!#/]([Ss][Ee][Tt][Ll][Aa][Nn][Gg]) ([Ee][Nn])$",
  "^[!#/]([Ll][Aa][Nn][Gg])",
   "^([Ss][Ee][Tt][Ll][Aa][Nn][Gg]) ([Ff][Aa])$",
  "^([Ss][Ee][Tt][Ll][Aa][Nn][Gg]) ([Ee][Nn])$",
  "^([Ll][Aa][Nn][Gg])"
  },
  run = run
}
end
