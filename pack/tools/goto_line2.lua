--[[--------------------------------------------------
goto_line2.lua
Author: Charsi
version: 1.01
------------------------------------------------------
При переходе на линию, текущее положение курсора на экране сохраняется
для чего текст прокручивается на нужное количество строк.

  Connection:
   In file SciTEStartup.lua add a line:
      dofile (props["SciteDefaultHome"].."\\tools\\goto_line2.lua")
--]]--------------------------------------------------

local shift = 0
function WaitGotoLine(id_msg, wp, lp) --print("OnSendEditor", id_msg, wp, lp)
	if id_msg == SCI_GOTOLINE then
		local CurrentLine = editor:LineFromPosition(editor.CurrentPos)
		local FirstVisLine = editor.FirstVisibleLine
		local LOS = editor.LinesOnScreen
		while CurrentLine < FirstVisLine do
			CurrentLine = CurrentLine + LOS
		end
		while CurrentLine > FirstVisLine + LOS do
			CurrentLine = CurrentLine - LOS
		end
		shift = wp - CurrentLine + FirstVisLine
		event("OnUpdateUI"):register(WaitUpdateUI)
		event("OnSendEditor"):removeThisCallback()
	end
end

function WaitUpdateUI(e)
	shift = shift - editor.FirstVisibleLine
	if shift~=0 then
		editor:LineScroll(0, shift)
	end
	AddEventHandler("OnSendEditor", WaitGotoLine)
	e:removeThisCallback()
end

AddEventHandler("OnSendEditor", WaitGotoLine)
