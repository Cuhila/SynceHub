-- SynceHub Library - Fixed Version
-- Part 1 of 4
-- Copy paste semua part secara berurutan (Part 1 -> Part 2 -> Part 3 -> Part 4)

local Library = {}
Library.__index = Library

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Theme
local Theme = {
	Background = Color3.fromRGB(240, 240, 245),
	Secondary = Color3.fromRGB(255, 255, 255),
	Tertiary = Color3.fromRGB(230, 230, 235),
	Text = Color3.fromRGB(50, 50, 50),
	TextDark = Color3.fromRGB(80, 80, 80),
	Accent = Color3.fromRGB(0, 122, 255),
	AccentDark = Color3.fromRGB(0, 100, 220),
	Toggle = Color3.fromRGB(52, 199, 89),
	Shadow = Color3.fromRGB(0, 0, 0),
	Red = Color3.fromRGB(255, 69, 58),
	Yellow = Color3.fromRGB(255, 214, 10),
	Green = Color3.fromRGB(52, 199, 89)
}

-- Utility Functions
local function Tween(instance, properties, duration)
	duration = duration or 0.3
	local tween = TweenService:Create(instance, TweenInfo.new(duration, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), properties)
	tween:Play()
	return tween
end

local function MakeDraggable(frame, handle)
	local dragging, dragInput, mousePos, framePos
	
	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			mousePos = input.Position
			framePos = frame.Position
			
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	
	handle.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - mousePos
			Tween(frame, {Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)}, 0.1)
		end
	end)
end

local function CreateShadow(parent)
	local shadow = Instance.new("ImageLabel")
	shadow.Name = "Shadow"
	shadow.BackgroundTransparency = 1
	shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
	shadow.ImageColor3 = Theme.Shadow
	shadow.ImageTransparency = 0.7
	shadow.Position = UDim2.new(0, -15, 0, -15)
	shadow.Size = UDim2.new(1, 30, 1, 30)
	shadow.ZIndex = parent.ZIndex - 1
	shadow.Parent = parent
	return shadow
end

