local lib = {RainbowColorValue = 0, HueSelectionPosition = 0}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local PresetColor = Color3.fromRGB(44, 120, 224)
local CloseBind = Enum.KeyCode.RightControl

local ui = Instance.new("ScreenGui")
ui.Name = "ui"
ui.Parent = game.CoreGui
ui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- UI开关状态
local uiEnabled = true

coroutine.wrap(
    function()
        while wait() do
            lib.RainbowColorValue = lib.RainbowColorValue + 1 / 255
            lib.HueSelectionPosition = lib.HueSelectionPosition + 1

            if lib.RainbowColorValue >= 1 then
                lib.RainbowColorValue = 0
            end

            if lib.HueSelectionPosition == 80 then
                lib.HueSelectionPosition = 0
            end
        end
    end
)()

local function MakeDraggable(topbarobject, object)
    local Dragging = nil
    local DragInput = nil
    local DragStart = nil
    local StartPosition = nil

    local function Update(input)
        local Delta = input.Position - DragStart
        local pos =
            UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + Delta.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset + Delta.Y
        )
        object.Position = pos
    end

    topbarobject.InputBegan:Connect(
        function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                Dragging = true
                DragStart = input.Position
                StartPosition = object.Position

                input.Changed:Connect(
                    function()
                        if input.UserInputState == Enum.UserInputState.End then
                            Dragging = false
                        end
                    end
                )
            end
        end
    )

    topbarobject.InputChanged:Connect(
        function(input)
            if
                input.UserInputType == Enum.UserInputType.MouseMovement or
                    input.UserInputType == Enum.UserInputType.Touch
             then
                DragInput = input
            end
        end
    )

    UserInputService.InputChanged:Connect(
        function(input)
            if input == DragInput and Dragging then
                Update(input)
            end
        end
    )
end

