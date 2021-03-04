local UserInputService = game:GetService("UserInputService")
local LocalPlayer = game.Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local themes = {
   TextColor = Color3.fromRGB(213,213,213),
   MainBackground = Color3.fromRGB(84, 89, 131),
   SubBackground = Color3.fromRGB(98, 105, 154),
   PageBackground = Color3.fromRGB(72, 76, 112),
   Glow = Color3.fromRGB(16,16,16),
   SectionBackground = Color3.fromRGB(99,105,154),
   ModuleBackground = Color3.fromRGB(84, 89, 131)
}

local Functions = {}

function Functions:Sort(list,pattern)
   
   local result = {}

   pattern = string.lower(pattern)

   if pattern == "" then
      return list
   end
   if #list == 0 then
      return list
   end

   for i,v in pairs (list) do
      if string.find(v,pattern) then
         table.insert(result,v)
      end
   end
   return result
end

function Functions:Pop(object, shrink)
   -- stolen from venyx ui lib :>
   local clone = object:Clone()
   
   clone.AnchorPoint = Vector2.new(0.5, 0.5)
   clone.Size = clone.Size - UDim2.new(0, shrink, 0, shrink)
   clone.Position = UDim2.new(0.5, 0, 0.5, 0)
   
   clone.Parent = object
   clone:ClearAllChildren()
   
   object.BackgroundTransparency = 1
   Functions:Tween(clone, {Size = object.Size}, 0.2)
   
   spawn(function()
      wait(0.2)
   
      object.BackgroundTransparency = 0
      clone:Destroy()
   end)
   
   return clone
end

function Functions:Draggable(frame,parent)
   parent = parent or frame
        
 local input = game:GetService('UserInputService')
   
 local dragging = false
 local dragInput, mousePos, framePos

 frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
       dragging = true
       mousePos = input.Position
       framePos = parent.Position
       
       input.Changed:Connect(function()
          if input.UserInputState == Enum.UserInputState.End then
             dragging = false
          end
       end)
    end
 end)

 frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
       dragInput = input
    end
 end)

 input.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
       local delta = input.Position - mousePos
       parent.Position  = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
    end
 end)
end

function Functions:KeyInput()
   key = UserInputService.InputBegan:Wait()

   repeat 
      key = UserInputService.InputBegan:Wait() 
   until key.UserInputType == Enum.UserInputType.Keyboard

   RunService.RenderStepped:Wait()
   return key
end

function Functions:Tween(instance,properties,duration,...)
    TweenService:Create(instance,TweenInfo.new(duration,...),properties):Play()
end

function Functions:Create(instance,properites,child) 
   local obj = Instance.new(instance)
   for i,v in pairs (properites or {}) do
    obj[i] = v
   end

   for i,lol in pairs (child or {}) do
      lol.Parent = obj
   end

 return obj

end

function Functions:Wait()
   RunService.RenderStepped:Wait()
end

function Functions:InputDetector()
   self.ended = {}
   self.binds = {}

   UserInputService.InputBegan:Connect(function(key)
      if self.binds[key.KeyCode] then
         for i,v in pairs (self.binds[key.KeyCode]) do
            v()
         end
      end
   end)

   UserInputService.InputEnded:Connect(function(key)
      if key.UserInputType == Enum.UserInputType.MouseButton1 then
         for i,v in pairs (self.ended) do
            v()
         end
      end
   end)
end 

function Functions:BindToKey(bind,callback)
   self.binds[bind] = self.binds[bind] or {}

   table.insert(self.binds[bind],callback)

   return {
      Unbind = function()
         for i,v in pairs (self.binds[bind]) do
            if v == callback then
               table.remove(self.binds[bind],i)
            end
         end
      end
   }
end 

function Functions:DraggingEnded(callback)
   table.insert(self.ended,callback)
end

function Functions:HSV2RGB(h,s,v)
   local r,g,b,i,f,p,q,t;

   i = math.floor(h * 6)
   f = h * 6 - i
   p = v * (1 - s)
   q = v * ( 1 - f * s)
   t = v * (1 - (1 - f) * s)

   local newI = i % 6

   if (newI == 0) then
      r = v
      g = t
      b = p
   elseif newI == 1 then
      r = q
      g = v
      b = p
   elseif newI == 2 then
      r = p
      g = v
      b = t
   elseif newI == 3 then
      r = p
      g = q
      b = v
   elseif newI == 4 then
      r = t
      g = p
      b = v
   elseif newI == 5 then
      r = v
      g = p
      b = q 
   end

   return {
      r = math.round(r * 255),
      g = math.round(g * 255),
      b = math.round(b * 255)
   }
end

local Library = {}
local Page = {}
local Section = {}

Library.__index = Library
Page.__index = Page
Section.__index = Section

