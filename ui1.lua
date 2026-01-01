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

-- 彩虹动画函数
local function CreateRainbowAnimation(object, property)
    spawn(function()
        while object and object.Parent do
            for i = 0, 1, 0.01 do
                local hue = tick() % 10 / 10
                local color = Color3.fromHSV(hue, 0.8, 1)
                if object[property] then
                    object[property] = color
                end
                wait(0.05)
            end
        end
    end)
end

function Tween(obj, t, data)
    services.TweenService:Create(obj, TweenInfo.new(t[1], Enum.EasingStyle[t[2]], Enum.EasingDirection[t[3]]), data):Play()
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
        Ripple.ImageColor3 = Color3.fromRGB(138, 43, 226)
        Ripple.Position = UDim2.new(
            (mouse.X - Ripple.AbsolutePosition.X) / obj.AbsoluteSize.X,
            0,
            (mouse.Y - Ripple.AbsolutePosition.Y) / obj.AbsoluteSize.Y,
            0
        )
        Tween(Ripple, {.3, "Linear", "InOut"}, {
            Position = UDim2.new(-5.5, 0, -5.5, 0),
            Size = UDim2.new(12, 0, 12, 0)
        })
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
        services.TweenService:Create(new[1], TweenInfo.new(0.1), {ImageTransparency = 0}):Play()
        services.TweenService:Create(new[1].TabText, TweenInfo.new(0.1), {TextTransparency = 0}):Play()
        return
    end
    
    if old[1] == new[1] then return end
    
    switchingTabs = true
    library.currentTab = new
    
    services.TweenService:Create(old[1], TweenInfo.new(0.1), {ImageTransparency = 0.2}):Play()
    services.TweenService:Create(new[1], TweenInfo.new(0.1), {ImageTransparency = 0}):Play()
    services.TweenService:Create(old[1].TabText, TweenInfo.new(0.1), {TextTransparency = 0.2}):Play()
    services.TweenService:Create(new[1].TabText, TweenInfo.new(0.1), {TextTransparency = 0}):Play()
    
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

-- 三色球效果
local function CreateOrbitingBalls(parent)
    local container = Instance.new("Frame")
    container.Name = "OrbitingBalls"
    container.Parent = parent
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(1, 0, 1, 0)
    container.ZIndex = 10
    
    local balls = {}
    local colors = {
        Color3.fromRGB(138, 43, 226),  -- 紫色
        Color3.fromRGB(255, 105, 180),  -- 粉色
        Color3.fromRGB(0, 255, 255)     -- 青色
    }
    
    for i = 1, 3 do
        local ball = Instance.new("Frame")
        ball.Name = "Ball"..i
        ball.Parent = container
        ball.Size = UDim2.new(0, 8, 0, 8)
        ball.BackgroundColor3 = colors[i]
        ball.BorderSizePixel = 0
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = ball
        
        local glow = Instance.new("UIGradient")
        glow.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, colors[i]),
            ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1))
        })
        glow.Rotation = 45
        glow.Parent = ball
        
        table.insert(balls, ball)
    end
    
    spawn(function()
        local time = 0
        while container and container.Parent do
            time = time + 0.05
            for i, ball in ipairs(balls) do
                local angle = time + (i - 1) * (math.pi * 2 / 3)
                local radius = 15
                local x = math.cos(angle) * radius
                local y = math.sin(angle) * radius
                ball.Position = UDim2.new(0.5, x, 0.5, y)
            end
            wait()
        end
    end)
end

