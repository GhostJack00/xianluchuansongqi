;v2 版本
#Requires AutoHotkey >=2.0
#SingleInstance force

TraySetIcon("pifmgr.dll",3)

; 检测修改为超级用户运行
if not (A_IsAdmin or RegExMatch(DllCall("GetCommandLine", "str"), " /restart(?!\S)"))
try A_IsCompiled?(Run '*RunAs "' A_ScriptFullPath '" /restart'):(Run '*RunAs "' A_AhkPath '" /restart "' A_ScriptFullPath '"')

SendMode "Event"
SetKeyDelay 30,30
SetMouseDelay 30
SetDefaultMouseSpeed 1

; 检测原神运行
if WinExist("ahk_exe YuanShen.exe")
	Winactivate
Else
	run "D:\Genshin Impact\launcher.exe"
	; Run '"d:\Genshin Impact Game\YuanShen.exe" "-popupwindow"'

; 确保多功能按键只能在原神游戏窗口下才能执行



; #HotIf WinActive("ahk_exe YuanShen.exe") and IfColor(1799, 1018, 0xFFE92C)
; a::d
; d::a

#HotIf WinActive("ahk_exe YuanShen.exe")

global ispick:=istalk:=false

XButton1::
{
SetTimer(pick,0)


while(GetKeyState("XButton1", "P"))
	{
		;拾取物品，无脑F 到底
		if 派蒙界面:=IfColors(&x,&y,"168, 124, 0x00CFFF,||","808, 1010, 0xFF5A5A|0x96D722")                      ;有交互F，执行快速F    1115,545
			Send("{f}"),Sleep(30),Send("{WheelDown}"),Sleep(10),TextOnTop("无脑拾取..." A_Index "次",600,0,1,500)             ;,ToolTip("拾取" A_Index "次")

		;物品太多，看见不F标志的调整方法,要求同时存在 地图中心 和血条
		else if IfColors(&x,&y,"1061~1063,532~537,0xFFE92C")
			Send("{WheelDown}"),Sleep(30),Send("{WheelUp}")

		; 对话快速过场 无脑 跳过
		else if 对话:=ifcolors(&x,&y,"1341, 404~832,0xFFCC32,||","1255,460~630,0xF1F1F1,||","685,460~630,0xF1F1F1,||","1308,440~840,0x806200|0xF1F1F1,||","959~960,1019~1056,0xFFB601|0xFFC001|0xFFBE00|0xFFBF01")
			{
			MouseGetPos(&xpos, &ypos),Send("{Space}"),MouseMove(x,y),Send("{Click}"),Sleep(500),MouseMove(xpos, ypos)  ;MouseClick("left",x,y,1)
			}

		; 强化圣遗物   《===》
		else if ifColors(&x,&y,"77,70,0xD3BC8E","1607,767,0xECE5D8","1619,768,0x3B4255")
		{
			while GetKeyState("XButton1","p")
				MouseClick("left",1700, 767),MouseClick("left",1687, 1020)
		}

		; 委托锻造   《===》
		else if IfColors(&x,&y,"73,52, 0xD3BC8E","1331,341,0xFFFFFF","1173,672,0xECE5D8","1612,672,0x3B4354")
		{
			while GetKeyState("XButton1","p")
				MouseClick("left",1613,671,6),MouseClick("left",1742,1014)
		}

		;全部收取  派遣 锻造 邮件  、尘歌壶物品  《===》
		else if ifcolors(&x,&y,"74~156,1018,0xFFCC33,||","1006,1010,0xFFCC33,||","822, 913, 0xFFCB32,||","690~720, 127, 0xE6455F")
		{
			MouseClick("left",X,Y)
		}

		;纪行领取
		else if ifcolors(&x,&y,"990~860,21,0xE6455F")
		{
			MouseClick("left",x,y)
		if ifcolors(&x,&y,"1697, 977,0x3B4255")
			MouseClick("left",x,y)
		}

		;尘歌壶 放置物品
		else if ifcolors(&x,&y,"71, 38, 0x3B4255","76, 47, 0xECE5D8")
		{
			MouseGetPos(&xpos, &ypos)
			while GetKeyState("XButton1","p")
				MouseClick("left",xpos,ypos),Sleep(50),MouseClick("left",1843, 586),Sleep(50)
		}

		;交付任务物品
		else if ifcolors(&x,&y,"280~780, 12, 0xFFC301")
		{
			; MouseGetPos(&xpos, &ypos),MouseClick("left",x,y)                                   ;选择物品栏目的叹号
			while GetKeyState("XButton1","p")
			{
			if ifcolors(&x,&y,"300,257,0xE9E5DC,||","160,257,0xE9E5DC,||")
				MouseClick("left",x,y)
			if ifcolors(&x,&y,"1026,875,0x313131,||")
				MouseClick("left",x,y),	MouseClick("left",1490, 1020)	
			}
		}
	}
	
	;有潜水，执行潜水
	if IfColor(1846, 1032,"0xFFE92C") 
		Send("{Ctrl Down}"),Sleep(50),Send("{Ctrl Up}")

	;道具Z 选择使用
	if IfColor(1823, 822, "0xB4DAEA|0xDA4A28|0x746F64|0xD2DBA4|0x5E898D|0xFCCDBB|0xAB89C7|0xC5F0FD|0xC6F1FD|0xA38355|0x70A4D5")  ;多功能Z  1823,822,0x70A4D5
		Send "z"
	
	;有T发射，执行发射
		Send("tvx") 
		
if ispick
	SetTimer(pick,50)
}

