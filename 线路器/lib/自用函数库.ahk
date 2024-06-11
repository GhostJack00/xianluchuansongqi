/*
;v2 版本
#Requires AutoHotkey >=2.0
自用函数


*/
iscolordev(x1,y1,color2,devR:=0,devG:=devR,devB:=devR)
{
    CoordMode "Pixel","Screen"             ; 全屏识别找坐标色
		Color1:= PixelGetColor(X1, Y1)
    r1 := Format("{:d}","0x" SubStr(color1, -6, 2))
    g1 := Format("{:d}","0x" SubStr(color1, -4, 2))
    b1 := Format("{:d}","0x" SubStr(color1, -2, 2))
		
    color2:=format("0X{:x}",color2)
    r2 := Format("{:d}","0x" SubStr(color2, -6, 2))
    g2 := Format("{:d}","0x" SubStr(color2, -4, 2))
    b2 := Format("{:d}","0x" SubStr(color2, -2, 2))
    return (abs(r1-r2)<=devR and Abs(g1-g2)<=devG and Abs(b1-b2)<=devB)
}





WaitClick(x,y,Color,Sleeptime:=50,outtime:=0,show:=1)
{
CoordMode "Pixel", "Screen"
if IsInteger(color)
	Color:=format("0X{:x}",Color)
out:=A_TickCount+outtime
while (A_PriorKey != "RButton") and (outtime=0?"ture":(A_TickCount<out))  {
	
	if Show and InStr(Color,PixelGetColor(x, y)) {
		Click(x,y)
		break
		}
	if !Show and !InStr(Color,PixelGetColor(x, y)) {
		Click(x,y)
		break
		}
	Sleep(Sleeptime)
	}
}





WaitColor(x:="~",y:="~",Color:="0XFFFFFF",Sleeptime:=50,outtime:=0,show:=1) {
/*------------------------------------------------		
; 等待屏幕坐标点的颜色出现或消失的就执行鼠标点击
参数：
x  		  => 坐标点X,也可以是X的范围,如:"100~200",还可以是缺省值~  0~A_ScreenWidth
y   		=> 坐标点Y,同X用法,
Color		=> 要查找的颜色，可以是多色，如:"0xFF0000|0xFFFFFF"
sleeptime => 找色循环的时间间隔，类似于SetTimer的间隔参数，大于0时为间隔，等于0时为运行1次0ms退出，小于0时为运行1次后延时负值ms退出
outtime		=> 循环找色的延时时间，类似 KeyWait 函数的T 参数，0为无限循环，正数为ms后退出循环
show    	=> 这是一个用于反转找色参数，等于1时，为循环等待颜色出现，点击鼠标退出；等于0时，为循环等待颜色消失，没有点击动作退出


; 示例用法	
		; 判断单个坐标点
		; WaitColor(100, 200, 0xFF0000) ; 等待坐标点(100, 200)的颜色为红色,点击该点
    ; WaitColor(100, 200, "0xFF0000|0xFFFFFF") ; 等待坐标点(100, 200) 的颜色为红色或白色,点击该点

返回:0,假     1，真
*/ ;--------------------------------------------	


out:=A_TickCount+outtime,find:=0
if IsInteger(color)
	Color:=format("0X{:x}",Color)

while (A_PriorKey != "RButton") and (outtime=0?"ture":(A_TickCount<out))  
	{
		if RegExMatch(x . y, "([~_&<>\.\|])")
		{
			x1:=RegExMatch(x, "(^\d+)", &xr)?xr[1]:x~=">"?A_ScreenWidth:0
			x2:=RegExMatch(x, "(\d+$)", &xr)?xr[1]:x~=">"?0:A_ScreenWidth
			y1:=RegExMatch(y, "(^\d+)", &yr)?yr[1]:y~=">"?A_ScreenHeight:0
			y2:=RegExMatch(y, "(\d+$)", &yr)?yr[1]:y~=">"?0:A_ScreenHeight
			Loop Parse, Color, "-~|&_."
			{
				find:=PixelSearch(&Cx, &Cy, x1, y1, x2, y2,A_LoopField)	
				if show and find
				{
					Click(Cx,Cy)
					return {x:cx,y:cy}
				}
				if !show and !find
					return 0
			}
		}	else {
		find:=InStr(Color,PixelGetColor(x,y)),Cx:=x,Cy:=y	
		if show and find
		{
			Click(Cx,Cy)
			return {x:cx,y:cy}
		}
		if !show and !find
			return 0
		}
	Sleep(Abs(Sleeptime))
	if Sleeptime<=0
		return 0
	}
}

















