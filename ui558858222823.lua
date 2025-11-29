local lib = {RainbowColorValue = 0, HueSelectionPosition = 0}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local PresetColor = Color3.fromRGB(44, 120, 224)
local CloseBind = Enum.KeyCode.RightControl

local ui = Instance.new("ScreenGui")
ui.Name = "sxuiv1"
ui.Parent = game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
ui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local ToggleUI = Instance.new("TextButton")
ToggleUI.Name = "ToggleUI"
ToggleUI.Parent = ui
ToggleUI.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ToggleUI.BackgroundTransparency = 0.2
ToggleUI.BorderSizePixel = 0
ToggleUI.Position = UDim2.new(0, 10, 0, 10)
ToggleUI.Size = UDim2.new(0, 100, 0, 40)
ToggleUI.AutoButtonColor = false
ToggleUI.Font = Enum.Font.GothamBold
ToggleUI.Text = "SX HUB"
ToggleUI.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleUI.TextSize = 14.000
ToggleUI.TextWrapped = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = ToggleUI

local SXText = Instance.new("TextLabel")
SXText.Name = "SXText"
SXText.Parent = ToggleUI
SXText.BackgroundTransparency = 1
SXText.Size = UDim2.new(1, 0, 1, 0)
SXText.Font = Enum.Font.GothamBold
SXText.Text = "SX HUB"
SXText.TextColor3 = Color3.fromRGB(255, 255, 255)
SXText.TextSize = 14.000
SXText.TextWrapped = true

local Gradient = Instance.new("UIGradient")
Gradient.Rotation = 45
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 165, 0)),
    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 255, 0)),
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0, 255, 0)),
    ColorSequenceKeypoint.new(0.8, Color3.fromRGB(0, 0, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(128, 0, 128))
})
Gradient.Parent = SXText

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

MakeDraggable(ToggleUI, ToggleUI)

local uiToggled = false
ToggleUI.MouseButton1Click:Connect(
    function()
        uiToggled = not uiToggled
        if uiToggled then
            ui.Enabled = false
            TweenService:Create(
                ToggleUI,
                TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {BackgroundTransparency = 0.7}
            ):Play()
        else
            ui.Enabled = true
            TweenService:Create(
                ToggleUI,
                TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {BackgroundTransparency = 0.2}
            ):Play()
        end
    end
)