~tab::
{
global ispick:=!ispick
if ispick
	SetTimer(pick,50),TextOnTop("自主拾取:开",600,0,1,1000),SoundBeep(500,50)      ;打开拾取
else
	SetTimer(pick,0),TextOnTop("自主拾取:关",600,0,1,1000)     ;关闭拾取,SoundBeep(500,15)
}


pick()
{
if 鼠标在中心点:=IfMousepos(959,539,960,540)
	{
	while IfColors(&x1,&y1,"1062, 535, 0xFFE92C,||","1115, 544, 0x323232,||")
		{
			if ifColors(&x2,&y2,"1115, 729~364, 0x323232")  ;544=1,544-36=2   1115 544 1177 533
				send(ifcolor(x2+1190-1115,y2+526-544,0xFFFFFF)?"":"{f}"),send(y2>544?"{wheelup}":"{wheeldown}")
			else
				send("{wheeldown}"),Sleep(50),send("{wheelup}")
		}
	}
	else Sleep(3000)
}


 ; if IfColors(&x,&y,"1062, 535, 0xFFE92C,||","1146, 467~539, 0xECE5D8")


#HotIf WinActive("ahk_exe YuanShen.exe") && 鼠标在中心点:=IfMousepos(959,539,960,540)

global  Persons:=["","","","",""],person:=""



;=============================队伍人物识别====================
~` up::
{
	;不断循环等待 鼠标归位中心点===
	while !IfMousepos(959,539,960,540)
		Sleep(1000)
	; 调用ImagePut  和  RapidOcr 两个库文件，截图保存并进行ocr文字识别，正则只要汉字
	a_Clipboard:=chinatxt:=RegExReplace(ImagePutRapidOcr(1650,233,1770,575,"人物识别"),"[^一-龟\n]")  ;删除识别文字中的非中文字和非段落符号

	chinatxt:=RegExReplace(chinatxt,"\n[田由内中]\n","`n")
	
	; 创建人物列表数组 全局模式
	global  Persons:=StrSplit(chinatxt,"`n",A_Space)		                                      ;利用段落符号分割字符串转变为数组，忽略空格		

	; 显示在右上角	
	try TextOnTop(chinatxt,1800,0,3,5000)
}







;========================= 切换人物 =====================附带释放元素爆发

~1::
~2::
~3::
~4::
~5::
{
try	{
		; A_Priorkey,A_TimeSincePriorHotkey 均指向上一个热键，若为第一次热键，就会报错，所以用 try
		if(InStr("1234",SubStr(A_Priorkey,-1)) and A_TimeSincePriorHotkey<500)
			;3按键一齐发动，只有一个在游戏中响应，按顺序优先 滚键盘
			send("{q}{e}{click}")

		; 修改当前人物名称，提取人物列表数组。数字5为最后一个人。
		global person:=A_ThisHotkey~="~[1234]"?Persons[SubStr(A_ThisHotkey,-1)]:Persons[Persons.Length<5?4:(Persons.Length-1)]

		; 显示在右上角	
		TextOnTop(person,1800,0,3,3000)
		}
}

~=::send("{b}"),WaitColor("529~1391",93,0xD3BC8E),click(865,53),WaitColor("118~1273","94~889",0xCB7FDD),WaitColor(1598,1018,0x313131,-50),WaitColor(1843,47,0x3B4255,-50)



;========================= 快速切人W长E 跑图 =====================

WheelUp::
WheelDown::
{
	; 滚轮同时按Q,可以调整Z物品的  1 2 号位置
	if GetKeyState("q") or GetKeyState("e")
	{
		send("{z down}"),Sleep(500)
		while (A_PriorKey != "RButton")
		{
			if IfColors(&x,&y,"632~1356,488,0xF4D8A8")
				send("{z up}"),send(A_ThisHotkey="WheelUp"?(x>750?"1":"2"):(x<1170?"4":"3"))
		Sleep(50)
		}
	}
	;在W行走状态，可以W+wheelup  w+wheeldown ，可以切换人物，并长按E， 方便（钟离，万叶、夜兰、早柚）矿车队跑图采矿
	else if GetKeyState("w") 
		send(A_ThisHotkey="WheelUp"?"12":"34"),Sleep(150),send("{e Down}"),Sleep(850),send("{e up}")
	;什么都不按，就直接切换人物
	else
	{
		send(A_ThisHotkey="WheelUp"?"12":"34")
	;循环检查当前人物
		loop 4
		{
			if !IfColor(1859, 258+96*(A_index-1),0xFFFFFF)
				person:=Persons[A_index],TextOnTop(person,1800,0,3,3000)
		}
	}
}