--For Serveral Reasons, I Didnt use Create Function :>
function Library.new(TitleText,icon)
   local InteractiveUi = Instance.new("ScreenGui")
   local Main = Instance.new("Frame")
   local Glow = Instance.new("ImageLabel")
   local LeftSide = Instance.new("Frame")
   local Glow_2 = Instance.new("ImageLabel")
   local Title = Instance.new("TextLabel")
   local Icon = Instance.new("ImageLabel")
   local PageList = Instance.new("ScrollingFrame")
   local UIListLayout = Instance.new("UIListLayout")
   local RightSide = Instance.new("Frame")

   InteractiveUi.Name = "InteractiveUi"
   InteractiveUi.Parent = game:GetService("CoreGui")
   InteractiveUi.ResetOnSpawn = false

   Main.Name = "Main"
   Main.Parent = InteractiveUi
   Main.BackgroundColor3 = Color3.fromRGB(84, 89, 131)
   Main.BorderSizePixel = 0
   Main.Position = UDim2.new(0.272782505, 0, 0.239104837, 0)
   Main.Size = UDim2.new(0, 748, 0, 442)

   Glow.Name = "Glow"
   Glow.Parent = Main
   Glow.BackgroundColor3 = Color3.fromRGB(229, 229, 229)
   Glow.BackgroundTransparency = 1.000
   Glow.BorderSizePixel = 0
   Glow.Position = UDim2.new(0, -15, 0, -15)
   Glow.Size = UDim2.new(1, 30, 1, 30)
   Glow.Image = "rbxassetid://5028857084"
   Glow.ImageColor3 = themes.Glow
   Glow.ScaleType = Enum.ScaleType.Slice
   Glow.SliceCenter = Rect.new(24, 24, 276, 276)

   LeftSide.Name = "LeftSide"
   LeftSide.Parent = Main
   LeftSide.BackgroundColor3 = themes.SubBackground
   LeftSide.BorderSizePixel = 0
   LeftSide.Size = UDim2.new(0, 186, 0, 442)

   Glow_2.Name = "Glow"
   Glow_2.Parent = LeftSide
   Glow_2.BackgroundColor3 = Color3.fromRGB(229, 229, 229)
   Glow_2.BackgroundTransparency = 1.000
   Glow_2.BorderSizePixel = 0
   Glow_2.Position = UDim2.new(0, -15, 0, -15)
   Glow_2.Size = UDim2.new(1, 30, 1, 30)
   Glow_2.Image = "http://www.roblox.com/asset/?id=5028857084"
   Glow_2.ImageColor3 = themes.Glow
   Glow_2.ScaleType = Enum.ScaleType.Slice
   Glow_2.SliceCenter = Rect.new(24, 24, 276, 276)

   Title.Name = "Title"
   Title.Parent = LeftSide
   Title.BackgroundColor3 = themes.TextColor
   Title.BackgroundTransparency = 1.000
   Title.Position = UDim2.new(0, 10, 0.0565610826, 10)
   Title.Size = UDim2.new(0, 186, 0, 103)
   Title.Font = Enum.Font.Nunito
   Title.Text = TitleText or "Interactive UI"
   Title.TextColor3 = Color3.fromRGB(255, 255, 255)
   Title.TextSize = 30.000
   Title.TextWrapped = true
   Title.TextXAlignment = Enum.TextXAlignment.Left

   Icon.Name = "Icon"
   Icon.Parent = LeftSide
   Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
   Icon.BackgroundTransparency = 1.000
   Icon.Size = UDim2.new(0, 64, 0, 64)
   Icon.Image = icon or "rbxassetid://6451147014"

   PageList.Name = "PageList"
   PageList.Parent = LeftSide
   PageList.Active = true
   PageList.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
   PageList.BackgroundTransparency = 1.000
   PageList.Position = UDim2.new(0, 0, 0.271493226, 0)
   PageList.Size = UDim2.new(0, 186, 0, 322)
   PageList.CanvasSize = UDim2.new(0, 0, 0, 0)
   PageList.ScrollBarThickness = 0

   UIListLayout.Parent = PageList
   UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
   UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
   UIListLayout.Padding = UDim.new(0, 3)

   RightSide.Name = "RightSide"
   RightSide.Parent = Main
   RightSide.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
   RightSide.BackgroundTransparency = 1.000
   RightSide.Position = UDim2.new(0.256684482, 0, 0, 0)
   RightSide.Size = UDim2.new(0, 556, 0, 442)
      

   Functions:Draggable(LeftSide,Main)
   Functions:InputDetector()

   return setmetatable({
      Main = Main,
      Library = self,
      PageList = PageList,
      PageContainer = RightSide,
      pages = {}
   },Library)
end

function Page.new(Library,Title)
   local PageFrame = Instance.new("ScrollingFrame")
   local UIListLayout_2 = Instance.new("UIListLayout")
   local PageButton = Instance.new("TextButton")
   local UICorner = Instance.new("UICorner")

   PageFrame.Name = "PageFrame"
   PageFrame.Parent = Library.PageContainer
   PageFrame.Active = true
   PageFrame.BackgroundColor3 = themes.PageBackground
   PageFrame.BorderSizePixel = 0
   PageFrame.Size = UDim2.new(1, 0, 1, 0)
   PageFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
   PageFrame.ScrollBarThickness = 0
   PageFrame.Visible = false

   UIListLayout_2.Parent = PageFrame
   UIListLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Center
   UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
   UIListLayout_2.Padding = UDim.new(0, 7)

   PageButton.Name = "PageButton"
   PageButton.Parent = Library.PageList
   PageButton.BackgroundColor3 = themes.MainBackground
   PageButton.BorderSizePixel = 0
   PageButton.Position = UDim2.new(0.0510752685, 0, 0, 0)
   PageButton.Size = UDim2.new(0, 167, 0, 37)
   PageButton.AutoButtonColor = false
   PageButton.Font = Enum.Font.GothamSemibold
   PageButton.TextColor3 = themes.TextColor
   PageButton.TextSize = 14.000
   PageButton.Text = Title

   UICorner.CornerRadius = UDim.new(0, 5)
   UICorner.Parent = PageButton

   return setmetatable({
      PageButton = PageButton,
      Library = Library,
      Container = PageFrame,
      Sections = {}
   },Page)
end