function library.new(library, name, theme)
    for _, v in next, services.CoreGui:GetChildren() do
        if v.Name == "PremiumUI" then
            v:Destroy()
        end
    end
    
    -- 颜色配置
    local MainColor = Color3.fromRGB(25, 25, 25)
    local SecondaryColor = Color3.fromRGB(35, 35, 35)
    local AccentColor = Color3.fromRGB(138, 43, 226)  -- 紫色
    local TextColor = Color3.fromRGB(255, 255, 255)
    
    -- 创建主UI
    local dogent = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local MainCorner = Instance.new("UICorner")
    local MainGradient = Instance.new("UIGradient")
    local DropShadow = Instance.new("ImageLabel")
    
    local SidePanel = Instance.new("Frame")
    local SideCorner = Instance.new("UICorner")
    local SideGradient = Instance.new("UIGradient")
    
    local ContentPanel = Instance.new("Frame")
    local ContentCorner = Instance.new("UICorner")
    
    local TitleContainer = Instance.new("Frame")
    local MainTitle = Instance.new("TextLabel")
    local SubTitle = Instance.new("TextLabel")
    local TitleGradient = Instance.new("UIGradient")
    
    local SearchContainer = Instance.new("Frame")
    local SearchBox = Instance.new("TextBox")
    local SearchIcon = Instance.new("ImageLabel")
    local SearchCorner = Instance.new("UICorner")
    
    local TabsContainer = Instance.new("ScrollingFrame")
    local TabsList = Instance.new("UIListLayout")
    
    local MinimizeButton = Instance.new("TextButton")
    local MinimizeCorner = Instance.new("UICorner")
    local MinimizeIcon = Instance.new("ImageLabel")
    
    local TabContentContainer = Instance.new("Frame")
    local TabContent = Instance.new("ScrollingFrame")
    local ContentList = Instance.new("UIListLayout")
    
    if syn and syn.protect_gui then
        syn.protect_gui(dogent)
    end
    
    dogent.Name = "PremiumUI"
    dogent.Parent = services.CoreGui
    dogent.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- 主框架
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = dogent
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = MainColor
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.Size = UDim2.new(0, 650, 0, 450)
    MainFrame.Active = true
    MainFrame.Draggable = true
    
    -- 大圆角
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainFrame
    
    -- 边框渐变
    MainGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, AccentColor),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 70, 255)),
        ColorSequenceKeypoint.new(1, AccentColor)
    })
    MainGradient.Rotation = 90
    MainGradient.Parent = MainFrame
    
    -- 阴影
    DropShadow.Name = "DropShadow"
    DropShadow.Parent = MainFrame
    DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    DropShadow.BackgroundTransparency = 1
    DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    DropShadow.Size = UDim2.new(1, 24, 1, 24)
    DropShadow.ZIndex = -1
    DropShadow.Image = "rbxassetid://6015897843"
    DropShadow.ImageColor3 = AccentColor
    DropShadow.ImageTransparency = 0.3
    DropShadow.ScaleType = Enum.ScaleType.Slice
    DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
    
    -- 侧边栏
    SidePanel.Name = "SidePanel"
    SidePanel.Parent = MainFrame
    SidePanel.BackgroundColor3 = SecondaryColor
    SidePanel.Position = UDim2.new(0, 0, 0, 0)
    SidePanel.Size = UDim2.new(0, 160, 0, 450)
    
    SideCorner.CornerRadius = UDim.new(0, 12)
    SideCorner.Parent = SidePanel
    
    SideGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, SecondaryColor),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(45, 45, 45))
    })
    SideGradient.Rotation = 90
    SideGradient.Parent = SidePanel
    
    -- 标题容器
    TitleContainer.Name = "TitleContainer"
    TitleContainer.Parent = SidePanel
    TitleContainer.BackgroundTransparency = 1
    TitleContainer.Position = UDim2.new(0, 15, 0, 15)
    TitleContainer.Size = UDim2.new(1, -30, 0, 60)
    
    -- 主标题
    MainTitle.Name = "MainTitle"
    MainTitle.Parent = TitleContainer
    MainTitle.BackgroundTransparency = 1
    MainTitle.Size = UDim2.new(1, 0, 0, 30)
    MainTitle.Font = Enum.Font.GothamBold
    MainTitle.Text = name
    MainTitle.TextColor3 = TextColor
    MainTitle.TextSize = 24
    MainTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    -- 副标题
    SubTitle.Name = "SubTitle"
    SubTitle.Parent = TitleContainer
    SubTitle.BackgroundTransparency = 1
    SubTitle.Position = UDim2.new(0, 0, 0, 32)
    SubTitle.Size = UDim2.new(1, 0, 0, 20)
    SubTitle.Font = Enum.Font.Gotham
    SubTitle.Text = "Premium Interface"
    SubTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
    SubTitle.TextSize = 14
    SubTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    -- 标题渐变效果
    TitleGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, AccentColor),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 105, 180)),
        ColorSequenceKeypoint.new(1, AccentColor)
    })
    TitleGradient.Parent = MainTitle
    
    -- 搜索容器
    SearchContainer.Name = "SearchContainer"
    SearchContainer.Parent = MainFrame
    SearchContainer.BackgroundColor3 = SecondaryColor
    SearchContainer.Position = UDim2.new(0, 165, 0, 15)
    SearchContainer.Size = UDim2.new(0, 220, 0, 35)
    
    SearchCorner.CornerRadius = UDim.new(0, 8)
    SearchCorner.Parent = SearchContainer
    
    -- 搜索图标
    SearchIcon.Name = "SearchIcon"
    SearchIcon.Parent = SearchContainer
    SearchIcon.BackgroundTransparency = 1
    SearchIcon.Position = UDim2.new(0, 10, 0, 7)
    SearchIcon.Size = UDim2.new(0, 20, 0, 20)
    SearchIcon.Image = "rbxassetid://6031302936"
    SearchIcon.ImageColor3 = Color3.fromRGB(200, 200, 200)
    
    -- 搜索框
    SearchBox.Name = "SearchBox"
    SearchBox.Parent = SearchContainer
    SearchBox.BackgroundTransparency = 1
    SearchBox.Position = UDim2.new(0, 35, 0, 0)
    SearchBox.Size = UDim2.new(1, -40, 1, 0)
    SearchBox.Font = Enum.Font.Gotham
    SearchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    SearchBox.PlaceholderText = "搜索功能..."
    SearchBox.Text = ""
    SearchBox.TextColor3 = TextColor
    SearchBox.TextSize = 14
    SearchBox.TextXAlignment = Enum.TextXAlignment.Left
    
    -- 最小化按钮
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Parent = MainFrame
    MinimizeButton.BackgroundColor3 = AccentColor
    MinimizeButton.Position = UDim2.new(1, -45, 0, 15)
    MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
    MinimizeButton.AutoButtonColor = false
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Text = ""
    MinimizeButton.TextColor3 = TextColor
    MinimizeButton.TextSize = 20
    
    MinimizeCorner.CornerRadius = UDim.new(0, 6)
    MinimizeCorner.Parent = MinimizeButton
    
    MinimizeIcon.Name = "MinimizeIcon"
    MinimizeIcon.Parent = MinimizeButton
    MinimizeIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    MinimizeIcon.BackgroundTransparency = 1
    MinimizeIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    MinimizeIcon.Size = UDim2.new(0, 20, 0, 20)
    MinimizeIcon.Image = "rbxassetid://6031091004"
    MinimizeIcon.ImageColor3 = TextColor
    
    -- 选项卡容器
    TabsContainer.Name = "TabsContainer"
    TabsContainer.Parent = SidePanel
    TabsContainer.BackgroundTransparency = 1
    TabsContainer.Position = UDim2.new(0, 15, 0, 100)
    TabsContainer.Size = UDim2.new(1, -30, 1, -120)
    TabsContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabsContainer.ScrollBarThickness = 3
    TabsContainer.ScrollBarImageColor3 = AccentColor
    
    TabsList.Name = "TabsList"
    TabsList.Parent = TabsContainer
    TabsList.SortOrder = Enum.SortOrder.LayoutOrder
    TabsList.Padding = UDim.new(0, 8)
    
    -- 内容面板
    ContentPanel.Name = "ContentPanel"
    ContentPanel.Parent = MainFrame
    ContentPanel.BackgroundColor3 = MainColor
    ContentPanel.Position = UDim2.new(0, 165, 0, 60)
    ContentPanel.Size = UDim2.new(1, -170, 1, -65)
    
    ContentCorner.CornerRadius = UDim.new(0, 8)
    ContentCorner.Parent = ContentPanel
    
    -- 选项卡内容容器
    TabContentContainer.Name = "TabContentContainer"
    TabContentContainer.Parent = ContentPanel
    TabContentContainer.BackgroundTransparency = 1
    TabContentContainer.Size = UDim2.new(1, 0, 1, 0)
    
    TabContent.Name = "TabContent"
    TabContent.Parent = TabContentContainer
    TabContent.BackgroundTransparency = 1
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContent.ScrollBarThickness = 3
    TabContent.ScrollBarImageColor3 = AccentColor
    
    ContentList.Name = "ContentList"
    ContentList.Parent = TabContent
    ContentList.SortOrder = Enum.SortOrder.LayoutOrder
    ContentList.Padding = UDim.new(0, 8)
    
    -- 创建三色球
    CreateOrbitingBalls(MainFrame)
    
    -- 动态搜索功能
    local function SearchFunctions(searchText)
        local allFunctions = {}
        local currentTab = library.currentTab
        if not currentTab then return end
        
        for _, child in ipairs(currentTab[2]:GetDescendants()) do
            if child:IsA("TextLabel") or child:IsA("TextButton") then
                if child.Text and child.Text ~= "" then
                    table.insert(allFunctions, {
                        object = child,
                        text = child.Text:lower()
                    })
                end
            end
        end
        
        for _, func in ipairs(allFunctions) do
            local parent = func.object.Parent
            if parent and parent:IsA("Frame") then
                if searchText == "" or func.text:find(searchText:lower()) then
                    parent.Visible = true
                    Tween(parent, {0.2, "Quad", "Out"}, {BackgroundTransparency = 0})
                else
                    Tween(parent, {0.2, "Quad", "Out"}, {BackgroundTransparency = 0.5})
                    spawn(function()
                        wait(0.2)
                        if parent then
                            parent.Visible = false
                        end
                    end)
                end
            end
        end
    end
    
    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        SearchFunctions(SearchBox.Text)
    end)
    
    -- 最小化功能
    local isMinimized = false
    local originalSize = UDim2.new(0, 650, 0, 450)
    local minimizedSize = UDim2.new(0, 60, 0, 60)
    
    MinimizeButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        
        if isMinimized then
            -- 最小化动画
            Tween(MainFrame, {0.3, "Quad", "Out"}, {
                Size = minimizedSize,
                Position = UDim2.new(1, -80, 1, -80)
            })
            Tween(MinimizeIcon, {0.3, "Quad", "Out"}, {Rotation = 180})
            
            -- 隐藏内容
            SidePanel.Visible = false
            ContentPanel.Visible = false
            SearchContainer.Visible = false
            
            -- 创建圆形效果
            MainCorner.CornerRadius = UDim.new(1, 0)
            
            -- 旋转动画
            spawn(function()
                while isMinimized do
                    Tween(MinimizeIcon, {1, "Linear", "Out"}, {Rotation = MinimizeIcon.Rotation + 360})
                    wait(1)
                end
            end)
        else
            -- 恢复动画
            MainCorner.CornerRadius = UDim.new(0, 12)
            Tween(MainFrame, {0.3, "Quad", "Out"}, {
                Size = originalSize,
                Position = UDim2.new(0.5, 0, 0.5, 0)
            })
            Tween(MinimizeIcon, {0.3, "Quad", "Out"}, {Rotation = 0})
            
            -- 显示内容
            SidePanel.Visible = true
            ContentPanel.Visible = true
            SearchContainer.Visible = true
        end
    end)
    
    -- 列表尺寸更新
    TabsList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabsContainer.CanvasSize = UDim2.new(0, 0, 0, TabsList.AbsoluteContentSize.Y)
    end)
    
    ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 20)
    end)
    
    -- 开启动画
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.BackgroundTransparency = 1
    
    local openSequence = function()
        Tween(MainFrame, {0.5, "Quad", "Out"}, {
            Size = originalSize,
            BackgroundTransparency = 0
        })
        
        -- 彩虹边框动画
        local rainbowGradient = Instance.new("UIGradient")
        rainbowGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 127, 0)),
            ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 255, 0)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 0)),
            ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
            ColorSequenceKeypoint.new(0.83, Color3.fromRGB(139, 0, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
        })
        rainbowGradient.Parent = MainGradient
        
        spawn(function()
            while MainFrame and MainFrame.Parent do
                rainbowGradient.Offset = Vector2.new(rainbowGradient.Offset.X + 0.01, 0)
                wait()
            end
        end)
    end
    
    openSequence()
    
    -- 拖动功能
    drag(MainFrame)
    
    local window = {}
    
    function window.Tab(window, name, icon)
        local TabButton = Instance.new("TextButton")
        local TabCorner = Instance.new("UICorner")
        local TabGradient = Instance.new("UIGradient")
        local TabIcon = Instance.new("ImageLabel")
        local TabLabel = Instance.new("TextLabel")
        
        local TabContentFrame = Instance.new("ScrollingFrame")
        local TabContentList = Instance.new("UIListLayout")
        
        -- 选项卡按钮
        TabButton.Name = "TabButton_" .. name
        TabButton.Parent = TabsContainer
        TabButton.BackgroundColor3 = SecondaryColor
        TabButton.Size = UDim2.new(1, 0, 0, 45)
        TabButton.AutoButtonColor = false
        TabButton.Text = ""
        
        TabCorner.CornerRadius = UDim.new(0, 8)
        TabCorner.Parent = TabButton
        
        TabGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, SecondaryColor),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 50))
        })
        TabGradient.Rotation = 90
        TabGradient.Parent = TabButton
        
        TabIcon.Name = "TabIcon"
        TabIcon.Parent = TabButton
        TabIcon.BackgroundTransparency = 1
        TabIcon.Position = UDim2.new(0, 15, 0, 10)
        TabIcon.Size = UDim2.new(0, 25, 0, 25)
        TabIcon.Image = icon or "rbxassetid://6031280882"
        TabIcon.ImageColor3 = Color3.fromRGB(200, 200, 200)
        
        TabLabel.Name = "TabLabel"
        TabLabel.Parent = TabButton
        TabLabel.BackgroundTransparency = 1
        TabLabel.Position = UDim2.new(0, 50, 0, 0)
        TabLabel.Size = UDim2.new(1, -55, 1, 0)
        TabLabel.Font = Enum.Font.GothamBold
        TabLabel.Text = name
        TabLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabLabel.TextSize = 14
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        -- 选项卡内容
        TabContentFrame.Name = "TabContent_" .. name
        TabContentFrame.Parent = TabContentContainer
        TabContentFrame.BackgroundTransparency = 1
        TabContentFrame.Size = UDim2.new(1, 0, 1, 0)
        TabContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContentFrame.ScrollBarThickness = 3
        TabContentFrame.ScrollBarImageColor3 = AccentColor
        TabContentFrame.Visible = false
        
        TabContentList.Name = "TabContentList"
        TabContentList.Parent = TabContentFrame
        TabContentList.SortOrder = Enum.SortOrder.LayoutOrder
        TabContentList.Padding = UDim.new(0, 8)
        
        TabContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContentFrame.CanvasSize = UDim2.new(0, 0, 0, TabContentList.AbsoluteContentSize.Y + 20)
        end)
        
        -- 选项卡点击事件
        TabButton.MouseButton1Click:Connect(function()
            Ripple(TabButton)
            switchTab({TabButton, TabContentFrame})
            
            -- 按钮选中效果
            for _, btn in ipairs(TabsContainer:GetChildren()) do
                if btn:IsA("TextButton") then
                    Tween(btn, {0.2, "Quad", "Out"}, {BackgroundColor3 = SecondaryColor})
                    if btn.TabIcon then
                        Tween(btn.TabIcon, {0.2, "Quad", "Out"}, {ImageColor3 = Color3.fromRGB(200, 200, 200)})
                    end
                    if btn.TabLabel then
                        Tween(btn.TabLabel, {0.2, "Quad", "Out"}, {TextColor3 = Color3.fromRGB(200, 200, 200)})
                    end
                end
            end
            
            Tween(TabButton, {0.2, "Quad", "Out"}, {BackgroundColor3 = AccentColor})
            Tween(TabIcon, {0.2, "Quad", "Out"}, {ImageColor3 = TextColor})
            Tween(TabLabel, {0.2, "Quad", "Out"}, {TextColor3 = TextColor})
        end)
        
        if library.currentTab == nil then
            switchTab({TabButton, TabContentFrame})
            Tween(TabButton, {0.2, "Quad", "Out"}, {BackgroundColor3 = AccentColor})
            Tween(TabIcon, {0.2, "Quad", "Out"}, {ImageColor3 = TextColor})
            Tween(TabLabel, {0.2, "Quad", "Out"}, {TextColor3 = TextColor})
        end
        
        local tab = {}
        
        function tab.section(tab, name, defaultOpen)
            local Section = Instance.new("Frame")
            local SectionCorner = Instance.new("UICorner")
            local SectionGradient = Instance.new("UIGradient")
            local SectionHeader = Instance.new("TextButton")
            local SectionTitle = Instance.new("TextLabel")
            local SectionIcon = Instance.new("ImageLabel")
            local SectionContent = Instance.new("Frame")
            local SectionContentList = Instance.new("UIListLayout")
            
            Section.Name = "Section_" .. name
            Section.Parent = TabContentFrame
            Section.BackgroundColor3 = SecondaryColor
            Section.Size = UDim2.new(1, 0, 0, 50)
            
            SectionCorner.CornerRadius = UDim.new(0, 8)
            SectionCorner.Parent = Section
            
            SectionGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, SecondaryColor),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(45, 45, 45))
            })
            SectionGradient.Rotation = 90
            SectionGradient.Parent = Section
            
            SectionHeader.Name = "SectionHeader"
            SectionHeader.Parent = Section
            SectionHeader.BackgroundTransparency = 1
            SectionHeader.Size = UDim2.new(1, 0, 0, 50)
            SectionHeader.Text = ""
            
            SectionTitle.Name = "SectionTitle"
            SectionTitle.Parent = SectionHeader
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Position = UDim2.new(0, 50, 0, 0)
            SectionTitle.Size = UDim2.new(1, -60, 1, 0)
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.Text = name
            SectionTitle.TextColor3 = TextColor
            SectionTitle.TextSize = 16
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            SectionIcon.Name = "SectionIcon"
            SectionIcon.Parent = SectionHeader
            SectionIcon.BackgroundTransparency = 1
            SectionIcon.Position = UDim2.new(0, 15, 0, 12)
            SectionIcon.Size = UDim2.new(0, 26, 0, 26)
            SectionIcon.Image = "rbxassetid://6031302932"
            SectionIcon.ImageColor3 = AccentColor
            
            SectionContent.Name = "SectionContent"
            SectionContent.Parent = Section
            SectionContent.BackgroundTransparency = 1
            SectionContent.Position = UDim2.new(0, 0, 0, 55)
            SectionContent.Size = UDim2.new(1, 0, 0, 0)
            SectionContent.ClipsDescendants = true
            
            SectionContentList.Name = "SectionContentList"
            SectionContentList.Parent = SectionContent
            SectionContentList.SortOrder = Enum.SortOrder.LayoutOrder
            SectionContentList.Padding = UDim.new(0, 8)
            
            local isOpen = defaultOpen or false
            
            local function toggleSection()
                isOpen = not isOpen
                if isOpen then
                    Tween(Section, {0.3, "Quad", "Out"}, {
                        Size = UDim2.new(1, 0, 0, 55 + SectionContentList.AbsoluteContentSize.Y)
                    })
                    Tween(SectionContent, {0.3, "Quad", "Out"}, {
                        Size = UDim2.new(1, 0, 0, SectionContentList.AbsoluteContentSize.Y)
                    })
                    Tween(SectionIcon, {0.3, "Quad", "Out"}, {Rotation = 90})
                else
                    Tween(Section, {0.3, "Quad", "Out"}, {Size = UDim2.new(1, 0, 0, 50)})
                    Tween(SectionContent, {0.3, "Quad", "Out"}, {Size = UDim2.new(1, 0, 0, 0)})
                    Tween(SectionIcon, {0.3, "Quad", "Out"}, {Rotation = 0})
                end
            end
            
            SectionHeader.MouseButton1Click:Connect(function()
                toggleSection()
            end)
            
            SectionContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                if isOpen then
                    Section.Size = UDim2.new(1, 0, 0, 55 + SectionContentList.AbsoluteContentSize.Y)
                    SectionContent.Size = UDim2.new(1, 0, 0, SectionContentList.AbsoluteContentSize.Y)
                end
            end)
            
            if defaultOpen then
                toggleSection()
            end
            
            local section = {}
            
            function section.Button(section, text, callback)
                local Button = Instance.new("TextButton")
                local ButtonCorner = Instance.new("UICorner")
                local ButtonGradient = Instance.new("UIGradient")
                local ButtonLabel = Instance.new("TextLabel")
                local ButtonIcon = Instance.new("ImageLabel")
                
                Button.Name = "Button_" .. text
                Button.Parent = SectionContent
                Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                Button.Size = UDim2.new(1, 0, 0, 40)
                Button.AutoButtonColor = false
                Button.Text = ""
                
                ButtonCorner.CornerRadius = UDim.new(0, 6)
                ButtonCorner.Parent = Button
                
                ButtonGradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 40)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 50))
                })
                ButtonGradient.Rotation = 90
                ButtonGradient.Parent = Button
                
                ButtonIcon.Name = "ButtonIcon"
                ButtonIcon.Parent = Button
                ButtonIcon.BackgroundTransparency = 1
                ButtonIcon.Position = UDim2.new(0, 15, 0, 10)
                ButtonIcon.Size = UDim2.new(0, 20, 0, 20)
                ButtonIcon.Image = "rbxassetid://6031280882"
                ButtonIcon.ImageColor3 = AccentColor
                
                ButtonLabel.Name = "ButtonLabel"
                ButtonLabel.Parent = Button
                ButtonLabel.BackgroundTransparency = 1
                ButtonLabel.Position = UDim2.new(0, 45, 0, 0)
                ButtonLabel.Size = UDim2.new(1, -50, 1, 0)
                ButtonLabel.Font = Enum.Font.Gotham
                ButtonLabel.Text = text
                ButtonLabel.TextColor3 = TextColor
                ButtonLabel.TextSize = 14
                ButtonLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                Button.MouseEnter:Connect(function()
                    Tween(Button, {0.2, "Quad", "Out"}, {BackgroundColor3 = Color3.fromRGB(50, 50, 50)})
                end)
                
                Button.MouseLeave:Connect(function()
                    Tween(Button, {0.2, "Quad", "Out"}, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)})
                end)
                
                Button.MouseButton1Click:Connect(function()
                    Ripple(Button)
                    if callback then
                        callback()
                    end
                end)
            end
            
            function section.Toggle(section, text, flag, enabled, callback)
                local Toggle = Instance.new("TextButton")
                local ToggleCorner = Instance.new("UICorner")
                local ToggleGradient = Instance.new("UIGradient")
                local ToggleLabel = Instance.new("TextLabel")
                local ToggleSwitch = Instance.new("Frame")
                local ToggleSwitchCorner = Instance.new("UICorner")
                local ToggleKnob = Instance.new("Frame")
                local ToggleKnobCorner = Instance.new("UICorner")
                
                library.flags[flag] = enabled or false
                
                Toggle.Name = "Toggle_" .. flag
                Toggle.Parent = SectionContent
                Toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                Toggle.Size = UDim2.new(1, 0, 0, 40)
                Toggle.AutoButtonColor = false
                Toggle.Text = ""
                
                ToggleCorner.CornerRadius = UDim.new(0, 6)
                ToggleCorner.Parent = Toggle
                
                ToggleGradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 40)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 50))
                })
                ToggleGradient.Rotation = 90
                ToggleGradient.Parent = Toggle
                
                ToggleLabel.Name = "ToggleLabel"
                ToggleLabel.Parent = Toggle
                ToggleLabel.BackgroundTransparency = 1
                ToggleLabel.Position = UDim2.new(0, 15, 0, 0)
                ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
                ToggleLabel.Font = Enum.Font.Gotham
                ToggleLabel.Text = text
                ToggleLabel.TextColor3 = TextColor
                ToggleLabel.TextSize = 14
                ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                ToggleSwitch.Name = "ToggleSwitch"
                ToggleSwitch.Parent = Toggle
                ToggleSwitch.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                ToggleSwitch.Position = UDim2.new(0.85, 0, 0.25, 0)
                ToggleSwitch.Size = UDim2.new(0, 50, 0, 20)
                
                ToggleSwitchCorner.CornerRadius = UDim.new(1, 0)
                ToggleSwitchCorner.Parent = ToggleSwitch
                
                ToggleKnob.Name = "ToggleKnob"
                ToggleKnob.Parent = ToggleSwitch
                ToggleKnob.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
                ToggleKnob.Size = UDim2.new(0, 20, 0, 20)
                
                ToggleKnobCorner.CornerRadius = UDim.new(1, 0)
                ToggleKnobCorner.Parent = ToggleKnob
                
                local function updateToggle(state)
                    library.flags[flag] = state
                    if state then
                        Tween(ToggleKnob, {0.2, "Quad", "Out"}, {
                            Position = UDim2.new(1, -20, 0, 0),
                            BackgroundColor3 = AccentColor
                        })
                        Tween(ToggleSwitch, {0.2, "Quad", "Out"}, {
                            BackgroundColor3 = Color3.fromRGB(138, 43, 226, 0.3)
                        })
                    else
                        Tween(ToggleKnob, {0.2, "Quad", "Out"}, {
                            Position = UDim2.new(0, 0, 0, 0),
                            BackgroundColor3 = Color3.fromRGB(150, 150, 150)
                        })
                        Tween(ToggleSwitch, {0.2, "Quad", "Out"}, {
                            BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                        })
                    end
                    if callback then
                        callback(state)
                    end
                end
                
                Toggle.MouseButton1Click:Connect(function()
                    Ripple(Toggle)
                    updateToggle(not library.flags[flag])
                end)
                
                if enabled then
                    updateToggle(true)
                end
                
                local funcs = {}
                funcs.SetState = function(self, state)
                    updateToggle(state)
                end
                
                return funcs
            end
            
            function section.Slider(section, text, flag, default, min, max, callback)
                local Slider = Instance.new("Frame")
                local SliderCorner = Instance.new("UICorner")
                local SliderGradient = Instance.new("UIGradient")
                local SliderLabel = Instance.new("TextLabel")
                local SliderValue = Instance.new("TextLabel")
                local SliderTrack = Instance.new("Frame")
                local SliderTrackCorner = Instance.new("UICorner")
                local SliderFill = Instance.new("Frame")
                local SliderFillCorner = Instance.new("UICorner")
                local SliderThumb = Instance.new("Frame")
                local SliderThumbCorner = Instance.new("UICorner")
                
                library.flags[flag] = default or min
                
                Slider.Name = "Slider_" .. flag
                Slider.Parent = SectionContent
                Slider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                Slider.Size = UDim2.new(1, 0, 0, 60)
                
                SliderCorner.CornerRadius = UDim.new(0, 6)
                SliderCorner.Parent = Slider
                
                SliderGradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 40)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 50))
                })
                SliderGradient.Rotation = 90
                SliderGradient.Parent = Slider
                
                SliderLabel.Name = "SliderLabel"
                SliderLabel.Parent = Slider
                SliderLabel.BackgroundTransparency = 1
                SliderLabel.Position = UDim2.new(0, 15, 0, 8)
                SliderLabel.Size = UDim2.new(0.7, 0, 0, 20)
                SliderLabel.Font = Enum.Font.Gotham
                SliderLabel.Text = text
                SliderLabel.TextColor3 = TextColor
                SliderLabel.TextSize = 14
                SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                SliderValue.Name = "SliderValue"
                SliderValue.Parent = Slider
                SliderValue.BackgroundTransparency = 1
                SliderValue.Position = UDim2.new(0.85, 0, 0, 8)
                SliderValue.Size = UDim2.new(0.15, -15, 0, 20)
                SliderValue.Font = Enum.Font.GothamBold
                SliderValue.Text = tostring(default or min)
                SliderValue.TextColor3 = AccentColor
                SliderValue.TextSize = 14
                SliderValue.TextXAlignment = Enum.TextXAlignment.Right
                
                SliderTrack.Name = "SliderTrack"
                SliderTrack.Parent = Slider
                SliderTrack.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                SliderTrack.Position = UDim2.new(0, 15, 0, 35)
                SliderTrack.Size = UDim2.new(1, -30, 0, 10)
                
                SliderTrackCorner.CornerRadius = UDim.new(0, 5)
                SliderTrackCorner.Parent = SliderTrack
                
                SliderFill.Name = "SliderFill"
                SliderFill.Parent = SliderTrack
                SliderFill.BackgroundColor3 = AccentColor
                SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
                
                SliderFillCorner.CornerRadius = UDim.new(0, 5)
                SliderFillCorner.Parent = SliderFill
                
                SliderThumb.Name = "SliderThumb"
                SliderThumb.Parent = SliderTrack
                SliderThumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                SliderThumb.Position = UDim2.new((default - min) / (max - min), -10, 0, -5)
                SliderThumb.Size = UDim2.new(0, 20, 0, 20)
                
                SliderThumbCorner.CornerRadius = UDim.new(1, 0)
                SliderThumbCorner.Parent = SliderThumb
                
                local dragging = false
                
                local function updateSlider(value)
                    value = math.clamp(value, min, max)
                    library.flags[flag] = value
                    SliderValue.Text = tostring(math.floor(value))
                    
                    local percent = (value - min) / (max - min)
                    Tween(SliderFill, {0.1, "Quad", "Out"}, {Size = UDim2.new(percent, 0, 1, 0)})
                    Tween(SliderThumb, {0.1, "Quad", "Out"}, {Position = UDim2.new(percent, -10, 0, -5)})
                    
                    if callback then
                        callback(value)
                    end
                end
                
                SliderThumb.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                    end
                end)
                
                services.UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                
                services.UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local mousePos = services.UserInputService:GetMouseLocation()
                        local trackPos = SliderTrack.AbsolutePosition
                        local trackSize = SliderTrack.AbsoluteSize
                        
                        local relativeX = (mousePos.X - trackPos.X) / trackSize.X
                        relativeX = math.clamp(relativeX, 0, 1)
                        
                        local value = min + (max - min) * relativeX
                        updateSlider(value)
                    end
                end)
                
                SliderTrack.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        local mousePos = services.UserInputService:GetMouseLocation()
                        local trackPos = SliderTrack.AbsolutePosition
                        local trackSize = SliderTrack.AbsoluteSize
                        
                        local relativeX = (mousePos.X - trackPos.X) / trackSize.X
                        relativeX = math.clamp(relativeX, 0, 1)
                        
                        local value = min + (max - min) * relativeX
                        updateSlider(value)
                        dragging = true
                    end
                end)
                
                updateSlider(default or min)
                
                local funcs = {}
                funcs.SetValue = function(self, value)
                    updateSlider(value)
                end
                
                return funcs
            end
            
            function section.Textbox(section, text, flag, placeholder, callback)
                local Textbox = Instance.new("Frame")
                local TextboxCorner = Instance.new("UICorner")
                local TextboxGradient = Instance.new("UIGradient")
                local TextboxLabel = Instance.new("TextLabel")
                local TextboxInput = Instance.new("TextBox")
                local TextboxInputCorner = Instance.new("UICorner")
                
                Textbox.Name = "Textbox_" .. flag
                Textbox.Parent = SectionContent
                Textbox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                Textbox.Size = UDim2.new(1, 0, 0, 40)
                
                TextboxCorner.CornerRadius = UDim.new(0, 6)
                TextboxCorner.Parent = Textbox
                
                TextboxGradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 40)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 50))
                })
                TextboxGradient.Rotation = 90
                TextboxGradient.Parent = Textbox
                
                TextboxLabel.Name = "TextboxLabel"
                TextboxLabel.Parent = Textbox
                TextboxLabel.BackgroundTransparency = 1
                TextboxLabel.Position = UDim2.new(0, 15, 0, 0)
                TextboxLabel.Size = UDim2.new(0.4, 0, 1, 0)
                TextboxLabel.Font = Enum.Font.Gotham
                TextboxLabel.Text = text
                TextboxLabel.TextColor3 = TextColor
                TextboxLabel.TextSize = 14
                TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                TextboxInput.Name = "TextboxInput"
                TextboxInput.Parent = Textbox
                TextboxInput.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                TextboxInput.Position = UDim2.new(0.45, 0, 0.125, 0)
                TextboxInput.Size = UDim2.new(0.5, -20, 0, 30)
                TextboxInput.Font = Enum.Font.Gotham
                TextboxInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
                TextboxInput.PlaceholderText = placeholder or "输入..."
                TextboxInput.Text = ""
                TextboxInput.TextColor3 = TextColor
                TextboxInput.TextSize = 14
                TextboxInput.ClearTextOnFocus = false
                
                TextboxInputCorner.CornerRadius = UDim.new(0, 6)
                TextboxInputCorner.Parent = TextboxInput
                
                TextboxInput.FocusLost:Connect(function()
                    library.flags[flag] = TextboxInput.Text
                    if callback then
                        callback(TextboxInput.Text)
                    end
                end)
                
                TextboxInput.MouseEnter:Connect(function()
                    Tween(TextboxInput, {0.2, "Quad", "Out"}, {
                        BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                    })
                end)
                
                TextboxInput.MouseLeave:Connect(function()
                    Tween(TextboxInput, {0.2, "Quad", "Out"}, {
                        BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                    })
                end)
            end
            
            function section.Dropdown(section, text, flag, options, callback)
                local Dropdown = Instance.new("Frame")
                local DropdownCorner = Instance.new("UICorner")
                local DropdownGradient = Instance.new("UIGradient")
                local DropdownHeader = Instance.new("TextButton")
                local DropdownLabel = Instance.new("TextLabel")
                local DropdownIcon = Instance.new("ImageLabel")
                local DropdownContent = Instance.new("Frame")
                local DropdownContentList = Instance.new("UIListLayout")
                
                Dropdown.Name = "Dropdown_" .. flag
                Dropdown.Parent = SectionContent
                Dropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                Dropdown.Size = UDim2.new(1, 0, 0, 40)
                Dropdown.ClipsDescendants = true
                
                DropdownCorner.CornerRadius = UDim.new(0, 6)
                DropdownCorner.Parent = Dropdown
                
                DropdownGradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 40)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 50))
                })
                DropdownGradient.Rotation = 90
                DropdownGradient.Parent = Dropdown
                
                DropdownHeader.Name = "DropdownHeader"
                DropdownHeader.Parent = Dropdown
                DropdownHeader.BackgroundTransparency = 1
                DropdownHeader.Size = UDim2.new(1, 0, 0, 40)
                DropdownHeader.Text = ""
                
                DropdownLabel.Name = "DropdownLabel"
                DropdownLabel.Parent = DropdownHeader
                DropdownLabel.BackgroundTransparency = 1
                DropdownLabel.Position = UDim2.new(0, 15, 0, 0)
                DropdownLabel.Size = UDim2.new(0.8, 0, 1, 0)
                DropdownLabel.Font = Enum.Font.Gotham
                DropdownLabel.Text = text .. " - 选择"
                DropdownLabel.TextColor3 = TextColor
                DropdownLabel.TextSize = 14
                DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                DropdownIcon.Name = "DropdownIcon"
                DropdownIcon.Parent = DropdownHeader
                DropdownIcon.BackgroundTransparency = 1
                DropdownIcon.Position = UDim2.new(0.9, 0, 0.25, 0)
                DropdownIcon.Size = UDim2.new(0, 20, 0, 20)
                DropdownIcon.Image = "rbxassetid://6031091004"
                DropdownIcon.ImageColor3 = AccentColor
                
                DropdownContent.Name = "DropdownContent"
                DropdownContent.Parent = Dropdown
                DropdownContent.BackgroundTransparency = 1
                DropdownContent.Position = UDim2.new(0, 0, 0, 45)
                DropdownContent.Size = UDim2.new(1, 0, 0, 0)
                
                DropdownContentList.Name = "DropdownContentList"
                DropdownContentList.Parent = DropdownContent
                DropdownContentList.SortOrder = Enum.SortOrder.LayoutOrder
                DropdownContentList.Padding = UDim.new(0, 5)
                
                local isOpen = false
                
                local function createOption(optionText)
                    local Option = Instance.new("TextButton")
                    local OptionCorner = Instance.new("UICorner")
                    
                    Option.Name = "Option_" .. optionText
                    Option.Parent = DropdownContent
                    Option.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                    Option.Size = UDim2.new(1, 0, 0, 30)
                    Option.AutoButtonColor = false
                    Option.Text = ""
                    
                    OptionCorner.CornerRadius = UDim.new(0, 4)
                    OptionCorner.Parent = Option
                    
                    local OptionLabel = Instance.new("TextLabel")
                    OptionLabel.Name = "OptionLabel"
                    OptionLabel.Parent = Option
                    OptionLabel.BackgroundTransparency = 1
                    OptionLabel.Size = UDim2.new(1, -10, 1, 0)
                    OptionLabel.Position = UDim2.new(0, 10, 0, 0)
                    OptionLabel.Font = Enum.Font.Gotham
                    OptionLabel.Text = optionText
                    OptionLabel.TextColor3 = TextColor
                    OptionLabel.TextSize = 13
                    OptionLabel.TextXAlignment = Enum.TextXAlignment.Left
                    
                    Option.MouseEnter:Connect(function()
                        Tween(Option, {0.2, "Quad", "Out"}, {
                            BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                        })
                    end)
                    
                    Option.MouseLeave:Connect(function()
                        Tween(Option, {0.2, "Quad", "Out"}, {
                            BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                        })
                    end)
                    
                    Option.MouseButton1Click:Connect(function()
                        DropdownLabel.Text = text .. " - " .. optionText
                        library.flags[flag] = optionText
                        if callback then
                            callback(optionText)
                        end
                        isOpen = false
                        Tween(Dropdown, {0.3, "Quad", "Out"}, {
                            Size = UDim2.new(1, 0, 0, 40)
                        })
                        Tween(DropdownContent, {0.3, "Quad", "Out"}, {
                            Size = UDim2.new(1, 0, 0, 0)
                        })
                        Tween(DropdownIcon, {0.3, "Quad", "Out"}, {Rotation = 0})
                    end)
                end
                
                for _, option in ipairs(options) do
                    createOption(option)
                end
                
                DropdownContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    if isOpen then
                        DropdownContent.Size = UDim2.new(1, 0, 0, DropdownContentList.AbsoluteContentSize.Y)
                        Dropdown.Size = UDim2.new(1, 0, 0, 45 + DropdownContentList.AbsoluteContentSize.Y)
                    end
                end)
                
                DropdownHeader.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    if isOpen then
                        Tween(Dropdown, {0.3, "Quad", "Out"}, {
                            Size = UDim2.new(1, 0, 0, 45 + DropdownContentList.AbsoluteContentSize.Y)
                        })
                        Tween(DropdownContent, {0.3, "Quad", "Out"}, {
                            Size = UDim2.new(1, 0, 0, DropdownContentList.AbsoluteContentSize.Y)
                        })
                        Tween(DropdownIcon, {0.3, "Quad", "Out"}, {Rotation = 180})
                    else
                        Tween(Dropdown, {0.3, "Quad", "Out"}, {
                            Size = UDim2.new(1, 0, 0, 40)
                        })
                        Tween(DropdownContent, {0.3, "Quad", "Out"}, {
                            Size = UDim2.new(1, 0, 0, 0)
                        })
                        Tween(DropdownIcon, {0.3, "Quad", "Out"}, {Rotation = 0})
                    end
                end)
                
                local funcs = {}
                funcs.AddOption = function(self, option)
                    createOption(option)
                end
                
                funcs.RemoveOption = function(self, optionText)
                    local option = DropdownContent:FindFirstChild("Option_" .. optionText)
                    if option then
                        option:Destroy()
                    end
                end
                
                return funcs
            end
            
            function section.Label(section, text)
                local Label = Instance.new("Frame")
                local LabelCorner = Instance.new("UICorner")
                local LabelText = Instance.new("TextLabel")
                
                Label.Name = "Label_" .. text
                Label.Parent = SectionContent
                Label.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                Label.Size = UDim2.new(1, 0, 0, 30)
                
                LabelCorner.CornerRadius = UDim.new(0, 6)
                LabelCorner.Parent = Label
                
                LabelText.Name = "LabelText"
                LabelText.Parent = Label
                LabelText.BackgroundTransparency = 1
                LabelText.Size = UDim2.new(1, -20, 1, 0)
                LabelText.Position = UDim2.new(0, 10, 0, 0)
                LabelText.Font = Enum.Font.Gotham
                LabelText.Text = text
                LabelText.TextColor3 = TextColor
                LabelText.TextSize = 14
                LabelText.TextXAlignment = Enum.TextXAlignment.Left
                
                return LabelText
            end
            
            return section
        end
        
        return tab
    end
    
    return window
end

return library