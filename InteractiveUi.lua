repeat wait() until game.Players.LocalPlayer ~= nil;

game.Players.LocalPlayer:Kick('Check readme.');
return;

local UserInputService = game:GetService("UserInputService")
local LocalPlayer = game.Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")

local themes = {
   TextColor = Color3.fromRGB(213,213,213),
   MainBackground = Color3.fromRGB(84, 89, 131),
   SubBackground = Color3.fromRGB(98, 105, 154),
   PageBackground = Color3.fromRGB(72, 76, 112),
   Glow = Color3.fromRGB(16,16,16),
   SectionBackground = Color3.fromRGB(99,105,154),
   ModuleBackground = Color3.fromRGB(84, 89, 131),
   InputBackground = Color3.fromRGB(66, 71, 103)
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

   local what = {
      image = "ImageTransparency",
      normal = "BackgroundTransparency"
   }
   
   val = what[string.find(object.ClassName,"Image") and "image" or "normal"]

   object[val] = 1
   Functions:Tween(clone, {Size = object.Size}, 0.2)
   
   spawn(function()
      wait(0.2)
   
      object[val] = 0
      clone:Destroy()
   end)
   
   return clone
end

function Functions:Create(ins,properties,child)
   local Instance = Instance.new(ins)

   for i,v in pairs (properties) do
      Instance[i] = v
   end

   for i,v in pairs (child or {}) do
      v.Parent = Instance
   end

   return Instance

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

Library.activated = true;

function Library.new(TitleText)
   local InteractiveUi = Instance.new("ScreenGui")
   local Main = Instance.new("Frame")
   local Glow = Instance.new("ImageLabel")
   local LeftSide = Instance.new("Frame")
   local Glow_2 = Instance.new("ImageLabel")
   local Title = Instance.new("TextLabel")
   local PageList = Instance.new("ScrollingFrame")
   local UIListLayout = Instance.new("UIListLayout")
   local RightSide = Instance.new("Frame")

   InteractiveUi.Name = "InteractiveUi"
   InteractiveUi.Parent = game:GetService("CoreGui")
   InteractiveUi.ResetOnSpawn = false

   local IntroSize = UDim2.new(0, 748, 0, 442)

   Main.Name = "Main"
   Main.Parent = InteractiveUi
   Main.BackgroundColor3 = Color3.fromRGB(84, 89, 131)
   Main.BorderSizePixel = 0
   Main.Position = UDim2.new(0.5, 0, 0.5, 0)
   Main.Size = UDim2.new(0, 0, 0, 0)
   Main.ClipsDescendants = true
   Main.AnchorPoint = Vector2.new(0.5,0.5)

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
   Title.Font = Enum.Font.SourceSansLight
   Title.Text = TitleText or "Interactive UI"
   Title.TextColor3 = Color3.fromRGB(255, 255, 255)
   Title.TextSize = 30.000
   Title.TextWrapped = true
   Title.TextXAlignment = Enum.TextXAlignment.Left

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

   wait(.3)

   Functions:Tween(Main,{Size = IntroSize},0.3)

   wait(.2)

   Main.ClipsDescendants = false

   return setmetatable({
      Main = Main,
      Library = self,
      PageList = PageList,
      PageContainer = RightSide,
      pages = {},
      Screen = InteractiveUi
   },Library)
end

function Library:addNoti(title,text,callback)

   local Notification = Instance.new("Frame")
   local Glow = Instance.new("ImageLabel")
   local Main = Instance.new("Frame")
   local Accept = Instance.new("ImageButton")
   local Decline = Instance.new("ImageButton")
   local Top = Instance.new("Frame")
   local Glow_2 = Instance.new("ImageLabel")
   local Title = Instance.new("TextLabel")
   local Content = Instance.new("TextLabel")

   callback = callback or function(cb) end;

   Notification.Name = "Notification"
   Notification.Parent = self.Screen
   Notification.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
   Notification.BorderSizePixel = 0
   Notification.Position = UDim2.new(0, 180, 1, -90)
   Notification.Size = UDim2.new(0, 0, 0, 0)
   Notification.ClipsDescendants = true
   Notification.AnchorPoint = Vector2.new(0.5,0.5)

   Glow.Name = "Glow"
   Glow.Parent = Notification
   Glow.BackgroundColor3 = Color3.fromRGB(229, 229, 229)
   Glow.BackgroundTransparency = 1.000
   Glow.BorderSizePixel = 0
   Glow.Position = UDim2.new(0, -15, 0, -15)
   Glow.Size = UDim2.new(1, 30, 1, 30)
   Glow.Image = "http://www.roblox.com/asset/?id=5028857084"
   Glow.ImageColor3 = Color3.fromRGB(39, 39, 39)
   Glow.ScaleType = Enum.ScaleType.Slice
   Glow.SliceCenter = Rect.new(24, 24, 276, 276)

   Main.Name = "Main"
   Main.Parent = Notification
   Main.BackgroundColor3 = Color3.fromRGB(84, 89, 131)
   Main.BorderSizePixel = 0
   Main.Size = UDim2.new(1, 0, 1, 0)

   Accept.Name = "Accept"
   Accept.Parent = Main
   Accept.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
   Accept.BackgroundTransparency = 1.000
   Accept.Position = UDim2.new(1, -30, 0.769999981, 0)
   Accept.Size = UDim2.new(0, 23, 0, 23)
   Accept.Image = "http://www.roblox.com/asset/?id=6507915574"

   Decline.Name = "Decline"
   Decline.Parent = Main
   Decline.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
   Decline.BackgroundTransparency = 1.000
   Decline.Position = UDim2.new(1, -50, 0.769999981, 0)
   Decline.Size = UDim2.new(0, 23, 0, 23)
   Decline.Image = "rbxassetid://5012538583"

   Top.Name = "Top"
   Top.Parent = Main
   Top.BackgroundColor3 = Color3.fromRGB(72, 76, 112)
   Top.BorderSizePixel = 0
   Top.Size = UDim2.new(1, 0, 0, 25)

   Glow_2.Name = "Glow"
   Glow_2.Parent = Top
   Glow_2.BackgroundColor3 = Color3.fromRGB(229, 229, 229)
   Glow_2.BackgroundTransparency = 1.000
   Glow_2.BorderSizePixel = 0
   Glow_2.Position = UDim2.new(0, -15, 0, -15)
   Glow_2.Size = UDim2.new(1, 30, 1, 30)
   Glow_2.Image = "http://www.roblox.com/asset/?id=5028857084"
   Glow_2.ImageColor3 = Color3.fromRGB(39, 39, 39)
   Glow_2.ScaleType = Enum.ScaleType.Slice
   Glow_2.SliceCenter = Rect.new(24, 24, 276, 276)

   Title.Name = "Title"
   Title.Parent = Top
   Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
   Title.BackgroundTransparency = 1.000
   Title.Size = UDim2.new(0, 317, 0, 25)
   Title.Font = Enum.Font.Gotham
   Title.Text = title or "Title"
   Title.TextColor3 = Color3.fromRGB(213, 213, 213)
   Title.TextSize = 14.000
   Title.TextXAlignment = Enum.TextXAlignment.Left

   Content.Name = "Content"
   Content.Parent = Main
   Content.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
   Content.BackgroundTransparency = 1.000
   Content.Position = UDim2.new(0, 0, 0.270000011, 0)
   Content.Size = UDim2.new(0, 317, 0, 50)
   Content.Font = Enum.Font.Gotham
   Content.Text = text or "Text"
   Content.TextColor3 = Color3.fromRGB(213, 213, 213)
   Content.TextSize = 16.000
   Content.TextXAlignment = Enum.TextXAlignment.Left

   if self.Notification then 
      self.Notification:Destroy()
      self.Notification = nil
   end

   self.Notification = Notification


   Functions:Draggable(Top,Notification)

   local TitleSize = TextService:GetTextSize(Title.Text,Title.TextSize,Title.Font,Vector2.new(math.huge,25))
   local ContentSize = TextService:GetTextSize(Content.Text,Content.TextSize,Content.Font,Vector2.new(math.huge,50))

   val = (TitleSize.X < ContentSize.X and ContentSize.X or TitleSize.X) + 20

   if self.lastNoti then
      Notification.Position = self.lastNoti
   end

   Functions:Tween(Notification,{Size = UDim2.new(0,val,0,100)},0.2)
   wait(.1)
   Notification.ClipsDescendants = false

   local closecallback = function(obj)
      Functions:Pop(obj,10)

      self.lastNoti = Notification.Position

      Notification.ClipsDescendants = true

      Functions:Tween(Notification,{Size = UDim2.new(0,0,0,0)},0.2)

      wait(.4)

      self.Notification = nil
      Notification:Destroy()

   end

   Accept.MouseButton1Down:Connect(function()
      closecallback(Accept)

      callback(true)
   end)

   Decline.MouseButton1Down:Connect(function()
      closecallback(Decline)

      callback(false)
   end)

end

function Page.new(Library,Title)
   local PageFrame = Instance.new("ScrollingFrame")
   local UIListLayout_2 = Instance.new("UIListLayout")
   local PageButton = Instance.new("TextButton")
   local UICorner = Instance.new("UICorner")
   local Glow = Instance.new("ImageLabel")

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
   PageButton.TextTransparency = 0.7

   Glow.Name = "Glow"
   Glow.Parent = PageButton
   Glow.BackgroundColor3 = Color3.fromRGB(229, 229, 229)
   Glow.BackgroundTransparency = 1.000
   Glow.BorderSizePixel = 0
   Glow.Position = UDim2.new(0, -15, 0, -15)
   Glow.Size = UDim2.new(1, 30, 1, 30)
   Glow.Image = "http://www.roblox.com/asset/?id=5028857084"
   Glow.ImageColor3 = Color3.fromRGB(39, 39, 39)
   Glow.ScaleType = Enum.ScaleType.Slice
   Glow.SliceCenter = Rect.new(24, 24, 276, 276)

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
   SectionFrame.ClipsDescendants = true

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
      binds = {},
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
      page.PageButton.TextTransparency = 0

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
      page.PageButton.TextTransparency = 0.7
      for i,v in pairs (page.Sections) do
         Functions:Tween(v.Container,{Size = UDim2.new(1,-30,0,0)},0.07)
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

function Library:Toggle()
   local DefaultSize = UDim2.new(0, 748, 0, 442)
   if self.activated then
      self.Main.ClipsDescendants = true
      Functions:Tween(self.Main,{Size = UDim2.new(0,0,0,0)},0.4)
      self.activated = false
      wait(.3)
   else
      Functions:Tween(self.Main,{Size = DefaultSize},0.4)
      wait(.3)
      self.activated = true
      self.Main.ClipsDescendants = false
   end
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
   local UICorner = Instance.new("UICorner")
   local Mover = Instance.new("ImageLabel")
   local Default = Instance.new("TextLabel")
   local Opposite = Instance.new("TextLabel")

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
   ToggleButton.Position = UDim2.new(0.860465229, 0, 0.0967741907, 0)
   ToggleButton.Size = UDim2.new(0, 51, 0, 24)
   ToggleButton.AutoButtonColor = false
   ToggleButton.Font = Enum.Font.SourceSans
   ToggleButton.Text = ""
   ToggleButton.TextColor3 = Color3.fromRGB(0, 0, 0)
   ToggleButton.TextSize = 14.000
   
   UICorner.CornerRadius = UDim.new(0, 15)
   UICorner.Parent = ToggleButton
   
   Mover.Name = "Mover"
   Mover.Parent = ToggleButton
   Mover.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
   Mover.BackgroundTransparency = 1.000
   Mover.Position = UDim2.new(0.0900000036, 0, 0.0829999968, 0)
   Mover.Size = UDim2.new(0, 20, 0, 20)
   Mover.Image = "rbxassetid://3570695787"
   Mover.ImageColor3 = Color3.fromRGB(229, 229, 229)
   Mover.ScaleType = Enum.ScaleType.Slice
   Mover.SliceCenter = Rect.new(100, 100, 100, 100)
   Mover.SliceScale = 0.130
   
   Default.Name = "Default"
   Default.Parent = Mover
   Default.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
   Default.BackgroundTransparency = 1.000
   Default.Position = UDim2.new(0.0716430694, 0, 0, 0)
   Default.Size = UDim2.new(0, 18, 0, 20)
   Default.Font = Enum.Font.SourceSans
   Default.Text = "✖"
   Default.TextColor3 = Color3.fromRGB(84, 89, 131)
   Default.TextSize = 14.000
   
   Opposite.Name = "Opposite"
   Opposite.Parent = Mover
   Opposite.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
   Opposite.BackgroundTransparency = 1.000
   Opposite.Position = UDim2.new(0.0716430694, 0, 0, 0)
   Opposite.Size = UDim2.new(0, 18, 0, 20)
   Opposite.Font = Enum.Font.SourceSans
   Opposite.Text = "✔"
   Opposite.TextColor3 = Color3.fromRGB(84, 89, 131)
   Opposite.TextSize = 14.000
   Opposite.TextTransparency = 1.000

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
         Default = UDim2.new(0.09, 0,0.083, 0),
         Opposite = UDim2.new(0.56, 0,0.083, 0)
      }

      local Colors = {
         Default = Color3.fromRGB(68, 68, 68),
         Opposite = Color3.fromRGB(80, 231, 113)
      }

      value = value and "Opposite" or "Default"
      Functions:Tween(Toggle.ToggleButton.Mover,{Position = Positions[value]},0.2)
      Functions:Tween(Toggle.ToggleButton.Mover.Default,{TextTransparency = (value == "Default" and 0 or 1)},0.2)
      Functions:Tween(Toggle.ToggleButton.Mover.Opposite,{TextTransparency = (value == "Opposite" and 0 or 1)},0.2)
      Functions:Tween(Toggle.ToggleButton,{BackgroundColor3 = Colors[value]},0.2)


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
         DropdownButton.TextColor3 = themes.TextColor
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
   Slider.BackgroundColor3 = themes.MainBackground
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
   SliderTitle.TextColor3 = themes.TextColor
   SliderTitle.TextSize = 13.000
   SliderTitle.TextXAlignment = Enum.TextXAlignment.Left

   Input.Name = "Input"
   Input.Parent = Slider
   Input.BackgroundColor3 = themes.InputBackground
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
   
   Functions:Create("UICorner",{
      Parent = Slider_2,
      CornerRadius = UDim.new(0,5)
   })

   SliderFrame.Name = "SliderFrame"
   SliderFrame.Parent = Slider_2
   SliderFrame.BackgroundColor3 = Color3.fromRGB(101, 107, 157)
   SliderFrame.BorderSizePixel = 0
   SliderFrame.Size = UDim2.new(0, 0, 1, 0)

   Functions:Create("UICorner",{
      Parent = SliderFrame,
      CornerRadius = UDim.new(0,5)
   })

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
         callback(math.clamp(val,min,max))

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
   Keybind.BackgroundColor3 = themes.MainBackground
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
   KeybindTitle.TextColor3 = themes.TextColor
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
   TextButton.TextColor3 = themes.TextColor
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
   Label.TextColor3 = themes.TextColor
   Label.TextSize = 14.000
