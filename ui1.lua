local library = {}
local ToggleUI = false
library.currentTab = nil
library.flags = {}

local services = setmetatable({}, {
    __index = function(t, k)
        return game:GetService(k)
    end
})

local mouse = services.Players.LocalPlayer:GetMouse()
local TweenService = services.TweenService

function Tween(obj, t, data)
    TweenService:Create(obj, TweenInfo.new(t[1], Enum.EasingStyle[t[2]], Enum.EasingDirection[t[3]]), data):Play()
    return true
end

function Ripple(obj)
    spawn(function()
        if obj.ClipsDescendants ~= true then
            obj.ClipsDescendants = true
        end
        local Ripple = Instance.new("ImageLabel")
        Ripple.Name = "Ripple"
        Ripple.Parent = obj
        Ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Ripple.BackgroundTransparency = 1.000
        Ripple.ZIndex = 8
        Ripple.Image = "rbxassetid://2708891598"
        Ripple.ImageTransparency = 0.800
        Ripple.ScaleType = Enum.ScaleType.Fit
        Ripple.ImageColor3 = Color3.fromRGB(255, 255, 255)
        Ripple.Position = UDim2.new(
            (mouse.X - Ripple.AbsolutePosition.X) / obj.AbsoluteSize.X,
            0,
            (mouse.Y - Ripple.AbsolutePosition.Y) / obj.AbsoluteSize.Y,
            0
        )
        Tween(Ripple, {.3, "Linear", "InOut"}, {Position = UDim2.new(-5.5, 0, -5.5, 0), Size = UDim2.new(12, 0, 12, 0)})
        wait(0.15)
        Tween(Ripple, {.3, "Linear", "InOut"}, {ImageTransparency = 1})
        wait(.3)
        Ripple:Destroy()
    end)
end

local toggled = false
local switchingTabs = false

function switchTab(new)
    if switchingTabs then return end
    local old = library.currentTab
    if old == nil then
        new[2].Visible = true
        library.currentTab = new
        Tween(new[1], {0.1, "Quad", "Out"}, {ImageTransparency = 0})
        Tween(new[1].TabText, {0.1, "Quad", "Out"}, {TextTransparency = 0})
        return
    end
    if old[1] == new[1] then return end
    switchingTabs = true
    library.currentTab = new
    
    Tween(old[1], {0.1, "Quad", "Out"}, {ImageTransparency = 0.3})
    Tween(new[1], {0.1, "Quad", "Out"}, {ImageTransparency = 0})
    Tween(old[1].TabText, {0.1, "Quad", "Out"}, {TextTransparency = 0.3})
    Tween(new[1].TabText, {0.1, "Quad", "Out"}, {TextTransparency = 0})
    
    old[2].Visible = false
    new[2].Visible = true
    task.wait(0.1)
    switchingTabs = false
end

function drag(frame, hold)
    if not hold then hold = frame end
    local dragging, dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
    
    hold.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
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
    
    services.UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