GetColor(x,y)    ;函数调用
{
    CoordMode "Pixel","Screen"             ; 全屏识别找坐标色
    return PixelGetColor(x,y)    ;获取X和Y坐标的颜色值 作为返回值
}




IfColor(x, y, Color) {
/*------------------------------------------------		
; 判断一个屏幕坐标点的颜色是否正确	
; 示例用法	
		; 判断单个坐标点
		; singleResult := IfColor(100, 200, 0xFF0000) ; 100, 200 坐标点的颜色是否为红色
    ; singleResult := IfColor(100, 200, "0xFF0000,0xFFFFFF") ; 100, 200 坐标点的颜色是否为红色或白色
    ; MsgBox, % singleResult ? "颜色正确" : "颜色错误"
返回:0,假     大于零的整数，真
*/ ;--------------------------------------------	
	if IsInteger(color)
		Color:=format("0X{:x}",Color)
	CoordMode "Pixel", "Screen"
	return InStr(Color,PixelGetColor(x, y))
}


IfMousepos(x1:=0,y1:=0,x2:=A_ScreenWidth,y2:=A_ScreenHeight)
{
	MouseGetPos &x,&y
	; x1:=x1=""?0:x1
	; y1:=y1=""?0:y1
	; x2:=x2=""?A_ScreenWidth:x2
	; y2:=y2=""?A_ScreenHeight:y2
	return x>=x1 and x<=x2 and y>=y1 and y<=y2
}



