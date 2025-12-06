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
    MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -250)
    MainFrame.Size = UDim2.new(0, 600, 0, 500)
    MainFrame.Parent = ScreenGui
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 15)
    MainCorner.Parent = MainFrame
    
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(102, 126, 234)
    MainStroke.Thickness = 1
    MainStroke.Transparency = 0.7
    MainStroke.Parent = MainFrame
    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    TitleBar.BorderSizePixel = 0
    TitleBar.Size = UDim2.new(1, 0, 0, 50)
    TitleBar.Parent = MainFrame
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 15)
    TitleCorner.Parent = TitleBar
    
    local TitleGradient = Instance.new("UIGradient")
    TitleGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(102, 126, 234)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(118, 75, 162))
    }
    TitleGradient.Rotation = 45
    TitleGradient.Parent = TitleBar
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 20, 0, 0)
    TitleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = title or "Mara's UI Library"
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 18
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
    CloseButton.BorderSizePixel = 0
    CloseButton.Position = UDim2.new(1, -40, 0.5, -12)
    CloseButton.Size = UDim2.new(0, 24, 0, 24)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 14
    CloseButton.Parent = TitleBar
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(1, 0)
    CloseCorner.Parent = CloseButton
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Tab Container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    TabContainer.BorderSizePixel = 0
    TabContainer.Position = UDim2.new(0, 10, 0, 60)
    TabContainer.Size = UDim2.new(0, 150, 1, -70)
    TabContainer.Parent = MainFrame
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 10)
    TabCorner.Parent = TabContainer
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 8)
    TabLayout.Parent = TabContainer
    
    local TabPadding = Instance.new("UIPadding")
    TabPadding.PaddingTop = UDim.new(0, 10)
    TabPadding.PaddingLeft = UDim.new(0, 10)
    TabPadding.PaddingRight = UDim.new(0, 10)
    TabPadding.Parent = TabContainer
    
    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 170, 0, 60)
    ContentContainer.Size = UDim2.new(1, -180, 1, -70)
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
    
    function Window:CreateTab(name)
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name
        TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        TabButton.BorderSizePixel = 0
        TabButton.Size = UDim2.new(1, 0, 0, 35)
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.Text = name
        TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabButton.TextSize = 14
        TabButton.Parent = TabContainer
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 8)
        TabCorner.Parent = TabButton
        
        local TabGradient = Instance.new("UIGradient")
        TabGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 30))
        }
        TabGradient.Rotation = 45
        TabGradient.Parent = TabButton
        
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = name .. "Content"
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.ScrollBarThickness = 4
        TabContent.ScrollBarImageColor3 = Color3.fromRGB(102, 126, 234)
        TabContent.Visible = false
        TabContent.Parent = ContentContainer
        
        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Padding = UDim.new(0, 10)
        ContentLayout.Parent = TabContent
        
        local ContentPadding = Instance.new("UIPadding")
        ContentPadding.PaddingTop = UDim.new(0, 10)
        ContentPadding.PaddingLeft = UDim.new(0, 10)
        ContentPadding.PaddingRight = UDim.new(0, 10)
        ContentPadding.Parent = TabContent
        
        ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
        end)
        
        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(Window.Tabs) do
                tab.Content.Visible = false
                tab.Button.TextColor3 = Color3.fromRGB(200, 200, 200)
                local gradient = tab.Button:FindFirstChildOfClass("UIGradient")
                if gradient then
                    gradient.Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 30))
                    }
                end
            end
            
            TabContent.Visible = true
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(102, 126, 234)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(118, 75, 162))
            }
            Window.CurrentTab = name
        end)
        
        local Tab = {
            Button = TabButton,
            Content = TabContent
        }
        
        Window.Tabs[name] = Tab
        
        if not Window.CurrentTab then
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(102, 126, 234)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(118, 75, 162))
            }
            TabContent.Visible = true
            Window.CurrentTab = name
        end
        
        local TabElements = {}
        
        function TabElements:CreateButton(text, callback)
            local Button = Instance.new("TextButton")
            Button.Name = text
            Button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            Button.BorderSizePixel = 0
            Button.Size = UDim2.new(1, -20, 0, 40)
            Button.Font = Enum.Font.Gotham
            Button.Text = text
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.TextSize = 14
            Button.Parent = TabContent
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 8)
            ButtonCorner.Parent = Button
            
            local ButtonGradient = Instance.new("UIGradient")
            ButtonGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 25)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 35))
            }
            ButtonGradient.Rotation = 90
            ButtonGradient.Parent = Button
            
            local ButtonStroke = Instance.new("UIStroke")
            ButtonStroke.Color = Color3.fromRGB(102, 126, 234)
            ButtonStroke.Thickness = 1
            ButtonStroke.Transparency = 0.8
            ButtonStroke.Parent = Button
            
            Button.MouseEnter:Connect(function()
                ButtonGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(102, 126, 234)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(118, 75, 162))
                }
            end)
            
            Button.MouseLeave:Connect(function()
                ButtonGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 25)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 35))
                }
            end)
            
            Button.MouseButton1Click:Connect(function()
                if callback then
                    callback()
                end
            end)
            
            return Button
        end
        
        function TabElements:CreateToggle(text, default, callback)
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = text
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Size = UDim2.new(1, -20, 0, 40)
            ToggleFrame.Parent = TabContent
            
            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 8)
            ToggleCorner.Parent = ToggleFrame
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Position = UDim2.new(0, 15, 0, 0)
            ToggleLabel.Size = UDim2.new(1, -80, 1, 0)
            ToggleLabel.Font = Enum.Font.Gotham
            ToggleLabel.Text = text
            ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            ToggleLabel.TextSize = 14
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Parent = ToggleFrame
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Name = "Toggle"
            ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            ToggleButton.BorderSizePixel = 0
            ToggleButton.Position = UDim2.new(1, -60, 0.5, -12)
            ToggleButton.Size = UDim2.new(0, 45, 0, 24)
            ToggleButton.Text = ""
            ToggleButton.Parent = ToggleFrame
            
            local ToggleButtonCorner = Instance.new("UICorner")
            ToggleButtonCorner.CornerRadius = UDim.new(1, 0)
            ToggleButtonCorner.Parent = ToggleButton
            
            local ToggleIndicator = Instance.new("Frame")
            ToggleIndicator.Name = "Indicator"
            ToggleIndicator.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            ToggleIndicator.BorderSizePixel = 0
            ToggleIndicator.Position = UDim2.new(0, 3, 0.5, -9)
            ToggleIndicator.Size = UDim2.new(0, 18, 0, 18)
            ToggleIndicator.Parent = ToggleButton
            
            local IndicatorCorner = Instance.new("UICorner")
            IndicatorCorner.CornerRadius = UDim.new(1, 0)
            IndicatorCorner.Parent = ToggleIndicator
            
            local IndicatorGradient = Instance.new("UIGradient")
            IndicatorGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 80, 80)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 60, 60))
            }
            IndicatorGradient.Rotation = 45
            IndicatorGradient.Parent = ToggleIndicator
            
            local toggled = default or false
            
            local function UpdateToggle()
                if toggled then
                    game:GetService("TweenService"):Create(ToggleIndicator, TweenInfo.new(0.2), {Position = UDim2.new(1, -21, 0.5, -9)}):Play()
                    IndicatorGradient.Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(102, 126, 234)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(118, 75, 162))
                    }
                    ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                else
                    game:GetService("TweenService"):Create(ToggleIndicator, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -9)}):Play()
                    IndicatorGradient.Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 80, 80)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 60, 60))
                    }
                    ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
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
        
        function TabElements:CreateSlider(text, min, max, default, callback)
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Name = text
            SliderFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            SliderFrame.BorderSizePixel = 0
            SliderFrame.Size = UDim2.new(1, -20, 0, 60)
            SliderFrame.Parent = TabContent
            
            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(0, 8)
            SliderCorner.Parent = SliderFrame
            
            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Position = UDim2.new(0, 15, 0, 5)
            SliderLabel.Size = UDim2.new(1, -30, 0, 20)
            SliderLabel.Font = Enum.Font.Gotham
            SliderLabel.Text = text
            SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            SliderLabel.TextSize = 14
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            SliderLabel.Parent = SliderFrame
            
            local SliderValue = Instance.new("TextLabel")
            SliderValue.BackgroundTransparency = 1
            SliderValue.Position = UDim2.new(0, 15, 0, 5)
            SliderValue.Size = UDim2.new(1, -30, 0, 20)
            SliderValue.Font = Enum.Font.GothamBold
            SliderValue.Text = tostring(default)
            SliderValue.TextColor3 = Color3.fromRGB(102, 126, 234)
            SliderValue.TextSize = 14
            SliderValue.TextXAlignment = Enum.TextXAlignment.Right
            SliderValue.Parent = SliderFrame
            
            local SliderBar = Instance.new("Frame")
            SliderBar.Name = "Bar"
            SliderBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            SliderBar.BorderSizePixel = 0
            SliderBar.Position = UDim2.new(0, 15, 0, 35)
            SliderBar.Size = UDim2.new(1, -30, 0, 10)
            SliderBar.Parent = SliderFrame
            
            local BarCorner = Instance.new("UICorner")
            BarCorner.CornerRadius = UDim.new(1, 0)
            BarCorner.Parent = SliderBar
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Name = "Fill"
            SliderFill.BackgroundColor3 = Color3.fromRGB(102, 126, 234)
            SliderFill.BorderSizePixel = 0
            SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            SliderFill.Parent = SliderBar
            
            local FillCorner = Instance.new("UICorner")
            FillCorner.CornerRadius = UDim.new(1, 0)
            FillCorner.Parent = SliderFill
            
            local FillGradient = Instance.new("UIGradient")
            FillGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(102, 126, 234)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(118, 75, 162))
            }
            FillGradient.Rotation = 0
            FillGradient.Parent = SliderFill
            
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
                    SliderValue.Text = tostring(value)
                    
                    if callback then
                        callback(value)
                    end
                end
            end)
            
            return SliderFrame
        end
        
        function TabElements:CreateDropdown(text, options, callback)
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Name = text
            DropdownFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            DropdownFrame.BorderSizePixel = 0
            DropdownFrame.Size = UDim2.new(1, -20, 0, 40)
            DropdownFrame.ClipsDescendants = true
            DropdownFrame.Parent = TabContent
            
            local DropdownCorner = Instance.new("UICorner")
            DropdownCorner.CornerRadius = UDim.new(0, 8)
            DropdownCorner.Parent = DropdownFrame
            
            local DropdownButton = Instance.new("TextButton")
            DropdownButton.BackgroundTransparency = 1
            DropdownButton.Size = UDim2.new(1, 0, 0, 40)
            DropdownButton.Font = Enum.Font.Gotham
            DropdownButton.Text = text .. ": None"
            DropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            DropdownButton.TextSize = 14
            DropdownButton.Parent = DropdownFrame
            
            local Arrow = Instance.new("TextLabel")
            Arrow.BackgroundTransparency = 1
            Arrow.Position = UDim2.new(1, -30, 0, 0)
            Arrow.Size = UDim2.new(0, 30, 0, 40)
            Arrow.Font = Enum.Font.GothamBold
            Arrow.Text = "▼"
            Arrow.TextColor3 = Color3.fromRGB(102, 126, 234)
            Arrow.TextSize = 12
            Arrow.Parent = DropdownFrame
            
            local OptionsFrame = Instance.new("Frame")
            OptionsFrame.BackgroundTransparency = 1
            OptionsFrame.Position = UDim2.new(0, 0, 0, 40)
            OptionsFrame.Size = UDim2.new(1, 0, 0, 0)
            OptionsFrame.Parent = DropdownFrame
            
            local OptionsLayout = Instance.new("UIListLayout")
            OptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
            OptionsLayout.Padding = UDim.new(0, 2)
            OptionsLayout.Parent = OptionsFrame
            
            local expanded = false
            
            for _, option in ipairs(options) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                OptionButton.BorderSizePixel = 0
                OptionButton.Size = UDim2.new(1, 0, 0, 30)
                OptionButton.Font = Enum.Font.Gotham
                OptionButton.Text = option
                OptionButton.TextColor3 = Color3.fromRGB(200, 200, 200)
                OptionButton.TextSize = 13
                OptionButton.Parent = OptionsFrame
                
                local OptionGradient = Instance.new("UIGradient")
                OptionGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 35)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 35))
                }
                OptionGradient.Rotation = 90
                OptionGradient.Parent = OptionButton
                
                OptionButton.MouseEnter:Connect(function()
                    OptionGradient.Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(102, 126, 234)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(118, 75, 162))
                    }
                end)
                
                OptionButton.MouseLeave:Connect(function()
                    OptionGradient.Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 35)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 35))
                    }
                end)
                
                OptionButton.MouseButton1Click:Connect(function()
                    DropdownButton.Text = text .. ": " .. option
                    expanded = false
                    game:GetService("TweenService"):Create(DropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, -20, 0, 40)}):Play()
                    Arrow.Text = "▼"
                    if callback then
                        callback(option)
                    end
                end)
            end
            
            DropdownButton.MouseButton1Click:Connect(function()
                expanded = not expanded
                if expanded then
                    local size = 40 + (#options * 32)
                    game:GetService("TweenService"):Create(DropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, -20, 0, size)}):Play()
                    Arrow.Text = "▲"
                else
                    game:GetService("TweenService"):Create(DropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, -20, 0, 40)}):Play()
                    Arrow.Text = "▼"
                end
            end)
            
            return DropdownFrame
        end
        
        function TabElements:CreateLabel(text)
            local Label = Instance.new("TextLabel")
            Label.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            Label.BorderSizePixel = 0
            Label.Size = UDim2.new(1, -20, 0, 35)
            Label.Font = Enum.Font.Gotham
            Label.Text = text
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.TextSize = 14
            Label.Parent = TabContent
            
            local LabelCorner = Instance.new("UICorner")
            LabelCorner.CornerRadius = UDim.new(0, 8)
            LabelCorner.Parent = Label
            
            local LabelGradient = Instance.new("UIGradient")
            LabelGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(102, 126, 234)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(118, 75, 162))
            }
            LabelGradient.Rotation = 45
            LabelGradient.Parent = Label
            
            return Label
        end
        
        function TabElements:CreateTextbox(text, placeholder, callback)
            local TextboxFrame = Instance.new("Frame")
            TextboxFrame.Name = text
            TextboxFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            TextboxFrame.BorderSizePixel = 0
            TextboxFrame.Size = UDim2.new(1, -20, 0, 70)
            TextboxFrame.Parent = TabContent
            
            local TextboxCorner = Instance.new("UICorner")
            TextboxCorner.CornerRadius = UDim.new(0, 8)
            TextboxCorner.Parent = TextboxFrame
            
            local TextboxLabel = Instance.new("TextLabel")
            TextboxLabel.BackgroundTransparency = 1
            TextboxLabel.Position = UDim2.new(0, 15, 0, 5)
            TextboxLabel.Size = UDim2.new(1, -30, 0, 20)
            TextboxLabel.Font = Enum.Font.Gotham
            TextboxLabel.Text = text
            TextboxLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextboxLabel.TextSize = 14
            TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextboxLabel.Parent = TextboxFrame
            
            local Textbox = Instance.new("TextBox")
            Textbox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Textbox.BorderSizePixel = 0
            Textbox.Position = UDim2.new(0, 15, 0, 30)
            Textbox.Size = UDim2.new(1, -30, 0, 30)
            Textbox.Font = Enum.Font.Gotham
            Textbox.PlaceholderText = placeholder or "Enter text..."
            Textbox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
            Textbox.Text = ""
            Textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
            Textbox.TextSize = 13
            Textbox.Parent = TextboxFrame
            
            local TextboxInnerCorner = Instance.new("UICorner")
            TextboxInnerCorner.CornerRadius = UDim.new(0, 6)
            TextboxInnerCorner.Parent = Textbox
            
            local TextboxStroke = Instance.new("UIStroke")
            TextboxStroke.Color = Color3.fromRGB(102, 126, 234)
            TextboxStroke.Thickness = 1
            TextboxStroke.Transparency = 0.8
            TextboxStroke.Parent = Textbox
            
            Textbox.Focused:Connect(function()
                TextboxStroke.Transparency = 0
            end)
            
            Textbox.FocusLost:Connect(function()
                TextboxStroke.Transparency = 0.8
                if callback then
                    callback(Textbox.Text)
                end
            end)
            
            return TextboxFrame
        end
        
        return TabElements
    end
    
    return Window
end

return Library
