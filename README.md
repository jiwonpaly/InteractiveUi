# InteractiveUi

Thank You For Using My Ui Library !

Please Read Document of Usage

This Ui Library is Still In Developing.

It Would Be Continued For My Plan To Be Completed

```lua
print("cheating")
```

### Example

```lua
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/jiwonpaly/InteractiveUi/main/InteractiveUi.lua"))()

local Window = library.new("Library Title")
local Tab = Window:addPage("Page Title")
local Section = Tab:addSection("Section Title")

Section:AddButton("text",callback)

Section:AddToggle("text",default (boolean),callback)

Section:AddDropdown("text",list (table),callback)

Section:AddSlider("text",default,min,max,callback)

Section:AddTextbox("text",default,callback)

Section:AddColorpicker("text",default (Color3),callback)

Section:AddKeybind("text",default key,callback)

Section:AddLabel("text")

```
## Credits

- RealReal#0001
