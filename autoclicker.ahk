#Requires AutoHotkey v2.0
#SingleInstance Force

; ==========================================
; INTERFAZ GRÁFICA (GUI)
; ==========================================
myGui := Gui("+AlwaysOnTop", "OP Auto Clicker 4.1 (AHK)")
myGui.SetFont("s9", "Segoe UI")

; Grupo: Click interval
myGui.Add("GroupBox", "x10 y10 w445 h85", "Click interval")
myGui.Add("Text", "x20 y32", "Hours:")
hrsInput := myGui.Add("Edit", "x58 y29 w40 h23 Number", "0")
myGui.Add("Text", "x105 y32", "Mins:")
minsInput := myGui.Add("Edit", "x140 y29 w40 h23 Number", "0")
myGui.Add("Text", "x188 y32", "Secs:")
secsInput := myGui.Add("Edit", "x222 y29 w40 h23 Number", "0")
myGui.Add("Text", "x270 y32", "Ms:")
msInput := myGui.Add("Edit", "x295 y29 w50 h23 Number", "100")

chkRandom := myGui.Add("Checkbox", "x20 y63", "Random offset +/-")
randomMs := myGui.Add("Edit", "x130 y60 w50 h23 Number", "40")
myGui.Add("Text", "x185 y63", "ms")

; Grupo: Click options
myGui.Add("GroupBox", "x10 y105 w215 h85", "Click options")
myGui.Add("Text", "x20 y130", "Mouse button:")
mouseBtn := myGui.Add("DropDownList", "x105 y127 w110", ["Left", "Right", "Middle"])
mouseBtn.Choose(1)

myGui.Add("Text", "x20 y160", "Click type:")
clickType := myGui.Add("DropDownList", "x105 y157 w110", ["Single", "Double"])
clickType.Choose(1)

; Grupo: Click repeat
myGui.Add("GroupBox", "x235 y105 w220 h85", "Click repeat")
radioRepeat := myGui.Add("Radio", "x245 y130", "Repeat")
repeatTimes := myGui.Add("Edit", "x300 y127 w50 h23 Number", "1")
myGui.Add("Text", "x355 y130", "times")
radioUntil := myGui.Add("Radio", "x245 y157 Checked", "Repeat until stopped")

; Grupo: Cursor position
myGui.Add("GroupBox", "x10 y200 w445 h65", "Cursor position")
radioCurrent := myGui.Add("Radio", "x20 y225 Checked", "Current location")
radioPick := myGui.Add("Radio", "x135 y225", "Pick")
myGui.Add("Button", "x180 y221 w80 h26", "Pick location").OnEvent("Click", (*) => MsgBox("Función de selección no activa."))

myGui.Add("Text", "x275 y225", "X:")
posX := myGui.Add("Edit", "x290 y222 w45 h23 Number", "0")
myGui.Add("Text", "x345 y225", "Y:")
posY := myGui.Add("Edit", "x360 y222 w45 h23 Number", "0")

; Botones inferiores
btnStart := myGui.Add("Button", "x10 y275 w218 h35", "Start (F6)")
btnStart.OnEvent("Click", (*) => ToggleClicker())

btnStop := myGui.Add("Button", "x238 y275 w217 h35", "Stop (F6)")
btnStop.Enabled := false
btnStop.OnEvent("Click", (*) => ToggleClicker())

myGui.Show("w465 h320")

; ==========================================
; LÓGICA DEL AUTOCLICKER
; ==========================================
global isRunning := false

F6::ToggleClicker()

ToggleClicker() {
    global isRunning
    if (!isRunning) {
        StartClicking()
    } else {
        StopClicking()
    }
}

StartClicking() {
    global isRunning
    isRunning := true
    btnStart.Enabled := false
    btnStop.Enabled := true

    ; Calcular intervalo en ms
    hrs := Integer(hrsInput.Value) * 3600000
    mins := Integer(minsInput.Value) * 60000
    secs := Integer(secsInput.Value) * 1000
    ms := Integer(msInput.Value)
    totalMs := hrs + mins + secs + ms
    if (totalMs < 10)
        totalMs := 10

    SetTimer(PerformClick, totalMs)
}

StopClicking() {
    global isRunning
    isRunning := false
    SetTimer(PerformClick, 0)
    btnStart.Enabled := true
    btnStop.Enabled := false
}

PerformClick() {
    b := mouseBtn.Text
    t := clickType.Text

    if (b = "Left")
        btnKey := "LButton"
    else if (b = "Right")
        btnKey := "RButton"
    else
        btnKey := "MButton"

    Click(btnKey)
    if (t = "Double") {
        Sleep(50)
        Click(btnKey)
    }
}