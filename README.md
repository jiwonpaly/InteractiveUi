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

Section:AddButton("text",function()
   print("hi")
end)

Section:AddToggle("text",false,function(v)
   print(v)
end)

Section:AddDropdown("text",{"whatever"},function(v)
   print(v)
end)

Section:AddSlider("text",10,0,100,function(v)
   print(v)
end)

Section:AddTextbox("text","placeholder",function(v)
   print(v)
end)

Section:AddColorpicker("text",Color3.fromRGB(255,0,0),function(v)
   print(v)
end)

Section:AddKeybind("text",Enum.KeyCode.H,function()
   print("Clicked")
end)

Section:AddLabel("text")

```
## Credits

- RealReal#0001

## Bug Fixes

- Bug That Occured When Resize Section Which Dont Have Any Child has Been Fixed
