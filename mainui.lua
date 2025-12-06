local Library = {}

-- Create ScreenGui
local function CreateUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MaraUILibrary"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    
    if gethui then
        ScreenGui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = game.CoreGui
    else
        ScreenGui.Parent = game.CoreGui
    end
    
    return ScreenGui
end

-- Create Main Window
function Library:CreateWindow(title)
    local ScreenGui = CreateUI()
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    MainFrame.Size = UDim2.new(0, 600, 0, 400)
    MainFrame.Parent = ScreenGui
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainFrame
    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    TitleBar.BorderSizePixel = 0
    TitleBar.Size = UDim2.new(1, 0, 0, 45)
    TitleBar.Parent = MainFrame
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 12)
    TitleCorner.Parent = TitleBar
    
    local TitleCover = Instance.new("Frame")
    TitleCover.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    TitleCover.BorderSizePixel = 0
    TitleCover.Position = UDim2.new(0, 0, 1, -12)
    TitleCover.Size = UDim2.new(1, 0, 0, 12)
    TitleCover.Parent = TitleBar
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.Size = UDim2.new(0.5, 0, 1, 0)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = title or "Mara's UI Library"
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar
    
    local Subtitle = Instance.new("TextLabel")
    Subtitle.BackgroundTransparency = 1
    Subtitle.Position = UDim2.new(0, 15, 0, 22)
    Subtitle.Size = UDim2.new(0.5, 0, 0, 20)
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.Text = "Exploit Hub • v1.0"
    Subtitle.TextColor3 = Color3.fromRGB(120, 120, 140)
    Subtitle.TextSize = 11
    Subtitle.TextXAlignment = Enum.TextXAlignment.Left
    Subtitle.Parent = TitleBar
    
    -- Top Right Buttons
    local ButtonContainer = Instance.new("Frame")
    ButtonContainer.BackgroundTransparency = 1
    ButtonContainer.Position = UDim2.new(1, -200, 0, 0)
    ButtonContainer.Size = UDim2.new(0, 200, 1, 0)
    ButtonContainer.Parent = TitleBar
    
    local function CreateTopButton(icon, position)
        local Button = Instance.new("TextButton")
        Button.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        Button.BorderSizePixel = 0
        Button.Position = UDim2.new(0, position, 0.5, -12)
        Button.Size = UDim2.new(0, 30, 0, 24)
        Button.Font = Enum.Font.GothamBold
        Button.Text = icon
        Button.TextColor3 = Color3.fromRGB(200, 200, 220)
        Button.TextSize = 12
        Button.Parent = ButtonContainer
        
        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 6)
        ButtonCorner.Parent = Button
        
        Button.MouseEnter:Connect(function()
            Button.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        end)
        
        Button.MouseLeave:Connect(function()
            Button.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        end)
        
        return Button
    end
    
    CreateTopButton("⚙", 95)
    CreateTopButton("💬", 130)
    local CloseButton = CreateTopButton("✕", 165)
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Navigation Bar
    local NavBar = Instance.new("Frame")
    NavBar.Name = "NavBar"
    NavBar.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    NavBar.BorderSizePixel = 0
    NavBar.Position = UDim2.new(0, 0, 0, 45)
    NavBar.Size = UDim2.new(1, 0, 0, 40)
    NavBar.Parent = MainFrame
    
    local NavLayout = Instance.new("UIListLayout")
    NavLayout.FillDirection = Enum.FillDirection.Horizontal
    NavLayout.SortOrder = Enum.SortOrder.LayoutOrder
    NavLayout.Padding = UDim.new(0, 5)
    NavLayout.Parent = NavBar
    
    local NavPadding = Instance.new("UIPadding")
    NavPadding.PaddingLeft = UDim.new(0, 10)
    NavPadding.PaddingTop = UDim.new(0, 7)
    NavPadding.Parent = NavBar
    
    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 0, 0, 85)
    ContentContainer.Size = UDim2.new(1, 0, 1, -85)
    ContentContainer.Parent = MainFrame
    
    -- Dragging
    local dragging, dragInput, dragStart, startPos
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    local Window = {}
    Window.Tabs = {}
    Window.CurrentTab = nil
    
    function Window:CreateTab(name, icon)
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name
        TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        TabButton.BorderSizePixel = 0
        TabButton.Size = UDim2.new(0, 90, 0, 28)
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.Text = (icon or "🏠") .. "  " .. name
        TabButton.TextColor3 = Color3.fromRGB(160, 160, 180)
        TabButton.TextSize = 12
        TabButton.Parent = NavBar
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 7)
        TabCorner.Parent = TabButton
        
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = name .. "Content"
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.ScrollBarThickness = 3
        TabContent.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 255)
        TabContent.Visible = false
        TabContent.Parent = ContentContainer
        
        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.FillDirection = Enum.FillDirection.Horizontal
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Padding = UDim.new(0, 15)
        ContentLayout.Parent = TabContent
        
        local ContentPadding = Instance.new("UIPadding")
        ContentPadding.PaddingTop = UDim.new(0, 15)
        ContentPadding.PaddingLeft = UDim.new(0, 15)
        ContentPadding.PaddingRight = UDim.new(0, 15)
        ContentPadding.Parent = TabContent
        
        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(Window.Tabs) do
                tab.Content.Visible = false
                tab.Button.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
                tab.Button.TextColor3 = Color3.fromRGB(160, 160, 180)
            end
            
            TabContent.Visible = true
            TabButton.BackgroundColor3 = Color3.fromRGB(80, 80, 255)
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            Window.CurrentTab = name
        end)
        
        local Tab = {
            Button = TabButton,
            Content = TabContent
        }
        
        Window.Tabs[name] = Tab
        
        if not Window.CurrentTab then
            TabButton.BackgroundColor3 = Color3.fromRGB(80, 80, 255)
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabContent.Visible = true
            Window.CurrentTab = name
        end
        
        local TabElements = {}
        
        function TabElements:CreateSection(title)
            local Section = Instance.new("Frame")
            Section.Name = title
            Section.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
            Section.BorderSizePixel = 0
            Section.Size = UDim2.new(0, 265, 0, 300)
            Section.Parent = TabContent
            
            local SectionCorner = Instance.new("UICorner")
            SectionCorner.CornerRadius = UDim.new(0, 10)
            SectionCorner.Parent = Section
            
            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Position = UDim2.new(0, 0, 0, 0)
            SectionTitle.Size = UDim2.new(1, 0, 0, 35)
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.Text = title
            SectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            SectionTitle.TextSize = 14
            SectionTitle.Parent = Section
            
            local Divider = Instance.new("Frame")
            Divider.BackgroundColor3 = Color3.fromRGB(80, 80, 255)
            Divider.BorderSizePixel = 0
            Divider.Position = UDim2.new(0, 15, 0, 38)
            Divider.Size = UDim2.new(0, 60, 0, 2)
            Divider.Parent = Section
            
            local DividerCorner = Instance.new("UICorner")
            DividerCorner.CornerRadius = UDim.new(1, 0)
            DividerCorner.Parent = Divider
            
            local ContentFrame = Instance.new("Frame")
            ContentFrame.BackgroundTransparency = 1
            ContentFrame.Position = UDim2.new(0, 0, 0, 50)
            ContentFrame.Size = UDim2.new(1, 0, 1, -50)
            ContentFrame.Parent = Section
            
            local ElementLayout = Instance.new("UIListLayout")
            ElementLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ElementLayout.Padding = UDim.new(0, 12)
            ElementLayout.Parent = ContentFrame
            
            local ElementPadding = Instance.new("UIPadding")
            ElementPadding.PaddingLeft = UDim.new(0, 15)
            ElementPadding.PaddingRight = UDim.new(0, 15)
            ElementPadding.PaddingTop = UDim.new(0, 5)
            ElementPadding.Parent = ContentFrame
            
            ElementLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                Section.Size = UDim2.new(0, 265, 0, math.max(300, ElementLayout.AbsoluteContentSize.Y + 70))
            end)
            
            local SectionElements = {}
            
            function SectionElements:CreateDropdown(label, options, callback)
                local DropdownFrame = Instance.new("Frame")
                DropdownFrame.BackgroundTransparency = 1
                DropdownFrame.Size = UDim2.new(1, 0, 0, 55)
                DropdownFrame.Parent = ContentFrame
                
                local Label = Instance.new("TextLabel")
                Label.BackgroundTransparency = 1
                Label.Size = UDim2.new(0.5, 0, 0, 20)
                Label.Font = Enum.Font.Gotham
                Label.Text = label
                Label.TextColor3 = Color3.fromRGB(200, 200, 220)
                Label.TextSize = 13
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = DropdownFrame
                
                local DropdownButton = Instance.new("TextButton")
                DropdownButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
                DropdownButton.BorderSizePixel = 0
                DropdownButton.Position = UDim2.new(0, 0, 0, 25)
                DropdownButton.Size = UDim2.new(1, 0, 0, 28)
                DropdownButton.Font = Enum.Font.Gotham
                DropdownButton.Text = options[1] or "Select"
                DropdownButton.TextColor3 = Color3.fromRGB(200, 200, 220)
                DropdownButton.TextSize = 12
                DropdownButton.TextXAlignment = Enum.TextXAlignment.Left
                DropdownButton.Parent = DropdownFrame
                
                local DropdownPadding = Instance.new("UIPadding")
                DropdownPadding.PaddingLeft = UDim.new(0, 10)
                DropdownPadding.Parent = DropdownButton
                
                local DropdownCorner = Instance.new("UICorner")
                DropdownCorner.CornerRadius = UDim.new(0, 6)
                DropdownCorner.Parent = DropdownButton
                
                local Arrow = Instance.new("TextLabel")
                Arrow.BackgroundTransparency = 1
                Arrow.Position = UDim2.new(1, -25, 0, 0)
                Arrow.Size = UDim2.new(0, 25, 1, 0)
                Arrow.Font = Enum.Font.GothamBold
                Arrow.Text = "▼"
                Arrow.TextColor3 = Color3.fromRGB(140, 140, 160)
                Arrow.TextSize = 10
                Arrow.Parent = DropdownButton
                
                return DropdownFrame
            end
            
            function SectionElements:CreateSlider(label, min, max, default, callback)
                local SliderFrame = Instance.new("Frame")
                SliderFrame.BackgroundTransparency = 1
                SliderFrame.Size = UDim2.new(1, 0, 0, 50)
                SliderFrame.Parent = ContentFrame
                
                local TopRow = Instance.new("Frame")
                TopRow.BackgroundTransparency = 1
                TopRow.Size = UDim2.new(1, 0, 0, 20)
                TopRow.Parent = SliderFrame
                
                local Label = Instance.new("TextLabel")
                Label.BackgroundTransparency = 1
                Label.Size = UDim2.new(0.6, 0, 1, 0)
                Label.Font = Enum.Font.Gotham
                Label.Text = label
                Label.TextColor3 = Color3.fromRGB(200, 200, 220)
                Label.TextSize = 13
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = TopRow
                
                local ValueLabel = Instance.new("TextLabel")
                ValueLabel.BackgroundTransparency = 1
                ValueLabel.Position = UDim2.new(0.6, 0, 0, 0)
                ValueLabel.Size = UDim2.new(0.4, 0, 1, 0)
                ValueLabel.Font = Enum.Font.GothamBold
                ValueLabel.Text = tostring(default)
                ValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                ValueLabel.TextSize = 13
                ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
                ValueLabel.Parent = TopRow
                
                local SliderBar = Instance.new("Frame")
                SliderBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
                SliderBar.BorderSizePixel = 0
                SliderBar.Position = UDim2.new(0, 0, 0, 28)
                SliderBar.Size = UDim2.new(1, 0, 0, 6)
                SliderBar.Parent = SliderFrame
                
                local BarCorner = Instance.new("UICorner")
                BarCorner.CornerRadius = UDim.new(1, 0)
                BarCorner.Parent = SliderBar
                
                local SliderFill = Instance.new("Frame")
                SliderFill.BackgroundColor3 = Color3.fromRGB(80, 80, 255)
                SliderFill.BorderSizePixel = 0
                SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
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
                
                game:GetService("UserInputService").InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local mouse = game.Players.LocalPlayer:GetMouse()
                        local percent = math.clamp((mouse.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                        local value = math.floor(min + (max - min) * percent)
                        
                        SliderFill.Size = UDim2.new(percent, 0, 1, 0)
                        ValueLabel.Text = tostring(value)
                        
                        if callback then
                            callback(value)
                        end
                    end
                end)
                
                return SliderFrame
            end
            
            function SectionElements:CreateToggle(label, subtitle, default, callback)
                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.BackgroundTransparency = 1
                ToggleFrame.Size = UDim2.new(1, 0, 0, subtitle and 45 or 30)
                ToggleFrame.Parent = ContentFrame
                
                local Label = Instance.new("TextLabel")
                Label.BackgroundTransparency = 1
                Label.Size = UDim2.new(0.75, 0, 0, 18)
                Label.Font = Enum.Font.GothamSemibold
                Label.Text = label
                Label.TextColor3 = Color3.fromRGB(220, 220, 240)
                Label.TextSize = 13
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = ToggleFrame
                
                if subtitle then
                    local Subtitle = Instance.new("TextLabel")
                    Subtitle.BackgroundTransparency = 1
                    Subtitle.Position = UDim2.new(0, 0, 0, 20)
                    Subtitle.Size = UDim2.new(0.75, 0, 0, 15)
                    Subtitle.Font = Enum.Font.Gotham
                    Subtitle.Text = subtitle
                    Subtitle.TextColor3 = Color3.fromRGB(120, 120, 140)
                    Subtitle.TextSize = 11
                    Subtitle.TextXAlignment = Enum.TextXAlignment.Left
                    Subtitle.Parent = ToggleFrame
                end
                
                local ToggleOuter = Instance.new("Frame")
                ToggleOuter.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
                ToggleOuter.BorderSizePixel = 0
                ToggleOuter.Position = UDim2.new(1, -40, 0, -2)
                ToggleOuter.Size = UDim2.new(0, 40, 0, 22)
                ToggleOuter.Parent = ToggleFrame
                
                local OuterCorner = Instance.new("UICorner")
                OuterCorner.CornerRadius = UDim.new(1, 0)
                OuterCorner.Parent = ToggleOuter
                
                local ToggleButton = Instance.new("TextButton")
                ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
                ToggleButton.BorderSizePixel = 0
                ToggleButton.Position = UDim2.new(0, 2, 0, 2)
                ToggleButton.Size = UDim2.new(0, 18, 0, 18)
                ToggleButton.Text = ""
                ToggleButton.Parent = ToggleOuter
                
                local ButtonCorner = Instance.new("UICorner")
                ButtonCorner.CornerRadius = UDim.new(1, 0)
                ButtonCorner.Parent = ToggleButton
                
                local toggled = default or false
                
                local function UpdateToggle()
                    if toggled then
                        game:GetService("TweenService"):Create(ToggleButton, TweenInfo.new(0.2), {
                            Position = UDim2.new(1, -20, 0, 2),
                            BackgroundColor3 = Color3.fromRGB(80, 80, 255)
                        }):Play()
                        game:GetService("TweenService"):Create(ToggleOuter, TweenInfo.new(0.2), {
                            BackgroundColor3 = Color3.fromRGB(60, 60, 180)
                        }):Play()
                    else
                        game:GetService("TweenService"):Create(ToggleButton, TweenInfo.new(0.2), {
                            Position = UDim2.new(0, 2, 0, 2),
                            BackgroundColor3 = Color3.fromRGB(60, 60, 75)
                        }):Play()
                        game:GetService("TweenService"):Create(ToggleOuter, TweenInfo.new(0.2), {
                            BackgroundColor3 = Color3.fromRGB(35, 35, 45)
                        }):Play()
                    end
                end
                
                UpdateToggle()
                
                ToggleButton.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    UpdateToggle()
                    if callback then
                        callback(toggled)
                    end
                end)
                
                return ToggleFrame
            end
            
            return SectionElements
        end
        
        return TabElements
    end
    
    return Window
end

return Library