function Section.new(page,Title)
   local SectionFrame = Instance.new("Frame")
   local SectionTitle = Instance.new("TextLabel")
   local UIListLayout_3 = Instance.new("UIListLayout")
   local UICorner_2 = Instance.new("UICorner")

   SectionFrame.Name = "SectionFrame"
   SectionFrame.Parent = page.Container
   SectionFrame.BackgroundColor3 = themes.SectionBackground
   SectionFrame.BorderSizePixel = 0
   SectionFrame.Position = UDim2.new(0.0629496425, 0, 0, 0)
   SectionFrame.Size = UDim2.new(1, -30, 0, 30)

   SectionTitle.Name = "SectionTitle"
   SectionTitle.Parent = SectionFrame
   SectionTitle.BackgroundColor3 = themes.MainBackground
   SectionTitle.Size = UDim2.new(0, 477, 0, 25)
   SectionTitle.Font = Enum.Font.Gotham
   SectionTitle.Text = Title or "Section 1"
   SectionTitle.TextColor3 = themes.TextColor
   SectionTitle.TextSize = 14.000
   SectionTitle.BorderSizePixel = 0

   UIListLayout_3.Parent = SectionFrame
   UIListLayout_3.HorizontalAlignment = Enum.HorizontalAlignment.Center
   UIListLayout_3.SortOrder = Enum.SortOrder.LayoutOrder
   UIListLayout_3.Padding = UDim.new(0, 10)

   UICorner_2.CornerRadius = UDim.new(0, 2)
   UICorner_2.Parent = SectionFrame

   return setmetatable({
      Page = page,
      Container = SectionFrame,
      module = {},
      binds = {}
   },Section)
end

function Library:addPage(...)
   local page = Page.new(self,...)
   local button = page.PageButton
   table.insert(self.pages,page)

   button.MouseButton1Click:Connect(function()
      Functions:Pop(button,10)
      self:SelectPage(page,true)
   end)
   Functions:Wait()

   return page
end

function Page:addSection(...)
   local section = Section.new(self,...)

   table.insert(self.Sections,section)

   return section
end

function Library:SelectPage(page,toggle)
   self:Resize()

   if toggle and self.FocusedPage == page then
      return
   end

   if toggle then
      
      local FocusedPage = self.FocusedPage
      self.FocusedPage = page
      if FocusedPage then
         self:SelectPage(FocusedPage,false)
      end

      wait(.1)
      page.Container.Visible = true

      if FocusedPage then
         FocusedPage.Container.Visible = false
      end

      wait(.05)

      for i,v in pairs (page.Sections) do
          v:Resize(true)
          wait(.05)
      end
      wait(.05)
      page:Resize(true)

   else
      for i,v in pairs (page.Sections) do
         Functions:Tween(v.Container,{Size = UDim2.new(0,v.Container.X.Offset,0,0)})
      end

      wait(.1)
      page.lastPosition = page.Container.CanvasPosition.Y
      page:Resize()
   end
end

function Library:Resize()
   local PageList = self.PageList
   local UIListLayout = PageList.UIListLayout
   PageList.CanvasSize = UDim2.new(0,0,0,UIListLayout.AbsoluteContentSize.Y)

   return PageList
end

function Page:Resize(Scroll)
   local BottomMargin = 20

   local PageContainer = self.Container
   local UIListLayout = PageContainer.UIListLayout

   PageContainer.CanvasSize =  UDim2.new(0,0,0,UIListLayout.AbsoluteContentSize.Y + BottomMargin)

   if Scroll then
      Functions:Tween(PageContainer,{CanvasPosition = Vector2.new(0,self.lastPosition)},0.2)
   end
end

function Section:Resize(smooth)
   if self.Page.Library.FocusedPage ~= self.Page then return print("you cant") end

   local Size = self.Container.UIListLayout.AbsoluteContentSize.Y + 10

   if smooth then
      Functions:Tween(self.Container,{Size = UDim2.new(1,-30,0,Size)},0.1)
   else
      self.Container.Size = UDim2.new(1,-30,0,Size)
      self.Page:Resize()
   end
end

function Section:AddButton(text,callback)
   local Button = Instance.new("TextButton")

   Button.Name = "Button"
   Button.Parent = self.Container
   Button.BackgroundColor3 = themes.ModuleBackground
   Button.Position = UDim2.new(0.0504115224, 0, 0.0755287036, 0)
   Button.Size = UDim2.new(0, 430, 0, 31)
   Button.AutoButtonColor = false
   Button.Font = Enum.Font.GothamSemibold
   Button.Text = text or "Button Text"
   Button.TextColor3 = themes.TextColor
   Button.TextSize = 16.000

   local debounce

   Button.MouseButton1Click:Connect(function()

      if debounce then return end

      debounce = true

      Functions:Tween(Button,{TextSize = 8},0.1)
      wait(.1)
      Functions:Tween(Button,{TextSize = 16},0.1)

         if callback then
            callback(function(...)
               self:UpdateButton(Button,...)
            end)
         end
      debounce = false
      end)
end

function Section:UpdateButton(Button,...)
   if Button then
      Button.Text = (...)
   end
end