IfColors(&X, &Y , Params*) {
/*--------------------------------------------------------------	
判断颜色 1.2
作者: Ghost_jack
(功能灵活，可多点，可单点，可多色，可单色）
返回值: 0-false  1-true 
示例用法  1.0版本 （PixelGetColor 第四参数 多点）


		
		1、IfColors(&X, &Y ,"100,200,0xFFFFFF")
		 => pc:=PixelGetColor(100,200)
		 => InStr(0xFFFFFF,pc)
			
			单点判断单颜色真假
		2、IfColors(&X, &Y ,"100,200,0xFFFFFF|0x00000")
			=> pc:=PixelGetColor(100,200)
			=> InStr(0xFFFFFF|0x00000,pc)
			单点判断多颜色真假,颜色分隔符不能是逗号
			
		3、IfColors(&X, &Y ,"100,200,0xFFFFFF","300,400,0x000000")
			多点判断多颜色同时成立的真假,多点用引号分开
			
		4、IfColors(&X, &Y ,"100,200,0xFFFFFF,or","300,400,0x000000")
			多点判断多颜色任一成立的真假,  第4参数为or ||,默认不设置为 and
		
		5、IfColors(&X, &Y ,"100,200,0xFFFFFF|0x000000,||","300,400,0x000000","500,600,0x888888")
			a => IfColors(&X, &Y ,"100,200,0xFFFFFF|0x000000")
			b => IfColors(&X, &Y ,"300,400,0x000000")
			c => IfColors(&X, &Y ,"500,600,0x888888")
		复杂逻辑的组合:解释从左往右,  （a or b）and c
		
/*------------------------------------------------------------	
示例用法  1.1版本 （PixelSearch 多色）
		兼容1.0,区分为 坐标数字，区分为是否存在 ~|-_ 分隔符
		
		1、IfColors(&X, &Y ,"100~200,300,0xFFFFFF")
			=>   PixelSearch(&X, &Y, 100, 300, 200, 300, 0xFFFFFF, 0 )
			范围判断单颜色真假
			
		2、IfColors(&X, &Y ,"100,300~200,0xFFFFFF|0x000000")
			a=>  PixelSearch(&X, &Y, 100, 300, 100, 200, 0xFFFFFF, 0 )
			b=>  PixelSearch(&X, &Y, 100, 300, 100, 200, 0x000000, 0 )
			  a or b
			判断范围，是否存在多颜色中的任意一个颜色 ,颜色分隔符不能是逗号
			
		3、IfColors(&X, &Y ,"100~200,300~400,0xFFFFFF","300,400,0x000000")
			a=> PixelSearch(&X, &Y, 100, 300, 200, 400, 0xFFFFFF, 0 )
			b=> IfColors(&X, &Y ,"300,400,0x000000")
				a and b
			范围判断+ 单点判断,同时成立
			
		4、IfColors(&X, &Y ,"100~200,300~400,0xFFFFFF,or","300,400,0x000000")
			a=> PixelSearch(&X, &Y, 100, 300, 200, 400, 0xFFFFFF, 0 )
			b=> IfColors(&X, &Y ,"300,400,0x000000")
				a or b
			范围判断 + 单点判断，任一成立    （第4参数为or ||,默认不设置为 and）
		
		5、IfColors(&X, &Y ,"100~200,200,0xFFFFFF|0x000000,||","300,400,0x000000","500~600,700,0x888888")
		
			a=> PixelSearch(&X, &Y, 100, 200, 100, 300, 0xFFFFFF, 0 )
					PixelSearch(&X, &Y, 100, 200, 100, 300, 0x000000, 0 )
			b=> IfColors(&X, &Y ,"300,400,0x000000")
			c=> PixelSearch(&X, &Y, 500, 700, 600, 700, 0xFFFFFF, 0 )

		复杂的组合:解释从左往右,  （a or b）and c

/*--------------------------------------------------------------
示例用法  1.3版本 （坐标缺省值设置，可反转）

		兼容1.0,1.1, 区分为 坐标数字缺省值表达方式 分隔符  ~_&<>.|
		没有分隔符   =  全屏幕坐标
		有分隔符，缺省数值 = 自动屏幕坐标值   > 分隔符表示反转
		
		1、缺省值
		=>  ifcolors(100~,~300,"0xFFFFFF")
		=>  PixelSearch(&X, &Y, 100,A_ScreenHeight, A_ScreenWidth,300 , 0xFFFFFF, 0 )
		
		2、缺省值表达 全屏搜索，下列表达是一个效果

		=>  ifcolors(,,"0xFFFFFF")
		=>  ifcolors( , ,"0xFFFFFF")
		=>  ifcolors(~, ,"0xFFFFFF")
		=>  ifcolors(~,|,"0xFFFFFF")
		=>  ifcolors(0~,0<,"0xFFFFFF")
		=>  PixelSearch(&X, &Y, 0, 0, A_ScreenWidth, A_ScreenHeight, "0xFFFFFF", 0 )
		
		3、缺省坐标表达式   反转分隔符  >
		=>  ifcolors(>, ,"0xFFFFFF")
		=>  PixelSearch(&X, &Y, A_ScreenWidth, 0,  0, A_ScreenHeight, "0xFFFFFF", 0 )
		
		
		
*/ ;--------------------------------------------

	for index,param in params	
	{
		xyc:= StrSplit(StrReplace(param, A_Space),","),x:=xyc[1],y:=xyc[2],cs:=xyc[3]
		a_o:=InStr("or||",xyc.Length=4?xyc[4]:"&")=0?false:true
		if (RegExMatch(x . y, "([~_&<>\.\|])") or !StrLen(x) or !StrLen(y)) 
		{
			x1:=RegExMatch(x, "(^\d+)", &xr)?xr[1]:RegExMatch(x, ">")?A_ScreenWidth:0
			x2:=RegExMatch(x, "(\d+$)", &xr)?xr[1]:RegExMatch(x, ">")?0:A_ScreenWidth
			y1:=RegExMatch(y, "(^\d+)", &yr)?yr[1]:RegExMatch(y, ">")?A_ScreenHeight:0
			y2:=RegExMatch(y, "(\d+$)", &yr)?yr[1]:RegExMatch(y, ">")?0:A_ScreenHeight
			Loop Parse, cs, "-~|&_."
				{
				IF t_f:=PixelSearch(&X, &Y, x1, y1, x2, y2,A_LoopField)
					break
				}
		}	else 
			t_f:=InStr(cs,PixelGetColor(x,y))=0?false:true
		if !t_f and !a_o
			return false
		if t_f and a_o
			return true
	}
	return t_f
}