function lib:Window(text, preset, closebind)
    CloseBind = closebind or Enum.KeyCode.RightControl
    PresetColor = preset or Color3.fromRGB(44, 120, 224)
    local fs = false
    local Main = Instance.new("Frame")
    local MainCorner = Instance.new("UICorner")
    local TabHold = Instance.new("Frame")
    local TabHoldLayout = Instance.new("UIListLayout")
    local Title = Instance.new("TextLabel")
    local TabFolder = Instance.new("Folder")
    local DragFrame = Instance.new("Frame")
    local SideBar = Instance.new("Frame")
    local SideBarCorner = Instance.new("UICorner")
    local SearchBox = Instance.new("TextBox")
    local SearchBoxCorner = Instance.new("UICorner")
    local SearchBoxPadding = Instance.new("UIPadding")

    Main.Name = "Main"
    Main.Parent = ui
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.Size = UDim2.new(0, 0, 0, 0)
    Main.ClipsDescendants = true
    Main.Visible = true

    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Name = "MainCorner"
    MainCorner.Parent = Main

    SideBar.Name = "SideBar"
    SideBar.Parent = Main
    SideBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    SideBar.BorderSizePixel = 0
    SideBar.Position = UDim2.new(0, 0, 0, 0)
    SideBar.Size = UDim2.new(0, 130, 0, 350)

    SideBarCorner.CornerRadius = UDim.new(0, 8)
    SideBarCorner.Name = "SideBarCorner"
    SideBarCorner.Parent = SideBar

    SearchBox.Name = "SearchBox"
    SearchBox.Parent = SideBar
    SearchBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    SearchBox.BorderSizePixel = 0
    SearchBox.Position = UDim2.new(0.1, 0, 0.12, 0)
    SearchBox.Size = UDim2.new(0, 107, 0, 25)
    SearchBox.Font = Enum.Font.Gotham
    SearchBox.PlaceholderText = "搜索功能..."
    SearchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    SearchBox.Text = ""
    SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    SearchBox.TextSize = 12.000
    SearchBox.TextXAlignment = Enum.TextXAlignment.Left

    SearchBoxCorner.CornerRadius = UDim.new(0, 4)
    SearchBoxCorner.Parent = SearchBox

    SearchBoxPadding.Parent = SearchBox
    SearchBoxPadding.PaddingLeft = UDim.new(0, 8)

    TabHold.Name = "TabHold"
    TabHold.Parent = SideBar
    TabHold.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TabHold.BackgroundTransparency = 1.000
    TabHold.Position = UDim2.new(0.1, 0, 0.2, 0)
    TabHold.Size = UDim2.new(0, 107, 0, 254)

    TabHoldLayout.Name = "TabHoldLayout"
    TabHoldLayout.Parent = TabHold
    TabHoldLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabHoldLayout.Padding = UDim.new(0, 8)

    Title.Name = "Title"
    Title.Parent = SideBar
    Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1.000
    Title.Position = UDim2.new(0.1, 0, 0.05, 0)
    Title.Size = UDim2.new(0, 110, 0, 25)
    Title.Font = Enum.Font.GothamBold
    Title.Text = text
    Title.TextColor3 = PresetColor
    Title.TextSize = 16.000
    Title.TextXAlignment = Enum.TextXAlignment.Left

    DragFrame.Name = "DragFrame"
    DragFrame.Parent = Main
    DragFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    DragFrame.BackgroundTransparency = 1.000
    DragFrame.Size = UDim2.new(0, 560, 0, 41)

    Main:TweenSize(UDim2.new(0, 560, 0, 350), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .6, true)

    MakeDraggable(DragFrame, Main)

    local uitoggled = false
    UserInputService.InputBegan:Connect(
        function(io, p)
            if io.KeyCode == CloseBind then
                if uitoggled == false then
                    uitoggled = true
                
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

    TabFolder.Name = "TabFolder"
    TabFolder.Parent = Main

    function lib:ChangePresetColor(toch)
        PresetColor = toch
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
        NotificationFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        NotificationFrame.BorderSizePixel = 0
        NotificationFrame.ClipsDescendants = true
        NotificationFrame.Position = UDim2.new(0.5, 0, 0.5, 0)

        NotificationFrameCorner.CornerRadius = UDim.new(0, 8)
        NotificationFrameCorner.Name = "NotificationFrameCorner"
        NotificationFrameCorner.Parent = NotificationFrame

        NotificationFrame:TweenSize(
            UDim2.new(0, 200, 0, 200),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quart,
            .6,
            true
        )

        OkayBtn.Name = "OkayBtn"
        OkayBtn.Parent = NotificationFrame
        OkayBtn.BackgroundColor3 = PresetColor
        OkayBtn.Position = UDim2.new(0.1, 0, 0.75, 0)
        OkayBtn.Size = UDim2.new(0, 160, 0, 35)
        OkayBtn.AutoButtonColor = false
        OkayBtn.Font = Enum.Font.SourceSans
        OkayBtn.Text = ""
        OkayBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        OkayBtn.TextSize = 14.000

        OkayBtnCorner.CornerRadius = UDim.new(0, 5)
        OkayBtnCorner.Name = "OkayBtnCorner"
        OkayBtnCorner.Parent = OkayBtn

        OkayBtnTitle.Name = "OkayBtnTitle"
        OkayBtnTitle.Parent = OkayBtn
        OkayBtnTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        OkayBtnTitle.BackgroundTransparency = 1.000
        OkayBtnTitle.Size = UDim2.new(0, 160, 0, 35)
        OkayBtnTitle.Font = Enum.Font.GothamBold
        OkayBtnTitle.Text = textbtn
        OkayBtnTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        OkayBtnTitle.TextSize = 14.000

        NotificationTitle.Name = "NotificationTitle"
        NotificationTitle.Parent = NotificationFrame
        NotificationTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        NotificationTitle.BackgroundTransparency = 1.000
        NotificationTitle.Position = UDim2.new(0.05, 0, 0.05, 0)
        NotificationTitle.Size = UDim2.new(0, 180, 0, 30)
        NotificationTitle.Font = Enum.Font.GothamBold
        NotificationTitle.Text = texttitle
        NotificationTitle.TextColor3 = PresetColor
        NotificationTitle.TextSize = 18.000
        NotificationTitle.TextXAlignment = Enum.TextXAlignment.Left

        NotificationDesc.Name = "NotificationDesc"
        NotificationDesc.Parent = NotificationFrame
        NotificationDesc.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        NotificationDesc.BackgroundTransparency = 1.000
        NotificationDesc.Position = UDim2.new(0.05, 0, 0.25, 0)
        NotificationDesc.Size = UDim2.new(0, 180, 0, 80)
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
                    {BackgroundColor3 = Color3.fromRGB(
                        math.min(PresetColor.R * 255 + 20, 255),
                        math.min(PresetColor.G * 255 + 20, 255),
                        math.min(PresetColor.B * 255 + 20, 255)
                    )}
                ):Play()
            end
        )

        OkayBtn.MouseLeave:Connect(
            function()
                TweenService:Create(
                    OkayBtn,
                    TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {BackgroundColor3 = PresetColor}
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
        TabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        TabBtn.Size = UDim2.new(0, 107, 0, 30)
        TabBtn.AutoButtonColor = false
        TabBtn.Font = Enum.Font.SourceSans
        TabBtn.Text = ""
        TabBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        TabBtn.TextSize = 14.000

        TabBtnCorner.CornerRadius = UDim.new(0, 5)
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
        TabBtnIndicator.Position = UDim2.new(0, 0, 0.8, 0)
        TabBtnIndicator.Size = UDim2.new(0, 0, 0, 3)

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
        Tab.Position = UDim2.new(0.25, 0, 0.147, 0)
        Tab.Size = UDim2.new(0, 400, 0, 254)
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
        TabPadding.PaddingLeft = UDim.new(0, 10)
        TabPadding.PaddingTop = UDim.new(0, 10)

        if fs == false then
            fs = true
            TabBtnIndicator.Size = UDim2.new(0, 107, 0, 3)
            TabTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            Tab.Visible = true
        end

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
                        v.TabBtnIndicator:TweenSize(
                            UDim2.new(0, 0, 0, 3),
                            Enum.EasingDirection.Out,
                            Enum.EasingStyle.Quart,
                            .2,
                            true
                        )
                        TweenService:Create(
                            v,
                            TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}
                        ):Play()
                        TweenService:Create(
                            v.TabTitle,
                            TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {TextColor3 = Color3.fromRGB(150, 150, 150)}
                        ):Play()
                    end
                end
                TabBtnIndicator:TweenSize(
                    UDim2.new(0, 107, 0, 3),
                    Enum.EasingDirection.Out,
                    Enum.EasingStyle.Quart,
                    .2,
                    true
                )
                TweenService:Create(
                    TabBtn,
                    TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}
                ):Play()
                TweenService:Create(
                    TabTitle,
                    TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {TextColor3 = Color3.fromRGB(255, 255, 255)}
                ):Play()
            end
        )
        
        local tabcontent = {}
        function tabcontent:Button(text, callback)
            local Button = Instance.new("TextButton")
            local ButtonCorner = Instance.new("UICorner")
            local ButtonTitle = Instance.new("TextLabel")

            Button.Name = "Button"
            Button.Parent = Tab
            Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            Button.Size = UDim2.new(0, 380, 0, 40)
            Button.AutoButtonColor = false
            Button.Font = Enum.Font.SourceSans
            Button.Text = ""
            Button.TextColor3 = Color3.fromRGB(0, 0, 0)
            Button.TextSize = 14.000

            ButtonCorner.CornerRadius = UDim.new(0, 6)
            ButtonCorner.Name = "ButtonCorner"
            ButtonCorner.Parent = Button

            ButtonTitle.Name = "ButtonTitle"
            ButtonTitle.Parent = Button
            ButtonTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ButtonTitle.BackgroundTransparency = 1.000
            ButtonTitle.Size = UDim2.new(0, 380, 0, 40)
            ButtonTitle.Font = Enum.Font.Gotham
            ButtonTitle.Text = text
            ButtonTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            ButtonTitle.TextSize = 14.000

            Button.MouseEnter:Connect(
                function()
                    TweenService:Create(
                        Button,
                        TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}
                    ):Play()
                end
            )

            Button.MouseLeave:Connect(
                function()
                    TweenService:Create(
                        Button,
                        TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}
                    ):Play()
                end
            )

            Button.MouseButton1Click:Connect(
                function()
                    TweenService:Create(
                        Button,
                        TweenInfo.new(.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {BackgroundColor3 = PresetColor}
                    ):Play()
                    wait(.1)
                    TweenService:Create(
                        Button,
                        TweenInfo.new(.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}
                    ):Play()
                    pcall(callback)
                end
            )

            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
            
            SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
                local searchText = string.lower(SearchBox.Text)
                if searchText == "" then
                    Button.Visible = true
                else
                    Button.Visible = string.find(string.lower(text), searchText) ~= nil
                end
            end)
        end
        
        function tabcontent:Toggle(text, default, callback)
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
            Toggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            Toggle.Size = UDim2.new(0, 380, 0, 40)
            Toggle.AutoButtonColor = false
            Toggle.Font = Enum.Font.SourceSans
            Toggle.Text = ""
            Toggle.TextColor3 = Color3.fromRGB(0, 0, 0)
            Toggle.TextSize = 14.000

            ToggleCorner.CornerRadius = UDim.new(0, 6)
            ToggleCorner.Name = "ToggleCorner"
            ToggleCorner.Parent = Toggle

            ToggleTitle.Name = "ToggleTitle"
            ToggleTitle.Parent = Toggle
            ToggleTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleTitle.BackgroundTransparency = 1.000
            ToggleTitle.Position = UDim2.new(0.03, 0, 0, 0)
            ToggleTitle.Size = UDim2.new(0, 260, 0, 40)
            ToggleTitle.Font = Enum.Font.Gotham
            ToggleTitle.Text = text
            ToggleTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            ToggleTitle.TextSize = 14.000
            ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left

            ToggleFrame.Name = "ToggleFrame"
            ToggleFrame.Parent = Toggle
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            ToggleFrame.Position = UDim2.new(0.85, 0, 0.5, -10)
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

            Toggle.MouseEnter:Connect(
                function()
                    TweenService:Create(
                        Toggle,
                        TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}
                    ):Play()
                end
            )

            Toggle.MouseLeave:Connect(
                function()
                    TweenService:Create(
                        Toggle,
                        TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}
                    ):Play()
                end
            )

            local function UpdateToggle()
                if toggled then
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
                        UDim2.new(0.55, 0, 0.1, 0),
                        Enum.EasingDirection.Out,
                        Enum.EasingStyle.Quart,
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
                        Enum.EasingStyle.Quart,
                        .2,
                        true
                    )
                end
            end

            Toggle.MouseButton1Click:Connect(
                function()
                    toggled = not toggled
                    UpdateToggle()
                    pcall(callback, toggled)
                end
            )

            if default then
                toggled = true
                UpdateToggle()
            end

            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
            
            SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
                local searchText = string.lower(SearchBox.Text)
                if searchText == "" then
                    Toggle.Visible = true
                else
                    Toggle.Visible = string.find(string.lower(text), searchText) ~= nil
                end
            end)
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
            Slider.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            Slider.Size = UDim2.new(0, 380, 0, 60)

            SliderCorner.CornerRadius = UDim.new(0, 6)
            SliderCorner.Name = "SliderCorner"
            SliderCorner.Parent = Slider

            SliderTitle.Name = "SliderTitle"
            SliderTitle.Parent = Slider
            SliderTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SliderTitle.BackgroundTransparency = 1.000
            SliderTitle.Position = UDim2.new(0.03, 0, 0, 0)
            SliderTitle.Size = UDim2.new(0, 260, 0, 30)
            SliderTitle.Font = Enum.Font.Gotham
            SliderTitle.Text = text
            SliderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            SliderTitle.TextSize = 14.000
            SliderTitle.TextXAlignment = Enum.TextXAlignment.Left

            SliderValue.Name = "SliderValue"
            SliderValue.Parent = Slider
            SliderValue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SliderValue.BackgroundTransparency = 1.000
            SliderValue.Position = UDim2.new(0.8, 0, 0, 0)
            SliderValue.Size = UDim2.new(0, 60, 0, 30)
            SliderValue.Font = Enum.Font.GothamBold
            SliderValue.Text = tostring(start and math.floor((start / max) * (max - min) + min) or min)
            SliderValue.TextColor3 = PresetColor
            SliderValue.TextSize = 14.000

            SlideFrame.Name = "SlideFrame"
            SlideFrame.Parent = Slider
            SlideFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            SlideFrame.Position = UDim2.new(0.03, 0, 0.6, 0)
            SlideFrame.Size = UDim2.new(0, 350, 0, 5)

            SlideFrameCorner.CornerRadius = UDim.new(1, 0)
            SlideFrameCorner.Name = "SlideFrameCorner"
            SlideFrameCorner.Parent = SlideFrame

            CurrentValueFrame.Name = "CurrentValueFrame"
            CurrentValueFrame.Parent = SlideFrame
            CurrentValueFrame.BackgroundColor3 = PresetColor
            CurrentValueFrame.Size = UDim2.new((start or min) / max, 0, 0, 5)

            CurrentValueFrameCorner.CornerRadius = UDim.new(1, 0)
            CurrentValueFrameCorner.Name = "CurrentValueFrameCorner"
            CurrentValueFrameCorner.Parent = CurrentValueFrame

            SlideCircle.Name = "SlideCircle"
            SlideCircle.Parent = SlideFrame
            SlideCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SlideCircle.Position = UDim2.new((start or min) / max, -8, -1.5, 0)
            SlideCircle.Size = UDim2.new(0, 16, 0, 16)
            SlideCircle.AutoButtonColor = false
            SlideCircle.Image = ""

            SlideCircleCorner.CornerRadius = UDim.new(1, 0)
            SlideCircleCorner.Name = "SlideCircleCorner"
            SlideCircleCorner.Parent = SlideCircle

            coroutine.wrap(
                function()
                    while wait() do
                        CurrentValueFrame.BackgroundColor3 = PresetColor
                        SliderValue.TextColor3 = PresetColor
                    end
                end
            )()

            local function move(input)
                local posX = math.clamp((input.Position.X - SlideFrame.AbsolutePosition.X) / SlideFrame.AbsoluteSize.X, 0, 1)
                CurrentValueFrame.Size = UDim2.new(posX, 0, 0, 5)
                SlideCircle.Position = UDim2.new(posX, -8, -1.5, 0)
                local value = math.floor(((posX * max) / max) * (max - min) + min)
                SliderValue.Text = tostring(value)
                pcall(callback, value)
            end

            SlideCircle.InputBegan:Connect(
                function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                    end
                end
            )

            SlideCircle.InputEnded:Connect(
                function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end
            )

            SlideFrame.InputBegan:Connect(
                function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        move(input)
                    end
                end
            )

            UserInputService.InputChanged:Connect(
                function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        move(input)
                    end
                end
            )

            UserInputService.InputEnded:Connect(
                function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end
            )

            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
            
            SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
                local searchText = string.lower(SearchBox.Text)
                if searchText == "" then
                    Slider.Visible = true
                else
                    Slider.Visible = string.find(string.lower(text), searchText) ~= nil
                end
            end)
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
            Dropdown.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            Dropdown.ClipsDescendants = true
            Dropdown.Size = UDim2.new(0, 380, 0, 40)

            DropdownCorner.CornerRadius = UDim.new(0, 6)
            DropdownCorner.Name = "DropdownCorner"
            DropdownCorner.Parent = Dropdown

            DropdownBtn.Name = "DropdownBtn"
            DropdownBtn.Parent = Dropdown
            DropdownBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            DropdownBtn.BackgroundTransparency = 1.000
            DropdownBtn.Size = UDim2.new(0, 380, 0, 40)
            DropdownBtn.Font = Enum.Font.SourceSans
            DropdownBtn.Text = ""
            DropdownBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
            DropdownBtn.TextSize = 14.000

            DropdownTitle.Name = "DropdownTitle"
            DropdownTitle.Parent = Dropdown
            DropdownTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            DropdownTitle.BackgroundTransparency = 1.000
            DropdownTitle.Position = UDim2.new(0.03, 0, 0, 0)
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
            ArrowImg.Position = UDim2.new(0.9, 0, 0.25, 0)
            ArrowImg.Size = UDim2.new(0, 20, 0, 20)
            ArrowImg.Image = "rbxassetid://6031091004"
            ArrowImg.ImageColor3 = Color3.fromRGB(200, 200, 200)

            DropItemHolder.Name = "DropItemHolder"
            DropItemHolder.Parent = Dropdown
            DropItemHolder.Active = true
            DropItemHolder.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            DropItemHolder.BorderSizePixel = 0
            DropItemHolder.Position = UDim2.new(0.03, 0, 1, 5)
            DropItemHolder.Size = UDim2.new(0, 350, 0, 0)
            DropItemHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
            DropItemHolder.ScrollBarThickness = 3
            DropItemHolder.Visible = false

            DropItemHolderCorner.CornerRadius = UDim.new(0, 6)
            DropItemHolderCorner.Name = "DropItemHolderCorner"
            DropItemHolderCorner.Parent = DropItemHolder

            DropLayout.Name = "DropLayout"
            DropLayout.Parent = DropItemHolder
            DropLayout.SortOrder = Enum.SortOrder.LayoutOrder
            DropLayout.Padding = UDim.new(0, 2)

            DropPadding.Name = "DropPadding"
            DropPadding.Parent = DropItemHolder
            DropPadding.PaddingLeft = UDim.new(0, 5)
            DropPadding.PaddingTop = UDim.new(0, 5)

            DropdownBtn.MouseButton1Click:Connect(
                function()
                    if droptog == false then
                        droptog = true
                        DropItemHolder.Visible = true
                        Dropdown:TweenSize(
                            UDim2.new(0, 380, 0, 40 + math.min(#list * 30, 150)),
                            Enum.EasingDirection.Out,
                            Enum.EasingStyle.Quart,
                            .2,
                            true
                        )
                        DropItemHolder:TweenSize(
                            UDim2.new(0, 350, 0, math.min(#list * 30, 150)),
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
                        Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
                    else
                        droptog = false
                        Dropdown:TweenSize(
                            UDim2.new(0, 380, 0, 40),
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
                        DropItemHolder.Visible = false
                        Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
                    end
                end
            )

            for i, v in next, list do
                local Item = Instance.new("TextButton")
                local ItemCorner = Instance.new("UICorner")

                Item.Name = "Item"
                Item.Parent = DropItemHolder
                Item.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
                Item.Size = UDim2.new(0, 340, 0, 25)
                Item.AutoButtonColor = false
                Item.Font = Enum.Font.Gotham
                Item.Text = v
                Item.TextColor3 = Color3.fromRGB(255, 255, 255)
                Item.TextSize = 14.000

                ItemCorner.CornerRadius = UDim.new(0, 4)
                ItemCorner.Name = "ItemCorner"
                ItemCorner.Parent = Item

                Item.MouseEnter:Connect(
                    function()
                        TweenService:Create(
                            Item,
                            TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {BackgroundColor3 = Color3.fromRGB(65, 65, 65)}
                        ):Play()
                    end
                )

                Item.MouseLeave:Connect(
                    function()
                        TweenService:Create(
                            Item,
                            TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {BackgroundColor3 = Color3.fromRGB(55, 55, 55)}
                        ):Play()
                    end
                )

                Item.MouseButton1Click:Connect(
                    function()
                        droptog = false
                        DropdownTitle.Text = text .. " - " .. v
                        pcall(callback, v)
                        Dropdown:TweenSize(
                            UDim2.new(0, 380, 0, 40),
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
                        DropItemHolder.Visible = false
                        Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
                    end
                )
            end

            DropItemHolder.CanvasSize = UDim2.new(0, 0, 0, DropLayout.AbsoluteContentSize.Y)
            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
            
            SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
                local searchText = string.lower(SearchBox.Text)
                if searchText == "" then
                    Dropdown.Visible = true
                else
                    Dropdown.Visible = string.find(string.lower(text), searchText) ~= nil
                end
            end)
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
            Colorpicker.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            Colorpicker.ClipsDescendants = true
            Colorpicker.Size = UDim2.new(0, 380, 0, 40)

            ColorpickerCorner.CornerRadius = UDim.new(0, 6)
            ColorpickerCorner.Name = "ColorpickerCorner"
            ColorpickerCorner.Parent = Colorpicker

            ColorpickerTitle.Name = "ColorpickerTitle"
            ColorpickerTitle.Parent = Colorpicker
            ColorpickerTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ColorpickerTitle.BackgroundTransparency = 1.000
            ColorpickerTitle.Position = UDim2.new(0.03, 0, 0, 0)
            ColorpickerTitle.Size = UDim2.new(0, 300, 0, 40)
            ColorpickerTitle.Font = Enum.Font.Gotham
            ColorpickerTitle.Text = text
            ColorpickerTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            ColorpickerTitle.TextSize = 14.000
            ColorpickerTitle.TextXAlignment = Enum.TextXAlignment.Left

            BoxColor.Name = "BoxColor"
            BoxColor.Parent = ColorpickerTitle
            BoxColor.BackgroundColor3 = preset or Color3.fromRGB(255, 0, 4)
            BoxColor.Position = UDim2.new(0.85, 0, 0.25, 0)
            BoxColor.Size = UDim2.new(0, 30, 0, 20)

            BoxColorCorner.CornerRadius = UDim.new(0, 4)
            BoxColorCorner.Name = "BoxColorCorner"
            BoxColorCorner.Parent = BoxColor

            ColorpickerBtn.Name = "ColorpickerBtn"
            ColorpickerBtn.Parent = Colorpicker
            ColorpickerBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ColorpickerBtn.BackgroundTransparency = 1.000
            ColorpickerBtn.Size = UDim2.new(0, 380, 0, 40)
            ColorpickerBtn.Font = Enum.Font.SourceSans
            ColorpickerBtn.Text = ""
            ColorpickerBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
            ColorpickerBtn.TextSize = 14.000

            local ColorPickerFrame = Instance.new("Frame")
            local ColorPickerFrameCorner = Instance.new("UICorner")
            local ConfirmBtn = Instance.new("TextButton")
            local ConfirmBtnCorner = Instance.new("UICorner")
            local ConfirmBtnTitle = Instance.new("TextLabel")
            local RainbowToggle = Instance.new("TextButton")
            local RainbowToggleCorner = Instance.new("UICorner")
            local RainbowToggleTitle = Instance.new("TextLabel")
            local ToggleFrame = Instance.new("Frame")
            local ToggleFrameCorner = Instance.new("UICorner")
            local ToggleCircle = Instance.new("Frame")
            local ToggleCircleCorner = Instance.new("UICorner")
            local Color = Instance.new("ImageLabel")
            local ColorCorner = Instance.new("UICorner")
            local ColorSelection = Instance.new("ImageLabel")
            local Hue = Instance.new("ImageLabel")
            local HueCorner = Instance.new("UICorner")
            local HueGradient = Instance.new("UIGradient")
            local HueSelection = Instance.new("ImageLabel")

            ColorPickerFrame.Name = "ColorPickerFrame"
            ColorPickerFrame.Parent = Colorpicker
            ColorPickerFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            ColorPickerFrame.Position = UDim2.new(0, 0, 1, 5)
            ColorPickerFrame.Size = UDim2.new(0, 380, 0, 0)
            ColorPickerFrame.Visible = false
            ColorPickerFrame.ClipsDescendants = true

            ColorPickerFrameCorner.CornerRadius = UDim.new(0, 6)
            ColorPickerFrameCorner.Name = "ColorPickerFrameCorner"
            ColorPickerFrameCorner.Parent = ColorPickerFrame

            ConfirmBtn.Name = "ConfirmBtn"
            ConfirmBtn.Parent = ColorPickerFrame
            ConfirmBtn.BackgroundColor3 = PresetColor
            ConfirmBtn.Position = UDim2.new(0.05, 0, 0.8, 0)
            ConfirmBtn.Size = UDim2.new(0, 170, 0, 30)
            ConfirmBtn.AutoButtonColor = false
            ConfirmBtn.Font = Enum.Font.SourceSans
            ConfirmBtn.Text = ""
            ConfirmBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
            ConfirmBtn.TextSize = 14.000

            ConfirmBtnCorner.CornerRadius = UDim.new(0, 4)
            ConfirmBtnCorner.Name = "ConfirmBtnCorner"
            ConfirmBtnCorner.Parent = ConfirmBtn

            ConfirmBtnTitle.Name = "ConfirmBtnTitle"
            ConfirmBtnTitle.Parent = ConfirmBtn
            ConfirmBtnTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ConfirmBtnTitle.BackgroundTransparency = 1.000
            ConfirmBtnTitle.Size = UDim2.new(0, 170, 0, 30)
            ConfirmBtnTitle.Font = Enum.Font.GothamBold
            ConfirmBtnTitle.Text = "Confirm"
            ConfirmBtnTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            ConfirmBtnTitle.TextSize = 14.000

            RainbowToggle.Name = "RainbowToggle"
            RainbowToggle.Parent = ColorPickerFrame
            RainbowToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            RainbowToggle.Position = UDim2.new(0.55, 0, 0.8, 0)
            RainbowToggle.Size = UDim2.new(0, 170, 0, 30)
            RainbowToggle.AutoButtonColor = false
            RainbowToggle.Font = Enum.Font.SourceSans
            RainbowToggle.Text = ""
            RainbowToggle.TextColor3 = Color3.fromRGB(0, 0, 0)
            RainbowToggle.TextSize = 14.000

            RainbowToggleCorner.CornerRadius = UDim.new(0, 4)
            RainbowToggleCorner.Name = "RainbowToggleCorner"
            RainbowToggleCorner.Parent = RainbowToggle

            RainbowToggleTitle.Name = "RainbowToggleTitle"
            RainbowToggleTitle.Parent = RainbowToggle
            RainbowToggleTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            RainbowToggleTitle.BackgroundTransparency = 1.000
            RainbowToggleTitle.Position = UDim2.new(0.05, 0, 0, 0)
            RainbowToggleTitle.Size = UDim2.new(0, 100, 0, 30)
            RainbowToggleTitle.Font = Enum.Font.Gotham
            RainbowToggleTitle.Text = "Rainbow"
            RainbowToggleTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            RainbowToggleTitle.TextSize = 14.000
            RainbowToggleTitle.TextXAlignment = Enum.TextXAlignment.Left

            ToggleFrame.Name = "ToggleFrame"
            ToggleFrame.Parent = RainbowToggle
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            ToggleFrame.Position = UDim2.new(0.8, 0, 0.2, 0)
            ToggleFrame.Size = UDim2.new(0, 40, 0, 18)

            ToggleFrameCorner.CornerRadius = UDim.new(1, 0)
            ToggleFrameCorner.Name = "ToggleFrameCorner"
            ToggleFrameCorner.Parent = ToggleFrame

            ToggleCircle.Name = "ToggleCircle"
            ToggleCircle.Parent = ToggleFrame
            ToggleCircle.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
            ToggleCircle.Position = UDim2.new(0.1, 0, 0.1, 0)
            ToggleCircle.Size = UDim2.new(0, 14, 0, 14)

            ToggleCircleCorner.CornerRadius = UDim.new(1, 0)
            ToggleCircleCorner.Name = "ToggleCircleCorner"
            ToggleCircleCorner.Parent = ToggleCircle

            Color.Name = "Color"
            Color.Parent = ColorPickerFrame
            Color.BackgroundColor3 = Color3.fromRGB(255, 0, 4)
            Color.Position = UDim2.new(0.05, 0, 0.1, 0)
            Color.Size = UDim2.new(0, 200, 0, 100)
            Color.Image = "rbxassetid://4155801252"

            ColorCorner.CornerRadius = UDim.new(0, 4)
            ColorCorner.Name = "ColorCorner"
            ColorCorner.Parent = Color

            ColorSelection.Name = "ColorSelection"
            ColorSelection.Parent = Color
            ColorSelection.AnchorPoint = Vector2.new(0.5, 0.5)
            ColorSelection.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ColorSelection.BackgroundTransparency = 1.000
            ColorSelection.Position = UDim2.new(preset and select(3, Color3.toHSV(preset)))
            ColorSelection.Size = UDim2.new(0, 10, 0, 10)
            ColorSelection.Image = "http://www.roblox.com/asset/?id=4805639000"
            ColorSelection.Visible = false

            Hue.Name = "Hue"
            Hue.Parent = ColorPickerFrame
            Hue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Hue.Position = UDim2.new(0.6, 0, 0.1, 0)
            Hue.Size = UDim2.new(0, 20, 0, 100)

            HueCorner.CornerRadius = UDim.new(0, 4)
            HueCorner.Name = "HueCorner"
            HueCorner.Parent = Hue

            HueGradient.Color =
                ColorSequence.new {
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 4)),
                ColorSequenceKeypoint.new(0.17, Color3.fromRGB(234, 255, 0)),
                ColorSequenceKeypoint.new(0.33, Color3.fromRGB(21, 255, 0)),
                ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)),
                ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 17, 255)),
                ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 251)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 4))
            }
            HueGradient.Rotation = 270
            HueGradient.Name = "HueGradient"
            HueGradient.Parent = Hue

            HueSelection.Name = "HueSelection"
            HueSelection.Parent = Hue
            HueSelection.AnchorPoint = Vector2.new(0.5, 0.5)
            HueSelection.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            HueSelection.BackgroundTransparency = 1.000
            HueSelection.Position = UDim2.new(0.5, 0, 1 - select(1, Color3.toHSV(preset)))
            HueSelection.Size = UDim2.new(0, 18, 0, 18)
            HueSelection.Image = "http://www.roblox.com/asset/?id=4805639000"
            HueSelection.Visible = false

            ColorpickerBtn.MouseButton1Click:Connect(
                function()
                    if ColorPickerToggled == false then
                        ColorPickerToggled = true
                        ColorPickerFrame.Visible = true
                        ColorSelection.Visible = true
                        HueSelection.Visible = true
                        Colorpicker:TweenSize(
                            UDim2.new(0, 380, 0, 180),
                            Enum.EasingDirection.Out,
                            Enum.EasingStyle.Quart,
                            .2,
                            true
                        )
                        ColorPickerFrame:TweenSize(
                            UDim2.new(0, 380, 0, 140),
                            Enum.EasingDirection.Out,
                            Enum.EasingStyle.Quart,
                            .2,
                            true
                        )
                        wait(.2)
                        Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
                    else
                        ColorPickerToggled = false
                        Colorpicker:TweenSize(
                            UDim2.new(0, 380, 0, 40),
                            Enum.EasingDirection.Out,
                            Enum.EasingStyle.Quart,
                            .2,
                            true
                        )
                        ColorPickerFrame:TweenSize(
                            UDim2.new(0, 380, 0, 0),
                            Enum.EasingDirection.Out,
                            Enum.EasingStyle.Quart,
                            .2,
                            true
                        )
                        wait(.2)
                        ColorPickerFrame.Visible = false
                        ColorSelection.Visible = false
                        HueSelection.Visible = false
                        Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
                    end
                end
            )

            local function UpdateColorPicker(nope)
                BoxColor.BackgroundColor3 = Color3.fromHSV(ColorH, ColorS, ColorV)
                Color.BackgroundColor3 = Color3.fromHSV(ColorH, 1, 1)

                pcall(callback, BoxColor.BackgroundColor3)
            end

            ColorH =
                1 -
                (math.clamp(HueSelection.AbsolutePosition.Y - Hue.AbsolutePosition.Y, 0, Hue.AbsoluteSize.Y) /
                    Hue.AbsoluteSize.Y)
            ColorS =
                (math.clamp(ColorSelection.AbsolutePosition.X - Color.AbsolutePosition.X, 0, Color.AbsoluteSize.X) /
                Color.AbsoluteSize.X)
            ColorV =
                1 -
                (math.clamp(ColorSelection.AbsolutePosition.Y - Color.AbsolutePosition.Y, 0, Color.AbsoluteSize.Y) /
                    Color.AbsoluteSize.Y)

            BoxColor.BackgroundColor3 = preset
            Color.BackgroundColor3 = preset
            pcall(callback, BoxColor.BackgroundColor3)

            Color.InputBegan:Connect(
                function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        if RainbowColorPicker then
                            return
                        end

                        if ColorInput then
                            ColorInput:Disconnect()
                        end

                        ColorInput =
                            RunService.RenderStepped:Connect(
                            function()
                                local ColorX =
                                    (math.clamp(Mouse.X - Color.AbsolutePosition.X, 0, Color.AbsoluteSize.X) /
                                    Color.AbsoluteSize.X)
                                local ColorY =
                                    (math.clamp(Mouse.Y - Color.AbsolutePosition.Y, 0, Color.AbsoluteSize.Y) /
                                    Color.AbsoluteSize.Y)

                                ColorSelection.Position = UDim2.new(ColorX, 0, ColorY, 0)
                                ColorS = ColorX
                                ColorV = 1 - ColorY

                                UpdateColorPicker(true)
                            end
                        )
                    end
                end
            )

            Color.InputEnded:Connect(
                function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        if ColorInput then
                            ColorInput:Disconnect()
                        end
                    end
                end
            )

            Hue.InputBegan:Connect(
                function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        if RainbowColorPicker then
                            return
                        end

                        if HueInput then
                            HueInput:Disconnect()
                        end

                        HueInput =
                            RunService.RenderStepped:Connect(
                            function()
                                local HueY =
                                    (math.clamp(Mouse.Y - Hue.AbsolutePosition.Y, 0, Hue.AbsoluteSize.Y) /
                                    Hue.AbsoluteSize.Y)

                                HueSelection.Position = UDim2.new(0.5, 0, HueY, 0)
                                ColorH = 1 - HueY

                                UpdateColorPicker(true)
                            end
                        )
                    end
                end
            )

            Hue.InputEnded:Connect(
                function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        if HueInput then
                            HueInput:Disconnect()
                        end
                    end
                end
            )

            RainbowToggle.MouseButton1Click:Connect(
                function()
                    RainbowColorPicker = not RainbowColorPicker
                    
                    if RainbowColorPicker then
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
                            UDim2.new(0.55, 0, 0.1, 0),
                            Enum.EasingDirection.Out,
                            Enum.EasingStyle.Quart,
                            .2,
                            true
                        )
                        
                        OldToggleColor = BoxColor.BackgroundColor3
                        OldColor = Color.BackgroundColor3
                        OldColorSelectionPosition = ColorSelection.Position
                        OldHueSelectionPosition = HueSelection.Position

                        while RainbowColorPicker do
                            BoxColor.BackgroundColor3 = Color3.fromHSV(lib.RainbowColorValue, 1, 1)
                            Color.BackgroundColor3 = Color3.fromHSV(lib.RainbowColorValue, 1, 1)

                            ColorSelection.Position = UDim2.new(1, 0, 0, 0)
                            HueSelection.Position = UDim2.new(0.48, 0, 0, lib.HueSelectionPosition)

                            pcall(callback, BoxColor.BackgroundColor3)
                            wait()
                        end
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
                            Enum.EasingStyle.Quart,
                            .2,
                            true
                        )
                        
                        BoxColor.BackgroundColor3 = OldToggleColor
                        Color.BackgroundColor3 = OldColor

                        ColorSelection.Position = OldColorSelectionPosition
                        HueSelection.Position = OldHueSelectionPosition

                        pcall(callback, BoxColor.BackgroundColor3)
                    end
                end
            )

            ConfirmBtn.MouseButton1Click:Connect(
                function()
                    ColorPickerToggled = false
                    Colorpicker:TweenSize(
                        UDim2.new(0, 380, 0, 40),
                        Enum.EasingDirection.Out,
                        Enum.EasingStyle.Quart,
                        .2,
                        true
                    )
                    ColorPickerFrame:TweenSize(
                        UDim2.new(0, 380, 0, 0),
                        Enum.EasingDirection.Out,
                        Enum.EasingStyle.Quart,
                        .2,
                        true
                    )
                    wait(.2)
                    ColorPickerFrame.Visible = false
                    ColorSelection.Visible = false
                    HueSelection.Visible = false
                    Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
                end
            )
            
            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
            
            SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
                local searchText = string.lower(SearchBox.Text)
                if searchText == "" then
                    Colorpicker.Visible = true
                else
                    Colorpicker.Visible = string.find(string.lower(text), searchText) ~= nil
                end
            end)
        end
        
        function tabcontent:Label(text)
            local Label = Instance.new("Frame")
            local LabelCorner = Instance.new("UICorner")
            local LabelTitle = Instance.new("TextLabel")

            Label.Name = "Label"
            Label.Parent = Tab
            Label.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            Label.Size = UDim2.new(0, 380, 0, 30)

            LabelCorner.CornerRadius = UDim.new(0, 6)
            LabelCorner.Name = "LabelCorner"
            LabelCorner.Parent = Label

            LabelTitle.Name = "LabelTitle"
            LabelTitle.Parent = Label
            LabelTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            LabelTitle.BackgroundTransparency = 1.000
            LabelTitle.Size = UDim2.new(0, 380, 0, 30)
            LabelTitle.Font = Enum.Font.Gotham
            LabelTitle.Text = text
            LabelTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            LabelTitle.TextSize = 14.000

            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
            
            SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
                local searchText = string.lower(SearchBox.Text)
                if searchText == "" then
                    Label.Visible = true
                else
                    Label.Visible = string.find(string.lower(text), searchText) ~= nil
                end
            end)
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
            Textbox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            Textbox.ClipsDescendants = true
            Textbox.Size = UDim2.new(0, 380, 0, 40)

            TextboxCorner.CornerRadius = UDim.new(0, 6)
            TextboxCorner.Name = "TextboxCorner"
            TextboxCorner.Parent = Textbox

            TextboxTitle.Name = "TextboxTitle"
            TextboxTitle.Parent = Textbox
            TextboxTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TextboxTitle.BackgroundTransparency = 1.000
            TextboxTitle.Position = UDim2.new(0.03, 0, 0, 0)
            TextboxTitle.Size = UDim2.new(0, 200, 0, 40)
            TextboxTitle.Font = Enum.Font.Gotham
            TextboxTitle.Text = text
            TextboxTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextboxTitle.TextSize = 14.000
            TextboxTitle.TextXAlignment = Enum.TextXAlignment.Left

            TextboxFrame.Name = "TextboxFrame"
            TextboxFrame.Parent = Textbox
            TextboxFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            TextboxFrame.Position = UDim2.new(0.6, 0, 0.25, 0)
            TextboxFrame.Size = UDim2.new(0, 140, 0, 25)

            TextboxFrameCorner.CornerRadius = UDim.new(0, 4)
            TextboxFrameCorner.Name = "TextboxFrameCorner"
            TextboxFrameCorner.Parent = TextboxFrame

            TextBox.Parent = TextboxFrame
            TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TextBox.BackgroundTransparency = 1.000
            TextBox.Size = UDim2.new(0, 140, 0, 25)
            TextBox.Font = Enum.Font.Gotham
            TextBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
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
            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
            
            SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
                local searchText = string.lower(SearchBox.Text)
                if searchText == "" then
                    Textbox.Visible = true
                else
                    Textbox.Visible = string.find(string.lower(text), searchText) ~= nil
                end
            end)
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
            Bind.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            Bind.Size = UDim2.new(0, 380, 0, 40)
            Bind.AutoButtonColor = false
            Bind.Font = Enum.Font.SourceSans
            Bind.Text = ""
            Bind.TextColor3 = Color3.fromRGB(0, 0, 0)
            Bind.TextSize = 14.000

            BindCorner.CornerRadius = UDim.new(0, 6)
            BindCorner.Name = "BindCorner"
            BindCorner.Parent = Bind

            BindTitle.Name = "BindTitle"
            BindTitle.Parent = Bind
            BindTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            BindTitle.BackgroundTransparency = 1.000
            BindTitle.Position = UDim2.new(0.03, 0, 0, 0)
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
            BindText.Font = Enum.Font.GothamBold
            BindText.Text = Key
            BindText.TextColor3 = PresetColor
            BindText.TextSize = 14.000

            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)

            Bind.MouseButton1Click:Connect(
                function()
                    BindText.Text = "..."
                    binding = true
                    local inputwait = UserInputService.InputBegan:wait()
                    if inputwait.KeyCode.Name ~= "Unknown" then
                        BindText.Text = inputwait.KeyCode.Name
                        Key = inputwait.KeyCode.Name
                        binding = false
                    else
                        binding = false
                    end
                end
            )

            UserInputService.InputBegan:connect(
                function(current, pressed)
                    if not pressed then
                        if current.KeyCode.Name == Key and binding == false then
                            pcall(callback)
                        end
                    end
                end
            )
            
            SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
                local searchText = string.lower(SearchBox.Text)
                if searchText == "" then
                    Bind.Visible = true
                else
                    Bind.Visible = string.find(string.lower(text), searchText) ~= nil
                end
            end)
        end
        
        return tabcontent
    end
    return tabhold
end

return lib