function Section:AddToggle(text,defualt,callback)
   local Toggle = Instance.new("Frame")
   local ToggleText = Instance.new("TextLabel")
   local ToggleButton = Instance.new("TextButton")
   local UICorner_3 = Instance.new("UICorner")
   local Mover = Instance.new("ImageLabel")

   Toggle.Name = "Toggle"
   Toggle.Parent = self.Container
   Toggle.BackgroundColor3 = themes.MainBackground
   Toggle.Position = UDim2.new(0.0576131679, 0, 0.229607254, 0)
   Toggle.Size = UDim2.new(0, 430, 0, 31)

   ToggleText.Name = "ToggleText"
   ToggleText.Parent = Toggle
   ToggleText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
   ToggleText.BackgroundTransparency = 1.000
   ToggleText.Position = UDim2.new(0.0255813953, 0, 0, 0)
   ToggleText.Size = UDim2.new(0, 298, 0, 31)
   ToggleText.Font = Enum.Font.GothamSemibold
   ToggleText.Text = text or "Toggle Text"
   ToggleText.TextColor3 = themes.TextColor
   ToggleText.TextSize = 14.000
   ToggleText.TextXAlignment = Enum.TextXAlignment.Left

   ToggleButton.Name = "ToggleButton"
   ToggleButton.Parent = Toggle
   ToggleButton.BackgroundColor3 = Color3.fromRGB(68, 68, 68)
   ToggleButton.Position = UDim2.new(0.800000012, 0, 0.0967741907, 0)
   ToggleButton.Size = UDim2.new(0, 67, 0, 24)
   ToggleButton.AutoButtonColor = false
   ToggleButton.Font = Enum.Font.SourceSans
   ToggleButton.Text = ""
   ToggleButton.TextColor3 = Color3.fromRGB(0, 0, 0)
   ToggleButton.TextSize = 14.000

   UICorner_3.CornerRadius = UDim.new(0, 15)
   UICorner_3.Parent = ToggleButton

   Mover.Name = "Mover"
   Mover.Parent = ToggleButton
   Mover.BackgroundColor3 = Color3.fromRGB(163, 163, 163)
   Mover.BackgroundTransparency = 1.000
   Mover.Position = UDim2.new(0, 0, 0.0833333358, 0)
   Mover.Size = UDim2.new(0, 20, 0, 20)
   Mover.Image = "rbxassetid://3570695787"
   Mover.ImageColor3 = Color3.fromRGB(193, 193, 193)
   Mover.ScaleType = Enum.ScaleType.Slice
   Mover.SliceCenter = Rect.new(100, 100, 100, 100)
   Mover.SliceScale = 0.130

   local active = defualt

   self:UpdateToggle(Toggle,nil,active)

   Toggle.ToggleButton.MouseButton1Click:Connect(function()
      active = not active
      self:UpdateToggle(Toggle,nil,active)

      if callback then
         callback(active,function(...)
            self:UpdateToggle(Toggle,...)
         end)
      end
   end)
end

function Section:UpdateToggle(Toggle,title,value)
   if Toggle then
      
      if title then
         Toggle.ToggleText.Text = title
      end

      local Positions = {
         Defualt = UDim2.new(0, 0, 0.0833333358, 0),
         Opposite = UDim2.new(0.701, 0,0.083, 0)
      }

      value = value and "Opposite" or "Defualt"
      Functions:Tween(Toggle.ToggleButton.Mover,{Position = Positions[value]},0.2)

   end
end

function Section:AddDropdown(text,list,callback)
   local Dropdown = Instance.new("Frame")
   local Search = Instance.new("TextBox")
   local Button_2 = Instance.new("ImageButton")
   local Padding = Instance.new("Frame")
   local Lists = Instance.new("ScrollingFrame")
   local UIListLayout_4 = Instance.new("UIListLayout")

   Dropdown.Name = "Dropdown"
   Dropdown.Parent = self.Container
   Dropdown.BackgroundColor3 = themes.MainBackground
   Dropdown.Position = UDim2.new(0.0576131679, 0, 0.353474319, 0)
   Dropdown.Size = UDim2.new(0, 430, 0, 31)
   Dropdown.ZIndex = 3
   Dropdown.ClipsDescendants = true

   Search.Name = "Search"
   Search.Parent = Dropdown
   Search.BackgroundColor3 = themes.MainBackground
   Search.BackgroundTransparency = 1.000
   Search.Size = UDim2.new(0, 430, 0, 31)
   Search.ZIndex = 3
   Search.Font = Enum.Font.Gotham
   Search.PlaceholderColor3 = Color3.fromRGB(178, 178, 178)
   Search.PlaceholderText = text or "Search Text"
   Search.Text = ""
   Search.TextColor3 = themes.TextColor
   Search.TextSize = 12.000

   Button_2.Name = "Button"
   Button_2.Parent = Dropdown
   Button_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
   Button_2.BackgroundTransparency = 1.000
   Button_2.Position = UDim2.new(0.932558179, 0, 0.0322580636, 0)
   Button_2.Size = UDim2.new(0, 29, 0, 29)
   Button_2.ZIndex = 3
   Button_2.Image = "rbxassetid://5012539403"

   Padding.Name = "Padding"
   Padding.Parent = Dropdown
   Padding.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
   Padding.Size = UDim2.new(0, 430, 0, 31)

   Lists.Name = "Lists"
   Lists.Parent = Dropdown
   Lists.Active = true
   Lists.BackgroundColor3 = Color3.fromRGB(74, 79, 115)
   Lists.BorderSizePixel = 0
   Lists.Position = UDim2.new(0, 0, 0,30)
   Lists.Size = UDim2.new(0, 430, 0, 90)
   Lists.ZIndex = 4
   Lists.ScrollBarThickness = 0

   UIListLayout_4.HorizontalAlignment = Enum.HorizontalAlignment.Center
   UIListLayout_4.Parent = Lists
   UIListLayout_4.Padding = UDim.new(0,4)

   local isFocused = false

   Button_2.MouseButton1Click:Connect(function()
      if Button_2.Rotation == 0 then
         self:UpdateDropdown(Dropdown,nil,list,callback)
      else
         self:UpdateDropdown(Dropdown,nil,nil,callback)
      end
   end)

   Search.Focused:Connect(function()
      if Button_2.Rotation == 0 then
         self:UpdateDropdown(Dropdown,nil,list,callback)
      end
      isFocused = true
   end)

   Search.FocusLost:Connect(function()
      isFocused = false
   end)

   Search:GetPropertyChangedSignal("Text"):Connect(function()
      if isFocused then
         local NewList = Functions:Sort(list,Search.Text)
         NewList = #NewList ~= 0 and NewList 
         self:UpdateDropdown(Dropdown,nil,NewList,callback)
      end
   end)

   Dropdown:GetPropertyChangedSignal("Size"):Connect(function()
      self:Resize()
   end)