-- Main Library Function
function Library:CreateWindow(config)
	config = config or {}
	config.Title = config.Title or "SynceHub"
	config.Size = config.Size or UDim2.new(0, 550, 0, 450)
	config.Theme = config.Theme or Theme
	
	local Window = {
		Tabs = {},
		CurrentTab = nil
	}
	
	-- ScreenGui
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "SynceHub"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.Parent = game:GetService("CoreGui")
	
	-- Main Frame
	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.BackgroundColor3 = Theme.Background
	MainFrame.BorderSizePixel = 0
	MainFrame.Position = UDim2.new(0.5, -275, 0.5, -225)
	MainFrame.Size = config.Size
	MainFrame.ClipsDescendants = true
	MainFrame.Parent = ScreenGui
	
	local MainCorner = Instance.new("UICorner")
	MainCorner.CornerRadius = UDim.new(0, 12)
	MainCorner.Parent = MainFrame
	
	CreateShadow(MainFrame)
	
	-- Top Bar
	local TopBar = Instance.new("Frame")
	TopBar.Name = "TopBar"
	TopBar.BackgroundColor3 = Theme.Secondary
	TopBar.BorderSizePixel = 0
	TopBar.Size = UDim2.new(1, 0, 0, 50)
	TopBar.ClipsDescendants = true
	TopBar.Parent = MainFrame
	
	local TopBarCorner = Instance.new("UICorner")
	TopBarCorner.CornerRadius = UDim.new(0, 12)
	TopBarCorner.Parent = TopBar
	
	-- Fix untuk corner bawah topbar agar tidak lancip
	local TopBarFix = Instance.new("Frame")
	TopBarFix.Name = "CornerFix"
	TopBarFix.BackgroundColor3 = Theme.Secondary
	TopBarFix.BorderSizePixel = 0
	TopBarFix.Position = UDim2.new(0, 0, 1, -12)
	TopBarFix.Size = UDim2.new(1, 0, 0, 12)
	TopBarFix.Parent = TopBar
	
	MakeDraggable(MainFrame, TopBar)
	
	-- Title
	local Title = Instance.new("TextLabel")
	Title.Name = "Title"
	Title.BackgroundTransparency = 1
	Title.Position = UDim2.new(0, 20, 0, 0)
	Title.Size = UDim2.new(1, -140, 1, 0)
	Title.Font = Enum.Font.GothamBold
	Title.Text = config.Title
	Title.TextColor3 = Theme.Text
	Title.TextSize = 16
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Parent = TopBar
	
	-- Window Controls
	local ControlsFrame = Instance.new("Frame")
	ControlsFrame.Name = "Controls"
	ControlsFrame.BackgroundTransparency = 1
	ControlsFrame.Position = UDim2.new(1, -120, 0, 0)
	ControlsFrame.Size = UDim2.new(0, 120, 1, 0)
	ControlsFrame.Parent = TopBar
	
	local ControlsList = Instance.new("UIListLayout")
	ControlsList.FillDirection = Enum.FillDirection.Horizontal
	ControlsList.HorizontalAlignment = Enum.HorizontalAlignment.Right
	ControlsList.Padding = UDim.new(0, 8)
	ControlsList.Parent = ControlsFrame
	
	local ControlsPadding = Instance.new("UIPadding")
	ControlsPadding.PaddingRight = UDim.new(0, 15)
	ControlsPadding.Parent = ControlsFrame

	-- Control Buttons
	local function CreateControl(name, color)
		local btn = Instance.new("TextButton")
		btn.Name = name
		btn.BackgroundColor3 = color
		btn.BorderSizePixel = 0
		btn.Size = UDim2.new(0, 12, 0, 12)
		btn.Text = ""
		btn.AutoButtonColor = false
		btn.Parent = ControlsFrame
		
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(1, 0)
		corner.Parent = btn
		
		btn.MouseEnter:Connect(function()
			Tween(btn, {BackgroundColor3 = Color3.new(color.R * 0.8, color.G * 0.8, color.B * 0.8)})
		end)
		
		btn.MouseLeave:Connect(function()
			Tween(btn, {BackgroundColor3 = color})
		end)
		
		return btn
	end
	
	local MinimizeBtn = CreateControl("Minimize", Theme.Yellow)
	local MaximizeBtn = CreateControl("Maximize", Theme.Green)
	local CloseBtn = CreateControl("Close", Theme.Red)
	
	local minimized = false
	local originalSize = MainFrame.Size
	
	MinimizeBtn.MouseButton1Click:Connect(function()
		minimized = not minimized
		if minimized then
			Tween(MainFrame, {Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, 0, 50)})
		else
			Tween(MainFrame, {Size = originalSize})
		end
	end)
	
	CloseBtn.MouseButton1Click:Connect(function()
		Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
		wait(0.3)
		ScreenGui:Destroy()
	end)
	
	-- Container
	local Container = Instance.new("Frame")
	Container.Name = "Container"
	Container.BackgroundTransparency = 1
	Container.Position = UDim2.new(0, 0, 0, 50)
	Container.Size = UDim2.new(1, 0, 1, -50)
	Container.ClipsDescendants = true
	Container.Parent = MainFrame
	
	-- Tab List
	local TabList = Instance.new("ScrollingFrame")
	TabList.Name = "TabList"
	TabList.BackgroundColor3 = Theme.Secondary
	TabList.BorderSizePixel = 0
	TabList.Size = UDim2.new(0, 170, 1, 0)
	TabList.ScrollBarThickness = 0
	TabList.CanvasSize = UDim2.new(0, 0, 0, 0)
	TabList.AutomaticCanvasSize = Enum.AutomaticSize.Y
	TabList.ScrollingDirection = Enum.ScrollingDirection.Y
	TabList.Parent = Container
	
	local TabListCorner = Instance.new("UICorner")
	TabListCorner.CornerRadius = UDim.new(0, 12)
	TabListCorner.Parent = TabList
	
	-- Fix untuk corner kanan tablist agar tidak lancip
	local TabListFix = Instance.new("Frame")
	TabListFix.Name = "CornerFix"
	TabListFix.BackgroundColor3 = Theme.Secondary
	TabListFix.BorderSizePixel = 0
	TabListFix.Position = UDim2.new(1, -12, 0, 0)
	TabListFix.Size = UDim2.new(0, 12, 1, 0)
	TabListFix.Parent = TabList
	
	local TabListLayout = Instance.new("UIListLayout")
	TabListLayout.Padding = UDim.new(0, 8)
	TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	TabListLayout.Parent = TabList
	
	local TabListPadding = Instance.new("UIPadding")
	TabListPadding.PaddingTop = UDim.new(0, 15)
	TabListPadding.PaddingBottom = UDim.new(0, 15)
	TabListPadding.PaddingLeft = UDim.new(0, 15)
	TabListPadding.PaddingRight = UDim.new(0, 15)
	TabListPadding.Parent = TabList
	
	-- Content Frame
	local ContentFrame = Instance.new("Frame")
	ContentFrame.Name = "ContentFrame"
	ContentFrame.BackgroundTransparency = 1
	ContentFrame.Position = UDim2.new(0, 185, 0, 0)
	ContentFrame.Size = UDim2.new(1, -200, 1, 0)
	ContentFrame.ClipsDescendants = true
	ContentFrame.Parent = Container
	
	-- Tab Functions
	function Window:CreateTab(tabName)
		local Tab = {
			Name = tabName,
			Sections = {}
		}
		
		-- Tab Button
		local TabButton = Instance.new("TextButton")
		TabButton.Name = tabName
		TabButton.BackgroundColor3 = Theme.Tertiary
		TabButton.BorderSizePixel = 0
		TabButton.Size = UDim2.new(1, 0, 0, 40)
		TabButton.Font = Enum.Font.GothamMedium
		TabButton.Text = tabName
		TabButton.TextColor3 = Theme.TextDark
		TabButton.TextSize = 14
		TabButton.AutoButtonColor = false
		TabButton.Parent = TabList
		
		local TabButtonCorner = Instance.new("UICorner")
		TabButtonCorner.CornerRadius = UDim.new(0, 8)
		TabButtonCorner.Parent = TabButton
		
		-- Tab Content
		local TabContent = Instance.new("ScrollingFrame")
		TabContent.Name = tabName .. "Content"
		TabContent.BackgroundTransparency = 1
		TabContent.Size = UDim2.new(1, 0, 1, 0)
		TabContent.ScrollBarThickness = 4
		TabContent.ScrollBarImageColor3 = Theme.Accent
		TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
		TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
		TabContent.ScrollingDirection = Enum.ScrollingDirection.Y
		TabContent.Visible = false
		TabContent.ClipsDescendants = true
		TabContent.Parent = ContentFrame
		
		local TabContentLayout = Instance.new("UIListLayout")
		TabContentLayout.Padding = UDim.new(0, 12)
		TabContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
		TabContentLayout.Parent = TabContent
		
		local TabContentPadding = Instance.new("UIPadding")
		TabContentPadding.PaddingTop = UDim.new(0, 15)
		TabContentPadding.PaddingBottom = UDim.new(0, 15)
		TabContentPadding.PaddingLeft = UDim.new(0, 0)
		TabContentPadding.PaddingRight = UDim.new(0, 15)
		TabContentPadding.Parent = TabContent
		
		TabButton.MouseButton1Click:Connect(function()
			for _, tab in pairs(Window.Tabs) do
				tab.Button.BackgroundColor3 = Theme.Tertiary
				tab.Button.TextColor3 = Theme.TextDark
				tab.Content.Visible = false
			end
			
			TabButton.BackgroundColor3 = Theme.Accent
			TabButton.TextColor3 = Theme.Secondary
			TabContent.Visible = true
			Window.CurrentTab = Tab
		end)
		
		Tab.Button = TabButton
		Tab.Content = TabContent
		table.insert(Window.Tabs, Tab)
		
		if #Window.Tabs == 1 then
			TabButton.BackgroundColor3 = Theme.Accent
			TabButton.TextColor3 = Theme.Secondary
			TabContent.Visible = true
			Window.CurrentTab = Tab
		end

		-- Section Functions
		function Tab:CreateSection(sectionName)
			local Section = {}
			
			local SectionFrame = Instance.new("Frame")
			SectionFrame.Name = sectionName
			SectionFrame.BackgroundColor3 = Theme.Secondary
			SectionFrame.BorderSizePixel = 0
			SectionFrame.Size = UDim2.new(1, 0, 0, 0)
			SectionFrame.AutomaticSize = Enum.AutomaticSize.Y
			SectionFrame.ClipsDescendants = false
			SectionFrame.Parent = TabContent
			
			local SectionCorner = Instance.new("UICorner")
			SectionCorner.CornerRadius = UDim.new(0, 10)
			SectionCorner.Parent = SectionFrame
			
			local SectionLayout = Instance.new("UIListLayout")
			SectionLayout.Padding = UDim.new(0, 10)
			SectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
			SectionLayout.Parent = SectionFrame
			
			local SectionPadding = Instance.new("UIPadding")
			SectionPadding.PaddingTop = UDim.new(0, 15)
			SectionPadding.PaddingBottom = UDim.new(0, 15)
			SectionPadding.PaddingLeft = UDim.new(0, 15)
			SectionPadding.PaddingRight = UDim.new(0, 15)
			SectionPadding.Parent = SectionFrame
			
			if sectionName ~= "" then
				local SectionLabel = Instance.new("TextLabel")
				SectionLabel.Name = "SectionLabel"
				SectionLabel.BackgroundTransparency = 1
				SectionLabel.Size = UDim2.new(1, 0, 0, 20)
				SectionLabel.Font = Enum.Font.GothamBold
				SectionLabel.Text = sectionName
				SectionLabel.TextColor3 = Theme.Text
				SectionLabel.TextSize = 15
				SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
				SectionLabel.Parent = SectionFrame
			end
			
			-- Button Element
			function Section:CreateButton(config)
				config = config or {}
				config.Text = config.Text or "Button"
				config.Callback = config.Callback or function() end
				
				local Button = Instance.new("TextButton")
				Button.Name = "Button"
				Button.BackgroundColor3 = Theme.Accent
				Button.BorderSizePixel = 0
				Button.Size = UDim2.new(1, 0, 0, 40)
				Button.Font = Enum.Font.GothamMedium
				Button.Text = config.Text
				Button.TextColor3 = Theme.Secondary
				Button.TextSize = 14
				Button.AutoButtonColor = false
				Button.ClipsDescendants = false
				Button.Parent = SectionFrame
				
				local ButtonCorner = Instance.new("UICorner")
				ButtonCorner.CornerRadius = UDim.new(0, 8)
				ButtonCorner.Parent = Button
				
				Button.MouseEnter:Connect(function()
					Tween(Button, {BackgroundColor3 = Theme.AccentDark})
				end)
				
				Button.MouseLeave:Connect(function()
					Tween(Button, {BackgroundColor3 = Theme.Accent})
				end)
				
				Button.MouseButton1Click:Connect(function()
					Tween(Button, {Size = UDim2.new(1, 0, 0, 38)}, 0.1)
					wait(0.1)
					Tween(Button, {Size = UDim2.new(1, 0, 0, 40)}, 0.1)
					config.Callback()
				end)
				
				return Button
			end
			
			-- Toggle Element
			function Section:CreateToggle(config)
				config = config or {}
				config.Text = config.Text or "Toggle"
				config.Default = config.Default or false
				config.Callback = config.Callback or function() end
				
				local toggled = config.Default
				
				local ToggleFrame = Instance.new("Frame")
				ToggleFrame.Name = "Toggle"
				ToggleFrame.BackgroundColor3 = Theme.Tertiary
				ToggleFrame.BorderSizePixel = 0
				ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
				ToggleFrame.Parent = SectionFrame
				
				local ToggleCorner = Instance.new("UICorner")
				ToggleCorner.CornerRadius = UDim.new(0, 8)
				ToggleCorner.Parent = ToggleFrame
				
				local ToggleLabel = Instance.new("TextLabel")
				ToggleLabel.Name = "Label"
				ToggleLabel.BackgroundTransparency = 1
				ToggleLabel.Position = UDim2.new(0, 15, 0, 0)
				ToggleLabel.Size = UDim2.new(1, -70, 1, 0)
				ToggleLabel.Font = Enum.Font.Gotham
				ToggleLabel.Text = config.Text
				ToggleLabel.TextColor3 = Theme.Text
				ToggleLabel.TextSize = 13
				ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
				ToggleLabel.TextTruncate = Enum.TextTruncate.AtEnd
				ToggleLabel.Parent = ToggleFrame
				
				local ToggleButton = Instance.new("TextButton")
				ToggleButton.Name = "Button"
				ToggleButton.BackgroundColor3 = toggled and Theme.Toggle or Theme.TextDark
				ToggleButton.BorderSizePixel = 0
				ToggleButton.Position = UDim2.new(1, -55, 0.5, -10)
				ToggleButton.Size = UDim2.new(0, 40, 0, 20)
				ToggleButton.Text = ""
				ToggleButton.AutoButtonColor = false
				ToggleButton.Parent = ToggleFrame
				
				local ToggleBtnCorner = Instance.new("UICorner")
				ToggleBtnCorner.CornerRadius = UDim.new(1, 0)
				ToggleBtnCorner.Parent = ToggleButton
				
				local ToggleCircle = Instance.new("Frame")
				ToggleCircle.Name = "Circle"
				ToggleCircle.BackgroundColor3 = Theme.Secondary
				ToggleCircle.BorderSizePixel = 0
				ToggleCircle.Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
				ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
				ToggleCircle.Parent = ToggleButton
				
				local CircleCorner = Instance.new("UICorner")
				CircleCorner.CornerRadius = UDim.new(1, 0)
				CircleCorner.Parent = ToggleCircle
				
				ToggleButton.MouseButton1Click:Connect(function()
					toggled = not toggled
					
					Tween(ToggleButton, {BackgroundColor3 = toggled and Theme.Toggle or Theme.TextDark})
					Tween(ToggleCircle, {Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)})
					
					config.Callback(toggled)
				end)
				
				return ToggleFrame
			end
			
			-- Slider Element
			function Section:CreateSlider(config)
				config = config or {}
				config.Text = config.Text or "Slider"
				config.Min = config.Min or 0
				config.Max = config.Max or 100
				config.Default = config.Default or 50
				config.Callback = config.Callback or function() end
				
				local SliderFrame = Instance.new("Frame")
				SliderFrame.Name = "Slider"
				SliderFrame.BackgroundColor3 = Theme.Tertiary
				SliderFrame.BorderSizePixel = 0
				SliderFrame.Size = UDim2.new(1, 0, 0, 60)
				SliderFrame.Parent = SectionFrame
				
				local SliderCorner = Instance.new("UICorner")
				SliderCorner.CornerRadius = UDim.new(0, 8)
				SliderCorner.Parent = SliderFrame
				
				local SliderLabel = Instance.new("TextLabel")
				SliderLabel.Name = "Label"
				SliderLabel.BackgroundTransparency = 1
				SliderLabel.Position = UDim2.new(0, 15, 0, 8)
				SliderLabel.Size = UDim2.new(1, -80, 0, 20)
				SliderLabel.Font = Enum.Font.Gotham
				SliderLabel.Text = config.Text
				SliderLabel.TextColor3 = Theme.Text
				SliderLabel.TextSize = 13
				SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
				SliderLabel.TextTruncate = Enum.TextTruncate.AtEnd
				SliderLabel.Parent = SliderFrame
				
				local SliderValue = Instance.new("TextLabel")
				SliderValue.Name = "Value"
				SliderValue.BackgroundTransparency = 1
				SliderValue.Position = UDim2.new(1, -65, 0, 8)
				SliderValue.Size = UDim2.new(0, 50, 0, 20)
				SliderValue.Font = Enum.Font.GothamBold
				SliderValue.Text = tostring(config.Default)
				SliderValue.TextColor3 = Theme.Accent
				SliderValue.TextSize = 13
				SliderValue.TextXAlignment = Enum.TextXAlignment.Right
				SliderValue.Parent = SliderFrame
				
				local SliderBar = Instance.new("Frame")
				SliderBar.Name = "Bar"
				SliderBar.BackgroundColor3 = Theme.Background
				SliderBar.BorderSizePixel = 0
				SliderBar.Position = UDim2.new(0, 15, 1, -20)
				SliderBar.Size = UDim2.new(1, -30, 0, 6)
				SliderBar.Parent = SliderFrame
				
				local BarCorner = Instance.new("UICorner")
				BarCorner.CornerRadius = UDim.new(1, 0)
				BarCorner.Parent = SliderBar
				
				local SliderFill = Instance.new("Frame")
				SliderFill.Name = "Fill"
				SliderFill.BackgroundColor3 = Theme.Accent
				SliderFill.BorderSizePixel = 0
				SliderFill.Size = UDim2.new((config.Default - config.Min) / (config.Max - config.Min), 0, 1, 0)
				SliderFill.Parent = SliderBar
				
				local FillCorner = Instance.new("UICorner")
				FillCorner.CornerRadius = UDim.new(1, 0)
				FillCorner.Parent = SliderFill
				
				local dragging = false
				
				SliderBar.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						dragging = true
					end
				end)
				
				SliderBar.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						dragging = false
					end
				end)
				
				UserInputService.InputChanged:Connect(function(input)
					if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
						local mouse = UserInputService:GetMouseLocation()
						local barPos = SliderBar.AbsolutePosition.X
						local barSize = SliderBar.AbsoluteSize.X
						local value = math.clamp((mouse.X - barPos) / barSize, 0, 1)
						local finalValue = math.floor(config.Min + (config.Max - config.Min) * value)
						
						SliderValue.Text = tostring(finalValue)
						Tween(SliderFill, {Size = UDim2.new(value, 0, 1, 0)}, 0.1)
						config.Callback(finalValue)
					end
				end)
				
				return SliderFrame
			end

			-- Label Element
			function Section:CreateLabel(text)
				local Label = Instance.new("TextLabel")
				Label.Name = "Label"
				Label.BackgroundTransparency = 1
				Label.Size = UDim2.new(1, 0, 0, 30)
				Label.Font = Enum.Font.Gotham
				Label.Text = text
				Label.TextColor3 = Theme.TextDark
				Label.TextSize = 13
				Label.TextXAlignment = Enum.TextXAlignment.Left
				Label.TextWrapped = true
				Label.AutomaticSize = Enum.AutomaticSize.Y
				Label.Parent = SectionFrame
				
				return Label
			end
			
			-- Divider Element (Fixed typo dari "Diveder")
			function Section:CreateDivider()
				local Divider = Instance.new("Frame")
				Divider.Name = "Divider"
				Divider.BackgroundColor3 = Theme.Tertiary
				Divider.BorderSizePixel = 0
				Divider.Size = UDim2.new(1, 0, 0, 1)
				Divider.Parent = SectionFrame
				
				return Divider
			end
			
			-- Textbox Element
			function Section:CreateTextbox(config)
				config = config or {}
				config.Text = config.Text or "Textbox"
				config.Placeholder = config.Placeholder or "Enter text..."
				config.Default = config.Default or ""
				config.Callback = config.Callback or function() end
				
				local TextboxFrame = Instance.new("Frame")
				TextboxFrame.Name = "Textbox"
				TextboxFrame.BackgroundColor3 = Theme.Tertiary
				TextboxFrame.BorderSizePixel = 0
				TextboxFrame.Size = UDim2.new(1, 0, 0, 70)
				TextboxFrame.Parent = SectionFrame
				
				local TextboxCorner = Instance.new("UICorner")
				TextboxCorner.CornerRadius = UDim.new(0, 8)
				TextboxCorner.Parent = TextboxFrame
				
				local TextboxLabel = Instance.new("TextLabel")
				TextboxLabel.Name = "Label"
				TextboxLabel.BackgroundTransparency = 1
				TextboxLabel.Position = UDim2.new(0, 15, 0, 8)
				TextboxLabel.Size = UDim2.new(1, -30, 0, 20)
				TextboxLabel.Font = Enum.Font.Gotham
				TextboxLabel.Text = config.Text
				TextboxLabel.TextColor3 = Theme.Text
				TextboxLabel.TextSize = 13
				TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left
				TextboxLabel.TextTruncate = Enum.TextTruncate.AtEnd
				TextboxLabel.Parent = TextboxFrame
				
				local TextboxInput = Instance.new("TextBox")
				TextboxInput.Name = "Input"
				TextboxInput.BackgroundColor3 = Theme.Background
				TextboxInput.BorderSizePixel = 0
				TextboxInput.Position = UDim2.new(0, 15, 0, 35)
				TextboxInput.Size = UDim2.new(1, -30, 0, 25)
				TextboxInput.Font = Enum.Font.Gotham
				TextboxInput.Text = config.Default
				TextboxInput.PlaceholderText = config.Placeholder
				TextboxInput.TextColor3 = Theme.Text
				TextboxInput.PlaceholderColor3 = Theme.TextDark
				TextboxInput.TextSize = 12
				TextboxInput.ClearTextOnFocus = false
				TextboxInput.Parent = TextboxFrame
				
				local InputCorner = Instance.new("UICorner")
				InputCorner.CornerRadius = UDim.new(0, 6)
				InputCorner.Parent = TextboxInput
				
				local InputPadding = Instance.new("UIPadding")
				InputPadding.PaddingLeft = UDim.new(0, 10)
				InputPadding.PaddingRight = UDim.new(0, 10)
				InputPadding.Parent = TextboxInput
				
				TextboxInput.FocusLost:Connect(function()
					config.Callback(TextboxInput.Text)
				end)
				
				return TextboxFrame
			end
			
			-- Keybind Element
			function Section:CreateKeybind(config)
				config = config or {}
				config.Text = config.Text or "Keybind"
				config.Default = config.Default or Enum.KeyCode.E
				config.Callback = config.Callback or function() end
				
				local currentKey = config.Default
				local binding = false
				
				local KeybindFrame = Instance.new("Frame")
				KeybindFrame.Name = "Keybind"
				KeybindFrame.BackgroundColor3 = Theme.Tertiary
				KeybindFrame.BorderSizePixel = 0
				KeybindFrame.Size = UDim2.new(1, 0, 0, 40)
				KeybindFrame.Parent = SectionFrame
				
				local KeybindCorner = Instance.new("UICorner")
				KeybindCorner.CornerRadius = UDim.new(0, 8)
				KeybindCorner.Parent = KeybindFrame
				
				local KeybindLabel = Instance.new("TextLabel")
				KeybindLabel.Name = "Label"
				KeybindLabel.BackgroundTransparency = 1
				KeybindLabel.Position = UDim2.new(0, 15, 0, 0)
				KeybindLabel.Size = UDim2.new(1, -100, 1, 0)
				KeybindLabel.Font = Enum.Font.Gotham
				KeybindLabel.Text = config.Text
				KeybindLabel.TextColor3 = Theme.Text
				KeybindLabel.TextSize = 13
				KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left
				KeybindLabel.TextTruncate = Enum.TextTruncate.AtEnd
				KeybindLabel.Parent = KeybindFrame
				
				local KeybindButton = Instance.new("TextButton")
				KeybindButton.Name = "Button"
				KeybindButton.BackgroundColor3 = Theme.Background
				KeybindButton.BorderSizePixel = 0
				KeybindButton.Position = UDim2.new(1, -80, 0.5, -12)
				KeybindButton.Size = UDim2.new(0, 65, 0, 24)
				KeybindButton.Font = Enum.Font.GothamMedium
				KeybindButton.Text = currentKey.Name
				KeybindButton.TextColor3 = Theme.Text
				KeybindButton.TextSize = 11
				KeybindButton.AutoButtonColor = false
				KeybindButton.Parent = KeybindFrame
				
				local KeybindBtnCorner = Instance.new("UICorner")
				KeybindBtnCorner.CornerRadius = UDim.new(0, 6)
				KeybindBtnCorner.Parent = KeybindButton
				
				KeybindButton.MouseButton1Click:Connect(function()
					binding = true
					KeybindButton.Text = "..."
				end)
				
				UserInputService.InputBegan:Connect(function(input, processed)
					if not processed and binding and input.UserInputType == Enum.UserInputType.Keyboard then
						currentKey = input.KeyCode
						KeybindButton.Text = currentKey.Name
						binding = false
						config.Callback(currentKey)
					end
				end)
				
				return KeybindFrame
			end
			
			return Section
		end
		
		return Tab
	end
	
	return Window
end

return Library