end

function Section:AddTextbox(text,defualt,callback)
   local TextBox = Instance.new("Frame")
   local TextBoxTitle = Instance.new("TextLabel")
   local Boxinput = Instance.new("TextBox")

   TextBox.Name = "TextBox"
   TextBox.Parent = self.Container
   TextBox.BackgroundColor3 = themes.MainBackground
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
   TextBoxTitle.TextColor3 = themes.TextColor
   TextBoxTitle.TextSize = 14.000
   TextBoxTitle.TextXAlignment = Enum.TextXAlignment.Left

   Boxinput.Name = "Boxinput"
   Boxinput.Parent = TextBox
   Boxinput.BackgroundColor3 = themes.InputBackground
   Boxinput.Position = UDim2.new(0.527906954, 0, 0.100000001, 0)
   Boxinput.Size = UDim2.new(0, 197, 0, 24)
   Boxinput.Font = Enum.Font.Gotham
   Boxinput.PlaceholderText = defualt or "It was hard"
   Boxinput.Text = ""
   Boxinput.TextColor3 = themes.TextColor
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
   local Hue = Instance.new("Frame")
   local UIGradient = Instance.new("UIGradient")
   local Mover = Instance.new("ImageLabel")
   local SV = Instance.new("Frame")
   local White = Instance.new("Frame")
   local UIGradient_2 = Instance.new("UIGradient")
   local Black = Instance.new("Frame")
   local UIGradient_3 = Instance.new("UIGradient")
   local Mover_2 = Instance.new("ImageLabel")
   local R = Instance.new("TextLabel")
   local G = Instance.new("TextLabel")
   local B = Instance.new("TextLabel")
   
   
   ColorPicker.Name = "ColorPicker"
   ColorPicker.Parent = self.Container
   ColorPicker.BackgroundColor3 = themes.MainBackground
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
   ColorPickerTitle.TextColor3 = themes.TextColor
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
   
   UICorner.CornerRadius = UDim.new(0, 5)
   UICorner.Parent = Select
   
   Frame.Parent = ColorPicker
   Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
   Frame.BackgroundTransparency = 1.000
   Frame.ClipsDescendants = true
   Frame.Position = UDim2.new(0, 0, 0, 30)
   Frame.Size = UDim2.new(0, 430, 0, 140)
   
   Hue.Name = "Hue"
   Hue.Parent = Frame
   Hue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
   Hue.Position = UDim2.new(0.667934537, 0, 0.0199133735, 0)
   Hue.Size = UDim2.new(0, 21, 0, 116)
   
   UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)), ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)), ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)), ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)), ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)), ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0))}
   UIGradient.Rotation = 90
   UIGradient.Parent = Hue
   
   Mover.Name = "Mover"
   Mover.Parent = Hue
   Mover.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
   Mover.BackgroundTransparency = 1.000
   Mover.Position = UDim2.new(0.230373219, 0, 0.468468487, 0)
   Mover.Size = UDim2.new(0, 11, 0, 11)
   Mover.Image = "rbxassetid://5100115962"
   Mover.ImageColor3 = Color3.fromRGB(21, 21, 21)
   
   SV.Name = "SV"
   SV.Parent = Frame
   SV.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
   SV.BorderSizePixel = 0
   SV.Position = UDim2.new(0.362025917, 0, 0.0184223726, 0)
   SV.Size = UDim2.new(0, 118, 0, 118)
   
   White.Name = "White"
   White.Parent = SV
   White.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
   White.BorderSizePixel = 0
   White.Position = UDim2.new(-0.00562864542, 0, -0.00395159144, 0)
   White.Size = UDim2.new(1, 0, 1, 0)
   
   UIGradient_2.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.00), NumberSequenceKeypoint.new(0.00, 0.00), NumberSequenceKeypoint.new(1.00, 1.00)}
   UIGradient_2.Parent = White
   
   Black.Name = "Black"
   Black.Parent = SV
   Black.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
   Black.Position = UDim2.new(0.00198520441, 0, 0.00176904164, 0)
   Black.Size = UDim2.new(1, 0, 1, 0)
   
   UIGradient_3.Rotation = -90
   UIGradient_3.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.00), NumberSequenceKeypoint.new(0.00, 0.00), NumberSequenceKeypoint.new(1.00, 1.00)}
   UIGradient_3.Parent = Black
   
   Mover_2.Name = "Mover"
   Mover_2.Parent = SV
   Mover_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
   Mover_2.BackgroundTransparency = 1.000
   Mover_2.Position = UDim2.new(0.468468457, 0, 0.468468487, 0)
   Mover_2.Size = UDim2.new(0, 11, 0, 11)
   Mover_2.Image = "rbxassetid://5100115962"
   
   R.Name = "R"
   R.Parent = Frame
   R.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
   R.BackgroundTransparency = 1.000
   R.Position = UDim2.new(0.111627907, 0, 0.0142857283, 0)
   R.Size = UDim2.new(0, 79, 0, 19)
   R.Font = Enum.Font.Gotham
   R.Text = "R"
   R.TextColor3 = themes.TextColor
   R.TextSize = 14.000
   
   G.Name = "G"
   G.Parent = Frame
   G.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
   G.BackgroundTransparency = 1.000
   G.Position = UDim2.new(0.111627907, 0, 0.364285737, 0)
   G.Size = UDim2.new(0, 79, 0, 19)
   G.Font = Enum.Font.Gotham
   G.Text = "G"
   G.TextColor3 = themes.TextColor
   G.TextSize = 14.000
   
   B.Name = "B"
   B.Parent = Frame
   B.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
   B.BackgroundTransparency = 1.000
   B.Position = UDim2.new(0.111627907, 0, 0.707142889, 0)
   B.Size = UDim2.new(0, 79, 0, 19)
   B.Font = Enum.Font.Gotham
   B.Text = "B"
   B.TextColor3 = themes.TextColor
   B.TextSize = 14.000

   local HueDown = false
   local SVDown = false
   local tabactive = false

   local Color = {1,1,1}

   Functions:DraggingEnded(function()
      HueDown = false
      SVDown = false
   end)
 
   Hue.InputBegan:Connect(function(key)
      if key.UserInputType == Enum.UserInputType.MouseButton1 then
         HueDown = true
      end
   end)
   
   SV.InputBegan:Connect(function(key)
      if key.UserInputType == Enum.UserInputType.MouseButton1 then
         SVDown = true
      end
   end)

   SV.BackgroundColor3 = Color3.fromHSV(Color[1],1,1)

   if default then
      self:UpdateColorpicker(ColorPicker,nil,default)

      Color = {Color3.toHSV(default)}

   end

   RunService.RenderStepped:Connect(function()
      if HueDown then
         local Y = math.clamp((Mouse.Y - Hue.AbsolutePosition.Y) / Hue.AbsoluteSize.Y,0,1)
         
         Color = {Y,Color[2],Color[3]}
         self:UpdateColorpicker(ColorPicker,nil,Color,nil)

         local res = Functions:HSV2RGB(unpack(Color))

         callback(Color3.new(res.r,res.g,res.b))
      end
      
      if SVDown then
         local X = math.clamp((Mouse.X - SV.AbsolutePosition.X) / SV.AbsoluteSize.X,0,1)
         local Y = math.clamp((Mouse.Y - SV.AbsolutePosition.Y) / SV.AbsoluteSize.Y,0,1)
         
         self:UpdateColorpicker(ColorPicker,nil,{Color[1],X,Y},nil)

         Color = {Color[1],X,Y}
         
         local res = Functions:HSV2RGB(unpack(Color))

         callback(Color3.new(res.r,res.g,res.b))
      end
      
      RunService.RenderStepped:Wait()
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
         
         local val = active and "open" or "close"

         local sizes = {
               open = UDim2.new(0,430,0,170),
               close = UDim2.new(0,430,0,30)
         }

         Functions:Tween(picker,{Size = sizes[val]},0.2)
      end

      if color then
         local Hue = picker.Frame.Hue
         local SV = picker.Frame.SV
         local HMover = Hue.Mover
         local SVMover = SV.Mover

         local h,s,v
         local color3

         if type(color) == "table" then
            h,s,v = unpack(color)
         else
            color3 = color
            h,s,v = Color3.toHSV(color3)
         end

         Functions:Tween(picker.Select,{BackgroundColor3 = Color3.fromHSV(h,s,1 - v)},0.2)
         Functions:Tween(HMover,{Position = UDim2.new(0.23,0,h,0)},0.2)
         Functions:Tween(SVMover,{Position = UDim2.new(s,0,v,0)},0.2)
         Functions:Tween(SV,{BackgroundColor3 = Color3.fromHSV(h,1,1)},0.2)

      end
   end
end
return Library