end

function Section:UpdateDropdown(Dropdown,title,list,callback)
   if Dropdown then
      
      if title then 
         Dropdown.Search.PlaceholderText = title
      end
      local objects = 0
      Functions:Pop(Dropdown.Search,10)

      for i,v in pairs (Dropdown.Lists:GetChildren()) do
         if v:IsA("TextButton") then
            v:Destroy()
         end
      end

      for i,v in pairs (list or {}) do
         local DropdownButton = Instance.new("TextButton")

         DropdownButton.Name = "DropdownButton"
         DropdownButton.Parent = Dropdown.Lists
         DropdownButton.BackgroundColor3 = Color3.fromRGB(107, 114, 167)
         DropdownButton.BorderSizePixel = 0
         DropdownButton.Position = UDim2.new(0.041860465, 0, 0, 0)
         DropdownButton.Size = UDim2.new(0, 383, 0, 25)
         DropdownButton.ZIndex = 4
         DropdownButton.AutoButtonColor = false
         DropdownButton.Font = Enum.Font.Gotham
         DropdownButton.Text = v or "Dropdown Button"
         DropdownButton.TextColor3 = Color3.fromRGB(213, 213, 213)
         DropdownButton.TextSize = 14.000


         DropdownButton.MouseButton1Click:Connect(function()
            if callback then
               callback(v,function(...)
                   self:UpdateDropdown(Dropdown,...)
               end)
            end
            self:UpdateDropdown(Dropdown,v,nil,callback)
         end)
         objects = objects + 1
      end

      Dropdown.Lists.CanvasSize = UDim2.new(0,0,0,Dropdown.Lists.UIListLayout.AbsoluteContentSize.Y)

      Functions:Tween(Dropdown,{Size = UDim2.new(0,Dropdown.Size.X.Offset,0, (objects == 0 and 30) or math.clamp(objects,0,3) * 29 + 33 )},.2)
      Functions:Tween(Dropdown.Button,{Rotation = list and 180 or 0},0.2)
   end
end