ShowToolTipForTime(TTtext, timeOut:=3, TTnumber:=2, posX:="", posY:="") {
		if IsInteger(posX) && isInteger(posY)
			ToolTip(TTtext, posX, posY, TTnumber)
		else
			ToolTip(TTtext, , , TTnumber)
		SetTimer () => ToolTip("", , , TTnumber), -timeOut*1000
	}



TextOnTop(text:="",x:=1600,y:=0,MyGui:="Gui",Delay:=5000,ColorS:="00ffFF",side:=0,w:=0) {
/* ;-------------------------------------------------------------------------------	
显示text的内容，delay后消失
<参数>
	text					:要显示的文本内容。
	X							:显示位置的X，默认为1600。
	Y							:显示位置的Y，默认为0。
	WhichToolTip	:如果您不需要同时显示多个工具提示, 默认值为20。
	Delay 				:文本显示后 消失的时间。 默认为1000，若为0，则不消失。
<返回>
	Text	
*/ ;-------------------------------------------------------------------------------	
global
if WinExist("my_over_Lay")
{
	try MyGuiText.text:=""
	try MyGui.Destroy()
}
	MyGui:= Gui("+AlwaysOnTop -Caption +ToolWindow","my_over_Lay") ; +ToolWindow 避免显示任务栏按钮和 alt-tab 菜单项.
	MyGui.BackColor := "000000"  ; 可以是任何 RGB 颜色(下面会变成透明的).
	MyGui.SetFont("s12 c" ColorS)  ; 设置大字体(32 磅).
	MyGuiText:=MyGui.Add("Text","w500 r5",text)  ; XX & YY 用来自动调整窗口大小.
	WinSetTransColor(MyGui.BackColor " 150",MyGui)

try if onoff
	MyGui.Show("x" x "y" y "NoActivate")  ; NoActivate 让当前活动窗口继续保持活动状态.
SetTimer(Guidestroy, "-" Delay)
Guidestroy(*)
	{
	try MyGui.Destroy()
	}
}




ImagePutRapidOcr(x1:=0,y1:=0,x2:=A_ScreenWidth,y2:=A_ScreenHeight,name:=" ")
{
	w:=x2-x1,h:=y2-y1,MyArray:=[x1,y1,w,h]
	folderPath := A_ScriptDir "\图片"
	if (!DirExist(folderPath))
		DirCreate folderPath
	Myfile:=folderPath "\" name "(" x1 "," y1 "）(" x2 "," y2 ").png"
	
	
	
	 ; 返回ocr图片的文字
	text:=RapidOcr().ocr_from_file(ImagePutFile(MyArray,Myfile))
	
	;文字正则修正

	Loop Parse, IniRead(folderPath "\ocr_reg.txt","RegEx"),"`n"
		if t:=InStr(A_LoopField, "=")
			text:=RegExReplace(text,SubStr(A_LoopField,t+1),SubStr(A_LoopField, 1, t-1))

	return text
}

#Include "Gdip_All.ahk"
#include "ImagePut.ahk"
#Include "RapidOcr\RapidOcr.ahk"

