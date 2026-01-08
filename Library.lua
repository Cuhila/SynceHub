-- macOS Style UI Library by Synce
-- Modern, Clean, Mobile-Friendly

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Library = {}

-- Theme Colors (macOS style)
local Theme = {
    Background = Color3.fromRGB(240, 240, 245),
    Header = Color3.fromRGB(250, 250, 252),
    TabBar = Color3.fromRGB(245, 245, 248),
    TabActive = Color3.fromRGB(255, 255, 255),
    TabInactive = Color3.fromRGB(235, 235, 240),
    Text = Color3.fromRGB(30, 30, 30),
    TextSecondary = Color3.fromRGB(100, 100, 100),
    Accent = Color3.fromRGB(0, 122, 255),
    Border = Color3.fromRGB(220, 220, 225),
    Success = Color3.fromRGB(52, 199, 89),
    Close = Color3.fromRGB(255, 95, 86),
    Minimize = Color3.fromRGB(255, 189, 46),
    Maximize = Color3.fromRGB(40, 205, 65)
}

-- Utility Functions
local function CreateCorner(radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    return corner
end

local function CreateStroke(color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    return stroke
end

local function Tween(object, properties, duration)
    local tween = TweenService:Create(
        object,
        TweenInfo.new(duration or 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        properties
    )
    tween:Play()
    return tween
end

-- Create Window
function Library:CreateWindow(config)
    local WindowName = config.Name or "macOS Window"
    local WindowSize = config.Size or UDim2.new(0, 350, 0, 500)
    
    -- ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "macOSLibrary"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game.CoreGui
    
    -- Main Window
    local Window = Instance.new("Frame")
    Window.Name = "Window"
    Window.Size = WindowSize
    Window.Position = UDim2.new(0.5, -WindowSize.X.Offset/2, 0.5, -WindowSize.Y.Offset/2)
    Window.BackgroundColor3 = Theme.Background
    Window.BorderSizePixel = 0
    Window.ClipsDescendants = true
    Window.Parent = ScreenGui
    
    CreateCorner(12).Parent = Window
    CreateStroke(Theme.Border, 1).Parent = Window
    
    -- Shadow Effect
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.BackgroundTransparency = 1
    Shadow.Position = UDim2.new(0, -15, 0, -15)
    Shadow.Size = UDim2.new(1, 30, 1, 30)
    Shadow.ZIndex = 0
    Shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.8
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    Shadow.Parent = Window
    
    -- Header
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 40)
    Header.BackgroundColor3 = Theme.Header
    Header.BorderSizePixel = 0
    Header.Parent = Window
    
    CreateCorner(12).Parent = Header
    
    -- Header Bottom Border
    local HeaderBorder = Instance.new("Frame")
    HeaderBorder.Size = UDim2.new(1, 0, 0, 1)
    HeaderBorder.Position = UDim2.new(0, 0, 1, -1)
    HeaderBorder.BackgroundColor3 = Theme.Border
    HeaderBorder.BorderSizePixel = 0
    HeaderBorder.Parent = Header
    
    -- Window Controls Container
    local Controls = Instance.new("Frame")
    Controls.Name = "Controls"
    Controls.Size = UDim2.new(0, 70, 1, 0)
    Controls.Position = UDim2.new(0, 12, 0, 0)
    Controls.BackgroundTransparency = 1
    Controls.Parent = Header
    
    -- Close Button (Red)
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "Close"
    CloseBtn.Size = UDim2.new(0, 12, 0, 12)
    CloseBtn.Position = UDim2.new(0, 0, 0.5, -6)
    CloseBtn.BackgroundColor3 = Theme.Close
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Text = ""
    CloseBtn.AutoButtonColor = false
    CloseBtn.Parent = Controls
    
    CreateCorner(12).Parent = CloseBtn
    
    -- Minimize Button (Yellow)
    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Name = "Minimize"
    MinimizeBtn.Size = UDim2.new(0, 12, 0, 12)
    MinimizeBtn.Position = UDim2.new(0, 20, 0.5, -6)
    MinimizeBtn.BackgroundColor3 = Theme.Minimize
    MinimizeBtn.BorderSizePixel = 0
    MinimizeBtn.Text = ""
    MinimizeBtn.AutoButtonColor = false
    MinimizeBtn.Parent = Controls
    
    CreateCorner(12).Parent = MinimizeBtn
    
    -- Maximize Button (Green)
    local MaximizeBtn = Instance.new("TextButton")
    MaximizeBtn.Name = "Maximize"
    MaximizeBtn.Size = UDim2.new(0, 12, 0, 12)
    MaximizeBtn.Position = UDim2.new(0, 40, 0.5, -6)
    MaximizeBtn.BackgroundColor3 = Theme.Maximize
    MaximizeBtn.BorderSizePixel = 0
    MaximizeBtn.Text = ""
    MaximizeBtn.AutoButtonColor = false
    MaximizeBtn.Parent = Controls
    
    CreateCorner(12).Parent = MaximizeBtn
    
    -- Window Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -160, 1, 0)
    Title.Position = UDim2.new(0, 80, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = WindowName
    Title.TextColor3 = Theme.Text
    Title.TextSize = 13
    Title.Font = Enum.Font.GothamMedium
    Title.TextXAlignment = Enum.TextXAlignment.Center
    Title.Parent = Header
    
    -- Tab Bar
    local TabBar = Instance.new("Frame")
    TabBar.Name = "TabBar"
    TabBar.Size = UDim2.new(1, 0, 0, 45)
    TabBar.Position = UDim2.new(0, 0, 0, 40)
    TabBar.BackgroundColor3 = Theme.TabBar
    TabBar.BorderSizePixel = 0
    TabBar.Parent = Window
    
    -- Tab Container (Scrolling)
    local TabScroll = Instance.new("ScrollingFrame")
    TabScroll.Name = "TabScroll"
    TabScroll.Size = UDim2.new(1, -20, 1, 0)
    TabScroll.Position = UDim2.new(0, 10, 0, 0)
    TabScroll.BackgroundTransparency = 1
    TabScroll.BorderSizePixel = 0
    TabScroll.ScrollBarThickness = 0
    TabScroll.ScrollingDirection = Enum.ScrollingDirection.X
    TabScroll.CanvasSize = UDim2.new(0, 0, 1, 0)
    TabScroll.Parent = TabBar
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    TabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    TabLayout.Padding = UDim.new(0, 8)
    TabLayout.Parent = TabScroll
    
    -- Content Container
    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.Size = UDim2.new(1, 0, 1, -85)
    Content.Position = UDim2.new(0, 0, 0, 85)
    Content.BackgroundTransparency = 1
    Content.Parent = Window
    
    -- Window Functions
    local WindowFunctions = {}
    WindowFunctions.CurrentTab = nil
    WindowFunctions.Tabs = {}
    WindowFunctions.Minimized = false
    WindowFunctions.OriginalSize = WindowSize
    
    -- Make Window Draggable
    local dragging = false
    local dragInput, mousePos, framePos
    
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            mousePos = input.Position
            framePos = Window.Position
        end
    end)
    
    Header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    Header.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            Tween(Window, {
                Position = UDim2.new(
                    framePos.X.Scale,
                    framePos.X.Offset + delta.X,
                    framePos.Y.Scale,
                    framePos.Y.Offset + delta.Y
                )
            }, 0.1)
        end
    end)
    
    -- Close Button
    CloseBtn.MouseButton1Click:Connect(function()
        Tween(Window, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        wait(0.3)
        ScreenGui:Destroy()
    end)
    
    -- Minimize Button
    MinimizeBtn.MouseButton1Click:Connect(function()
        if not WindowFunctions.Minimized then
            WindowFunctions.Minimized = true
            Tween(Window, {Size = UDim2.new(0, WindowSize.X.Offset, 0, 40)}, 0.3)
        else
            WindowFunctions.Minimized = false
            Tween(Window, {Size = WindowFunctions.OriginalSize}, 0.3)
        end
    end)
    
    -- Maximize Button
    local maximized = false
    MaximizeBtn.MouseButton1Click:Connect(function()
        if not maximized then
            maximized = true
            WindowFunctions.OriginalSize = Window.Size
            Tween(Window, {
                Size = UDim2.new(0, 500, 0, 650),
                Position = UDim2.new(0.5, -250, 0.5, -325)
            }, 0.3)
        else
            maximized = false
            Tween(Window, {
                Size = WindowSize,
                Position = UDim2.new(0.5, -WindowSize.X.Offset/2, 0.5, -WindowSize.Y.Offset/2)
            }, 0.3)
        end
    end)
    
    -- Create Tab Function
    function WindowFunctions:CreateTab(tabName, icon)
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName
        TabButton.Size = UDim2.new(0, 80, 0, 32)
        TabButton.BackgroundColor3 = Theme.TabInactive
        TabButton.BorderSizePixel = 0
        TabButton.Text = tabName
        TabButton.TextColor3 = Theme.TextSecondary
        TabButton.TextSize = 12
        TabButton.Font = Enum.Font.GothamMedium
        TabButton.AutoButtonColor = false
        TabButton.Parent = TabScroll
        
        CreateCorner(8).Parent = TabButton
        
        -- Tab Content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = tabName .. "Content"
        TabContent.Size = UDim2.new(1, -20, 1, -10)
        TabContent.Position = UDim2.new(0, 10, 0, 5)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 4
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.Visible = false
        TabContent.Parent = Content
        
        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.Padding = UDim.new(0, 10)
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Parent = TabContent
        
        -- Auto-resize canvas
        ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 10)
        end)
        
        -- Tab Functions
        local TabFunctions = {}
        
        TabButton.MouseButton1Click:Connect(function()
            -- Deselect all tabs
            for _, tab in pairs(WindowFunctions.Tabs) do
                tab.Button.BackgroundColor3 = Theme.TabInactive
                tab.Button.TextColor3 = Theme.TextSecondary
                tab.Content.Visible = false
            end
            
            -- Select this tab
            TabButton.BackgroundColor3 = Theme.TabActive
            TabButton.TextColor3 = Theme.Text
            TabContent.Visible = true
            WindowFunctions.CurrentTab = TabFunctions
        end)
        
        -- Auto-select first tab
        if #WindowFunctions.Tabs == 0 then
            TabButton.BackgroundColor3 = Theme.TabActive
            TabButton.TextColor3 = Theme.Text
            TabContent.Visible = true
            WindowFunctions.CurrentTab = TabFunctions
        end
        
        table.insert(WindowFunctions.Tabs, {
            Button = TabButton,
            Content = TabContent,
            Functions = TabFunctions
        })
        
        -- Update canvas size
        TabScroll.CanvasSize = UDim2.new(0, TabLayout.AbsoluteContentSize.X, 0, 0)
        
        -- Create Section
        function TabFunctions:CreateSection(sectionName)
            local Section = Instance.new("TextLabel")
            Section.Name = sectionName
            Section.Size = UDim2.new(1, 0, 0, 25)
            Section.BackgroundTransparency = 1
            Section.Text = sectionName
            Section.TextColor3 = Theme.TextSecondary
            Section.TextSize = 11
            Section.Font = Enum.Font.GothamBold
            Section.TextXAlignment = Enum.TextXAlignment.Left
            Section.Parent = TabContent
        end
        
        -- Create Toggle
        function TabFunctions:CreateToggle(config)
            local ToggleName = config.Name or "Toggle"
            local DefaultValue = config.Default or false
            local Callback = config.Callback or function() end
            
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = ToggleName
            ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Parent = TabContent
            
            CreateCorner(8).Parent = ToggleFrame
            CreateStroke(Theme.Border, 1).Parent = ToggleFrame
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
            ToggleLabel.Position = UDim2.new(0, 12, 0, 0)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Text = ToggleName
            ToggleLabel.TextColor3 = Theme.Text
            ToggleLabel.TextSize = 13
            ToggleLabel.Font = Enum.Font.Gotham
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Parent = ToggleFrame
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Size = UDim2.new(0, 44, 0, 24)
            ToggleButton.Position = UDim2.new(1, -54, 0.5, -12)
            ToggleButton.BackgroundColor3 = Theme.Border
            ToggleButton.BorderSizePixel = 0
            ToggleButton.Text = ""
            ToggleButton.AutoButtonColor = false
            ToggleButton.Parent = ToggleFrame
            
            CreateCorner(12).Parent = ToggleButton
            
            local ToggleIndicator = Instance.new("Frame")
            ToggleIndicator.Size = UDim2.new(0, 20, 0, 20)
            ToggleIndicator.Position = UDim2.new(0, 2, 0, 2)
            ToggleIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleIndicator.BorderSizePixel = 0
            ToggleIndicator.Parent = ToggleButton
            
            CreateCorner(10).Parent = ToggleIndicator
            
            local toggled = DefaultValue
            
            local function UpdateToggle()
                if toggled then
                    Tween(ToggleButton, {BackgroundColor3 = Theme.Success}, 0.2)
                    Tween(ToggleIndicator, {Position = UDim2.new(0, 22, 0, 2)}, 0.2)
                else
                    Tween(ToggleButton, {BackgroundColor3 = Theme.Border}, 0.2)
                    Tween(ToggleIndicator, {Position = UDim2.new(0, 2, 0, 2)}, 0.2)
                end
                Callback(toggled)
            end
            
            ToggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                UpdateToggle()
            end)
            
            if DefaultValue then
                UpdateToggle()
            end
            
            return {
                Set = function(value)
                    toggled = value
                    UpdateToggle()
                end
            }
        end
        
        -- Create Button
        function TabFunctions:CreateButton(config)
            local ButtonName = config.Name or "Button"
            local Callback = config.Callback or function() end
            
            local ButtonFrame = Instance.new("TextButton")
            ButtonFrame.Name = ButtonName
            ButtonFrame.Size = UDim2.new(1, 0, 0, 40)
            ButtonFrame.BackgroundColor3 = Theme.Accent
            ButtonFrame.BorderSizePixel = 0
            ButtonFrame.Text = ButtonName
            ButtonFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
            ButtonFrame.TextSize = 13
            ButtonFrame.Font = Enum.Font.GothamMedium
            ButtonFrame.AutoButtonColor = false
            ButtonFrame.Parent = TabContent
            
            CreateCorner(8).Parent = ButtonFrame
            
            ButtonFrame.MouseButton1Click:Connect(function()
                Tween(ButtonFrame, {BackgroundColor3 = Color3.fromRGB(0, 102, 204)}, 0.1)
                wait(0.1)
                Tween(ButtonFrame, {BackgroundColor3 = Theme.Accent}, 0.1)
                Callback()
            end)
        end
        
        -- Create Input
        function TabFunctions:CreateInput(config)
            local InputName = config.Name or "Input"
            local Placeholder = config.Placeholder or "Enter text..."
            local Callback = config.Callback or function() end
            
            local InputFrame = Instance.new("Frame")
            InputFrame.Name = InputName
            InputFrame.Size = UDim2.new(1, 0, 0, 65)
            InputFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            InputFrame.BorderSizePixel = 0
            InputFrame.Parent = TabContent
            
            CreateCorner(8).Parent = InputFrame
            CreateStroke(Theme.Border, 1).Parent = InputFrame
            
            local InputLabel = Instance.new("TextLabel")
            InputLabel.Size = UDim2.new(1, -20, 0, 20)
            InputLabel.Position = UDim2.new(0, 10, 0, 8)
            InputLabel.BackgroundTransparency = 1
            InputLabel.Text = InputName
            InputLabel.TextColor3 = Theme.Text
            InputLabel.TextSize = 12
            InputLabel.Font = Enum.Font.GothamMedium
            InputLabel.TextXAlignment = Enum.TextXAlignment.Left
            InputLabel.Parent = InputFrame
            
            local TextBox = Instance.new("TextBox")
            TextBox.Size = UDim2.new(1, -20, 0, 30)
            TextBox.Position = UDim2.new(0, 10, 0, 30)
            TextBox.BackgroundColor3 = Theme.TabBar
            TextBox.BorderSizePixel = 0
            TextBox.PlaceholderText = Placeholder
            TextBox.Text = ""
            TextBox.TextColor3 = Theme.Text
            TextBox.PlaceholderColor3 = Theme.TextSecondary
            TextBox.TextSize = 12
            TextBox.Font = Enum.Font.Gotham
            TextBox.ClearTextOnFocus = false
            TextBox.Parent = InputFrame
            
            CreateCorner(6).Parent = TextBox
            
            TextBox.FocusLost:Connect(function(enter)
                if enter then
                    Callback(TextBox.Text)
                end
            end)
        end
        
        return TabFunctions
    end
    
    -- Notification System
    function WindowFunctions:Notify(config)
        local NotifTitle = config.Title or "Notification"
        local NotifText = config.Text or ""
        local Duration = config.Duration or 3
        
        local Notif = Instance.new("Frame")
        Notif.Size = UDim2.new(0, 0, 0, 70)
        Notif.Position = UDim2.new(1, -20, 1, -90)
        Notif.AnchorPoint = Vector2.new(1, 0)
        Notif.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Notif.BorderSizePixel = 0
        Notif.ClipsDescendants = true
        Notif.Parent = ScreenGui
        
        CreateCorner(10).Parent = Notif
        CreateStroke(Theme.Border, 1).Parent = Notif
        
        local NotifTitleLabel = Instance.new("TextLabel")
        NotifTitleLabel.Size = UDim2.new(1, -20, 0, 20)
        NotifTitleLabel.Position = UDim2.new(0, 10, 0, 10)
        NotifTitleLabel.BackgroundTransparency = 1
        NotifTitleLabel.Text = NotifTitle
        NotifTitleLabel.TextColor3 = Theme.Text
        NotifTitleLabel.TextSize = 13
        NotifTitleLabel.Font = Enum.Font.GothamBold
        NotifTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        NotifTitleLabel.Parent = Notif
        
        local NotifTextLabel = Instance.new("TextLabel")
        NotifTextLabel.Size = UDim2.new(1, -20, 0, 30)
        NotifTextLabel.Position = UDim2.new(0, 10, 0, 32)
        NotifTextLabel.BackgroundTransparency = 1
        NotifTextLabel.Text = NotifText
        NotifTextLabel.TextColor3 = Theme.TextSecondary
        NotifTextLabel.TextSize = 11
        NotifTextLabel.Font = Enum.Font.Gotham
        NotifTextLabel.TextXAlignment = Enum.TextXAlignment.Left
        NotifTextLabel.TextYAlignment = Enum.TextYAlignment.Top
        NotifTextLabel.TextWrapped = true
        NotifTextLabel.Parent = Notif
        
        -- Animate in
        Tween(Notif, {Size = UDim2.new(0, 280, 0, 70)}, 0.4)
        
        -- Auto dismiss
        task.delay(Duration, function()
            Tween(Notif, {Size = UDim2.new(0, 0, 0, 70)}, 0.3)
            task.wait(0.3)
            Notif:Destroy()
        end)
    end
    
    return WindowFunctions
end

return Library
  