function Section:AddSlider(text,defualt,min,max,callback)
   local Slider = Instance.new("Frame")
   local SliderTitle = Instance.new("TextLabel")
   local Input = Instance.new("TextBox")
   local Slider_2 = Instance.new("TextButton")
   local SliderFrame = Instance.new("Frame")
   local Circle = Instance.new("ImageLabel")

   Slider.Name = "Slider"
   Slider.Parent = self.Container
   Slider.BackgroundColor3 = Color3.fromRGB(84, 89, 131)
   Slider.Position = UDim2.new(0.0576131679, 0, 0.477341384, 0)
   Slider.Size = UDim2.new(0, 430, 0, 50)

   SliderTitle.Name = "SliderTitle"
   SliderTitle.Parent = Slider
   SliderTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
   SliderTitle.BackgroundTransparency = 1.000
   SliderTitle.Position = UDim2.new(0.0255813953, 0, 0, 0)
   SliderTitle.Size = UDim2.new(0, 200, 0, 15)
   SliderTitle.Font = Enum.Font.Gotham
   SliderTitle.Text = text or "Slider Title"
   SliderTitle.TextColor3 = Color3.fromRGB(213, 213, 213)
   SliderTitle.TextSize = 13.000
   SliderTitle.TextXAlignment = Enum.TextXAlignment.Left

   Input.Name = "Input"
   Input.Parent = Slider
   Input.BackgroundColor3 = Color3.fromRGB(70, 74, 109)
   Input.Position = UDim2.new(0.874418616, 0, 0.150000006, 0)
   Input.Size = UDim2.new(0, 48, 0, 15)
   Input.Font = Enum.Font.SourceSans
   Input.Text = ""
   Input.TextColor3 = themes.TextColor
   Input.TextSize = 14.000

   Slider_2.Name = "Slider"
   Slider_2.Parent = Slider
   Slider_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
   Slider_2.BorderSizePixel = 0
   Slider_2.Position = UDim2.new(0.00697674416, 0, 0.675000012, 0)
   Slider_2.Size = UDim2.new(0, 424, 0, 7)
   Slider_2.Font = Enum.Font.SourceSans
   Slider_2.Text = ""
   Slider_2.TextColor3 = Color3.fromRGB(0, 0, 0)
   Slider_2.TextSize = 14.000
   Slider_2.AutoButtonColor = false

   SliderFrame.Name = "SliderFrame"
   SliderFrame.Parent = Slider_2
   SliderFrame.BackgroundColor3 = Color3.fromRGB(101, 107, 157)
   SliderFrame.BorderSizePixel = 0
   SliderFrame.Size = UDim2.new(0, 0, 1, 0)

   Circle.Name = "Circle"
   Circle.Parent = SliderFrame
   Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
   Circle.BackgroundTransparency = 1.000
   Circle.Position = UDim2.new(1, -10, -1.14285684, 0)
   Circle.Size = UDim2.new(0, 23, 0, 23)
   Circle.Image = "rbxassetid://3570695787"
   Circle.ImageTransparency = 1.000
   Circle.ScaleType = Enum.ScaleType.Slice
   Circle.SliceCenter = Rect.new(100, 100, 100, 100)
   Circle.SliceScale = 0.120

   local dragging;
   local callback = function(value)
      if callback then
         callback(value, function(...)
            self:UpdateSlider(slider, ...)
         end)
      end
   end

   local defualt = defualt or min

   Functions:DraggingEnded(function()
      dragging = false
   end)

   self:UpdateSlider(Slider,nil,defualt,min,max)

   Slider_2.MouseButton1Down:Connect(function()
      dragging = true
      
      Functions:Tween(Circle,{ImageTransparency = 0},0.1)

      while dragging do

         local val = self:UpdateSlider(Slider,nil,nil,min,max,defualt)
         callback(val)

         Input.Text = val

         Functions:Wait()
      end 
      wait(.1)
      Functions:Tween(Circle,{ImageTransparency = 1},0.2)
   end)

   Input:GetPropertyChangedSignal("Text"):Connect(function()
      if tonumber(Input.Text) ~= nil then
        val = self:UpdateSlider(Slider,nil,Input.Text,min,max)
        callback(val)
      else
         Input.Text = string.sub(Input.Text,1,#Input.Text - 1)
      end
   end)
end 

function Section:UpdateSlider(Slider,text,value,min,max,newvalue)
  if Slider then
   
   if text then Slider.SliderTitle.Text = text end 

   local bar = Slider.Slider
   local percentage = (Mouse.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X
 
   if value then
      percentage = (value - min) / (max - min)
   end

   percentage = math.clamp(percentage,0,1)
    
   value = value or math.floor(min + (max-min) * percentage)
   Functions:Tween(bar.SliderFrame,{Size = UDim2.new(percentage,0,1,0)},.2)
   return value
  end   
end

function Section:AddKeybind(text,defualt,callback)
   local Keybind = Instance.new("Frame")
   local KeybindTitle = Instance.new("TextLabel")
   local TextButton = Instance.new("TextButton")

   Keybind.Name = "Keybind"
   Keybind.Parent = self.Container
   Keybind.BackgroundColor3 = Color3.fromRGB(84, 89, 131)
   Keybind.Position = UDim2.new(-0.281893015, 0, 0.658610284, 0)
   Keybind.Size = UDim2.new(0, 430, 0, 30)

   KeybindTitle.Name = "KeybindTitle"
   KeybindTitle.Parent = Keybind
   KeybindTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
   KeybindTitle.BackgroundTransparency = 1.000
   KeybindTitle.Position = UDim2.new(0.0255813953, 0, 0.233333334, 0)
   KeybindTitle.Size = UDim2.new(0, 298, 0, 15)
   KeybindTitle.Font = Enum.Font.Gotham
   KeybindTitle.Text = text or "Keybind Title"
   KeybindTitle.TextColor3 = Color3.fromRGB(213, 213, 213)
   KeybindTitle.TextSize = 13.000
   KeybindTitle.TextXAlignment = Enum.TextXAlignment.Left

   TextButton.Parent = Keybind
   TextButton.BackgroundColor3 = Color3.fromRGB(68, 68, 68)
   TextButton.BorderSizePixel = 0
   TextButton.Position = UDim2.new(0.713953495, 0, 0.13333334, 0)
   TextButton.Size = UDim2.new(0, 117, 0, 22)
   TextButton.AutoButtonColor = false
   TextButton.Font = Enum.Font.Gotham
   TextButton.Text = "None"
   TextButton.TextColor3 = Color3.fromRGB(213, 213, 213)
   TextButton.TextSize = 14.000

   self.binds[Keybind] = {callback = function()
      Functions:Pop(TextButton,10)

      if callback then
         callback(function(...)
            self:UpdateKeybind(Keybind,...)
         end)
      end
   end}

   if defualt and Keybind then self:UpdateKeybind(Keybind,nil,defualt) end

   TextButton.MouseButton1Click:Connect(function()
      
      if self.binds[Keybind].conn then return self:UpdateKeybind(Keybind) end

      if TextButton.Text == "None" then 
         TextButton.Text = "Listening..."

         key = Functions:KeyInput()

         self:UpdateKeybind(Keybind,nil,key.KeyCode)
      end
   end)
end

function Section:UpdateKeybind(keybind,text,key)
   if keybind then
      if text then
         keybind.KeybindTitle.Text = text
      end

      if self.binds[keybind].conn then
         self.binds[keybind].conn = self.binds[keybind].conn:Unbind()
      end

      if key then
         self.binds[keybind].conn = Functions:BindToKey(key,self.binds[keybind].callback)
         keybind.TextButton.Text = key.Name
      else
         keybind.TextButton.Text = "None"
      end
   end
end

function Section:AddLabel(text)
   local Label = Instance.new("TextLabel")

   Label.Name = "Label"
   Label.Parent = self.Container
   Label.BackgroundColor3 = Color3.fromRGB(84, 89, 131)
   Label.Position = UDim2.new(-0.179012343, 0, 0.779456198, 0)
   Label.Size = UDim2.new(0, 430, 0, 30)
   Label.Font = Enum.Font.Gotham
   Label.Text = text or "Label Text"
   Label.TextColor3 = Color3.fromRGB(213, 213, 213)
   Label.TextSize = 14.000
end

function Section:AddTextbox(text,defualt,callback)
   local TextBox = Instance.new("Frame")
   local TextBoxTitle = Instance.new("TextLabel")
   local Boxinput = Instance.new("TextBox")

   TextBox.Name = "TextBox"
   TextBox.Parent = self.Container
   TextBox.BackgroundColor3 = Color3.fromRGB(84, 89, 131)
   TextBox.Position = UDim2.new(-0.281893015, 0, 0.839436591, 0)
   TextBox.Size = UDim2.new(0, 430, 0, 30)

   TextBoxTitle.Name = "TextBoxTitle"
   TextBoxTitle.Parent = TextBox
   TextBoxTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
   TextBoxTitle.BackgroundTransparency = 1.000
   TextBoxTitle.Position = UDim2.new(0.0255813953, 0, 0.100000001, 0)
   TextBoxTitle.Size = UDim2.new(0, 200, 0, 24)
   TextBoxTitle.Font = Enum.Font.Gotham
   TextBoxTitle.Text = text or "TextBox Title"
   TextBoxTitle.TextColor3 = Color3.fromRGB(213, 213, 213)
   TextBoxTitle.TextSize = 14.000
   TextBoxTitle.TextXAlignment = Enum.TextXAlignment.Left

   Boxinput.Name = "Boxinput"
   Boxinput.Parent = TextBox
   Boxinput.BackgroundColor3 = Color3.fromRGB(66, 71, 103)
   Boxinput.Position = UDim2.new(0.527906954, 0, 0.100000001, 0)
   Boxinput.Size = UDim2.new(0, 197, 0, 24)
   Boxinput.Font = Enum.Font.Gotham
   Boxinput.PlaceholderText = defualt or "It was hard"
   Boxinput.Text = ""
   Boxinput.TextColor3 = Color3.fromRGB(213, 213, 213)
   Boxinput.TextSize = 10.000

   Boxinput.FocusLost:Connect(function()
      if callback then
         --im lazy
         callback(Boxinput.Text,function(...)
            Section:UpdateTextbox(TextBox,...)
         end)
      end
   end)
end

function Section:UpdateTextbox(box,text,holder)
   if box then
      if text then
         box.TextBoxTitle.Text = text
      end
      
      if holder then
         box.Boxinput.PlaceholderText = holder
      end
   end
end

function Section:AddColorpicker(text,default,callback)
   local ColorPicker = Instance.new("Frame")
   local ColorPickerTitle = Instance.new("TextLabel")
   local Select = Instance.new("TextButton")
   local UICorner = Instance.new("UICorner")
   local Frame = Instance.new("Frame")
   local cc = Instance.new("ImageLabel")
   local Mover = Instance.new("Frame")
   local Frame_2 = Instance.new("ImageLabel")
   local ImageLabel = Instance.new("ImageLabel")
   local ColorVal = Instance.new("TextLabel")
   
   ColorPicker.Name = "ColorPicker"
   ColorPicker.Parent = self.Container
   ColorPicker.BackgroundColor3 = Color3.fromRGB(84, 89, 131)
   ColorPicker.ClipsDescendants = true
   ColorPicker.Position = UDim2.new(0.0576131679, 0, 0.631775677, 0)
   ColorPicker.Size = UDim2.new(0, 430, 0, 30)
   
   ColorPickerTitle.Name = "ColorPickerTitle"
   ColorPickerTitle.Parent = ColorPicker
   ColorPickerTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
   ColorPickerTitle.BackgroundTransparency = 1.000
   ColorPickerTitle.Position = UDim2.new(0.0255813953, 0, 0, 0)
   ColorPickerTitle.Size = UDim2.new(0, 200, 0, 30)
   ColorPickerTitle.Font = Enum.Font.Gotham
   ColorPickerTitle.Text = text or "Color Picker Title"
   ColorPickerTitle.TextColor3 = Color3.fromRGB(213, 213, 213)
   ColorPickerTitle.TextSize = 14.000
   ColorPickerTitle.TextStrokeColor3 = Color3.fromRGB(213, 213, 213)
   ColorPickerTitle.TextXAlignment = Enum.TextXAlignment.Left
   
   Select.Name = "Select"
   Select.Parent = ColorPicker
   Select.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
   Select.BorderSizePixel = 0
   Select.Position = UDim2.new(1, -100, 0, 5)
   Select.Size = UDim2.new(0, 91, 0, 22)
   Select.AutoButtonColor = false
   Select.Font = Enum.Font.SourceSans
   Select.Text = ""
   Select.TextColor3 = Color3.fromRGB(0, 0, 0)
   Select.TextSize = 14.000
   Select.ZIndex = 2
   
   UICorner.CornerRadius = UDim.new(0, 5)
   UICorner.Parent = Select
   
   Frame.Parent = ColorPicker
   Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
   Frame.BackgroundTransparency = 1.000
   Frame.ClipsDescendants = true
   Frame.Position = UDim2.new(0, 0, 0, 30)
   Frame.Size = UDim2.new(0, 430, 0, 140)
   
   cc.Name = "cc"
   cc.Parent = Frame
   cc.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
   cc.Position = UDim2.new(0.196111783, 0, 0.0623098463, 0)
   cc.Size = UDim2.new(0, 53, 0, 126)
   cc.Image = "rbxassetid://359311684"
   cc.ImageColor3 = Color3.fromRGB(0, 0, 0)
   
   Mover.Name = "Mover"
   Mover.Parent = cc
   Mover.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
   Mover.Position = UDim2.new(-0.0566037744, 0, 0.985000014, 0)
   Mover.Size = UDim2.new(0, 59, 0, 3)
   
   Frame_2.Name = "Frame"
   Frame_2.Parent = Frame
   Frame_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
   Frame_2.Position = UDim2.new(0.353200078, 0, 0.0681920201, 0)
   Frame_2.Size = UDim2.new(0, 126, 0, 126)
   Frame_2.Image = "rbxassetid://1433361550"
   Frame_2.ZIndex = 5
   
   ImageLabel.Parent = Frame_2
   ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
   ImageLabel.BackgroundTransparency = 1.000
   ImageLabel.Position = UDim2.new(0.465000004, 0, 0.469999999, 0)
   ImageLabel.Size = UDim2.new(0, 13, 0, 13)
   ImageLabel.Image = "rbxassetid://5100115962"
   ImageLabel.ZIndex = 5
   
   ColorVal.Name = "ColorVal"
   ColorVal.Parent = Frame
   ColorVal.BackgroundColor3 = Color3.fromRGB(84, 89, 131)
   ColorVal.BorderColor3 = Color3.fromRGB(25, 25, 25)
   ColorVal.BorderSizePixel = 0
   ColorVal.Position = UDim2.new(0.697674394, 0, 0.382779241, 0)
   ColorVal.Size = UDim2.new(0, 121, 0, 30)
   ColorVal.Font = Enum.Font.Gotham
   ColorVal.Text = "r : g : b:"
   ColorVal.TextColor3 = Color3.fromRGB(213, 213, 213)
   ColorVal.TextSize = 14.000


   local mouseDown = false
   local mouseDown1 = false
   local tabactive = false

   local Color = {1,1,1}

   local function Getp(NewX,NewY)
      local x,y = Mouse.X,Mouse.Y
      local Main = Frame_2
      
      local X1 = math.clamp((x - Main.AbsolutePosition.X) / Main.AbsoluteSize.X,0,1)
      local Y1 = math.clamp((y - Main.AbsolutePosition.Y) / Main.AbsoluteSize.Y,0,1)
      
      Color = {1-X1 or Color[1] , 1-Y1 or Color[2] , Color[3]}

      if x and y then
         TweenService:Create(Main.ImageLabel,TweenInfo.new(0.05),{
            ['Position'] = UDim2.new(1 - NewX,-5,1 - NewY,0)
         }):Play()
      else
         TweenService:Create(Main.ImageLabel,TweenInfo.new(0.05),{
            ['Position'] = UDim2.new(X1,-5,Y1 ,0)
         }):Play()
      end

      return X1,Y1
   end

   local function GetSaturation(NewY)
      local y = Mouse.Y
      local Saturation = cc

    	local Y1 = math.clamp((y - Saturation.AbsolutePosition.Y) / Saturation.AbsoluteSize.Y,0,1)
      Color = {Color[1] , Color[2] , Y1 or Color[3]}

      if y then
         TweenService:Create(Mover,TweenInfo.new(0.05),{
            ['Position'] = UDim2.new(Mover.Position.X.Scale,0,NewY,0)
         }):Play()
      else
         TweenService:Create(Mover,TweenInfo.new(0.05),{
            ['Position'] = UDim2.new(Mover.Position.X.Scale,0,Y1,0)
         }):Play()
      end

	   return Y1
   end

   local function SetColor(h,s,v)
      local Saturation = cc
      Color = {h or Color[1],s or Color[2], v or Color[3]}
      Select.BackgroundColor3 = Color3.fromHSV(unpack(Color))
      Saturation.BackgroundColor3 = Color3.fromHSV(Color[1],Color[2],1)

    
      local res = Functions:HSV2RGB(Color[1],Color[2],Color[3])

      callback(Color3.new(res.r,res.g,res.b))
   end
 
   Functions:DraggingEnded(function()
      mouseDown,mouseDown1 = false,false
   end)


   if default then
      local h,s,v = Color3.toHSV(default)
      SetColor(h,s,v)
      Getp(h,v)
      GetSaturation(s)
   end


   Frame_2.InputBegan:Connect(function(a)
      local Main = Frame_2
      if a.UserInputType == Enum.UserInputType.MouseButton1 then
         mouseDown = true

         while mouseDown do
            local x,y = Getp()
            SetColor(1 - x,1 - y,nil)
            RunService.RenderStepped:Wait()
         end
      end
   end)

   cc.InputBegan:Connect(function(a)
      if a.UserInputType == Enum.UserInputType.MouseButton1 then
         mouseDown1 = true

         while mouseDown1 do
            local Y = GetSaturation()
            SetColor(nil,nil,Y)
            RunService.RenderStepped:Wait()
         end
      end
   end)
 

   Select.MouseButton1Click:Connect(function()

      Functions:Pop(Select,10)

      tabactive = not tabactive

      self:UpdateColorpicker(ColorPicker,nil,nil,tabactive)
   end)

   ColorPicker:GetPropertyChangedSignal("Size"):Connect(function()
      self:Resize()
   end)

end

function Section:UpdateColorpicker(picker,text,color,active)

   if picker then

      if text then
         picker.ColorPickerTitle.Text = text
      end

      if active ~= nil then
         
         val = active and "open" or "close"

         local sizes = {
               open = UDim2.new(0,430,0,170),
               close = UDim2.new(0,430,0,30)
         }

         Functions:Tween(picker,{Size = sizes[val]},0.2)
      end
   end
end
return Library
