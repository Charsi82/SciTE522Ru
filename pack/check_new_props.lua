local function getcwd()
return debug.getinfo(1,"S").short_src:match(".+\\"):to_utf8(0)
end
local editor_path = getcwd()
local path = editor_path..[[SciTEGlobal.properties]]
local path2 = editor_path..[[SciTEGlobal__new.properties]]
local t = {}
function process(src_id, path)
print("process:"..path)
local cur_line = ''
for line in io.lines(path) do
-- 	print(line)
-- 	if line:match("\\$") then
--[[		if #cur_line==0 then
			cur_line = line
		else
			cur_line = cur_line ..'\n  '.. line
		end]]
-- 	else
		local commented,txt, value = line:match("^([#%s]+)([%.a-zA-Z]+)%s?=%s?(%S+)")
		if txt then
			table.insert(t,{src = src_id, cur_line = line, cmd = txt, value = value, comm = commented})
-- 			if #cur_line then table.insert(t,{src = src_id, cur_line = cur_line}) end
-- 			cur_line = txt
		end
-- 	end
end
-- table.insert(t,{src = src_id, cur_line = line, cmd =  })
end

process(0,path)
process(1,path2)
table.sort(t, function(a,b) return a.cmd < b.cmd or (a.cmd == b.cmd and a.src < b.src) end)
-- output
io.output("scite_settings.properties")
-- reduce
for i = 1, #t-1 do
	if not t[i+1] then break end
	if t[i].cmd == t[i+1].cmd --[[and t[i].value == t[i+1].value]] then
		t[i].src = 3
		t[i+1].src = 3
	end
end

for k, v in ipairs(t) do
	if v.src < 3 then
		local idx = "[old]"
		if v.src == 1 then idx = "[new]" end
-- 		io.write(idx,v.cmd," = ",v.value,'\n')
		if v.src == 1 then io.write(v.comm or "",v.cmd,"=",v.value,'\n') end
	end
end
io.close()
print('done.')