function library.new(library, name, theme)
    for _, v in next, services.CoreGui:GetChildren() do
        if v.Name == "SXUI" then
            v:Destroy()
        end
    end
    
    local MainXEColor = Color3.fromRGB(15, 0, 20)
    local Background = Color3.fromRGB(10, 0, 15)
    local zyColor = Color3.fromRGB(25, 5, 30)
    local accentColor = Color3.fromRGB(180, 70, 255)
    local textColor = Color3.fromRGB(240, 240, 255)
    
    local dogent = Instance.new("ScreenGui")
    local MainXE = Instance.new("Frame")
    local TabMainXE = Instance.new("Frame")
    local MainXEC = Instance.new("UICorner")
    local SidePanel = Instance.new("Frame")
    local SideGradient = Instance.new("UIGradient")
    local TabBtns = Instance.new("ScrollingFrame")
    local TabBtnsL = Instance.new("UIListLayout")
    local TitleFrame = Instance.new("Frame")
    local MainTitle = Instance.new("TextLabel")
    local SubTitle = Instance.new("TextLabel")
    local TitleGradient = Instance.new("UIGradient")
    local SearchBox = Instance.new("Frame")
    local SearchInput = Instance.new("TextBox")
    local SearchIcon = Instance.new("ImageLabel")
    local SearchCorner = Instance.new("UICorner")
    local MinimizeBtn = Instance.new("TextButton")
    local OrbContainer = Instance.new("Frame")
    local RedOrb = Instance.new("Frame")
    local GreenOrb = Instance.new("Frame")
    local BlueOrb = Instance.new("Frame")
    local DropShadowHolder = Instance.new("Frame")
    local DropShadow = Instance.new("ImageLabel")
    local BorderGradient = Instance.new("UIGradient")
    local UICornerMainXE = Instance.new("UICorner")
    
    if syn and syn.protect_gui then
        syn.protect_gui(dogent)
    end
    
    dogent.Name = "SXUI"
    dogent.Parent = services.CoreGui
    
    function UiDestroy()
        dogent:Destroy()
    end
    
    local Language = {
        ["zh-cn"] = {
            Universal = "SX UI Library",
            OpenUI = "打开",
            HideUI = "隐藏",
            Currently = "当前：",
            SearchPlaceholder = "搜索功能...",
            Minimize = "最小化",
            Maximize = "最大化"
        }
    }
    
    local currentLanguage = "zh-cn"
    
    MainXE.Name = "MainXE"
    MainXE.Parent = dogent
    MainXE.AnchorPoint = Vector2.new(0.5, 0.5)
    MainXE.BackgroundColor3 = Background
    MainXE.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainXE.Size = UDim2.new(0, 0, 0, 0)
    MainXE.ZIndex = 1
    MainXE.Active = true
    MainXE.Draggable = true
    MainXE.Visible = true
    
    UICornerMainXE.Parent = MainXE
    UICornerMainXE.CornerRadius = UDim.new(0, 20)
    
    DropShadowHolder.Name = "DropShadowHolder"
    DropShadowHolder.Parent = MainXE
    DropShadowHolder.BackgroundTransparency = 1
    DropShadowHolder.Size = UDim2.new(1, 0, 1, 0)
    DropShadowHolder.ZIndex = 0
    
    DropShadow.Name = "DropShadow"
    DropShadow.Parent = DropShadowHolder
    DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    DropShadow.BackgroundTransparency = 1
    DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    DropShadow.Size = UDim2.new(1, 10, 1, 10)
    DropShadow.ZIndex = 0
    DropShadow.Image = "rbxassetid://6015897843"
    DropShadow.ImageColor3 = Color3.fromRGB(180, 70, 255)
    DropShadow.ImageTransparency = 0.3
    DropShadow.ScaleType = Enum.ScaleType.Slice
    DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
    
    BorderGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 70, 255)),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(150, 50, 220)),
        ColorSequenceKeypoint.new(0.6, Color3.fromRGB(120, 30, 200)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 70, 255))
    })
    BorderGradient.Rotation = 45
    BorderGradient.Parent = DropShadow
    
    local borderTween = TweenService:Create(
        BorderGradient,
        TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
        {Rotation = 405}
    )
    borderTween:Play()
    
    TabMainXE.Name = "TabMainXE"
    TabMainXE.Parent = MainXE
    TabMainXE.BackgroundColor3 = Background
    TabMainXE.BackgroundTransparency = 1
    TabMainXE.Position = UDim2.new(0.25, 0, 0.1, 0)
    TabMainXE.Size = UDim2.new(0, 450, 0, 400)
    TabMainXE.Visible = false
    
    SidePanel.Name = "SidePanel"
    SidePanel.Parent = MainXE
    SidePanel.BackgroundColor3 = zyColor
    SidePanel.BorderSizePixel = 0
    SidePanel.Position = UDim2.new(0, 0, 0, 0)
    SidePanel.Size = UDim2.new(0, 0, 0, 0)
    
    local sideCorner = Instance.new("UICorner")
    sideCorner.CornerRadius = UDim.new(0, 20)
    sideCorner.Parent = SidePanel
    
    SideGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 5, 40)),
        ColorSequenceKeypoint.new(1, zyColor)
    })
    SideGradient.Rotation = 90
    SideGradient.Parent = SidePanel
    
    TitleFrame.Name = "TitleFrame"
    TitleFrame.Parent = SidePanel
    TitleFrame.BackgroundTransparency = 1
    TitleFrame.Position = UDim2.new(0, 15, 0, 20)
    TitleFrame.Size = UDim2.new(0, 180, 0, 60)
    
    MainTitle.Name = "MainTitle"
    MainTitle.Parent = TitleFrame
    MainTitle.BackgroundTransparency = 1
    MainTitle.Size = UDim2.new(1, 0, 0, 30)
    MainTitle.Font = Enum.Font.GothamBlack
    MainTitle.Text = name
    MainTitle.TextColor3 = textColor
    MainTitle.TextSize = 24
    MainTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    SubTitle.Name = "SubTitle"
    SubTitle.Parent = TitleFrame
    SubTitle.BackgroundTransparency = 1
    SubTitle.Position = UDim2.new(0, 0, 0, 32)
    SubTitle.Size = UDim2.new(1, 0, 0, 20)
    SubTitle.Font = Enum.Font.Gotham
    SubTitle.Text = "高级功能库 v2.0"
    SubTitle.TextColor3 = Color3.fromRGB(200, 180, 255)
    SubTitle.TextSize = 14
    SubTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    TitleGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, accentColor),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(220, 120, 255)),
        ColorSequenceKeypoint.new(1, accentColor)
    })
    TitleGradient.Parent = MainTitle
    
    local titleTween = TweenService:Create(
        TitleGradient,
        TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
        {Offset = Vector2.new(1, 0)}
    )
    titleTween:Play()
    
    TabBtns.Name = "TabBtns"
    TabBtns.Parent = SidePanel
    TabBtns.Active = true
    TabBtns.BackgroundTransparency = 1
    TabBtns.Position = UDim2.new(0, 15, 0, 100)
    TabBtns.Size = UDim2.new(0, 180, 0, 280)
    TabBtns.CanvasSize = UDim2.new(0, 0, 1, 0)
    TabBtns.ScrollBarThickness = 0
    
    TabBtnsL.Name = "TabBtnsL"
    TabBtnsL.Parent = TabBtns
    TabBtnsL.SortOrder = Enum.SortOrder.LayoutOrder
    TabBtnsL.Padding = UDim.new(0, 10)
    
    SearchBox.Name = "SearchBox"
    SearchBox.Parent = MainXE
    SearchBox.BackgroundColor3 = zyColor
    SearchBox.Position = UDim2.new(0.75, 0, 0.02, 0)
    SearchBox.Size = UDim2.new(0, 0, 0, 0)
    
    SearchCorner.CornerRadius = UDim.new(0, 15)
    SearchCorner.Parent = SearchBox
    
    SearchIcon.Name = "SearchIcon"
    SearchIcon.Parent = SearchBox
    SearchIcon.BackgroundTransparency = 1
    SearchIcon.Position = UDim2.new(0, 10, 0.5, -10)
    SearchIcon.Size = UDim2.new(0, 20, 0, 20)
    SearchIcon.Image = "rbxassetid://6031302936"
    SearchIcon.ImageColor3 = accentColor
    
    SearchInput.Name = "SearchInput"
    SearchInput.Parent = SearchBox
    SearchInput.BackgroundTransparency = 1
    SearchInput.Position = UDim2.new(0, 40, 0, 0)
    SearchInput.Size = UDim2.new(1, -40, 1, 0)
    SearchInput.Font = Enum.Font.Gotham
    SearchInput.PlaceholderText = Language[currentLanguage].SearchPlaceholder
    SearchInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 180)
    SearchInput.Text = ""
    SearchInput.TextColor3 = textColor
    SearchInput.TextSize = 14
    SearchInput.TextXAlignment = Enum.TextXAlignment.Left
    
    MinimizeBtn.Name = "MinimizeBtn"
    MinimizeBtn.Parent = MainXE
    MinimizeBtn.BackgroundColor3 = zyColor
    MinimizeBtn.BackgroundTransparency = 0.8
    MinimizeBtn.Position = UDim2.new(0.95, 0, 0.02, 0)
    MinimizeBtn.Size = UDim2.new(0, 0, 0, 0)
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.Text = "-"
    MinimizeBtn.TextColor3 = textColor
    MinimizeBtn.TextSize = 20
    MinimizeBtn.AutoButtonColor = true
    
    local minCorner = Instance.new("UICorner")
    minCorner.CornerRadius = UDim.new(0, 8)
    minCorner.Parent = MinimizeBtn
    
    OrbContainer.Name = "OrbContainer"
    OrbContainer.Parent = MainXE
    OrbContainer.BackgroundTransparency = 1
    OrbContainer.Position = UDim2.new(0.02, 0, 0.02, 0)
    OrbContainer.Size = UDim2.new(0, 0, 0, 0)
    
    local function createOrb(name, color, position)
        local orb = Instance.new("Frame")
        orb.Name = name
        orb.Parent = OrbContainer
        orb.BackgroundColor3 = color
        orb.Size = UDim2.new(0, 12, 0, 12)
        orb.Position = position
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = orb
        
        return orb
    end
    
    RedOrb = createOrb("RedOrb", Color3.fromRGB(255, 80, 80), UDim2.new(0, 0, 0, 0))
    GreenOrb = createOrb("GreenOrb", Color3.fromRGB(80, 255, 80), UDim2.new(0, 16, 0, 0))
    BlueOrb = createOrb("BlueOrb", Color3.fromRGB(80, 80, 255), UDim2.new(0, 32, 0, 0))
    
    local function pulseOrb(orb)
        spawn(function()
            Tween(orb, {0.3, "Quad", "Out"}, {Size = UDim2.new(0, 16, 0, 16)})
            wait(0.1)
            Tween(orb, {0.3, "Quad", "Out"}, {Size = UDim2.new(0, 12, 0, 12)})
        end)
    end
    
    local isMinimized = false
    MinimizeBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            MinimizeBtn.Text = "+"
            Tween(MainXE, {0.5, "Quint", "Out"}, {
                Size = UDim2.new(0, 80, 0, 80),
                Position = UDim2.new(1, -100, 1, -100)
            })
            Tween(SidePanel, {0.5, "Quint", "Out"}, {Size = UDim2.new(0, 0, 0, 0)})
            Tween(SearchBox, {0.5, "Quint", "Out"}, {Size = UDim2.new(0, 0, 0, 0)})
            TabMainXE.Visible = false
        else
            MinimizeBtn.Text = "-"
            Tween(MainXE, {0.5, "Quint", "Out"}, {
                Size = UDim2.new(0, 600, 0, 450),
                Position = UDim2.new(0.5, 0, 0.5, 0)
            })
            Tween(SidePanel, {0.5, "Quint", "Out"}, {Size = UDim2.new(0, 200, 0, 450)})
            Tween(SearchBox, {0.5, "Quint", "Out"}, {Size = UDim2.new(0, 200, 0, 40)})
            TabMainXE.Visible = true
        end
    end)
    
    if _G.SXUILoaded then
        MainXE:TweenSize(UDim2.new(0, 600, 0, 450), "Out", "Quint", 0.8, true, function()
            SidePanel:TweenSize(UDim2.new(0, 200, 0, 450), "Out", "Quint", 0.4, true, function()
                SearchBox:TweenSize(UDim2.new(0, 200, 0, 40), "Out", "Quint", 0.3, function()
                    MinimizeBtn:TweenSize(UDim2.new(0, 30, 0, 30), "Out", "Quint", 0.2, function()
                        OrbContainer:TweenSize(UDim2.new(0, 50, 0, 15), "Out", "Quint", 0.2)
                    end)
                end)
                TabMainXE.Visible = true
            end)
        end)
    else
        MainXE:TweenSize(UDim2.new(0, 600, 0, 450), "Out", "Quint", 1, true, function()
            SidePanel:TweenSize(UDim2.new(0, 200, 0, 450), "Out", "Quint", 0.6, true, function()
                SearchBox:TweenSize(UDim2.new(0, 200, 0, 40), "Out", "Quint", 0.4, function()
                    MinimizeBtn:TweenSize(UDim2.new(0, 30, 0, 30), "Out", "Quint", 0.3, function()
                        OrbContainer:TweenSize(UDim2.new(0, 50, 0, 15), "Out", "Quint", 0.2)
                    end)
                end)
                wait(0.5)
                TabMainXE.Visible = true
                _G.SXUILoaded = true
            end)
        end)
    end
    
    TabBtnsL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabBtns.CanvasSize = UDim2.new(0, 0, 0, TabBtnsL.AbsoluteContentSize.Y + 20)
    end)
    
    drag(MainXE, TitleFrame)
    
    local function animateOrbs()
        while wait(1.5) do
            pulseOrb(RedOrb)
            wait(0.3)
            pulseOrb(GreenOrb)
            wait(0.3)
            pulseOrb(BlueOrb)
        end
    end
    spawn(animateOrbs)
    
    local window = {}
    function window.Tab(window, name, icon)
        local Tab = Instance.new("ScrollingFrame")
        local TabContainer = Instance.new("Frame")
        local TabIco = Instance.new("ImageLabel")
        local TabText = Instance.new("TextLabel")
        local TabBtn = Instance.new("TextButton")
        local TabL = Instance.new("UIListLayout")
        local TabPadding = Instance.new("UIPadding")
        
        Tab.Name = "Tab"
        Tab.Parent = TabMainXE
        Tab.Active = true
        Tab.BackgroundTransparency = 1
        Tab.Size = UDim2.new(1, 0, 1, 0)
        Tab.ScrollBarThickness = 4
        Tab.ScrollBarImageColor3 = accentColor
        Tab.Visible = false
        
        TabContainer.Name = "TabContainer"
        TabContainer.Parent = Tab
        TabContainer.BackgroundTransparency = 1
        TabContainer.Size = UDim2.new(1, -20, 1, 0)
        TabContainer.Position = UDim2.new(0, 10, 0, 0)
        
        TabIco.Name = "TabIco"
        TabIco.Parent = TabBtns
        TabIco.BackgroundTransparency = 1
        TabIco.Size = UDim2.new(0, 24, 0, 24)
        TabIco.Image = ("rbxassetid://%s"):format((icon or 6031302936))
        TabIco.ImageColor3 = accentColor
        TabIco.ImageTransparency = 0.3
        
        TabText.Name = "TabText"
        TabText.Parent = TabIco
        TabText.BackgroundTransparency = 1
        TabText.Position = UDim2.new(1.2, 0, 0, 0)
        TabText.Size = UDim2.new(0, 150, 0, 24)
        TabText.Font = Enum.Font.GothamSemibold
        TabText.Text = name
        TabText.TextColor3 = textColor
        TabText.TextSize = 14
        TabText.TextTransparency = 0.3
        TabText.TextXAlignment = Enum.TextXAlignment.Left
        
        TabBtn.Name = "TabBtn"
        TabBtn.Parent = TabIco
        TabBtn.BackgroundTransparency = 1
        TabBtn.Size = UDim2.new(0, 180, 0, 30)
        TabBtn.AutoButtonColor = false
        TabBtn.Text = ""
        
        TabL.Name = "TabL"
        TabL.Parent = TabContainer
        TabL.SortOrder = Enum.SortOrder.LayoutOrder
        TabL.Padding = UDim.new(0, 8)
        
        TabPadding.Name = "TabPadding"
        TabPadding.Parent = TabContainer
        TabPadding.PaddingTop = UDim.new(0, 10)
        
        TabBtn.MouseButton1Click:Connect(function()
            spawn(function() Ripple(TabBtn) end)
            switchTab({TabIco, Tab})
        end)
        
        if library.currentTab == nil then
            switchTab({TabIco, Tab})
        end
        
        TabL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Tab.CanvasSize = UDim2.new(0, 0, 0, TabL.AbsoluteContentSize.Y + 20)
        end)
        
        local tab = {}
        function tab.section(tab, name, TabVal)
            local Section = Instance.new("Frame")
            local SectionC = Instance.new("UICorner")
            local SectionHeader = Instance.new("Frame")
            local SectionText = Instance.new("TextLabel")
            local SectionIcon = Instance.new("ImageLabel")
            local SectionToggle = Instance.new("ImageButton")
            local Objs = Instance.new("Frame")
            local ObjsL = Instance.new("UIListLayout")
            
            Section.Name = "Section"
            Section.Parent = TabContainer
            Section.BackgroundColor3 = zyColor
            Section.BackgroundTransparency = 0.95
            Section.BorderSizePixel = 0
            Section.ClipsDescendants = true
            Section.Size = UDim2.new(1, 0, 0, 40)
            
            SectionC.CornerRadius = UDim.new(0, 12)
            SectionC.Name = "SectionC"
            SectionC.Parent = Section
            
            SectionHeader.Name = "SectionHeader"
            SectionHeader.Parent = Section
            SectionHeader.BackgroundTransparency = 1
            SectionHeader.Size = UDim2.new(1, 0, 0, 40)
            
            SectionIcon.Name = "SectionIcon"
            SectionIcon.Parent = SectionHeader
            SectionIcon.BackgroundTransparency = 1
            SectionIcon.Position = UDim2.new(0, 15, 0, 8)
            SectionIcon.Size = UDim2.new(0, 24, 0, 24)
            SectionIcon.Image = "rbxassetid://6031302936"
            SectionIcon.ImageColor3 = accentColor
            
            SectionText.Name = "SectionText"
            SectionText.Parent = SectionHeader
            SectionText.BackgroundTransparency = 1
            SectionText.Position = UDim2.new(0, 50, 0, 0)
            SectionText.Size = UDim2.new(0, 300, 0, 40)
            SectionText.Font = Enum.Font.GothamSemibold
            SectionText.Text = name
            SectionText.TextColor3 = textColor
            SectionText.TextSize = 16
            SectionText.TextXAlignment = Enum.TextXAlignment.Left
            
            SectionToggle.Name = "SectionToggle"
            SectionToggle.Parent = SectionHeader
            SectionToggle.BackgroundTransparency = 1
            SectionToggle.Position = UDim2.new(1, -40, 0, 8)
            SectionToggle.Size = UDim2.new(0, 24, 0, 24)
            SectionToggle.Image = "rbxassetid://6031302934"
            SectionToggle.ImageColor3 = accentColor
            
            Objs.Name = "Objs"
            Objs.Parent = Section
            Objs.BackgroundTransparency = 1
            Objs.Position = UDim2.new(0, 10, 0, 45)
            Objs.Size = UDim2.new(1, -20, 0, 0)
            
            ObjsL.Name = "ObjsL"
            ObjsL.Parent = Objs
            ObjsL.SortOrder = Enum.SortOrder.LayoutOrder
            ObjsL.Padding = UDim.new(0, 8)
            
            local open = TabVal or false
            if TabVal ~= false then
                Section.Size = UDim2.new(1, 0, 0, open and 50 + ObjsL.AbsoluteContentSize.Y + 10 or 40)
                SectionToggle.Image = open and "rbxassetid://6031302932" or "rbxassetid://6031302934"
            end
            
            SectionToggle.MouseButton1Click:Connect(function()
                open = not open
                SectionToggle.Image = open and "rbxassetid://6031302932" or "rbxassetid://6031302934"
                Tween(Section, {0.3, "Quint", "Out"}, {
                    Size = UDim2.new(1, 0, 0, open and 50 + ObjsL.AbsoluteContentSize.Y + 10 or 40)
                })
            end)
            
            ObjsL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                if not open then return end
                Section.Size = UDim2.new(1, 0, 0, 50 + ObjsL.AbsoluteContentSize.Y + 10)
            end)
            
            local section = {}
            
            function section.Button(section, text, callback)
                local callback = callback or function() end
                
                local BtnModule = Instance.new("Frame")
                local Btn = Instance.new("TextButton")
                local BtnC = Instance.new("UICorner")
                local BtnGradient = Instance.new("UIGradient")
                
                BtnModule.Name = "BtnModule"
                BtnModule.Parent = Objs
                BtnModule.BackgroundTransparency = 1
                BtnModule.Size = UDim2.new(1, 0, 0, 40)
                
                Btn.Name = "Btn"
                Btn.Parent = BtnModule
                Btn.BackgroundColor3 = zyColor
                Btn.Size = UDim2.new(1, 0, 1, 0)
                Btn.AutoButtonColor = false
                Btn.Font = Enum.Font.GothamSemibold
                Btn.Text = text
                Btn.TextColor3 = textColor
                Btn.TextSize = 14
                
                BtnC.CornerRadius = UDim.new(0, 8)
                BtnC.Name = "BtnC"
                BtnC.Parent = Btn
                
                BtnGradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 15, 60)),
                    ColorSequenceKeypoint.new(1, zyColor)
                })
                BtnGradient.Rotation = 90
                BtnGradient.Parent = Btn
                
                Btn.MouseButton1Click:Connect(function()
                    spawn(function() Ripple(Btn) end)
                    Tween(Btn, {0.1, "Quad", "Out"}, {BackgroundTransparency = 0.7})
                    wait(0.1)
                    Tween(Btn, {0.1, "Quad", "Out"}, {BackgroundTransparency = 0})
                    spawn(callback)
                end)
                
                Btn.MouseEnter:Connect(function()
                    Tween(Btn, {0.2, "Quad", "Out"}, {BackgroundTransparency = 0.3})
                end)
                
                Btn.MouseLeave:Connect(function()
                    Tween(Btn, {0.2, "Quad", "Out"}, {BackgroundTransparency = 0})
                end)
            end
            
            function section:Label(text)
                local LabelModule = Instance.new("Frame")
                local TextLabel = Instance.new("TextLabel")
                local LabelC = Instance.new("UICorner")
                local LabelGradient = Instance.new("UIGradient")
                
                LabelModule.Name = "LabelModule"
                LabelModule.Parent = Objs
                LabelModule.BackgroundTransparency = 1
                LabelModule.Size = UDim2.new(1, 0, 0, 30)
                
                TextLabel.Parent = LabelModule
                TextLabel.BackgroundColor3 = zyColor
                TextLabel.Size = UDim2.new(1, 0, 1, 0)
                TextLabel.Font = Enum.Font.Gotham
                TextLabel.Text = "  " .. text
                TextLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
                TextLabel.TextSize = 14
                TextLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                LabelC.CornerRadius = UDim.new(0, 8)
                LabelC.Parent = TextLabel
                
                LabelGradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 10, 45)),
                    ColorSequenceKeypoint.new(1, zyColor)
                })
                LabelGradient.Rotation = 90
                LabelGradient.Parent = TextLabel
                
                return TextLabel
            end
            
            function section.Toggle(section, text, flag, enabled, callback)
                local callback = callback or function() end
                local enabled = enabled or false
                assert(text, "No text provided")
                assert(flag, "No flag provided")
                
                library.flags[flag] = enabled
                
                local ToggleModule = Instance.new("Frame")
                local ToggleBtn = Instance.new("TextButton")
                local ToggleBtnC = Instance.new("UICorner")
                local ToggleText = Instance.new("TextLabel")
                local ToggleSwitch = Instance.new("Frame")
                local ToggleSwitchC = Instance.new("UICorner")
                local ToggleGradient = Instance.new("UIGradient")
                
                ToggleModule.Name = "ToggleModule"
                ToggleModule.Parent = Objs
                ToggleModule.BackgroundTransparency = 1
                ToggleModule.Size = UDim2.new(1, 0, 0, 40)
                
                ToggleBtn.Name = "ToggleBtn"
                ToggleBtn.Parent = ToggleModule
                ToggleBtn.BackgroundColor3 = zyColor
                ToggleBtn.Size = UDim2.new(1, 0, 1, 0)
                ToggleBtn.AutoButtonColor = false
                ToggleBtn.Text = ""
                
                ToggleBtnC.CornerRadius = UDim.new(0, 8)
                ToggleBtnC.Name = "ToggleBtnC"
                ToggleBtnC.Parent = ToggleBtn
                
                ToggleText.Name = "ToggleText"
                ToggleText.Parent = ToggleBtn
                ToggleText.BackgroundTransparency = 1
                ToggleText.Position = UDim2.new(0, 15, 0, 0)
                ToggleText.Size = UDim2.new(0.7, 0, 1, 0)
                ToggleText.Font = Enum.Font.GothamSemibold
                ToggleText.Text = text
                ToggleText.TextColor3 = textColor
                ToggleText.TextSize = 14
                ToggleText.TextXAlignment = Enum.TextXAlignment.Left
                
                ToggleSwitch.Name = "ToggleSwitch"
                ToggleSwitch.Parent = ToggleBtn
                ToggleSwitch.BackgroundColor3 = enabled and accentColor or Color3.fromRGB(80, 80, 100)
                ToggleSwitch.Position = UDim2.new(0.85, 0, 0.5, -15)
                ToggleSwitch.Size = UDim2.new(0, 60, 0, 30)
                
                ToggleSwitchC.CornerRadius = UDim.new(1, 0)
                ToggleSwitchC.Name = "ToggleSwitchC"
                ToggleSwitchC.Parent = ToggleSwitch
                
                local toggleCircle = Instance.new("Frame")
                toggleCircle.Name = "ToggleCircle"
                toggleCircle.Parent = ToggleSwitch
                toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                toggleCircle.Size = UDim2.new(0, 26, 0, 26)
                toggleCircle.Position = enabled and UDim2.new(1, -28, 0.5, -13) or UDim2.new(0, 2, 0.5, -13)
                
                local circleCorner = Instance.new("UICorner")
                circleCorner.CornerRadius = UDim.new(1, 0)
                circleCorner.Parent = toggleCircle
                
                local funcs = {
                    SetState = function(self, state)
                        if state == nil then state = not library.flags[flag] end
                        if library.flags[flag] == state then return end
                        
                        library.flags[flag] = state
                        Tween(toggleCircle, {0.2, "Quad", "Out"}, {
                            Position = state and UDim2.new(1, -28, 0.5, -13) or UDim2.new(0, 2, 0.5, -13)
                        })
                        Tween(ToggleSwitch, {0.2, "Quad", "Out"}, {
                            BackgroundColor3 = state and accentColor or Color3.fromRGB(80, 80, 100)
                        })
                        callback(state)
                    end,
                    Module = ToggleModule
                }
                
                ToggleBtn.MouseButton1Click:Connect(function()
                    funcs:SetState()
                end)
                
                ToggleBtn.MouseEnter:Connect(function()
                    Tween(ToggleBtn, {0.2, "Quad", "Out"}, {BackgroundTransparency = 0.3})
                end)
                
                ToggleBtn.MouseLeave:Connect(function()
                    Tween(ToggleBtn, {0.2, "Quad", "Out"}, {BackgroundTransparency = 0})
                end)
                
                if enabled then funcs:SetState(true) end
                return funcs
            end
            
            function section.Slider(section, text, flag, default, min, max, precise, callback)
                local callback = callback or function() end
                local min = min or 0
                local max = max or 100
                local default = default or min
                local precise = precise or false
                
                library.flags[flag] = default
                
                assert(text, "No text provided")
                assert(flag, "No flag provided")
                
                local SliderModule = Instance.new("Frame")
                local SliderBack = Instance.new("Frame")
                local SliderBackC = Instance.new("UICorner")
                local SliderText = Instance.new("TextLabel")
                local SliderValue = Instance.new("TextLabel")
                local SliderBar = Instance.new("Frame")
                local SliderBarC = Instance.new("UICorner")
                local SliderFill = Instance.new("Frame")
                local SliderFillC = Instance.new("UICorner")
                local SliderButton = Instance.new("TextButton")
                
                SliderModule.Name = "SliderModule"
                SliderModule.Parent = Objs
                SliderModule.BackgroundTransparency = 1
                SliderModule.Size = UDim2.new(1, 0, 0, 60)
                
                SliderBack.Name = "SliderBack"
                SliderBack.Parent = SliderModule
                SliderBack.BackgroundColor3 = zyColor
                SliderBack.Size = UDim2.new(1, 0, 1, 0)
                
                SliderBackC.CornerRadius = UDim.new(0, 8)
                SliderBackC.Parent = SliderBack
                
                SliderText.Name = "SliderText"
                SliderText.Parent = SliderBack
                SliderText.BackgroundTransparency = 1
                SliderText.Position = UDim2.new(0, 15, 0, 5)
                SliderText.Size = UDim2.new(0.6, 0, 0, 20)
                SliderText.Font = Enum.Font.GothamSemibold
                SliderText.Text = text
                SliderText.TextColor3 = textColor
                SliderText.TextSize = 14
                SliderText.TextXAlignment = Enum.TextXAlignment.Left
                
                SliderValue.Name = "SliderValue"
                SliderValue.Parent = SliderBack
                SliderValue.BackgroundTransparency = 1
                SliderValue.Position = UDim2.new(0.7, 0, 0, 5)
                SliderValue.Size = UDim2.new(0.25, 0, 0, 20)
                SliderValue.Font = Enum.Font.GothamSemibold
                SliderValue.Text = tostring(default)
                SliderValue.TextColor3 = accentColor
                SliderValue.TextSize = 14
                SliderValue.TextXAlignment = Enum.TextXAlignment.Right
                
                SliderBar.Name = "SliderBar"
                SliderBar.Parent = SliderBack
                SliderBar.BackgroundColor3 = Color3.fromRGB(40, 20, 60)
                SliderBar.Position = UDim2.new(0, 15, 0, 30)
                SliderBar.Size = UDim2.new(1, -30, 0, 8)
                
                SliderBarC.CornerRadius = UDim.new(1, 0)
                SliderBarC.Parent = SliderBar
                
                SliderFill.Name = "SliderFill"
                SliderFill.Parent = SliderBar
                SliderFill.BackgroundColor3 = accentColor
                SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
                
                SliderFillC.CornerRadius = UDim.new(1, 0)
                SliderFillC.Parent = SliderFill
                
                SliderButton.Name = "SliderButton"
                SliderButton.Parent = SliderBar
                SliderButton.BackgroundTransparency = 1
                SliderButton.Size = UDim2.new(1, 0, 1, 0)
                SliderButton.Text = ""
                
                local dragging = false
                local lastValue = default
                
                local function updateValue(value)
                    value = math.clamp(value, min, max)
                    if precise then
                        value = tonumber(string.format("%.2f", value))
                    else
                        value = math.floor(value)
                    end
                    
                    if lastValue ~= value then
                        lastValue = value
                        library.flags[flag] = value
                        SliderValue.Text = tostring(value)
                        SliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                        callback(value)
                    end
                end
                
                local function updateSlider(input)
                    local pos = UDim2.new(
                        math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1),
                        0,
                        0, 0
                    )
                    local value = min + (max - min) * pos.X.Scale
                    updateValue(value)
                end
                
                SliderButton.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        updateSlider(input)
                    end
                end)
                
                SliderButton.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                
                services.UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        updateSlider(input)
                    end
                end)
                
                local funcs = {}
                funcs.SetValue = function(self, value)
                    updateValue(value)
                end
                
                updateValue(default)
                return funcs
            end
            
            function section.Dropdown(section, text, flag, options, callback)
                local callback = callback or function() end
                local options = options or {}
                assert(text, "No text provided")
                assert(flag, "No flag provided")
                
                library.flags[flag] = nil
                
                local DropdownModule = Instance.new("Frame")
                local DropdownTop = Instance.new("TextButton")
                local DropdownTopC = Instance.new("UICorner")
                local DropdownText = Instance.new("TextLabel")
                local DropdownArrow = Instance.new("ImageLabel")
                local DropdownList = Instance.new("ScrollingFrame")
                local DropdownListL = Instance.new("UIListLayout")
                
                DropdownModule.Name = "DropdownModule"
                DropdownModule.Parent = Objs
                DropdownModule.BackgroundTransparency = 1
                DropdownModule.ClipsDescendants = true
                DropdownModule.Size = UDim2.new(1, 0, 0, 40)
                
                DropdownTop.Name = "DropdownTop"
                DropdownTop.Parent = DropdownModule
                DropdownTop.BackgroundColor3 = zyColor
                DropdownTop.Size = UDim2.new(1, 0, 0, 40)
                DropdownTop.AutoButtonColor = false
                DropdownTop.Text = ""
                
                DropdownTopC.CornerRadius = UDim.new(0, 8)
                DropdownTopC.Parent = DropdownTop
                
                DropdownText.Name = "DropdownText"
                DropdownText.Parent = DropdownTop
                DropdownText.BackgroundTransparency = 1
                DropdownText.Position = UDim2.new(0, 15, 0, 0)
                DropdownText.Size = UDim2.new(0.8, 0, 1, 0)
                DropdownText.Font = Enum.Font.GothamSemibold
                DropdownText.Text = text
                DropdownText.TextColor3 = textColor
                DropdownText.TextSize = 14
                DropdownText.TextXAlignment = Enum.TextXAlignment.Left
                
                DropdownArrow.Name = "DropdownArrow"
                DropdownArrow.Parent = DropdownTop
                DropdownArrow.BackgroundTransparency = 1
                DropdownArrow.Position = UDim2.new(0.9, 0, 0.5, -10)
                DropdownArrow.Size = UDim2.new(0, 20, 0, 20)
                DropdownArrow.Image = "rbxassetid://6031302934"
                DropdownArrow.ImageColor3 = accentColor
                
                DropdownList.Name = "DropdownList"
                DropdownList.Parent = DropdownModule
                DropdownList.BackgroundColor3 = Color3.fromRGB(25, 10, 35)
                DropdownList.Position = UDim2.new(0, 0, 1, 5)
                DropdownList.Size = UDim2.new(1, 0, 0, 0)
                DropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
                DropdownList.ScrollBarThickness = 4
                DropdownList.ScrollBarImageColor3 = accentColor
                
                local listCorner = Instance.new("UICorner")
                listCorner.CornerRadius = UDim.new(0, 8)
                listCorner.Parent = DropdownList
                
                DropdownListL.Name = "DropdownListL"
                DropdownListL.Parent = DropdownList
                DropdownListL.SortOrder = Enum.SortOrder.LayoutOrder
                DropdownListL.Padding = UDim.new(0, 2)
                
                local open = false
                local selectedOption = nil
                
                local function toggleList()
                    open = not open
                    DropdownArrow.Image = open and "rbxassetid://6031302932" or "rbxassetid://6031302934"
                    Tween(DropdownList, {0.3, "Quint", "Out"}, {
                        Size = UDim2.new(1, 0, 0, open and math.min(#options * 35, 150) or 0)
                    })
                    DropdownModule.Size = UDim2.new(1, 0, 0, open and 45 + DropdownList.Size.Y.Offset or 40)
                end
                
                DropdownTop.MouseButton1Click:Connect(toggleList)
                
                DropdownListL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    DropdownList.CanvasSize = UDim2.new(0, 0, 0, DropdownListL.AbsoluteContentSize.Y)
                end)
                
                local funcs = {}
                
                funcs.AddOption = function(self, option)
                    local OptionBtn = Instance.new("TextButton")
                    local OptionCorner = Instance.new("UICorner")
                    
                    OptionBtn.Name = "Option_" .. option
                    OptionBtn.Parent = DropdownList
                    OptionBtn.BackgroundColor3 = Color3.fromRGB(35, 15, 50)
                    OptionBtn.Size = UDim2.new(1, -10, 0, 30)
                    OptionBtn.Position = UDim2.new(0, 5, 0, 0)
                    OptionBtn.AutoButtonColor = false
                    OptionBtn.Font = Enum.Font.Gotham
                    OptionBtn.Text = option
                    OptionBtn.TextColor3 = textColor
                    OptionBtn.TextSize = 13
                    
                    OptionCorner.CornerRadius = UDim.new(0, 6)
                    OptionCorner.Parent = OptionBtn
                    
                    OptionBtn.MouseButton1Click:Connect(function()
                        selectedOption = option
                        DropdownText.Text = text .. " | " .. option
                        library.flags[flag] = option
                        callback(option)
                        toggleList()
                    end)
                    
                    OptionBtn.MouseEnter:Connect(function()
                        Tween(OptionBtn, {0.2, "Quad", "Out"}, {
                            BackgroundColor3 = Color3.fromRGB(45, 20, 65)
                        })
                    end)
                    
                    OptionBtn.MouseLeave:Connect(function()
                        Tween(OptionBtn, {0.2, "Quad", "Out"}, {
                            BackgroundColor3 = Color3.fromRGB(35, 15, 50)
                        })
                    end)
                end
                
                funcs.SetOptions = function(self, newOptions)
                    for _, v in next, DropdownList:GetChildren() do
                        if v:IsA("TextButton") then
                            v:Destroy()
                        end
                    end
                    for _, option in next, newOptions do
                        funcs:AddOption(option)
                    end
                end
                
                funcs:SetOptions(options)
                return funcs
            end
            
            function section.Textbox(section, text, flag, default, callback)
                local callback = callback or function() end
                assert(text, "No text provided")
                assert(flag, "No flag provided")
                
                library.flags[flag] = default or ""
                
                local TextboxModule = Instance.new("Frame")
                local TextboxBack = Instance.new("Frame")
                local TextboxBackC = Instance.new("UICorner")
                local TextboxLabel = Instance.new("TextLabel")
                local TextboxInput = Instance.new("TextBox")
                local TextboxInputC = Instance.new("UICorner")
                
                TextboxModule.Name = "TextboxModule"
                TextboxModule.Parent = Objs
                TextboxModule.BackgroundTransparency = 1
                TextboxModule.Size = UDim2.new(1, 0, 0, 60)
                
                TextboxBack.Name = "TextboxBack"
                TextboxBack.Parent = TextboxModule
                TextboxBack.BackgroundColor3 = zyColor
                TextboxBack.Size = UDim2.new(1, 0, 1, 0)
                
                TextboxBackC.CornerRadius = UDim.new(0, 8)
                TextboxBackC.Parent = TextboxBack
                
                TextboxLabel.Name = "TextboxLabel"
                TextboxLabel.Parent = TextboxBack
                TextboxLabel.BackgroundTransparency = 1
                TextboxLabel.Position = UDim2.new(0, 15, 0, 5)
                TextboxLabel.Size = UDim2.new(1, -30, 0, 20)
                TextboxLabel.Font = Enum.Font.GothamSemibold
                TextboxLabel.Text = text
                TextboxLabel.TextColor3 = textColor
                TextboxLabel.TextSize = 14
                TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                TextboxInput.Name = "TextboxInput"
                TextboxInput.Parent = TextboxBack
                TextboxInput.BackgroundColor3 = Color3.fromRGB(30, 15, 45)
                TextboxInput.Position = UDim2.new(0, 15, 0, 30)
                TextboxInput.Size = UDim2.new(1, -30, 0, 25)
                TextboxInput.Font = Enum.Font.Gotham
                TextboxInput.PlaceholderText = "输入内容..."
                TextboxInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 180)
                TextboxInput.Text = default or ""
                TextboxInput.TextColor3 = textColor
                TextboxInput.TextSize = 13
                TextboxInput.ClearTextOnFocus = false
                
                TextboxInputC.CornerRadius = UDim.new(0, 6)
                TextboxInputC.Parent = TextboxInput
                
                TextboxInput.FocusLost:Connect(function()
                    library.flags[flag] = TextboxInput.Text
                    callback(TextboxInput.Text)
                end)
                
                TextboxInput.MouseEnter:Connect(function()
                    Tween(TextboxInput, {0.2, "Quad", "Out"}, {
                        BackgroundColor3 = Color3.fromRGB(35, 20, 55)
                    })
                end)
                
                TextboxInput.MouseLeave:Connect(function()
                    Tween(TextboxInput, {0.2, "Quad", "Out"}, {
                        BackgroundColor3 = Color3.fromRGB(30, 15, 45)
                    })
                end)
            end
            
            function section.Keybind(section, text, default, callback)
                local callback = callback or function() end
                assert(text, "No text provided")
                assert(default, "No default key provided")
                
                local default = (typeof(default) == "string" and Enum.KeyCode[default] or default)
                local banned = {
                    Return = true, Space = true, Tab = true,
                    Backquote = true, CapsLock = true, Escape = true
                }
                
                local bindKey = default
                local keyTxt = (default and default.Name or "None")
                
                local KeybindModule = Instance.new("Frame")
                local KeybindBack = Instance.new("Frame")
                local KeybindBackC = Instance.new("UICorner")
                local KeybindText = Instance.new("TextLabel")
                local KeybindValue = Instance.new("TextButton")
                local KeybindValueC = Instance.new("UICorner")
                
                KeybindModule.Name = "KeybindModule"
                KeybindModule.Parent = Objs
                KeybindModule.BackgroundTransparency = 1
                KeybindModule.Size = UDim2.new(1, 0, 0, 40)
                
                KeybindBack.Name = "KeybindBack"
                KeybindBack.Parent = KeybindModule
                KeybindBack.BackgroundColor3 = zyColor
                KeybindBack.Size = UDim2.new(1, 0, 1, 0)
                
                KeybindBackC.CornerRadius = UDim.new(0, 8)
                KeybindBackC.Parent = KeybindBack
                
                KeybindText.Name = "KeybindText"
                KeybindText.Parent = KeybindBack
                KeybindText.BackgroundTransparency = 1
                KeybindText.Position = UDim2.new(0, 15, 0, 0)
                KeybindText.Size = UDim2.new(0.6, 0, 1, 0)
                KeybindText.Font = Enum.Font.GothamSemibold
                KeybindText.Text = text
                KeybindText.TextColor3 = textColor
                KeybindText.TextSize = 14
                KeybindText.TextXAlignment = Enum.TextXAlignment.Left
                
                KeybindValue.Name = "KeybindValue"
                KeybindValue.Parent = KeybindBack
                KeybindValue.BackgroundColor3 = Color3.fromRGB(40, 20, 60)
                KeybindValue.Position = UDim2.new(0.7, 0, 0.5, -15)
                KeybindValue.Size = UDim2.new(0.25, 0, 0, 30)
                KeybindValue.AutoButtonColor = false
                KeybindValue.Font = Enum.Font.GothamSemibold
                KeybindValue.Text = keyTxt
                KeybindValue.TextColor3 = accentColor
                KeybindValue.TextSize = 13
                
                KeybindValueC.CornerRadius = UDim.new(0, 6)
                KeybindValueC.Parent = KeybindValue
                
                services.UserInputService.InputBegan:Connect(function(input, gpe)
                    if gpe then return end
                    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
                    if input.KeyCode ~= bindKey then return end
                    callback(bindKey.Name)
                end)
                
                KeybindValue.MouseButton1Click:Connect(function()
                    KeybindValue.Text = "..."
                    local key = services.UserInputService.InputBegan:Wait()
                    if key.UserInputType ~= Enum.UserInputType.Keyboard then
                        KeybindValue.Text = keyTxt
                        return
                    end
                    if banned[key.KeyCode.Name] then
                        KeybindValue.Text = keyTxt
                        return
                    end
                    bindKey = key.KeyCode
                    keyTxt = key.KeyCode.Name
                    KeybindValue.Text = keyTxt
                end)
                
                KeybindValue.MouseEnter:Connect(function()
                    Tween(KeybindValue, {0.2, "Quad", "Out"}, {
                        BackgroundColor3 = Color3.fromRGB(50, 25, 75)
                    })
                end)
                
                KeybindValue.MouseLeave:Connect(function()
                    Tween(KeybindValue, {0.2, "Quad", "Out"}, {
                        BackgroundColor3 = Color3.fromRGB(40, 20, 60)
                    })
                end)
            end
            
            return section
        end
        return tab
    end
    
    local searchCache = {}
    SearchInput:GetPropertyChangedSignal("Text"):Connect(function()
        local searchText = SearchInput.Text:lower()
        if searchText == "" then
            for _, item in pairs(searchCache) do
                if item and item.Parent then
                    item.Visible = true
                end
            end
            return
        end
        
        for _, item in pairs(searchCache) do
            if item and item.Parent then
                local itemText = item:IsA("TextLabel") and item.Text or 
                                item:IsA("TextButton") and item.Text or ""
                item.Visible = itemText:lower():find(searchText) ~= nil
            end
        end
    end)
    
    function window:AddToSearch(item)
        table.insert(searchCache, item)
    end
    
    return window
end

return library