;========================= 快速聊天热字串 =====================

~F2::
{
if !KeyWait("F2","T0.5")
	WaitColor(1514,1017,0x38A1E4,100),WaitColor(1010,748,0xFFCB32,100,1000)
}

~o::
{
if !KeyWait("o","T0.5")
	Sleep(800),Click(1069,59)
}


NumpadAdd::         ;+ 打开自动门
NumpadSub::         ;- 关闭自动门
; NumpadMult::        ;* 最近队友界面
NumpadDiv::         ;/ 直接退出联机模式
NumpadDot::
Numpad0::
Numpad1::
Numpad2::
Numpad3::
Numpad4::
Numpad5::
Numpad6::
Numpad7::
Numpad8::
Numpad9::
{
SetTimer(pick,0)
if A_ThisHotkey~="Mult"
	send("{o}"),Sleep(800),Click(1069,59)
else if A_ThisHotkey~="Div"
	send("{F2}"),WaitColor(1514,1017,0x38A1E4,100),WaitColor(1010,748,0xFFCB32,100,1000)
else if A_ThisHotkey~="[AaSs][du][db]"
	send("{F2}"),WaitColor(532,1015,0x3B4255),WaitColor(530, (InStr(A_ThisHotkey,"Sub")?960:910),"0x606979|0x495366" ),send("{Esc}")
else if A_ThisHotkey~="0"
	send("{Enter}"),Sleep(200),send("{Enter}"),SendText("谢谢大佬！"),Sleep(100),send("{Enter}"),send("{Esc}")
else if A_ThisHotkey~="Dot"
	send("{Enter}"),Sleep(200),send("{Enter}"),SendText("1琴无温,多多关照！"),Sleep(100),send("{Enter}"),send("{Esc}")
; else if A_ThisHotkey~="[123456789]"
	; send("{Enter}"),WaitColor(910,1003,0xEBE4D7,100),mu:=SubStr(A_ThisHotkey,-1)-1,WaitColor(374,920,0xEB5745),click(600+165*mod(mu,3),850-200*(mu//3)),send("{Esc}")

SetTimer(pick,ispick?50:0)
}



; #HotIf WinActive("ahk_exe YuanShen.exe") and 鼠标在中心点:=IfMousepos(959,539,960,540) and person="阿蕾奇诺"
; ~LButton::
; {
	; if !KeyWait("LButton","T0.3") and IfColor(1020, 1002, "0xFF837B|0xFF837A|0xFF847B|0xFF847A")
		; send("{click}"),Sleep(200),send("{click}"),Sleep(200),send("{click}")
; }



#HotIf WinActive("ahk_exe YuanShen.exe") and 鼠标在中心点:=IfMousepos(959,539,960,540) and person="纳西妲"  

~e::
{
; 正则修改 A_ThisHotkey 的 修饰键
thisHotkey := RegExReplace(A_ThisHotkey,"^(\w* & |\W*)")
; 获取鼠标当前位置(959,539）====（960,540) 4个点中，判断出左右，上下的旋转随机数
MouseGetPos(&X,&Y),LR:=x=960?-1:1,UD:=y=540?-1:1

while GetKeyState(thisHotkey, "P")
	{
	if iscolordev(770,363,0XF0F0F0,16)          ;相机左上角的颜色，RGB 差值在+-16以内
		{
		; ImagePutRapidOcr(770-100,363-100,770+100,363+100,"纳西妲E技能识别点x=770y=363color=0XF0F0F0偏差=16")
		; 一个转圈为什么搞得这么复杂：	; 1.把周身一圈，分成16段，也就是
		Loop 16
			DllCall("mouse_event", "UInt", 1,"UInt",Ceil(LR*308),"UInt",Ceil(5*308*(A_index=1?0.5:A_index=16?-0.5:mod(A_index,2)=1?1:-1))),Sleep(25)
		break
		}
	Sleep(50)
	}
}


#HotIf WinActive("ahk_exe YuanShen.exe") and 鼠标在中心点:=IfMousepos(959,539,960,540) and person="那维莱特"
e::
{
send("{e down}")
; 等待0.2秒，判断E键是否释放，若没有，就执行
if !KeyWait("e","T0.3")
	send("{click down}"),Sleep(500),send("{click up}"),MouseGetPos(&X,&Y),LR:=x=960?-1:1,UD:=y=540?-1:1,ST:=A_TickCount

; 再次等待0.2秒，判断E键是否释放，若没有，就执行
if !KeyWait("e","T0.3")
	while (A_PriorKey!="RButton") and (A_TickCount-ST<3000)
		loop 16
			DllCall("mouse_event", "UInt", 1,"UInt",Ceil(LR*308),"UInt",Ceil(5*308*(A_index=1?0.5:A_index=16?-0.5:mod(A_index,2)=1?1:-1))),Sleep(20)
send("{e up}")
}


~q::
{
if !KeyWait("q","T0.3")
	send("{click down}"),Sleep(500),send("{click up}") 
}



#HotIf WinActive("ahk_exe YuanShen.exe") and 鼠标在中心点:=IfMousepos(959,539,960,540) and (person="钟离" or person="久岐忍")
~LButton::
{
if !KeyWait("LButton","T0.2")
	send("{e Down}"),Sleep(850),send("{e up}")
}
e::send("{e Down}"),Sleep(850),send("{e up}")


#HotIf WinActive("ahk_exe YuanShen.exe")  and 鼠标在中心点:=IfMousepos(959,539,960,540) and person="芙宁娜"
~LButton::
{
if !KeyWait("LButton","T0.8")
	send("{e}")
}

~e::
{
if !KeyWait("e","T0.4") 
	click("Down"),Sleep(850),click("up")
}

;===============================传送============

#HotIf WinActive("ahk_exe YuanShen.exe")

XButton2 Up::
{
	SetTimer(pick,0)
	startTime := A_TickCount
	
	send("m")

	;转换地图，传送点编号向后 移动一位
try MapGoto:=IniRead(filenames[FNU],SectionNames[SNU],"MapGoto",-1)
global SNU:=MapGoto>0?MapGoto:SNU-MapGoto
	
	
	;如果超出了文件中的 Section，就写入一个新的
	if SNU>readsection(FNU)
	{
		appfilename:=RTrim(LTrim(filenames[FNU] , A_ScriptDir "\线路\"),".ini")
		appSection:="[" SubStr(appfilename,InStr(appfilename,".")+1) SNU "]`n"
		FileAppend appSection,filenames[FNU]
		readsection(FNU)
	}

	callgui()
	
	; 读取下一个点的预设参数信息
try	
	{
		MapName:=IniRead(filenames[FNU],SectionNames[SNU],"MapName","")
		MapNumber:=IniRead(filenames[FNU],SectionNames[SNU],"MapNumber",0)
		MapZoom:=IniRead(filenames[FNU],SectionNames[SNU],"MapZoom",573)
		MapDragS:=IniRead(filenames[FNU],SectionNames[SNU],"MapDragS","")
		MapClickS:=IniRead(filenames[FNU],SectionNames[SNU],"MapClickS","")
		MapModen:=IniRead(filenames[FNU],SectionNames[SNU],"MapModen",1)
		MainZprop:=IniRead(filenames[FNU],SectionNames[SNU],"MainZprop","")
		Mainaction:=IniRead(filenames[FNU],SectionNames[SNU],"Mainaction","")
	}



	;若城市编号非零，就执行城市转换

	if MapNumber {
		while (A_PriorKey != "RButton")  {                       ; 在设定的超时时间内循环
			if IfColors(&map_x,&map_y,"1842, 1034, 0xECE5D8,||","1317,700~100,0xF39000,||","1615,700~100,0xF39000")    ;查找1 点   和 2 线x=1317.x=1615
			{
				
				; map_hang:=(map_y-110)//103                             ;=====>        行号
				; map_lie:=map_x=1317?1:map_x=1615?2:0                   ;=====>        列号
				; map_dangqian:=(map_hang-1)*2+map_lie                   ;=====>        当前地图编号
				
				if (map_y=1034)                                        ;============>右侧底下点开城市选项卡
					MouseClick("left",map_x,map_y)
				; else if (map_dangqian=MapNumber) and IfColor(map_x+6,map_y,0xECE5D8)
					; MouseClick("left",map_lie=1?1615:1317,map_hang=3?200:200+(MapNumber-1)//2*103)
				else
				{
					MouseClick("left",1700-Mod(Abs(MapNumber),2)*300,200+(MapNumber-1)//2*103),Sleep(250)	
					break
				}
			}
		TextOnTop("等待地图选择" A_Index "......" A_TickCount-startTime "ms" ,1000,A_Index*10,8,1000,"0xFF8000")	
		Sleep(50)	
		}
	}


	;若地图放缩坐标非零，就执行地图放缩
	if MapZoom {
		while (A_PriorKey != "RButton") 
		{   
		if IfColors(&Zoom_x,&zoom_y,"1842,1034,0xECE5D8","59,640~440,0xEDE5DA")               ;检测地图放缩比例 59 1线  进行调整
			{ 
				if Abs(zoom_y-MapZoom)>6                                                           ;6 大距离，用滚轮调整
				{
					Loop abs(Floor((MapZoom-zoom_y)/6))
						MouseMove(940,560),send(MapZoom<zoom_y?"{WheelUp}":"{WheelDown}"),Sleep(10)
				}else if Abs(zoom_y-MapZoom)>2                                                     ;2 小距离，用鼠标调整
					MouseGetPos(&xpos, &ypos),MouseClick("left",Zoom_x-10,zoom_y,,,"Down"),MouseMove(Zoom_x-10,MapZoom,3),MouseClick("left",Zoom_x-10,MapZoom,,,"UP"),MouseMove(xpos,ypos)
				else																																								;没有达到小距离，跳出
					break	            ;复查无误，才退出
			}
		TextOnTop("等待地图放缩显示" A_Index "......" A_TickCount-startTime "ms" ,1000,A_Index*10,8,1000,"0x0080FF")		;"0x0080FF"
		Sleep(50)	
		}
	}

;大距离拖动地图，需要放慢鼠标速度
	if MapDragS!=""
	{
		Loop parse, MapDragS, "`|"
		{
			Drag:= StrSplit(A_LoopField,",")
			x1:=Trim(Drag[1]),y1:=Trim(Drag[2])
			x2:=Trim(Drag[3]),y2:=Trim(Drag[4])
			r:=20
			xr:=Round(r*(x2-x1)/Sqrt((x2-x1)**2+(y2-y1)**2))+x1
			yr:=Round(r*(y2-y1)/Sqrt((x2-x1)**2+(y2-y1)**2))+y1

			MouseClick("left",x1,y1,,2,"Down")
			MouseMove(xr,yr,10)
			MouseMove(x2,y2)
			Sleep(200)
			MouseClick("left",x2,y2,,10)
		}
	}

	;按照记录的鼠标点击位置，执行点击，可执行多点
	if MapClickS!=""
	{
		Loop parse, MapClickS, "`|"
		{
			coord:= StrSplit(A_LoopField,","),x1:=Trim(coord[1]),y1:=Trim(coord[2])
			x2:=coord.Length=4?Trim(coord[3]):X1,y2:=coord.Length=4?Trim(coord[4]):y1
			MouseClick("left",X1,Y1,,2,"Down"),MouseMove(X2,Y2,5),MouseClick("left",X2,Y2,,2,"UP")
		}
	}


	;鼠标传送点类型 选择 默认为1，锚点
	ColorIds:={1:"0x2D91D9|0x2CBCDD",2:"0x99ECF5",3:"0x00FFFF",0:"0xFFFFFF"}
	xButton2Pressed := false,ThisHotKeyClick:="",ThisHotKeyDrag:=""
	while (A_PriorKey != "RButton") 
	{  
		if IfColors(&Moden_x,&Moden_y,"1472, 1012, 0xFFCD33||0xFFCC33,||", "1298,650~950," ColorIds.%MapModen%) {                       ;确定传送点坐标  和颜色

				if (MapName="" and Moden_y=1012)
				{
					;OCR 识别图片文字，并保存图片备查
					a_Clipboard:=nametext:=ImagePutRapidOcr(1480,15,1790,135,"锚点七天秘境")
					MapModen:=InStr(nametext,"七天")?2:instr(nametext,"锚点")?1:3
					; 非锚点类型，写入ini
					if MapModen!=1
						IniWrite(MapModen,filenames[FNU],SectionNames[SNU],"MapModen")
					;名字整理写入 ini
					MapName:=StrReplace(Trim(nametext,"传送锚点七天神像- 蒙德璃月稻妻须弥枫丹`t"),"`n")
					IniWrite(MapName,filenames[FNU],SectionNames[SNU],"MapName")
					callgui()
				}
				Sleep(150),mouseClick("left",Moden_x,Moden_y),Sleep(150)
				if (Moden_y=1012)                               ;如果是右下角的确定传送点，就可以跳出循环
					break
			}	
			
			else if (GetKeyState("XButton2", "P")) and InStr("0xEDE5DA",PixelGetColor(48, 428))
			{
				if (!xButton2Pressed) 
					MouseGetPos(&pressX, &pressY),Click("Down")
				xButton2Pressed := true
			}	else 
			{
				if (xButton2Pressed)
				{
					MouseGetPos(&releaseX, &releaseY),Click("up")
					if IfColors(&Px, &Py, "59, 451~627, 0xEDE5DA")                  ;检测地图放缩比例  进行调整   573
						MapZoom:=PY
					if Round(Sqrt((releaseX-pressX)**2+(releaseY-pressY)**2))<10
						ThisHotKeyClick:=pressX "," pressY
					else
						ThisHotKeyDrag:=ThisHotKeyDrag "|" pressX "," pressY "," releaseX "," releaseY
				}
				xButton2Pressed := false
			}	
		TextOnTop("等待地图确认" A_Index "......" A_TickCount-startTime "ms" ,1000,A_Index*10,8,1000,"0x000000"),Sleep(50)
	}

	;###############    写入文件记录     ###############
	
	if abs(MapZoom-573)>2
		IniWrite MapZoom, filenames[FNU],SectionNames[SNU],"MapZoom"
	if ThisHotKeyClick!=""
		IniWrite ThisHotKeyClick, filenames[FNU],SectionNames[SNU],"MapClickS"
	if ThisHotKeyDrag!=""
		IniWrite LTrim(ThisHotKeyDrag,"|"), filenames[FNU],SectionNames[SNU],"MapDragS"


	

	
	
try if MainZprop!=""  
	{
		while (A_PriorKey != "RButton") 
		{
			if IfMousepos(959,539,960,540)
			{
				Loop parse, MainZprop, "`|"
				{
					if A_LoopField = ""
						send("{z}")
					else
					{
						zprop:=Trim(A_LoopField)
						zcolors:={1:"0x6F3610",2:"0xE2FFFF",3:"0xA38355|0xF6F3EE",4:"0xF68742"}  ;取点 （1823，822） 
						if !InStr(zcolors.%zprop%,PixelGetColor(1823,822))
						{
							send("{z down}"),Sleep(500)
							while(A_PriorKey != "RButton")
							{
								if IfColor(430+210*zprop,600,"0xFFFFFF")
								{
									MouseClick("left", 430+210*zprop,600),send("{z Up}"),Sleep(50)
									break
								}
								Sleep(50)
							}
						}
					} 
				}
				break
			}
		TextOnTop("等待派蒙界面" A_Index "......" A_TickCount-startTime "ms",1000,A_Index*10,8,1000,"0x8080FF")
		Sleep(50)
		}
	}


try if Mainaction!=""  
	{
		while (A_PriorKey != "RButton") 
		{
			;MouseGetPos &xpos, &ypos 
			;if 派蒙界面:=IfColors(&x,&y,"168, 124, 0x00CFFF,||","808, 1010, 0x96D722|0xFF5A5A") && xpos=
			if IfMousepos(959,539,960,540)
			{
				Loop parse, Mainaction, "`|"
				{
					if A_LoopField =""
						send("{W down}")
					else
					{
						keycoord:= StrSplit(A_LoopField,",")
						keyname:=Trim(keycoord[1])
						keytime:=Trim(keycoord.Length>1?keycoord[2]:0)
						keymode:=Trim(keycoord.Length>2?keycoord[3]:0)
						if keyname=""
						{
							if keytime
								DllCall("mouse_event", "UInt", 1,"UInt",Ceil(0+keytime*308),"UInt",0),Sleep(Abs(keytime)*50)	
							if keymode
								DllCall("mouse_event", "UInt", 1,"UInt",0,"UInt",Ceil(0+keymode*616)),Sleep(Abs(keymode)*50)
						}	
						else if keyname="z"
						{
							zcolors:={1:"0x6F3610",2:"0xE2FFFF",3:"0xA38355|0xF6F3EE",4:"0xF68742"}  ;取点 （1823，822） 
							if keytime and !InStr(zcolors.%keytime%,PixelGetColor(1823,822))
							{
								send("{z down}"),Sleep(500)
								while(A_PriorKey != "RButton")
								{
									if IfColor(430+210*keytime,600,"0xFFFFFF")
									{
										; MouseClick("left", 430+210*keytime,600),send("{z Up}")  ;试试下面不用鼠标点击 用键盘控制
										send(keytime),send("{z Up}")
										if keymode
											Sleep(50),send("{z}")
										break
									}
									Sleep(50)
								}
							} else if keytime+keymode=0 or keymode=1
							send("{z}")
						}
						else 
						{
							Loop Abs(keymode)>1?Abs(keymode):1
								send("{" keyname (keymode=1?" down}":keymode=-1?" up}":"}")),Sleep(Abs(keytime)*100)
						}
					}
				}
				break
			}
		TextOnTop("等待派蒙界面" A_Index "......" A_TickCount-startTime "ms",1000,A_Index*10,8,1000,"0x8080FF")
		Sleep(500)	
		}
	}
	
try	SetTimer(pick,ispick?0:50)
}
	








global FNU:=8,SNU:=1,onoff:=true
;读取文件夹里的ini文件，

readfiles()
readsection(FNU)
try Gui2.Destroy()

>^Home::RUN A_ScriptDir "\线路\"
Home:: RUN filenames[FNU]
Up::
end::
Down::
Left::
PgUp::
PgDn::
Right::
{

FNUMax:=readfiles()
global FNU:=A_ThisHotkey="PgUp"?max(1,FNU-1):A_ThisHotkey="PgDn"?min(FNUMax,FNU+1):A_ThisHotkey="end"?8:FNU

SNUMax:=readsection(FNU)
global SNU:=A_ThisHotkey="Up"?max(1,SNU-10):A_ThisHotkey="down"?min(SNUMax,SNU+10):A_ThisHotkey="end"?1:SNU
global SNU:=A_ThisHotkey="Left"?max(1,SNU-1):A_ThisHotkey="Right"?min(SNUMax,SNU+1):A_ThisHotkey="end"?1:SNU

callgui()
}


; 开/关，用于显示或隐藏 gui 的
del:: 
{
global	onoff:=!onoff
try if onoff
		Gui2.Show("x0 y220 NoActivate")
	else
		Gui2.hide()
}



;读取文件夹内的文件，创建成一个数组
readfiles()
{
global	filenames:=[]
	Loop Files, A_ScriptDir "\线路\*.ini"  
		filenames.Push A_LoopFilePath
return filenames.Length
}

;按照文件数组中第 fnu 个文件 中，读取段落，创建一个段数组
readsection(FNU)
{
global SectionNames:=[]
	SectionNames:=StrSplit(IniRead(filenames[FNU]),"`n")
return SectionNames.Length
}





callgui()
{
;声明全局变量，这里非常重要
global

; 检查窗口存在，就gui.Destroy() ，避免文字重叠
if WinExist("my_Lay")
	try Gui2.Destroy() 
;重新创建一个gui
	Gui2:= Gui("+AlwaysOnTop -Caption +ToolWindow","my_Lay")
	Gui2.BackColor := "000000"                
	Gui2.SetFont("s12 cFF0000") 
	WinSetTransColor(Gui2.BackColor " 150",Gui2)
try
	{
		; 当前文件名称
		appfilename:=RTrim(LTrim(filenames[FNU] , A_ScriptDir "\线路\"),".ini")
		
		; 累加记录线路统计数
		DataNumber:=IniRead(filenames[FNU], SectionNames[SNU], "DataNumber",1)
		DataNumbers:=SNU=1?0:(DataNumbers+DataNumber) 
		
		; 记录线路使用时间，初始值为当前时刻
		StartUsetime:=(FNU=1 or SNU =1)?A_TickCount:StartUsetime
		Usetime:=(FNU=1 or SNU =1)?(A_Hour ":" A_Min ":" A_Sec):(Floor((A_TickCount-StartUsetime)/60000) ":" Floor(mod((A_TickCount-StartUsetime)/1000,60)))
			
		; 创建addtext,显示
		Gui2.Add("Text","xM cff80FF",appfilename " ("  DataNumber    "/" DataNumbers     ") < " Usetime " > <" (ispick?"开>":"关>")) 
	}
	
;循环5次，用于创建5个addtext
try loop 5
	{
		; 低于1的段落没有,所以不能创建
		IF (SNU+A_Index-3<1)
			continue
		text2:=SNU+A_Index-3 ".[" SectionNames[SNU+A_Index-3] "]=>" IniRead(filenames[FNU],SectionNames[SNU+A_Index-3],"MapName","")
		
		; 第3个addtext为当前段落,改换不同颜色显示
		Color:=A_index=3?"FF0000":"80FF80"
		
		; 创建addtext
		Gui2.Add("Text","xs c" Color,text2) 
	}
	try if onoff
		Gui2.Show("x0 y220 NoActivate")
}



>!XButton1::
{
	send("{z down}"),Sleep(500)
	Hotkey:=RegExReplace(A_ThisHotkey,"^(\w* & |\W*)")
	zwhich:=zdown:=x:=y:=0
	While(GetKeyState(Hotkey,"P"))
	{
		MouseGetPos &xp, &yp
		if (x!=xp or y!=yp)
			{
				loop 4
				if Abs(434+210*A_Index-xp)<80
					zwhich:=A_Index,zdown:=yp>540?1:0
				ToolTip "x=" xp "y=" yp "`n记录：Z," zwhich "," zdown	
			}
		x:=xp,y:=yp	
	}
	send("{z up}"),send("{z}"),ToolTip()

if zwhich+zdown
	{
		Mainaction:=IniRead(filenames[FNU],SectionNames[SNU],"Mainaction","")
		Mainaction:=RegExReplace(Mainaction, "z.*\|")
		Mainaction:="z," zwhich (zdown?",1":"") "|" Mainaction
		IniWrite Mainaction,filenames[FNU],SectionNames[SNU],"Mainaction"
		SoundBeep 523,150
	}
}


<!XButton1::
{
	SetTimer(pick,0)
	pToken:=Gdip_Startup()
  Gui("-Caption +E0x80000 +LastFound +AlwaysOnTop +ToolWindow +OwnDialogs","mygui").Show("NoActivate")
  Width := A_ScreenWidth, Height := A_ScreenHeight
  hbm := CreateDIBSection(Width, Height)
  hdc := CreateCompatibleDC()
  obm := SelectObject(hdc, hbm)
  G := Gdip_GraphicsFromHDC(hdc)
  Gdip_SetSmoothingMode(G, 4)

  pBrushWhite := Gdip_BrushCreateSolid(0x80000080)
  Gdip_FillEllipse(G, pBrushWhite, 960-480, 540-270, 960, 540)
  Gdip_DeleteBrush(pBrushWhite)
  
  pBrushblack := Gdip_BrushCreateSolid(0x80008080)
  Gdip_FillEllipse(G, pBrushblack, 960-320, 540-180, 640, 360)
  Gdip_DeleteBrush(pBrushblack)
  
  UpdateLayeredWindow(WinExist("mygui"), hdc, 0, 0, Width, Height)
  
	Hotkey:=RegExReplace(A_ThisHotkey,"^(\w* & |\W*)")
	ta:=qa:=x:=y:=0
	While(GetKeyState(Hotkey,"P"))
	{
		MouseGetPos &xp, &yp
    try if(x!=xp or y!=yp)
				{
					Xa:=xp-A_ScreenWidth/2+0.1   ;偏移0.1像素，不影响计算结果，但可以避免斜率除数为0的报错问题
					Ya:=A_ScreenHeight/2-yp+0.1  ;偏移0.1像素，不影响计算结果，但可以避免斜率除数为0的报错问题
					an:=Round(ATan(Xa/Ya)*57.3)
					gg:=(Xa>0 and Ya<0)?(an+180):(Xa<0 and Ya<0)?(an-180):an ;坐标轴4个象限的角度归正===>> 按照钟表角度，顺为正，逆时针为负
					ta:=format("{:g}",Round(gg/30,1))                                 ;转化为保留1位小数的时钟
					pl := Round(Sqrt(Xa**2+Ya**2))                           ;鼠标到中点距离
					cl:=xp=960?270:yp=540?480:Round(Sqrt(1/((2/960)**2+(2*(540-yp)/(540*(xp-960)))**2)+1/((2/540)**2+(2*(xp-960)/(960*(540-yp)))**2)))
					qa:=format("{:g}",Round((cl-pl)*6/cl,1))
				
					ToolTip "正前方为0点，逆时针为负，顺时针为正`n当前点：px=" xp "  py=" yp "  PL=" pl "`n中心点：cx=" Round(A_ScreenWidth/2) "   cp=" Round(A_ScreenHeight/2) "  CL= " cl "`n角  度：" gg "度`n时  刻：" ta "时    俯仰度：" qa "时`n 标记为： @," ta "," qa "|" 
					pPen := Gdip_CreatePen(0xFFFF00ff, 1)
					Gdip_DrawLine(G, pPen, 960, 540,xp,yp)
					Gdip_DeletePen(pPen)
					UpdateLayeredWindow(WinExist("mygui"), hdc, 0, 0, Width, Height)
				}
		x:=xp,y:=yp
	}
  Gdip_GraphicsClear(G)
  UpdateLayeredWindow(WinExist("mygui"), hdc, 0, 0, Width, Height)
  Gdip_DeleteGraphics(G),SelectObject(hdc, obm),DeleteDC(hdc),DeleteObject(hbm)
  Gdip_Shutdown(pToken)
	send("{ctrl}"),ToolTip()
	
	;###############    写入文件记录     ###############
	if abs(ta)>0.5 or Abs(qa)>0.5          
	{
		Mainaction:=IniRead(filenames[FNU],SectionNames[SNU],"Mainaction","")
		Mainaction:=RegExReplace(RegExReplace(Mainaction, "^,.+?\d\|"), "^,.+?\|") 
		Mainaction:="," (abs(ta)>0.5?ta:"") (Abs(qa)>0.5?"," qa:"") "|" Mainaction
		IniWrite Mainaction,filenames[FNU],SectionNames[SNU],"Mainaction"
		SoundBeep 523,150
	}
	SetTimer(pick,ispick?50:0)
}






#HotIf WinActive("ahk_exe YuanShen.exe") ;&& 鼠标不在中心点:=!IfMousepos(959,539,960,540)


;右键快速退回到主界面。。
~RButton Up::
{ 
if !IfMousepos(959,539,960,540)	{
	Send "{esc}"
	if IfColors(&x,&y,"1796, 45, 0xFFFFFF,||","1841, 48,0x3B4255|0xFFFFFF|0xA18F6C|0xA08F6C|0xECE5D8|0xA69572|0xA0906D,||","1876, 35, 0xECE5D8,||","1671, 235, 0xD0B8AC,||","1842, 156, 0x3A4154|0x3B4255,||","44, 44, 0x3B4255,||","60, 48, 0xECE5D8,||","1307, 816, 0xF1F1F1")
		MouseGetPos(&xpos, &ypos),MouseClick("left",x,y,1),Send("{Space}"),MouseMove(xpos, ypos)
	}
	else if IfColor(1736,1038,0x323232)
		send "{x}"
}


#HotIf WinActive("QQ频道")
XButton1::
{
A_Clipboard:= "" ; 清空剪贴板
SendInput "^c"
if !ClipWait(0.2)
{
	CoordMode "Mouse"
	MouseGetPos &x,&y
	MyArray:=[x-100,y-50,400,100]
	Imagefile:= A_ScriptDir "\图片\频道ID.png"
	A_Clipboard:=RapidOcr().ocr_from_file(ImagePutFile(MyArray,Imagefile))
}

txt_Clipboard:=A_Clipboard
try RegExMatch(txt_Clipboard,".*[123]\d{8}[,\s，]*(\D).*",&gamemode)
try RegExMatch(txt_Clipboard,".*([123]\d{8}).*",&GameID)
try A_Clipboard:=GameID[1]

for index, element in filenames
{
	try If InStr(element,gamemode[1]) {
			global FNU:=A_Index
			global SNU:=2
			break	
		}
}


WinActivate "原神"
	readsection(FNU)
	callgui()


if WinWaitActive("原神", , 2)
	{
	send("{F2}")
	WaitColor(1466,111,"0xFF5C5C|0xFFFFFF")
	WaitColor(1671,118,0x3B4255)
	WaitColor(1580,365,0x3B4255,,,0)
	WaitColor(1580,240,0x3B4255)
	} 
	else
		MsgBox "等待窗口2秒激活超时."
}





#HotIf WinActive("ahk_exe SciTE.exe")
~^s Up::Reload


#HotIf
~PrintScreen::
{
if !WinExist("AHK抓抓工具 v2.5 - By FeiYue")
	run A_ScriptDir "\lib\AHK抓抓工具—作者：飞跃.ahk"
}


<^F12::exitApp
<^F11::Edit
<^F10::PAUSE
<^F9::Reload


#Include "lib\自用函数库.ahk"