function lib:Window(text, preset, closebind)
    CloseBind = closebind or Enum.KeyCode.RightControl
    PresetColor = preset or Color3.fromRGB(44, 120, 224)
    fs = false
    local Main = Instance.new("Frame")
    local MainCorner = Instance.new("UICorner")
    local TabHold = Instance.new("Frame")
    local TabHoldLayout = Instance.new("UIListLayout")
    local Title = Instance.new("TextLabel")
    local TabFolder = Instance.new("Folder")
    local DragFrame = Instance.new("Frame")
    local SearchBox = Instance.new("Frame")
    local SearchBoxCorner = Instance.new("UICorner")
    local SearchIcon = Instance.new("ImageLabel")
    local SearchTextBox = Instance.new("TextBox")
    local UIButton = Instance.new("TextButton")
    local UIButtonCorner = Instance.new("UICorner")

    Main.Name = "Main"
    Main.Parent = ui
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.Size = UDim2.new(0, 0, 0, 0)
    Main.ClipsDescendants = true
    Main.Visible = true

    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Name = "MainCorner"
    MainCorner.Parent = Main

    TabHold.Name = "TabHold"
    TabHold.Parent = Main
    TabHold.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TabHold.BackgroundTransparency = 1.000
    TabHold.Position = UDim2.new(0.0339285731, 0, 0.2, 0)
    TabHold.Size = UDim2.new(0, 107, 0, 240)

    TabHoldLayout.Name = "TabHoldLayout"
    TabHoldLayout.Parent = TabHold
    TabHoldLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabHoldLayout.Padding = UDim.new(0, 8)

    Title.Name = "Title"
    Title.Parent = Main
    Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1.000
    Title.Position = UDim2.new(0.0339285731, 0, 0.0564263314, 0)
    Title.Size = UDim2.new(0, 200, 0, 25)
    Title.Font = Enum.Font.GothamSemibold
    Title.Text = text
    Title.TextColor3 = PresetColor
    Title.TextSize = 16.000
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- 搜索框
    SearchBox.Name = "SearchBox"
    SearchBox.Parent = Main
    SearchBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    SearchBox.Position = UDim2.new(0.033, 0, 0.85, 0)
    SearchBox.Size = UDim2.new(0, 107, 0, 30)

    SearchBoxCorner.CornerRadius = UDim.new(0, 8)
    SearchBoxCorner.Name = "SearchBoxCorner"
    SearchBoxCorner.Parent = SearchBox

    SearchIcon.Name = "SearchIcon"
    SearchIcon.Parent = SearchBox
    SearchIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SearchIcon.BackgroundTransparency = 1.000
    SearchIcon.Position = UDim2.new(0.1, 0, 0.2, 0)
    SearchIcon.Size = UDim2.new(0, 18, 0, 18)
    SearchIcon.Image = "rbxassetid://3926305904"
    SearchIcon.ImageColor3 = Color3.fromRGB(150, 150, 150)
    SearchIcon.ImageRectOffset = Vector2.new(964, 324)
    SearchIcon.ImageRectSize = Vector2.new(36, 36)

    SearchTextBox.Name = "SearchTextBox"
    SearchTextBox.Parent = SearchBox
    SearchTextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SearchTextBox.BackgroundTransparency = 1.000
    SearchTextBox.Position = UDim2.new(0.35, 0, 0, 0)
    SearchTextBox.Size = UDim2.new(0, 65, 0, 30)
    SearchTextBox.Font = Enum.Font.Gotham
    SearchTextBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    SearchTextBox.PlaceholderText = "搜索..."
    SearchTextBox.Text = ""
    SearchTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    SearchTextBox.TextSize = 12.000
    SearchTextBox.TextXAlignment = Enum.TextXAlignment.Left

    -- UI开关按钮
    UIButton.Name = "UIButton"
    UIButton.Parent = Main
    UIButton.BackgroundColor3 = Color3.fromRGB(44, 120, 224)
    UIButton.Position = UDim2.new(0.85, 0, 0.04, 0)
    UIButton.Size = UDim2.new(0, 60, 0, 25)
    UIButton.Font = Enum.Font.Gotham
    UIButton.Text = "隐藏"
    UIButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    UIButton.TextSize = 12.000

    UIButtonCorner.CornerRadius = UDim.new(0, 6)
    UIButtonCorner.Name = "UIButtonCorner"
    UIButtonCorner.Parent = UIButton

    DragFrame.Name = "DragFrame"
    DragFrame.Parent = Main
    DragFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    DragFrame.BackgroundTransparency = 1.000
    DragFrame.Size = UDim2.new(0, 500, 0, 35)

    Main:TweenSize(UDim2.new(0, 560, 0, 350), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .6, true)

    MakeDraggable(DragFrame, Main)

    local uitoggled = false
    UserInputService.InputBegan:Connect(
        function(io, p)
            if io.KeyCode == CloseBind then
                if uitoggled == false then
                    uitoggled = true
                    UIButton.Text = "显示"
                    Main:TweenSize(
                        UDim2.new(0, 0, 0, 0), 
                        Enum.EasingDirection.Out, 
                        Enum.EasingStyle.Quart, 
                        .6, 
                        true, 
                        function()
                            ui.Enabled = false
                        end
                    )
                else
                    uitoggled = false
                    UIButton.Text = "隐藏"
                    ui.Enabled = true
                    Main:TweenSize(
                        UDim2.new(0, 560, 0, 350),
                        Enum.EasingDirection.Out,
                        Enum.EasingStyle.Quart,
                        .6,
                        true
                    )
                end
            end
        end
    )

    -- UI开关按钮点击事件
    UIButton.MouseButton1Click:Connect(function()
        if uitoggled == false then
            uitoggled = true
            UIButton.Text = "显示"
            Main:TweenSize(
                UDim2.new(0, 0, 0, 0), 
                Enum.EasingDirection.Out, 
                Enum.EasingStyle.Quart, 
                .6, 
                true, 
                function()
                    ui.Enabled = false
                end
            )
        else
            uitoggled = false
            UIButton.Text = "隐藏"
            ui.Enabled = true
            Main:TweenSize(
                UDim2.new(0, 560, 0, 350),
                Enum.EasingDirection.Out,
                Enum.EasingStyle.Quart,
                .6,
                true
            )
        end
    end)

    TabFolder.Name = "TabFolder"
    TabFolder.Parent = Main

    function lib:ChangePresetColor(toch)
        PresetColor = toch
        Title.TextColor3 = toch
    end

    function lib:Notification(texttitle, textdesc, textbtn)
        local NotificationHold = Instance.new("TextButton")
        local NotificationFrame = Instance.new("Frame")
        local NotificationFrameCorner = Instance.new("UICorner")
        local OkayBtn = Instance.new("TextButton")
        local OkayBtnCorner = Instance.new("UICorner")
        local OkayBtnTitle = Instance.new("TextLabel")
        local NotificationTitle = Instance.new("TextLabel")
        local NotificationDesc = Instance.new("TextLabel")

        NotificationHold.Name = "NotificationHold"
        NotificationHold.Parent = Main
        NotificationHold.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        NotificationHold.BackgroundTransparency = 1.000
        NotificationHold.BorderSizePixel = 0
        NotificationHold.Size = UDim2.new(0, 560, 0, 350)
        NotificationHold.AutoButtonColor = false
        NotificationHold.Font = Enum.Font.SourceSans
        NotificationHold.Text = ""
        NotificationHold.TextColor3 = Color3.fromRGB(0, 0, 0)
        NotificationHold.TextSize = 14.000

        TweenService:Create(
            NotificationHold,
            TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundTransparency = 0.7}
        ):Play()
        wait(0.4)

        NotificationFrame.Name = "NotificationFrame"
        NotificationFrame.Parent = NotificationHold
        NotificationFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        NotificationFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        NotificationFrame.BorderSizePixel = 0
        NotificationFrame.ClipsDescendants = true
        NotificationFrame.Position = UDim2.new(0.5, 0, 0.5, 0)

        NotificationFrameCorner.CornerRadius = UDim.new(0, 12)
        NotificationFrameCorner.Name = "NotificationFrameCorner"
        NotificationFrameCorner.Parent = NotificationFrame

        NotificationFrame:TweenSize(
            UDim2.new(0, 200, 0, 220),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quart,
            .6,
            true
        )

        OkayBtn.Name = "OkayBtn"
        OkayBtn.Parent = NotificationFrame
        OkayBtn.BackgroundColor3 = Color3.fromRGB(44, 120, 224)
        OkayBtn.Position = UDim2.new(0.1, 0, 0.75, 0)
        OkayBtn.Size = UDim2.new(0, 160, 0, 35)
        OkayBtn.AutoButtonColor = false
        OkayBtn.Font = Enum.Font.SourceSans
        OkayBtn.Text = ""
        OkayBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        OkayBtn.TextSize = 14.000

        OkayBtnCorner.CornerRadius = UDim.new(0, 8)
        OkayBtnCorner.Name = "OkayBtnCorner"
        OkayBtnCorner.Parent = OkayBtn

        OkayBtnTitle.Name = "OkayBtnTitle"
        OkayBtnTitle.Parent = OkayBtn
        OkayBtnTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        OkayBtnTitle.BackgroundTransparency = 1.000
        OkayBtnTitle.Size = UDim2.new(0, 160, 0, 35)
        OkayBtnTitle.Font = Enum.Font.GothamSemibold
        OkayBtnTitle.Text = textbtn
        OkayBtnTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        OkayBtnTitle.TextSize = 14.000

        NotificationTitle.Name = "NotificationTitle"
        NotificationTitle.Parent = NotificationFrame
        NotificationTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        NotificationTitle.BackgroundTransparency = 1.000
        NotificationTitle.Position = UDim2.new(0.1, 0, 0.1, 0)
        NotificationTitle.Size = UDim2.new(0, 160, 0, 30)
        NotificationTitle.Font = Enum.Font.GothamSemibold
        NotificationTitle.Text = texttitle
        NotificationTitle.TextColor3 = PresetColor
        NotificationTitle.TextSize = 18.000

        NotificationDesc.Name = "NotificationDesc"
        NotificationDesc.Parent = NotificationFrame
        NotificationDesc.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        NotificationDesc.BackgroundTransparency = 1.000
        NotificationDesc.Position = UDim2.new(0.1, 0, 0.3, 0)
        NotificationDesc.Size = UDim2.new(0, 160, 0, 80)
        NotificationDesc.Font = Enum.Font.Gotham
        NotificationDesc.Text = textdesc
        NotificationDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
        NotificationDesc.TextSize = 14.000
        NotificationDesc.TextWrapped = true
        NotificationDesc.TextXAlignment = Enum.TextXAlignment.Left
        NotificationDesc.TextYAlignment = Enum.TextYAlignment.Top

        OkayBtn.MouseEnter:Connect(
            function()
                TweenService:Create(
                    OkayBtn,
                    TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {BackgroundColor3 = Color3.fromRGB(50, 130, 240)}
                ):Play()
            end
        )

        OkayBtn.MouseLeave:Connect(
            function()
                TweenService:Create(
                    OkayBtn,
                    TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {BackgroundColor3 = Color3.fromRGB(44, 120, 224)}
                ):Play()
            end
        )

        OkayBtn.MouseButton1Click:Connect(
            function()
                NotificationFrame:TweenSize(
                    UDim2.new(0, 0, 0, 0),
                    Enum.EasingDirection.Out,
                    Enum.EasingStyle.Quart,
                    .6,
                    true
                )

                wait(0.4)

                TweenService:Create(
                    NotificationHold,
                    TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {BackgroundTransparency = 1}
                ):Play()

                wait(.3)

                NotificationHold:Destroy()
            end
        )
    end
    
    local tabhold = {}
    function tabhold:Tab(text)
        local TabBtn = Instance.new("TextButton")
        local TabBtnCorner = Instance.new("UICorner")
        local TabTitle = Instance.new("TextLabel")
        local TabBtnIndicator = Instance.new("Frame")
        local TabBtnIndicatorCorner = Instance.new("UICorner")

        TabBtn.Name = "TabBtn"
        TabBtn.Parent = TabHold
        TabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        TabBtn.Size = UDim2.new(0, 107, 0, 30)
        TabBtn.AutoButtonColor = false
        TabBtn.Font = Enum.Font.SourceSans
        TabBtn.Text = ""
        TabBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        TabBtn.TextSize = 14.000

        TabBtnCorner.CornerRadius = UDim.new(0, 6)
        TabBtnCorner.Name = "TabBtnCorner"
        TabBtnCorner.Parent = TabBtn

        TabTitle.Name = "TabTitle"
        TabTitle.Parent = TabBtn
        TabTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TabTitle.BackgroundTransparency = 1.000
        TabTitle.Size = UDim2.new(0, 107, 0, 30)
        TabTitle.Font = Enum.Font.Gotham
        TabTitle.Text = text
        TabTitle.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabTitle.TextSize = 14.000

        TabBtnIndicator.Name = "TabBtnIndicator"
        TabBtnIndicator.Parent = TabBtn
        TabBtnIndicator.BackgroundColor3 = PresetColor
        TabBtnIndicator.BorderSizePixel = 0
        TabBtnIndicator.Position = UDim2.new(0.9, 0, 0.2, 0)
        TabBtnIndicator.Size = UDim2.new(0, 4, 0, 18)

        TabBtnIndicatorCorner.CornerRadius = UDim.new(0, 2)
        TabBtnIndicatorCorner.Name = "TabBtnIndicatorCorner"
        TabBtnIndicatorCorner.Parent = TabBtnIndicator

        coroutine.wrap(
            function()
                while wait() do
                    TabBtnIndicator.BackgroundColor3 = PresetColor
                end
            end
        )()

        local Tab = Instance.new("ScrollingFrame")
        local TabCorner = Instance.new("UICorner")
        local TabLayout = Instance.new("UIListLayout")
        local TabPadding = Instance.new("UIPadding")

        Tab.Name = "Tab"
        Tab.Parent = TabFolder
        Tab.Active = true
        Tab.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        Tab.BorderSizePixel = 0
        Tab.Position = UDim2.new(0.25, 0, 0.2, 0)
        Tab.Size = UDim2.new(0, 400, 0, 240)
        Tab.CanvasSize = UDim2.new(0, 0, 0, 0)
        Tab.ScrollBarThickness = 3
        Tab.Visible = false

        TabCorner.CornerRadius = UDim.new(0, 8)
        TabCorner.Name = "TabCorner"
        TabCorner.Parent = Tab

        TabLayout.Name = "TabLayout"
        TabLayout.Parent = Tab
        TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabLayout.Padding = UDim.new(0, 8)

        TabPadding.Name = "TabPadding"
        TabPadding.Parent = Tab
        TabPadding.PaddingLeft = UDim.new(0, 8)
        TabPadding.PaddingTop = UDim.new(0, 8)

        if fs == false then
            fs = true
            TabBtnIndicator.Size = UDim2.new(0, 4, 0, 18)
            TabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            TabTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            Tab.Visible = true
        end

        TabBtn.MouseEnter:Connect(function()
            if Tab.Visible == false then
                TweenService:Create(
                    TabBtn,
                    TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {BackgroundColor3 = Color3.fromRGB(38, 38, 38)}
                ):Play()
            end
        end)

        TabBtn.MouseLeave:Connect(function()
            if Tab.Visible == false then
                TweenService:Create(
                    TabBtn,
                    TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}
                ):Play()
            end
        end)

        TabBtn.MouseButton1Click:Connect(
            function()
                for i, v in next, TabFolder:GetChildren() do
                    if v.Name == "Tab" then
                        v.Visible = false
                    end
                    Tab.Visible = true
                end
                for i, v in next, TabHold:GetChildren() do
                    if v.Name == "TabBtn" then
                        TweenService:Create(
                            v,
                            TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}
                        ):Play()
                        TweenService:Create(
                            v.TabTitle,
                            TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {TextColor3 = Color3.fromRGB(150, 150, 150)}
                        ):Play()
                        v.TabBtnIndicator.Size = UDim2.new(0, 0, 0, 18)
                    end
                end
                
                TweenService:Create(
                    TabBtn,
                    TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}
                ):Play()
                TweenService:Create(
                    TabTitle,
                    TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {TextColor3 = Color3.fromRGB(255, 255, 255)}
                ):Play()
                TabBtnIndicator.Size = UDim2.new(0, 4, 0, 18)
            end
        )
        
        local tabcontent = {}
        
        -- 搜索功能
        local function SearchElements(searchText)
            if searchText == "" then
                -- 显示所有元素
                for i, v in ipairs(Tab:GetChildren()) do
                    if v:IsA("Frame") or v:IsA("TextButton") then
                        v.Visible = true
                    end
                end
            else
                -- 根据文本过滤元素
                for i, v in ipairs(Tab:GetChildren()) do
                    if v:IsA("Frame") or v:IsA("TextButton") then
                        local title = v:FindFirstChild("ButtonTitle") or v:FindFirstChild("ToggleTitle") or 
                                     v:FindFirstChild("SliderTitle") or v:FindFirstChild("DropdownTitle") or
                                     v:FindFirstChild("ColorpickerTitle") or v:FindFirstChild("TextboxTitle")
                        if title and string.find(string.lower(title.Text), string.lower(searchText)) then
                            v.Visible = true
                        else
                            v.Visible = false
                        end
                    end
                end
            end
            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 10)
        end

        SearchTextBox:GetPropertyChangedSignal("Text"):Connect(function()
            SearchElements(SearchTextBox.Text)
        end)

        function tabcontent:Button(text, callback)
            local Button = Instance.new("TextButton")
            local ButtonCorner = Instance.new("UICorner")
            local ButtonTitle = Instance.new("TextLabel")

            Button.Name = "Button"
            Button.Parent = Tab
            Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            Button.Size = UDim2.new(0, 384, 0, 40)
            Button.AutoButtonColor = false
            Button.Font = Enum.Font.SourceSans
            Button.Text = ""
            Button.TextColor3 = Color3.fromRGB(0, 0, 0)
            Button.TextSize = 14.000

            ButtonCorner.CornerRadius = UDim.new(0, 8)
            ButtonCorner.Name = "ButtonCorner"
            ButtonCorner.Parent = Button

            ButtonTitle.Name = "ButtonTitle"
            ButtonTitle.Parent = Button
            ButtonTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ButtonTitle.BackgroundTransparency = 1.000
            ButtonTitle.Position = UDim2.new(0.05, 0, 0, 0)
            ButtonTitle.Size = UDim2.new(0, 300, 0, 40)
            ButtonTitle.Font = Enum.Font.Gotham
            ButtonTitle.Text = text
            ButtonTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            ButtonTitle.TextSize = 14.000
            ButtonTitle.TextXAlignment = Enum.TextXAlignment.Left

            Button.MouseEnter:Connect(
                function()
                    TweenService:Create(
                        Button,
                        TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}
                    ):Play()
                end
            )

            Button.MouseLeave:Connect(
                function()
                    TweenService:Create(
                        Button,
                        TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}
                    ):Play()
                end
            )

            Button.MouseButton1Click:Connect(
                function()
                    pcall(callback)
                end
            )

            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 10)
        end
        
        function tabcontent:Toggle(text,default, callback)
            local toggled = false

            local Toggle = Instance.new("TextButton")
            local ToggleCorner = Instance.new("UICorner")
            local ToggleTitle = Instance.new("TextLabel")
            local ToggleFrame = Instance.new("Frame")
            local ToggleFrameCorner = Instance.new("UICorner")
            local ToggleCircle = Instance.new("Frame")
            local ToggleCircleCorner = Instance.new("UICorner")

            Toggle.Name = "Toggle"
            Toggle.Parent = Tab
            Toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            Toggle.Size = UDim2.new(0, 384, 0, 40)
            Toggle.AutoButtonColor = false
            Toggle.Font = Enum.Font.SourceSans
            Toggle.Text = ""
            Toggle.TextColor3 = Color3.fromRGB(0, 0, 0)
            Toggle.TextSize = 14.000

            ToggleCorner.CornerRadius = UDim.new(0, 8)
            ToggleCorner.Name = "ToggleCorner"
            ToggleCorner.Parent = Toggle

            ToggleTitle.Name = "ToggleTitle"
            ToggleTitle.Parent = Toggle
            ToggleTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleTitle.BackgroundTransparency = 1.000
            ToggleTitle.Position = UDim2.new(0.05, 0, 0, 0)
            ToggleTitle.Size = UDim2.new(0, 300, 0, 40)
            ToggleTitle.Font = Enum.Font.Gotham
            ToggleTitle.Text = text
            ToggleTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            ToggleTitle.TextSize = 14.000
            ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left

            ToggleFrame.Name = "ToggleFrame"
            ToggleFrame.Parent = Toggle
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            ToggleFrame.Position = UDim2.new(0.85, 0, 0.25, 0)
            ToggleFrame.Size = UDim2.new(0, 40, 0, 20)

            ToggleFrameCorner.CornerRadius = UDim.new(1, 0)
            ToggleFrameCorner.Name = "ToggleFrameCorner"
            ToggleFrameCorner.Parent = ToggleFrame

            ToggleCircle.Name = "ToggleCircle"
            ToggleCircle.Parent = ToggleFrame
            ToggleCircle.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
            ToggleCircle.Position = UDim2.new(0.1, 0, 0.1, 0)
            ToggleCircle.Size = UDim2.new(0, 16, 0, 16)

            ToggleCircleCorner.CornerRadius = UDim.new(1, 0)
            ToggleCircleCorner.Name = "ToggleCircleCorner"
            ToggleCircleCorner.Parent = ToggleCircle

            Toggle.MouseButton1Click:Connect(
                function()
                    if toggled == false then
                        TweenService:Create(
                            ToggleFrame,
                            TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {BackgroundColor3 = PresetColor}
                        ):Play()
                        TweenService:Create(
                            ToggleCircle,
                            TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}
                        ):Play()
                        ToggleCircle:TweenPosition(
                            UDim2.new(0.7, 0, 0.1, 0),
                            Enum.EasingDirection.Out,
                            Enum.EasingStyle.Quad,
                            .2,
                            true
                        )
                    else
                        TweenService:Create(
                            ToggleFrame,
                            TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}
                        ):Play()
                        TweenService:Create(
                            ToggleCircle,
                            TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {BackgroundColor3 = Color3.fromRGB(120, 120, 120)}
                        ):Play()
                        ToggleCircle:TweenPosition(
                            UDim2.new(0.1, 0, 0.1, 0),
                            Enum.EasingDirection.Out,
                            Enum.EasingStyle.Quad,
                            .2,
                            true
                        )
                    end
                    toggled = not toggled
                    pcall(callback, toggled)
                end
            )

            if default == true then
                TweenService:Create(
                    ToggleFrame,
                    TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {BackgroundColor3 = PresetColor}
                ):Play()
                TweenService:Create(
                    ToggleCircle,
                    TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}
                ):Play()
                ToggleCircle.Position = UDim2.new(0.7, 0, 0.1, 0)
                toggled = true
            end

            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 10)
        end
        
        function tabcontent:Slider(text, min, max, start, callback)
            local dragging = false
            local Slider = Instance.new("Frame")
            local SliderCorner = Instance.new("UICorner")
            local SliderTitle = Instance.new("TextLabel")
            local SliderValue = Instance.new("TextLabel")
            local SlideFrame = Instance.new("Frame")
            local SlideFrameCorner = Instance.new("UICorner")
            local CurrentValueFrame = Instance.new("Frame")
            local CurrentValueFrameCorner = Instance.new("UICorner")
            local SlideCircle = Instance.new("ImageButton")
            local SlideCircleCorner = Instance.new("UICorner")

            Slider.Name = "Slider"
            Slider.Parent = Tab
            Slider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            Slider.Size = UDim2.new(0, 384, 0, 60)

            SliderCorner.CornerRadius = UDim.new(0, 8)
            SliderCorner.Name = "SliderCorner"
            SliderCorner.Parent = Slider

            SliderTitle.Name = "SliderTitle"
            SliderTitle.Parent = Slider
            SliderTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SliderTitle.BackgroundTransparency = 1.000
            SliderTitle.Position = UDim2.new(0.05, 0, 0.1, 0)
            SliderTitle.Size = UDim2.new(0, 300, 0, 20)
            SliderTitle.Font = Enum.Font.Gotham
            SliderTitle.Text = text
            SliderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            SliderTitle.TextSize = 14.000
            SliderTitle.TextXAlignment = Enum.TextXAlignment.Left

            SliderValue.Name = "SliderValue"
            SliderValue.Parent = Slider
            SliderValue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SliderValue.BackgroundTransparency = 1.000
            SliderValue.Position = UDim2.new(0.8, 0, 0.1, 0)
            SliderValue.Size = UDim2.new(0, 60, 0, 20)
            SliderValue.Font = Enum.Font.Gotham
            SliderValue.Text = tostring(start and math.floor((start / max) * (max - min) + min) or min)
            SliderValue.TextColor3 = Color3.fromRGB(255, 255, 255)
            SliderValue.TextSize = 14.000

            SlideFrame.Name = "SlideFrame"
            SlideFrame.Parent = Slider
            SlideFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            SlideFrame.Position = UDim2.new(0.05, 0, 0.7, 0)
            SlideFrame.Size = UDim2.new(0, 350, 0, 6)

            SlideFrameCorner.CornerRadius = UDim.new(1, 0)
            SlideFrameCorner.Name = "SlideFrameCorner"
            SlideFrameCorner.Parent = SlideFrame

            CurrentValueFrame.Name = "CurrentValueFrame"
            CurrentValueFrame.Parent = SlideFrame
            CurrentValueFrame.BackgroundColor3 = PresetColor
            CurrentValueFrame.Size = UDim2.new((start or min) / max, 0, 0, 6)

            CurrentValueFrameCorner.CornerRadius = UDim.new(1, 0)
            CurrentValueFrameCorner.Name = "CurrentValueFrameCorner"
            CurrentValueFrameCorner.Parent = CurrentValueFrame

            SlideCircle.Name = "SlideCircle"
            SlideCircle.Parent = SlideFrame
            SlideCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SlideCircle.Position = UDim2.new((start or min) / max, -8, -0.66, 0)
            SlideCircle.Size = UDim2.new(0, 16, 0, 16)
            SlideCircle.AutoButtonColor = false

            SlideCircleCorner.CornerRadius = UDim.new(1, 0)
            SlideCircleCorner.Name = "SlideCircleCorner"
            SlideCircleCorner.Parent = SlideCircle

            coroutine.wrap(
                function()
                    while wait() do
                        CurrentValueFrame.BackgroundColor3 = PresetColor
                    end
                end
            )()

            local function move(input)
                local pos =
                    UDim2.new(
                    math.clamp((input.Position.X - SlideFrame.AbsolutePosition.X) / SlideFrame.AbsoluteSize.X, 0, 1),
                    -8,
                    -0.66,
                    0
                )
                local pos1 =
                    UDim2.new(
                    math.clamp((input.Position.X - SlideFrame.AbsolutePosition.X) / SlideFrame.AbsoluteSize.X, 0, 1),
                    0,
                    0,
                    6
                )
                CurrentValueFrame:TweenSize(pos1, "Out", "Sine", 0.1, true)
                SlideCircle:TweenPosition(pos, "Out", "Sine", 0.1, true)
                local value = math.floor(((pos.X.Scale * max) / max) * (max - min) + min)
                SliderValue.Text = tostring(value)
                pcall(callback, value)
            end
            
            SlideCircle.InputBegan:Connect(
                function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                    end
                end
            )
            
            SlideCircle.InputEnded:Connect(
                function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end
            )
            
            game:GetService("UserInputService").InputChanged:Connect(
                function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        move(input)
                    end
                end
            )
            
            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 10)
        end
        
        function tabcontent:Dropdown(text, list, callback)
            local droptog = false
            local framesize = 0
            local itemcount = 0

            local Dropdown = Instance.new("Frame")
            local DropdownCorner = Instance.new("UICorner")
            local DropdownBtn = Instance.new("TextButton")
            local DropdownTitle = Instance.new("TextLabel")
            local ArrowImg = Instance.new("ImageLabel")
            local DropItemHolder = Instance.new("ScrollingFrame")
            local DropItemHolderCorner = Instance.new("UICorner")
            local DropLayout = Instance.new("UIListLayout")
            local DropPadding = Instance.new("UIPadding")

            Dropdown.Name = "Dropdown"
            Dropdown.Parent = Tab
            Dropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            Dropdown.ClipsDescendants = true
            Dropdown.Size = UDim2.new(0, 384, 0, 40)

            DropdownCorner.CornerRadius = UDim.new(0, 8)
            DropdownCorner.Name = "DropdownCorner"
            DropdownCorner.Parent = Dropdown

            DropdownBtn.Name = "DropdownBtn"
            DropdownBtn.Parent = Dropdown
            DropdownBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            DropdownBtn.BackgroundTransparency = 1.000
            DropdownBtn.Size = UDim2.new(0, 384, 0, 40)
            DropdownBtn.Font = Enum.Font.SourceSans
            DropdownBtn.Text = ""
            DropdownBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
            DropdownBtn.TextSize = 14.000

            DropdownTitle.Name = "DropdownTitle"
            DropdownTitle.Parent = Dropdown
            DropdownTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            DropdownTitle.BackgroundTransparency = 1.000
            DropdownTitle.Position = UDim2.new(0.05, 0, 0, 0)
            DropdownTitle.Size = UDim2.new(0, 300, 0, 40)
            DropdownTitle.Font = Enum.Font.Gotham
            DropdownTitle.Text = text
            DropdownTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            DropdownTitle.TextSize = 14.000
            DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left

            ArrowImg.Name = "ArrowImg"
            ArrowImg.Parent = DropdownTitle
            ArrowImg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ArrowImg.BackgroundTransparency = 1.000
            ArrowImg.Position = UDim2.new(0.85, 0, 0.25, 0)
            ArrowImg.Size = UDim2.new(0, 20, 0, 20)
            ArrowImg.Image = "rbxassetid://6031091004"
            ArrowImg.ImageColor3 = Color3.fromRGB(200, 200, 200)

            DropItemHolder.Name = "DropItemHolder"
            DropItemHolder.Parent = Dropdown
            DropItemHolder.Active = true
            DropItemHolder.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            DropItemHolder.BorderSizePixel = 0
            DropItemHolder.Position = UDim2.new(0.05, 0, 1, 5)
            DropItemHolder.Size = UDim2.new(0, 350, 0, 0)
            DropItemHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
            DropItemHolder.ScrollBarThickness = 3

            DropItemHolderCorner.CornerRadius = UDim.new(0, 6)
            DropItemHolderCorner.Name = "DropItemHolderCorner"
            DropItemHolderCorner.Parent = DropItemHolder

            DropLayout.Name = "DropLayout"
            DropLayout.Parent = DropItemHolder
            DropLayout.SortOrder = Enum.SortOrder.LayoutOrder
            DropLayout.Padding = UDim.new(0, 5)

            DropPadding.Name = "DropPadding"
            DropPadding.Parent = DropItemHolder
            DropPadding.PaddingLeft = UDim.new(0, 5)
            DropPadding.PaddingTop = UDim.new(0, 5)

            DropdownBtn.MouseButton1Click:Connect(
                function()
                    if droptog == false then
                        framesize = math.min(#list * 30, 120)
                        Dropdown:TweenSize(
                            UDim2.new(0, 384, 0, 45 + framesize),
                            Enum.EasingDirection.Out,
                            Enum.EasingStyle.Quart,
                            .2,
                            true
                        )
                        DropItemHolder:TweenSize(
                            UDim2.new(0, 350, 0, framesize),
                            Enum.EasingDirection.Out,
                            Enum.EasingStyle.Quart,
                            .2,
                            true
                        )
                        TweenService:Create(
                            ArrowImg,
                            TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {Rotation = 180}
                        ):Play()
                        wait(.2)
                        Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 10)
                    else
                        Dropdown:TweenSize(
                            UDim2.new(0, 384, 0, 40),
                            Enum.EasingDirection.Out,
                            Enum.EasingStyle.Quart,
                            .2,
                            true
                        )
                        DropItemHolder:TweenSize(
                            UDim2.new(0, 350, 0, 0),
                            Enum.EasingDirection.Out,
                            Enum.EasingStyle.Quart,
                            .2,
                            true
                        )
                        TweenService:Create(
                            ArrowImg,
                            TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {Rotation = 0}
                        ):Play()
                        wait(.2)
                        Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 10)
                    end
                    droptog = not droptog
                end
            )

            for i, v in next, list do
                local Item = Instance.new("TextButton")
                local ItemCorner = Instance.new("UICorner")

                Item.Name = "Item"
                Item.Parent = DropItemHolder
                Item.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                Item.Size = UDim2.new(0, 340, 0, 25)
                Item.AutoButtonColor = false
                Item.Font = Enum.Font.Gotham
                Item.Text = v
                Item.TextColor3 = Color3.fromRGB(255, 255, 255)
                Item.TextSize = 13.000

                ItemCorner.CornerRadius = UDim.new(0, 4)
                ItemCorner.Name = "ItemCorner"
                ItemCorner.Parent = Item

                Item.MouseEnter:Connect(
                    function()
                        TweenService:Create(
                            Item,
                            TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {BackgroundColor3 = Color3.fromRGB(55, 55, 55)}
                        ):Play()
                    end
                )

                Item.MouseLeave:Connect(
                    function()
                        TweenService:Create(
                            Item,
                            TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}
                        ):Play()
                    end
                )

                Item.MouseButton1Click:Connect(
                    function()
                        droptog = not droptog
                        DropdownTitle.Text = text .. " - " .. v
                        pcall(callback, v)
                        Dropdown:TweenSize(
                            UDim2.new(0, 384, 0, 40),
                            Enum.EasingDirection.Out,
                            Enum.EasingStyle.Quart,
                            .2,
                            true
                        )
                        DropItemHolder:TweenSize(
                            UDim2.new(0, 350, 0, 0),
                            Enum.EasingDirection.Out,
                            Enum.EasingStyle.Quart,
                            .2,
                            true
                        )
                        TweenService:Create(
                            ArrowImg,
                            TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {Rotation = 0}
                        ):Play()
                        wait(.2)
                        Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 10)
                    end
                )

                DropItemHolder.CanvasSize = UDim2.new(0, 0, 0, DropLayout.AbsoluteContentSize.Y + 10)
            end
            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 10)
        end
        
        function tabcontent:Colorpicker(text, preset, callback)
            local ColorPickerToggled = false
            local OldToggleColor = Color3.fromRGB(0, 0, 0)
            local OldColor = Color3.fromRGB(0, 0, 0)
            local OldColorSelectionPosition = nil
            local OldHueSelectionPosition = nil
            local ColorH, ColorS, ColorV = 1, 1, 1
            local RainbowColorPicker = false
            local ColorPickerInput = nil
            local ColorInput = nil
            local HueInput = nil

            local Colorpicker = Instance.new("Frame")
            local ColorpickerCorner = Instance.new("UICorner")
            local ColorpickerTitle = Instance.new("TextLabel")
            local BoxColor = Instance.new("Frame")
            local BoxColorCorner = Instance.new("UICorner")
            local ColorpickerBtn = Instance.new("TextButton")

            Colorpicker.Name = "Colorpicker"
            Colorpicker.Parent = Tab
            Colorpicker.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            Colorpicker.ClipsDescendants = true
            Colorpicker.Size = UDim2.new(0, 384, 0, 40)

            ColorpickerCorner.CornerRadius = UDim.new(0, 8)
            ColorpickerCorner.Name = "ColorpickerCorner"
            ColorpickerCorner.Parent = Colorpicker

            ColorpickerTitle.Name = "ColorpickerTitle"
            ColorpickerTitle.Parent = Colorpicker
            ColorpickerTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ColorpickerTitle.BackgroundTransparency = 1.000
            ColorpickerTitle.Position = UDim2.new(0.05, 0, 0, 0)
            ColorpickerTitle.Size = UDim2.new(0, 300, 0, 40)
            ColorpickerTitle.Font = Enum.Font.Gotham
            ColorpickerTitle.Text = text
            ColorpickerTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            ColorpickerTitle.TextSize = 14.000
            ColorpickerTitle.TextXAlignment = Enum.TextXAlignment.Left

            BoxColor.Name = "BoxColor"
            BoxColor.Parent = ColorpickerTitle
            BoxColor.BackgroundColor3 = preset or Color3.fromRGB(255, 0, 0)
            BoxColor.Position = UDim2.new(0.85, 0, 0.25, 0)
            BoxColor.Size = UDim2.new(0, 30, 0, 20)

            BoxColorCorner.CornerRadius = UDim.new(0, 4)
            BoxColorCorner.Name = "BoxColorCorner"
            BoxColorCorner.Parent = BoxColor

            ColorpickerBtn.Name = "ColorpickerBtn"
            ColorpickerBtn.Parent = Colorpicker
            ColorpickerBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ColorpickerBtn.BackgroundTransparency = 1.000
            ColorpickerBtn.Size = UDim2.new(0, 384, 0, 40)
            ColorpickerBtn.Font = Enum.Font.SourceSans
            ColorpickerBtn.Text = ""
            ColorpickerBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
            ColorpickerBtn.TextSize = 14.000

            -- 简化的颜色选择器实现
            ColorpickerBtn.MouseButton1Click:Connect(
                function()
                    lib:Notification("颜色选择器", "完整颜色选择器功能需要更多代码实现", "确定")
                end
            )

            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 10)
        end
        
        function tabcontent:Label(text)
            local Label = Instance.new("Frame")
            local LabelCorner = Instance.new("UICorner")
            local LabelTitle = Instance.new("TextLabel")

            Label.Name = "Label"
            Label.Parent = Tab
            Label.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            Label.Size = UDim2.new(0, 384, 0, 30)

            LabelCorner.CornerRadius = UDim.new(0, 6)
            LabelCorner.Name = "LabelCorner"
            LabelCorner.Parent = Label

            LabelTitle.Name = "LabelTitle"
            LabelTitle.Parent = Label
            LabelTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            LabelTitle.BackgroundTransparency = 1.000
            LabelTitle.Size = UDim2.new(0, 384, 0, 30)
            LabelTitle.Font = Enum.Font.GothamSemibold
            LabelTitle.Text = text
            LabelTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
            LabelTitle.TextSize = 14.000

            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 10)
        end
        
        function tabcontent:Textbox(text, disapper, callback)
            local Textbox = Instance.new("Frame")
            local TextboxCorner = Instance.new("UICorner")
            local TextboxTitle = Instance.new("TextLabel")
            local TextboxFrame = Instance.new("Frame")
            local TextboxFrameCorner = Instance.new("UICorner")
            local TextBox = Instance.new("TextBox")

            Textbox.Name = "Textbox"
            Textbox.Parent = Tab
            Textbox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            Textbox.ClipsDescendants = true
            Textbox.Size = UDim2.new(0, 384, 0, 60)

            TextboxCorner.CornerRadius = UDim.new(0, 8)
            TextboxCorner.Name = "TextboxCorner"
            TextboxCorner.Parent = Textbox

            TextboxTitle.Name = "TextboxTitle"
            TextboxTitle.Parent = Textbox
            TextboxTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TextboxTitle.BackgroundTransparency = 1.000
            TextboxTitle.Position = UDim2.new(0.05, 0, 0.1, 0)
            TextboxTitle.Size = UDim2.new(0, 300, 0, 20)
            TextboxTitle.Font = Enum.Font.Gotham
            TextboxTitle.Text = text
            TextboxTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextboxTitle.TextSize = 14.000
            TextboxTitle.TextXAlignment = Enum.TextXAlignment.Left

            TextboxFrame.Name = "TextboxFrame"
            TextboxFrame.Parent = Textbox
            TextboxFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            TextboxFrame.Position = UDim2.new(0.05, 0, 0.6, 0)
            TextboxFrame.Size = UDim2.new(0, 350, 0, 25)

            TextboxFrameCorner.CornerRadius = UDim.new(0, 4)
            TextboxFrameCorner.Name = "TextboxFrameCorner"
            TextboxFrameCorner.Parent = TextboxFrame

            TextBox.Parent = TextboxFrame
            TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TextBox.BackgroundTransparency = 1.000
            TextBox.Size = UDim2.new(0, 350, 0, 25)
            TextBox.Font = Enum.Font.Gotham
            TextBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
            TextBox.PlaceholderText = "输入文本..."
            TextBox.Text = ""
            TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextBox.TextSize = 14.000

            TextBox.FocusLost:Connect(
                function(ep)
                    if ep then
                        if #TextBox.Text > 0 then
                            pcall(callback, TextBox.Text)
                            if disapper then
                                TextBox.Text = ""
                            end
                        end
                    end
                end
            )
            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 10)
        end
        
        function tabcontent:Bind(text, keypreset, callback)
            local binding = false
            local Key = keypreset.Name
            local Bind = Instance.new("TextButton")
            local BindCorner = Instance.new("UICorner")
            local BindTitle = Instance.new("TextLabel")
            local BindText = Instance.new("TextLabel")

            Bind.Name = "Bind"
            Bind.Parent = Tab
            Bind.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            Bind.Size = UDim2.new(0, 384, 0, 40)
            Bind.AutoButtonColor = false
            Bind.Font = Enum.Font.SourceSans
            Bind.Text = ""
            Bind.TextColor3 = Color3.fromRGB(0, 0, 0)
            Bind.TextSize = 14.000

            BindCorner.CornerRadius = UDim.new(0, 8)
            BindCorner.Name = "BindCorner"
            BindCorner.Parent = Bind

            BindTitle.Name = "BindTitle"
            BindTitle.Parent = Bind
            BindTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            BindTitle.BackgroundTransparency = 1.000
            BindTitle.Position = UDim2.new(0.05, 0, 0, 0)
            BindTitle.Size = UDim2.new(0, 200, 0, 40)
            BindTitle.Font = Enum.Font.Gotham
            BindTitle.Text = text
            BindTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            BindTitle.TextSize = 14.000
            BindTitle.TextXAlignment = Enum.TextXAlignment.Left

            BindText.Name = "BindText"
            BindText.Parent = Bind
            BindText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            BindText.BackgroundTransparency = 1.000
            BindText.Position = UDim2.new(0.7, 0, 0, 0)
            BindText.Size = UDim2.new(0, 100, 0, 40)
            BindText.Font = Enum.Font.GothamSemibold
            BindText.Text = Key
            BindText.TextColor3 = PresetColor
            BindText.TextSize = 14.000

            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 10)

            Bind.MouseButton1Click:Connect(
                function()
                    BindText.Text = "..."
                    binding = true
                    local inputwait = game:GetService("UserInputService").InputBegan:wait()
                    if inputwait.KeyCode.Name ~= "Unknown" then
                        BindText.Text = inputwait.KeyCode.Name
                        Key = inputwait.KeyCode.Name
                        binding = false
                    else
                        binding = false
                    end
                end
            )

            game:GetService("UserInputService").InputBegan:connect(
                function(current, pressed)
                    if not pressed then
                        if current.KeyCode.Name == Key and binding == false then
                            pcall(callback)
                        end
                    end
                end
            )
        end

        -- 新增功能：卡片式显示
        function tabcontent:Card(title, description, callback)
            local Card = Instance.new("TextButton")
            local CardCorner = Instance.new("UICorner")
            local CardTitle = Instance.new("TextLabel")
            local CardDesc = Instance.new("TextLabel")
            local CardIcon = Instance.new("ImageLabel")

            Card.Name = "Card"
            Card.Parent = Tab
            Card.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            Card.Size = UDim2.new(0, 384, 0, 80)
            Card.AutoButtonColor = false
            Card.Font = Enum.Font.SourceSans
            Card.Text = ""
            Card.TextColor3 = Color3.fromRGB(0, 0, 0)
            Card.TextSize = 14.000

            CardCorner.CornerRadius = UDim.new(0, 12)
            CardCorner.Name = "CardCorner"
            CardCorner.Parent = Card

            CardIcon.Name = "CardIcon"
            CardIcon.Parent = Card
            CardIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            CardIcon.BackgroundTransparency = 1.000
            CardIcon.Position = UDim2.new(0.05, 0, 0.2, 0)
            CardIcon.Size = UDim2.new(0, 40, 0, 40)
            CardIcon.Image = "rbxassetid://3926305904"
            CardIcon.ImageColor3 = PresetColor
            CardIcon.ImageRectOffset = Vector2.new(964, 324)
            CardIcon.ImageRectSize = Vector2.new(36, 36)

            CardTitle.Name = "CardTitle"
            CardTitle.Parent = Card
            CardTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            CardTitle.BackgroundTransparency = 1.000
            CardTitle.Position = UDim2.new(0.2, 0, 0.2, 0)
            CardTitle.Size = UDim2.new(0, 250, 0, 25)
            CardTitle.Font = Enum.Font.GothamSemibold
            CardTitle.Text = title
            CardTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            CardTitle.TextSize = 16.000
            CardTitle.TextXAlignment = Enum.TextXAlignment.Left

            CardDesc.Name = "CardDesc"
            CardDesc.Parent = Card
            CardDesc.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            CardDesc.BackgroundTransparency = 1.000
            CardDesc.Position = UDim2.new(0.2, 0, 0.55, 0)
            CardDesc.Size = UDim2.new(0, 250, 0, 20)
            CardDesc.Font = Enum.Font.Gotham
            CardDesc.Text = description
            CardDesc.TextColor3 = Color3.fromRGB(180, 180, 180)
            CardDesc.TextSize = 12.000
            CardDesc.TextXAlignment = Enum.TextXAlignment.Left
            CardDesc.TextWrapped = true

            Card.MouseEnter:Connect(function()
                TweenService:Create(
                    Card,
                    TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}
                ):Play()
            end)

            Card.MouseLeave:Connect(function()
                TweenService:Create(
                    Card,
                    TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}
                ):Play()
            end)

            Card.MouseButton1Click:Connect(function()
                pcall(callback)
            end)

            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 10)
        end

        -- 新增功能：进度条
        function tabcontent:Progress(text, value, callback)
            local Progress = Instance.new("Frame")
            local ProgressCorner = Instance.new("UICorner")
            local ProgressTitle = Instance.new("TextLabel")
            local ProgressBar = Instance.new("Frame")
            local ProgressBarCorner = Instance.new("UICorner")
            local ProgressFill = Instance.new("Frame")
            local ProgressFillCorner = Instance.new("UICorner")
            local ProgressText = Instance.new("TextLabel")

            Progress.Name = "Progress"
            Progress.Parent = Tab
            Progress.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            Progress.Size = UDim2.new(0, 384, 0, 50)

            ProgressCorner.CornerRadius = UDim.new(0, 8)
            ProgressCorner.Name = "ProgressCorner"
            ProgressCorner.Parent = Progress

            ProgressTitle.Name = "ProgressTitle"
            ProgressTitle.Parent = Progress
            ProgressTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ProgressTitle.BackgroundTransparency = 1.000
            ProgressTitle.Position = UDim2.new(0.05, 0, 0.1, 0)
            ProgressTitle.Size = UDim2.new(0, 200, 0, 20)
            ProgressTitle.Font = Enum.Font.Gotham
            ProgressTitle.Text = text
            ProgressTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            ProgressTitle.TextSize = 14.000
            ProgressTitle.TextXAlignment = Enum.TextXAlignment.Left

            ProgressBar.Name = "ProgressBar"
            ProgressBar.Parent = Progress
            ProgressBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            ProgressBar.Position = UDim2.new(0.05, 0, 0.6, 0)
            ProgressBar.Size = UDim2.new(0, 350, 0, 12)

            ProgressBarCorner.CornerRadius = UDim.new(1, 0)
            ProgressBarCorner.Name = "ProgressBarCorner"
            ProgressBarCorner.Parent = ProgressBar

            ProgressFill.Name = "ProgressFill"
            ProgressFill.Parent = ProgressBar
            ProgressFill.BackgroundColor3 = PresetColor
            ProgressFill.Size = UDim2.new(value or 0.5, 0, 1, 0)

            ProgressFillCorner.CornerRadius = UDim.new(1, 0)
            ProgressFillCorner.Name = "ProgressFillCorner"
            ProgressFillCorner.Parent = ProgressFill

            ProgressText.Name = "ProgressText"
            ProgressText.Parent = Progress
            ProgressText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ProgressText.BackgroundTransparency = 1.000
            ProgressText.Position = UDim2.new(0.8, 0, 0.1, 0)
            ProgressText.Size = UDim2.new(0, 60, 0, 20)
            ProgressText.Font = Enum.Font.Gotham
            ProgressText.Text = math.floor((value or 0.5) * 100) .. "%"
            ProgressText.TextColor3 = Color3.fromRGB(255, 255, 255)
            ProgressText.TextSize = 14.000

            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 10)
        end

        return tabcontent
    end
    return tabhold
end

return lib