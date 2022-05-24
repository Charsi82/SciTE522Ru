--[[--------------------------------------------------
InsertSpecialChar.lua
Authors: mozers™
Version: 0.4.1
------------------------------------------------------
Вставка спецсимволов (©,®,§,±,…) из раскрывающегося списка (для HTML вставляются их обозначения)
--]]--------------------------------------------------

local cp=1

local char2html = {
	' ', '  ', '&nbsp;',
	'&', '& ', '&amp;',
	'"', '" ', '&quot;',
	'<', '< ', '&lt;',
	'>', '> ', '&gt;',
	'‘', 'вЂ', '&lsquo;',
	'’', 'вЂ™', '&rsquo;',
	'“', 'вЂњ', '&ldquo;',
	'”', 'вЂќ', '&rdquo;',
	'‹', 'вЂ№', '&lsaquo;',
	'›', 'вЂє', '&rsaquo;',
	'«', 'В«', '&laquo;',
	'»', 'В»', '&raquo;',
	'„', 'вЂћ', '&bdquo;',
	'‚', 'вЂљ', '&sbquo;',
	'·', 'В·', '&middot;',
	'…', 'вЂ¦', '&hellip;',
	'§', 'В§', '&sect;',
	'©', 'В©', '&copy;',
	'®', 'В®', '&reg;',
	'™', 'в„ў', '&trade;',
	'¦', 'В¦', '&brvbar;',
	'†', 'вЂ ', '&dagger;',
	'‡', 'вЂЎ', '&Dagger;',
	'¬', 'В¬', '&not;',
	'­', 'В­', '&shy;',
	'±', 'В±', '&plusmn;',
	'µ', 'Вµ', '&micro;',
	'‰', 'вЂ°', '&permil;',
	'°', 'В°', '&deg;',
	'€', 'в‚¬', '&euro;',
	'¤', 'В¤', '&curren;',
	'•', 'вЂў', '&bull;',
}

local function f_char2html (char)
--[[	function f(index,value)
		if (value == char) then
			html = char2html[index+3-cp]
		end
	end
	table.foreachi (char2html, f)]]
	for k, v in pairs(char2html) do
		if (value == char) then
			html = char2html[index+3-cp]
		end
	end
	return html
end

local function InsertSpecialChar(sel_value)
	local pos = editor.CurrentPos
	if editor.Lexer == SCLEX_HTML then
		sel_value = f_char2html(sel_value)
	end
	editor:InsertText(pos, sel_value)
	pos = pos + string.len(sel_value)
	editor:SetSel(pos, pos)
end

function SpecialChar()
	if editor.CodePage==0 then
		cp=1
	else
		cp=2
	end
	local user_list = ''
	local sep = ';'
	local n = #char2html
	for i = cp,n-3,3 do
		user_list = user_list..char2html[i]..sep
	end
	user_list = user_list..char2html[n-3+cp]
	editor.AutoCSeparator = string.byte(sep)
	editor:UserListShow(12,user_list:from_utf8(0))
	editor.AutoCSeparator = string.byte(' ')
end

-- Добавляем свой обработчик события OnUserListSelection
AddEventHandler("OnUserListSelection", function(tp, sel_value)
	if tp == 12 then
		InsertSpecialChar(sel_value)
	end
end)
