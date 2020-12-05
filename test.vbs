Option Explicit
Dim Title,ws,nMinutes,nSeconds,sMessage
Title = "Counting Down to Next Break"
Set ws = CreateObject("wscript.Shell")
nMinutes = 20
nSeconds = 0
sMessage = "<font color=Red size=2><b>Counting Down to Next Break"

'create pop up window and ask to loop until shutdown

Do
'Open a chromeless window with message
with HTABox("lightBlue",100,250,0,630)
    .document.title = "Counting Down Notification to Break"
    .msg.innerHTML = sMessage
    do until .done.value or (nMinutes + nSeconds < 1)
        .msg.innerHTML = sMessage & "<br>" & nMinutes & ":" & Right("0"&nSeconds, 2) _
        & " remaining</b></font><br>"
        wsh.sleep 1000 ' milliseconds
        nSeconds = nSeconds - 1
        if nSeconds < 0 then 
            if nMinutes > 0 then
                nMinutes = nMinutes - 1
                nSeconds = 59
            end if
        end if
    loop
    .done.value = true
    .close
end with
ws.Popup "TIME IS OVER !","5",Title,0+48 
sMessage = "<font color=Red size=2><b>Break Timer"
nMinutes = 0
nSeconds = 25
with HTABox("lightBlue",100,250,0,630)
    .document.title = "Break Time!"
    .msg.innerHTML = sMessage
    do until .done.value or (nMinutes + nSeconds < 1)
        .msg.innerHTML = sMessage & "<br>" & nMinutes & ":" & Right("0"&nSeconds, 2) _
        & " remaining</b></font><br>"
        wsh.sleep 1000 ' milliseconds
        nSeconds = nSeconds - 1
        if nSeconds < 0 then 
            if nMinutes > 0 then
                nMinutes = nMinutes - 1
                nSeconds = 59
            end if
        end if
    loop
    .done.value = true
    .close
end with
ws.Popup "BREAK TIME IS OVER !","5",Title,0+48 
 'confirm repeat
If vbYes = MsgBox("Do you want to continue?", vbYesNo, "Repeat?") Then
    'Do things
	nMinutes = 20
	nSeconds = 0
	sMessage = "<font color=Red size=2><b>Counting Down to Next Break"
Else
    'Don't do things
	WScript.Quit
End If
Loop While 1>0
'*****************************************************************
Function HTABox(sBgColor, h, w, l, t)
    Dim IE, HTA, sCmd, nRnd
    randomize : nRnd = Int(1000000 * rnd)
    sCmd = "mshta.exe ""javascript:{new " _
    & "ActiveXObject(""InternetExplorer.Application"")" _
    & ".PutProperty('" & nRnd & "',window);" _
    & "window.resizeTo(" & w & "," & h & ");" _
    & "window.moveTo(" & l & "," & t & ")}"""
    with CreateObject("WScript.Shell")
        .Run sCmd, 1, False
        do until .AppActivate("javascript:{new ") : WSH.sleep 10 : loop
        end with  'WSHShell
        For Each IE In CreateObject("Shell.Application").windows
            If IsObject(IE.GetProperty(nRnd)) Then
                set HTABox = IE.GetProperty(nRnd)
                IE.Quit
                HTABox.document.title = "HTABox"
                HTABox.document.write _
                "<HTA:Application contextMenu=no border=thin " _
                & "minimizebutton=no maximizebutton=no sysmenu=no SHOWINTASKBAR=no >" _
                & "<body scroll=no style='background-color:" _
                & sBgColor & ";font:normal 10pt Arial;" _
                & "border-Style:inset;border-Width:3px'" _
                & "onbeforeunload='vbscript:if not done.value then " _
                & "window.event.cancelBubble=true:" _
                & "window.event.returnValue=false:" _
                & "done.value=true:end if'>" _
                & "<input type=hidden id=done value=false>" _
                & "<center><span id=msg>&nbsp;</span><br>" _
                & "<input type=button id=btn1 value=' OK ' "_
                & "onclick=done.value=true><center></body>"
                
                Exit Function
            End If
        Next
        MsgBox "HTA window not found."
        wsh.quit
End Function
'*****************************************************************
