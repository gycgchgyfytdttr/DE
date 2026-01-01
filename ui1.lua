local library = {}
local ToggleUI = false
library.currentTab = nil
library.flags = {}

local services =
    setmetatable(
    {},
    {
        __index = function(t, k)
            return game.GetService(game, k)
        end
    }
)

local mouse = services.Players.LocalPlayer:GetMouse()

function Tween(obj, t, data)
    services.TweenService:Create(obj, TweenInfo.new(t[1], Enum.EasingStyle[t[2]], Enum.EasingDirection[t[3]]), data):Play()
    return true
end

function Ripple(obj)
    spawn(
        function()
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
            Ripple.Position =
                UDim2.new(
                (mouse.X - Ripple.AbsolutePosition.X) / obj.AbsoluteSize.X,
                0,
                (mouse.Y - Ripple.AbsolutePosition.Y) / obj.AbsoluteSize.Y,
                0
            )
            Tween(
                Ripple,
                {0.3, "Linear", "InOut"},
                {Position = UDim2.new(-5.5, 0, -5.5, 0), Size = UDim2.new(12, 0, 12, 0)}
            )
            wait(0.15)
            Tween(Ripple, {0.3, "Linear", "InOut"}, {ImageTransparency = 1})
            wait(0.3)
            Ripple:Destroy()
        end
    )
end

local toggled = false

-- # Switch Tabs # --
local switchingTabs = false
function switchTab(new)
    if switchingTabs then
        return
    end
    local old = library.currentTab
    if old == nil then
        new[2].Visible = true
        library.currentTab = new
        services.TweenService:Create(new[1], TweenInfo.new(0.1), {ImageTransparency = 0}):Play()
        services.TweenService:Create(new[1].TabText, TweenInfo.new(0.1), {TextTransparency = 0}):Play()
        return
    end

    if old[1] == new[1] then
        return
    end
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

-- # Drag Function # --
function drag(frame, hold)
    if not hold then
        hold = frame
    end
    local dragging
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        frame.Position =
            UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    hold.InputBegan:Connect(
        function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = frame.Position

                input.Changed:Connect(
                    function()
                        if input.UserInputState == Enum.UserInputState.End then
                            dragging = false
                        end
                    end
                )
            end
        end
    )

    frame.InputChanged:Connect(
        function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                dragInput = input
            end
        end
    )

    services.UserInputService.InputChanged:Connect(
        function(input)
            if input == dragInput and dragging then
                update(input)
            end
        end
    )
end

function library.new(library, name, theme)
    for _, v in next, services.CoreGui:GetChildren() do
        if v.Name == "SX_UI" then
            v:Destroy()
        end
    end
    
    -- Color Scheme
    local MainColor = Color3.fromRGB(138, 43, 226) -- 紫色主题
    local BackgroundColor = Color3.fromRGB(10, 10, 10) -- 纯黑背景
    local SidebarColor = Color3.fromRGB(20, 20, 20)
    local TextColor = Color3.fromRGB(255, 255, 255)
    local AccentColor = Color3.fromRGB(123, 44, 191)
    
    local dogent = Instance.new("ScreenGui")
    local MainContainer = Instance.new("Frame")
    local TabContainer = Instance.new("Frame")
    local MainCorner = Instance.new("UICorner")
    local Sidebar = Instance.new("Frame")
    local SidebarCorner = Instance.new("UICorner")
    local TabButtons = Instance.new("ScrollingFrame")
    local TabListLayout = Instance.new("UIListLayout")
    local TitleContainer = Instance.new("Frame")
    local MainTitle = Instance.new("TextLabel")
    local SubTitle = Instance.new("TextLabel")
    local SearchContainer = Instance.new("Frame")
    local SearchBox = Instance.new("TextBox")
    local SearchIcon = Instance.new("ImageLabel")
    local MinimizeButton = Instance.new("ImageButton")
    local ThreeColorBalls = Instance.new("Frame")
    local Ball1 = Instance.new("Frame")
    local Ball2 = Instance.new("Frame")
    local Ball3 = Instance.new("Frame")
    local GlowEffect = Instance.new("ImageLabel")
    local ParticlesContainer = Instance.new("Frame")
    
    if syn and syn.protect_gui then
        syn.protect_gui(dogent)
    end

    dogent.Name = "SX_UI"
    dogent.Parent = services.CoreGui
    dogent.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    function UiDestroy()
        dogent:Destroy()
    end

    function ToggleUILib()
        if not ToggleUI then
            dogent.Enabled = false
            ToggleUI = true
        else
            ToggleUI = false
            dogent.Enabled = true
        end
    end

    -- Main Container
    MainContainer.Name = "MainContainer"
    MainContainer.Parent = dogent
    MainContainer.AnchorPoint = Vector2.new(0.5, 0.5)
    MainContainer.BackgroundColor3 = BackgroundColor
    MainContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainContainer.Size = UDim2.new(0, 570, 0, 380)
    MainContainer.ZIndex = 1
    MainContainer.Active = true
    MainContainer.Draggable = true

    -- Large Rounded Corners
    MainCorner.CornerRadius = UDim.new(0, 16)
    MainCorner.Name = "MainCorner"
    MainCorner.Parent = MainContainer

    -- Glow Effect
    GlowEffect.Name = "GlowEffect"
    GlowEffect.Parent = MainContainer
    GlowEffect.AnchorPoint = Vector2.new(0.5, 0.5)
    GlowEffect.BackgroundTransparency = 1
    GlowEffect.Position = UDim2.new(0.5, 0, 0.5, 0)
    GlowEffect.Size = UDim2.new(1, 20, 1, 20)
    GlowEffect.Image = "rbxassetid://8992230671"
    GlowEffect.ImageColor3 = MainColor
    GlowEffect.ImageTransparency = 0.7
    GlowEffect.ScaleType = Enum.ScaleType.Slice
    GlowEffect.SliceCenter = Rect.new(22, 22, 278, 278)
    GlowEffect.ZIndex = 0

    -- Animated Gradient Effect
    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, MainColor),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 105, 180)),
        ColorSequenceKeypoint.new(1, MainColor)
    })
    Gradient.Rotation = 45
    Gradient.Parent = GlowEffect
    
    -- Animate Gradient
    spawn(function()
        while true do
            for i = 0, 360, 2 do
                Gradient.Rotation = i
                wait()
            end
        end
    end)

    -- Title Container
    TitleContainer.Name = "TitleContainer"
    TitleContainer.Parent = MainContainer
    TitleContainer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    TitleContainer.BackgroundTransparency = 0.5
    TitleContainer.Size = UDim2.new(1, 0, 0, 80)
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 16)
    TitleCorner.Name = "TitleCorner"
    TitleCorner.Parent = TitleContainer

    -- Main Title
    MainTitle.Name = "MainTitle"
    MainTitle.Parent = TitleContainer
    MainTitle.BackgroundTransparency = 1
    MainTitle.Position = UDim2.new(0, 20, 0, 15)
    MainTitle.Size = UDim2.new(0, 200, 0, 30)
    MainTitle.Font = Enum.Font.GothamBold
    MainTitle.Text = name
    MainTitle.TextColor3 = TextColor
    MainTitle.TextSize = 24
    MainTitle.TextXAlignment = Enum.TextXAlignment.Left

    -- Sub Title
    SubTitle.Name = "SubTitle"
    SubTitle.Parent = TitleContainer
    SubTitle.BackgroundTransparency = 1
    SubTitle.Position = UDim2.new(0, 20, 0, 45)
    SubTitle.Size = UDim2.new(0, 200, 0, 20)
    SubTitle.Font = Enum.Font.Gotham
    SubTitle.Text = "Premium UI Framework"
    SubTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
    SubTitle.TextSize = 14
    SubTitle.TextXAlignment = Enum.TextXAlignment.Left

    -- Three Color Balls
    ThreeColorBalls.Name = "ThreeColorBalls"
    ThreeColorBalls.Parent = TitleContainer
    ThreeColorBalls.BackgroundTransparency = 1
    ThreeColorBalls.Position = UDim2.new(1, -100, 0.1, 0)
    ThreeColorBalls.Size = UDim2.new(0, 80, 0, 30)

    local function createBall(parent, color, position)
        local ball = Instance.new("Frame")
        ball.Name = "Ball"
        ball.Parent = parent
        ball.BackgroundColor3 = color
        ball.Size = UDim2.new(0, 12, 0, 12)
        ball.Position = position
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = ball
        
        -- Pulse animation
        spawn(function()
            while true do
                for i = 0, 1, 0.1 do
                    ball.BackgroundTransparency = 0.3 + i * 0.4
                    wait(0.05)
                end
                for i = 1, 0, -0.1 do
                    ball.BackgroundTransparency = 0.3 + i * 0.4
                    wait(0.05)
                end
                wait(math.random(1, 3))
            end
        end)
        
        return ball
    end

    Ball1 = createBall(ThreeColorBalls, Color3.fromRGB(255, 50, 50), UDim2.new(0, 0, 0.5, -6))
    Ball2 = createBall(ThreeColorBalls, Color3.fromRGB(50, 255, 50), UDim2.new(0, 25, 0.5, -6))
    Ball3 = createBall(ThreeColorBalls, Color3.fromRGB(50, 50, 255), UDim2.new(0, 50, 0.5, -6))

    -- Search Container
    SearchContainer.Name = "SearchContainer"
    SearchContainer.Parent = TitleContainer
    SearchContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    SearchContainer.Position = UDim2.new(0.5, -150, 0.5, -15)
    SearchContainer.Size = UDim2.new(0, 200, 0, 30)
    
    local SearchCorner = Instance.new("UICorner")
    SearchCorner.CornerRadius = UDim.new(0, 8)
    SearchCorner.Parent = SearchContainer

    SearchIcon.Name = "SearchIcon"
    SearchIcon.Parent = SearchContainer
    SearchIcon.BackgroundTransparency = 1
    SearchIcon.Position = UDim2.new(0, 8, 0, 5)
    SearchIcon.Size = UDim2.new(0, 20, 0, 20)
    SearchIcon.Image = "rbxassetid://6031280882"
    SearchIcon.ImageColor3 = MainColor

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

    -- Minimize Button
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Parent = TitleContainer
    MinimizeButton.BackgroundTransparency = 1
    MinimizeButton.Position = UDim2.new(1, -40, 0.5, -12)
    MinimizeButton.Size = UDim2.new(0, 24, 0, 24)
    MinimizeButton.Image = "rbxassetid://6031094678"
    MinimizeButton.ImageColor3 = MainColor
    
    local MinimizeHover = Instance.new("Frame")
    MinimizeHover.Name = "MinimizeHover"
    MinimizeHover.Parent = MinimizeButton
    MinimizeHover.BackgroundColor3 = MainColor
    MinimizeHover.BackgroundTransparency = 0.9
    MinimizeHover.Size = UDim2.new(1, 0, 1, 0)
    local HoverCorner = Instance.new("UICorner")
    HoverCorner.CornerRadius = UDim.new(1, 0)
    HoverCorner.Parent = MinimizeHover
    MinimizeHover.Visible = false
    
    MinimizeButton.MouseEnter:Connect(function()
        MinimizeHover.Visible = true
    end)
    
    MinimizeButton.MouseLeave:Connect(function()
        MinimizeHover.Visible = false
    end)

    -- Sidebar
    Sidebar.Name = "Sidebar"
    Sidebar.Parent = MainContainer
    Sidebar.BackgroundColor3 = SidebarColor
    Sidebar.Position = UDim2.new(0, 0, 0, 80)
    Sidebar.Size = UDim2.new(0, 180, 0, 300)
    
    SidebarCorner.CornerRadius = UDim.new(0, 16)
    SidebarCorner.Name = "SidebarCorner"
    SidebarCorner.Parent = Sidebar

    -- Tab Buttons Container
    TabButtons.Name = "TabButtons"
    TabButtons.Parent = Sidebar
    TabButtons.Active = true
    TabButtons.BackgroundTransparency = 1
    TabButtons.BorderSizePixel = 0
    TabButtons.Position = UDim2.new(0, 10, 0, 10)
    TabButtons.Size = UDim2.new(1, -20, 1, -20)
    TabButtons.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabButtons.ScrollBarThickness = 3
    TabButtons.ScrollBarImageColor3 = MainColor

    TabListLayout.Name = "TabListLayout"
    TabListLayout.Parent = TabButtons
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 8)

    TabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(
        function()
            TabButtons.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y + 10)
        end
    )

    -- Tab Container
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = MainContainer
    TabContainer.BackgroundColor3 = BackgroundColor
    TabContainer.BackgroundTransparency = 1
    TabContainer.Position = UDim2.new(0, 190, 0, 90)
    TabContainer.Size = UDim2.new(0, 370, 0, 280)

    -- Particles Effect
    ParticlesContainer.Name = "ParticlesContainer"
    ParticlesContainer.Parent = MainContainer
    ParticlesContainer.BackgroundTransparency = 1
    ParticlesContainer.Size = UDim2.new(1, 0, 1, 0)
    ParticlesContainer.ZIndex = -1
    
    spawn(function()
        for i = 1, 15 do
            local particle = Instance.new("Frame")
            particle.Name = "Particle"
            particle.Parent = ParticlesContainer
            particle.BackgroundColor3 = MainColor
            particle.BackgroundTransparency = 0.7
            particle.Size = UDim2.new(0, math.random(2, 4), 0, math.random(2, 4))
            particle.Position = UDim2.new(0, math.random(-50, 600), 0, math.random(-50, 400))
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(1, 0)
            corner.Parent = particle
            
            spawn(function()
                while true do
                    local targetX = particle.Position.X.Offset + math.random(-20, 20)
                    local targetY = particle.Position.Y.Offset + math.random(-20, 20)
                    
                    Tween(
                        particle,
                        {math.random(2, 4), "Sine", "InOut"},
                        {
                            Position = UDim2.new(0, math.clamp(targetX, -50, 600), 0, math.clamp(targetY, -50, 400))
                        }
                    )
                    wait(math.random(3, 6))
                end
            end)
        end
    end)

    -- Minimize Functionality
    local isMinimized = false
    local originalSize = MainContainer.Size
    local originalPosition = MainContainer.Position
    
    MinimizeButton.MouseButton1Click:Connect(function()
        if isMinimized then
            -- Restore
            Tween(MainContainer, {0.3, "Quad", "Out"}, {Size = originalSize})
            wait(0.2)
            TitleContainer.Visible = true
            Sidebar.Visible = true
            TabContainer.Visible = true
            GlowEffect.Visible = true
        else
            -- Minimize to unique shape
            Tween(MainContainer, {0.3, "Quad", "Out"}, {Size = UDim2.new(0, 100, 0, 100)})
            wait(0.2)
            TitleContainer.Visible = false
            Sidebar.Visible = false
            TabContainer.Visible = false
            GlowEffect.Visible = false
            
            -- Create special minimized shape
            local minimizedShape = Instance.new("Frame")
            minimizedShape.Name = "MinimizedShape"
            minimizedShape.Parent = MainContainer
            minimizedShape.BackgroundColor3 = MainColor
            minimizedShape.Size = UDim2.new(1, 0, 1, 0)
            minimizedShape.ZIndex = 2
            
            local shapeCorner = Instance.new("UICorner")
            shapeCorner.CornerRadius = UDim.new(0, 20)
            shapeCorner.Parent = minimizedShape
            
            local innerShape = Instance.new("Frame")
            innerShape.Name = "InnerShape"
            innerShape.Parent = minimizedShape
            innerShape.BackgroundColor3 = BackgroundColor
            innerShape.AnchorPoint = Vector2.new(0.5, 0.5)
            innerShape.Position = UDim2.new(0.5, 0, 0.5, 0)
            innerShape.Size = UDim2.new(0.8, 0, 0.8, 0)
            
            local innerCorner = Instance.new("UICorner")
            innerCorner.CornerRadius = UDim.new(0, 15)
            innerCorner.Parent = innerShape
            
            -- Add spinning SX logo
            local logo = Instance.new("ImageLabel")
            logo.Name = "Logo"
            logo.Parent = innerShape
            logo.BackgroundTransparency = 1
            logo.AnchorPoint = Vector2.new(0.5, 0.5)
            logo.Position = UDim2.new(0.5, 0, 0.5, 0)
            logo.Size = UDim2.new(0.6, 0, 0.6, 0)
            logo.Image = "rbxassetid://6031302934"
            logo.ImageColor3 = TextColor
            
            spawn(function()
                while minimizedShape.Parent do
                    logo.Rotation = logo.Rotation + 2
                    wait()
                end
            end)
        end
        isMinimized = not isMinimized
    end)

    drag(MainContainer)

    local window = {}
    
    -- Search Functionality
    local function searchFeatures(searchText)
        if searchText == "" then
            -- Show all sections
            for _, tab in pairs(TabContainer:GetChildren()) do
                if tab:IsA("ScrollingFrame") then
                    tab.Visible = true
                    for _, section in pairs(tab:GetChildren()) do
                        if section:IsA("Frame") and section.Name == "Section" then
                            section.Visible = true
                        end
                    end
                end
            end
            return
        end
        
        searchText = string.lower(searchText)
        
        for _, tab in pairs(TabContainer:GetChildren()) do
            if tab:IsA("ScrollingFrame") then
                local hasVisibleSections = false
                
                for _, section in pairs(tab:GetChildren()) do
                    if section:IsA("Frame") and section.Name == "Section" then
                        local sectionText = section.SectionText.Text
                        local found = string.find(string.lower(sectionText), searchText, 1, true)
                        
                        section.Visible = found ~= nil
                        
                        if found then
                            hasVisibleSections = true
                            
                            -- Highlight matching text
                            spawn(function()
                                section.SectionText.TextColor3 = MainColor
                                wait(0.5)
                                section.SectionText.TextColor3 = TextColor
                            end)
                        end
                    end
                end
                
                tab.Visible = hasVisibleSections
            end
        end
    end
    
    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        searchFeatures(SearchBox.Text)
    end)

    function window.Tab(window, name, icon)
        local Tab = Instance.new("ScrollingFrame")
        local TabButtonContainer = Instance.new("Frame")
        local TabIcon = Instance.new("ImageLabel")
        local TabText = Instance.new("TextLabel")
        local TabButton = Instance.new("TextButton")
        local TabList = Instance.new("UIListLayout")
        local TabPadding = Instance.new("UIPadding")

        -- Tab Button
        TabButtonContainer.Name = "TabButtonContainer"
        TabButtonContainer.Parent = TabButtons
        TabButtonContainer.BackgroundColor3 = SidebarColor
        TabButtonContainer.BackgroundTransparency = 1
        TabButtonContainer.Size = UDim2.new(1, 0, 0, 40)
        
        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 8)
        ButtonCorner.Parent = TabButtonContainer

        TabIcon.Name = "TabIcon"
        TabIcon.Parent = TabButtonContainer
        TabIcon.BackgroundTransparency = 1
        TabIcon.Position = UDim2.new(0, 15, 0.5, -10)
        TabIcon.Size = UDim2.new(0, 20, 0, 20)
        TabIcon.Image = ("rbxassetid://%s"):format((icon or 6031302934))
        TabIcon.ImageColor3 = MainColor
        TabIcon.ImageTransparency = 0.5

        TabText.Name = "TabText"
        TabText.Parent = TabButtonContainer
        TabText.BackgroundTransparency = 1
        TabText.Position = UDim2.new(0, 45, 0, 0)
        TabText.Size = UDim2.new(1, -45, 1, 0)
        TabText.Font = Enum.Font.GothamSemibold
        TabText.Text = name
        TabText.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabText.TextSize = 14
        TabText.TextXAlignment = Enum.TextXAlignment.Left
        TabText.TextTransparency = 0.5

        TabButton.Name = "TabButton"
        TabButton.Parent = TabButtonContainer
        TabButton.BackgroundTransparency = 1
        TabButton.Size = UDim2.new(1, 0, 1, 0)
        TabButton.Text = ""
        TabButton.AutoButtonColor = false

        -- Hover effect
        local HoverFrame = Instance.new("Frame")
        HoverFrame.Name = "HoverFrame"
        HoverFrame.Parent = TabButtonContainer
        HoverFrame.BackgroundColor3 = MainColor
        HoverFrame.BackgroundTransparency = 0.95
        HoverFrame.Size = UDim2.new(1, 0, 1, 0)
        HoverFrame.ZIndex = -1
        local HoverCorner = Instance.new("UICorner")
        HoverCorner.CornerRadius = UDim.new(0, 8)
        HoverCorner.Parent = HoverFrame
        HoverFrame.Visible = false
        
        TabButton.MouseEnter:Connect(function()
            HoverFrame.Visible = true
        end)
        
        TabButton.MouseLeave:Connect(function()
            if library.currentTab ~= {TabIcon, Tab} then
                HoverFrame.Visible = false
            end
        end)

        -- Tab Content
        Tab.Name = "Tab"
        Tab.Parent = TabContainer
        Tab.Active = true
        Tab.BackgroundTransparency = 1
        Tab.Size = UDim2.new(1, 0, 1, 0)
        Tab.ScrollBarThickness = 3
        Tab.ScrollBarImageColor3 = MainColor
        Tab.Visible = false

        TabList.Name = "TabList"
        TabList.Parent = Tab
        TabList.SortOrder = Enum.SortOrder.LayoutOrder
        TabList.Padding = UDim.new(0, 8)

        TabPadding.Name = "TabPadding"
        TabPadding.Parent = Tab
        TabPadding.PaddingLeft = UDim.new(0, 5)
        TabPadding.PaddingTop = UDim.new(0, 5)

        TabList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(
            function()
                Tab.CanvasSize = UDim2.new(0, 0, 0, TabList.AbsoluteContentSize.Y + 10)
            end
        )

        TabButton.MouseButton1Click:Connect(
            function()
                spawn(function() Ripple(TabButtonContainer) end)
                switchTab({TabIcon, Tab})
                HoverFrame.Visible = true
                
                -- Update all other tabs' hover frames
                for _, btn in pairs(TabButtons:GetChildren()) do
                    if btn:IsA("Frame") and btn ~= TabButtonContainer and btn.HoverFrame then
                        btn.HoverFrame.Visible = false
                        btn.TabIcon.ImageTransparency = 0.5
                        btn.TabText.TextTransparency = 0.5
                        btn.TabText.TextColor3 = Color3.fromRGB(200, 200, 200)
                    end
                end
                
                TabIcon.ImageTransparency = 0
                TabText.TextTransparency = 0
                TabText.TextColor3 = TextColor
            end
        )

        if library.currentTab == nil then
            switchTab({TabIcon, Tab})
            HoverFrame.Visible = true
            TabIcon.ImageTransparency = 0
            TabText.TextTransparency = 0
            TabText.TextColor3 = TextColor
        end

        local tab = {}
        function tab.section(tab, name, TabVal)
            local Section = Instance.new("Frame")
            local SectionCorner = Instance.new("UICorner")
            local SectionHeader = Instance.new("Frame")
            local SectionText = Instance.new("TextLabel")
            local ToggleIcon = Instance.new("ImageButton")
            local ContentContainer = Instance.new("Frame")
            local ContentLayout = Instance.new("UIListLayout")

            Section.Name = "Section"
            Section.Parent = Tab
            Section.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            Section.BackgroundTransparency = 0.5
            Section.Size = UDim2.new(1, -10, 0, 40)

            SectionCorner.CornerRadius = UDim.new(0, 12)
            SectionCorner.Name = "SectionCorner"
            SectionCorner.Parent = Section

            SectionHeader.Name = "SectionHeader"
            SectionHeader.Parent = Section
            SectionHeader.BackgroundTransparency = 1
            SectionHeader.Size = UDim2.new(1, 0, 0, 40)

            SectionText.Name = "SectionText"
            SectionText.Parent = SectionHeader
            SectionText.BackgroundTransparency = 1
            SectionText.Position = UDim2.new(0, 15, 0, 0)
            SectionText.Size = UDim2.new(0.8, 0, 1, 0)
            SectionText.Font = Enum.Font.GothamSemibold
            SectionText.Text = name
            SectionText.TextColor3 = TextColor
            SectionText.TextSize = 16
            SectionText.TextXAlignment = Enum.TextXAlignment.Left

            ToggleIcon.Name = "ToggleIcon"
            ToggleIcon.Parent = SectionHeader
            ToggleIcon.BackgroundTransparency = 1
            ToggleIcon.Position = UDim2.new(1, -40, 0.5, -12)
            ToggleIcon.Size = UDim2.new(0, 24, 0, 24)
            ToggleIcon.Image = "rbxassetid://6031094679"
            ToggleIcon.ImageColor3 = MainColor

            ContentContainer.Name = "ContentContainer"
            ContentContainer.Parent = Section
            ContentContainer.BackgroundTransparency = 1
            ContentContainer.Position = UDim2.new(0, 0, 0, 45)
            ContentContainer.Size = UDim2.new(1, 0, 0, 0)
            ContentContainer.ClipsDescendants = true

            ContentLayout.Name = "ContentLayout"
            ContentLayout.Parent = ContentContainer
            ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ContentLayout.Padding = UDim.new(0, 5)

            local isOpen = TabVal ~= false
            if isOpen then
                ToggleIcon.Rotation = 180
            end

            local function updateSize()
                if isOpen then
                    Section.Size = UDim2.new(1, -10, 0, 45 + ContentLayout.AbsoluteContentSize.Y + 5)
                    ContentContainer.Size = UDim2.new(1, 0, 0, ContentLayout.AbsoluteContentSize.Y)
                else
                    Section.Size = UDim2.new(1, -10, 0, 40)
                    ContentContainer.Size = UDim2.new(1, 0, 0, 0)
                end
            end

            ToggleIcon.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                Tween(ToggleIcon, {0.2, "Quad", "Out"}, {Rotation = isOpen and 180 or 0})
                updateSize()
            end)

            ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                if isOpen then
                    updateSize()
                end
            end)

            updateSize()

            local section = {}
            
            function section.Button(section, text, callback)
                local callback = callback or function() end

                local ButtonModule = Instance.new("Frame")
                local Button = Instance.new("TextButton")
                local ButtonCorner = Instance.new("UICorner")

                ButtonModule.Name = "ButtonModule"
                ButtonModule.Parent = ContentContainer
                ButtonModule.BackgroundTransparency = 1
                ButtonModule.Size = UDim2.new(1, 0, 0, 36)

                Button.Name = "Button"
                Button.Parent = ButtonModule
                Button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                Button.Size = UDim2.new(1, 0, 0, 36)
                Button.AutoButtonColor = false
                Button.Font = Enum.Font.Gotham
                Button.Text = text
                Button.TextColor3 = TextColor
                Button.TextSize = 14

                ButtonCorner.CornerRadius = UDim.new(0, 8)
                ButtonCorner.Name = "ButtonCorner"
                ButtonCorner.Parent = Button

                -- Hover effect
                local HoverEffect = Instance.new("Frame")
                HoverEffect.Name = "HoverEffect"
                HoverEffect.Parent = Button
                HoverEffect.BackgroundColor3 = MainColor
                HoverEffect.BackgroundTransparency = 0.9
                HoverEffect.Size = UDim2.new(1, 0, 1, 0)
                HoverEffect.ZIndex = -1
                local HoverCorner = Instance.new("UICorner")
                HoverCorner.CornerRadius = UDim.new(0, 8)
                HoverCorner.Parent = HoverEffect
                HoverEffect.Visible = false
                
                Button.MouseEnter:Connect(function()
                    HoverEffect.Visible = true
                end)
                
                Button.MouseLeave:Connect(function()
                    HoverEffect.Visible = false
                end)

                Button.MouseButton1Click:Connect(function()
                    spawn(function() Ripple(Button) end)
                    spawn(callback)
                    
                    -- Click feedback
                    Tween(Button, {0.1, "Quad", "Out"}, {BackgroundColor3 = MainColor})
                    wait(0.1)
                    Tween(Button, {0.1, "Quad", "Out"}, {BackgroundColor3 = Color3.fromRGB(35, 35, 35)})
                end)
            end

            function section:Label(text)
                local LabelModule = Instance.new("Frame")
                local Label = Instance.new("TextLabel")
                local LabelCorner = Instance.new("UICorner")

                LabelModule.Name = "LabelModule"
                LabelModule.Parent = ContentContainer
                LabelModule.BackgroundTransparency = 1
                LabelModule.Size = UDim2.new(1, 0, 0, 28)

                Label.Name = "Label"
                Label.Parent = LabelModule
                Label.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                Label.Size = UDim2.new(1, 0, 0, 28)
                Label.Font = Enum.Font.Gotham
                Label.Text = "  " .. text
                Label.TextColor3 = TextColor
                Label.TextSize = 14
                Label.TextXAlignment = Enum.TextXAlignment.Left

                LabelCorner.CornerRadius = UDim.new(0, 8)
                LabelCorner.Name = "LabelCorner"
                LabelCorner.Parent = Label

                return Label
            end

            function section.Toggle(section, text, flag, enabled, callback)
                local callback = callback or function() end
                local enabled = enabled or false
                assert(text, "No text provided")
                assert(flag, "No flag provided")

                library.flags[flag] = enabled

                local ToggleModule = Instance.new("Frame")
                local ToggleButton = Instance.new("TextButton")
                local ToggleCorner = Instance.new("UICorner")
                local ToggleText = Instance.new("TextLabel")
                local ToggleSwitch = Instance.new("Frame")
                local ToggleKnob = Instance.new("Frame")
                local ToggleKnobCorner = Instance.new("UICorner")

                ToggleModule.Name = "ToggleModule"
                ToggleModule.Parent = ContentContainer
                ToggleModule.BackgroundTransparency = 1
                ToggleModule.Size = UDim2.new(1, 0, 0, 36)

                ToggleButton.Name = "ToggleButton"
                ToggleButton.Parent = ToggleModule
                ToggleButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                ToggleButton.Size = UDim2.new(1, 0, 0, 36)
                ToggleButton.AutoButtonColor = false
                ToggleButton.Text = ""

                ToggleCorner.CornerRadius = UDim.new(0, 8)
                ToggleCorner.Name = "ToggleCorner"
                ToggleCorner.Parent = ToggleButton

                ToggleText.Name = "ToggleText"
                ToggleText.Parent = ToggleButton
                ToggleText.BackgroundTransparency = 1
                ToggleText.Position = UDim2.new(0, 15, 0, 0)
                ToggleText.Size = UDim2.new(0.7, 0, 1, 0)
                ToggleText.Font = Enum.Font.Gotham
                ToggleText.Text = text
                ToggleText.TextColor3 = TextColor
                ToggleText.TextSize = 14
                ToggleText.TextXAlignment = Enum.TextXAlignment.Left

                ToggleSwitch.Name = "ToggleSwitch"
                ToggleSwitch.Parent = ToggleButton
                ToggleSwitch.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                ToggleSwitch.Position = UDim2.new(1, -60, 0.5, -10)
                ToggleSwitch.Size = UDim2.new(0, 50, 0, 20)

                local SwitchCorner = Instance.new("UICorner")
                SwitchCorner.CornerRadius = UDim.new(1, 0)
                SwitchCorner.Parent = ToggleSwitch

                ToggleKnob.Name = "ToggleKnob"
                ToggleKnob.Parent = ToggleSwitch
                ToggleKnob.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
                ToggleKnob.Position = UDim2.new(0, 2, 0.5, -8)
                ToggleKnob.Size = UDim2.new(0, 16, 0, 16)

                ToggleKnobCorner.CornerRadius = UDim.new(1, 0)
                ToggleKnobCorner.Name = "ToggleKnobCorner"
                ToggleKnobCorner.Parent = ToggleKnob

                local funcs = {
                    SetState = function(self, state)
                        if state == nil then
                            state = not library.flags[flag]
                        end
                        if library.flags[flag] == state then
                            return
                        end
                        
                        library.flags[flag] = state
                        
                        Tween(
                            ToggleKnob,
                            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {
                                Position = UDim2.new(0, state and 32 or 2, 0.5, -8),
                                BackgroundColor3 = state and MainColor or Color3.fromRGB(200, 200, 200)
                            }
                        )
                        
                        Tween(
                            ToggleSwitch,
                            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {
                                BackgroundColor3 = state and Color3.fromRGB(123, 44, 191, 0.3) or Color3.fromRGB(60, 60, 60)
                            }
                        )
                        
                        callback(state)
                    end,
                    Module = ToggleModule
                }

                if enabled then
                    funcs:SetState(true)
                end

                ToggleButton.MouseButton1Click:Connect(function()
                    spawn(function() Ripple(ToggleButton) end)
                    funcs:SetState()
                end)
                
                -- Hover effect
                local HoverEffect = Instance.new("Frame")
                HoverEffect.Name = "HoverEffect"
                HoverEffect.Parent = ToggleButton
                HoverEffect.BackgroundColor3 = MainColor
                HoverEffect.BackgroundTransparency = 0.95
                HoverEffect.Size = UDim2.new(1, 0, 1, 0)
                HoverEffect.ZIndex = -1
                local HoverCorner = Instance.new("UICorner")
                HoverCorner.CornerRadius = UDim.new(0, 8)
                HoverCorner.Parent = HoverEffect
                HoverEffect.Visible = false
                
                ToggleButton.MouseEnter:Connect(function()
                    HoverEffect.Visible = true
                end)
                
                ToggleButton.MouseLeave:Connect(function()
                    HoverEffect.Visible = false
                end)

                return funcs
            end

            function section.Keybind(section, text, default, callback)
                local callback = callback or function() end
                assert(text, "No text provided")
                assert(default, "No default key provided")

                local default = (typeof(default) == "string" and Enum.KeyCode[default] or default)
                local banned = {
                    Return = true,
                    Space = true,
                    Tab = true,
                    Backquote = true,
                    CapsLock = true,
                    Escape = true,
                    Unknown = true
                }
                local shortNames = {
                    RightControl = "RCtrl",
                    LeftControl = "LCtrl",
                    LeftShift = "LShift",
                    RightShift = "RShift",
                    Semicolon = ";",
                    Quote = '"',
                    LeftBracket = "[",
                    RightBracket = "]",
                    Equals = "=",
                    Minus = "-",
                    RightAlt = "RAlt",
                    LeftAlt = "LAlt"
                }

                local bindKey = default
                local keyTxt = (default and (shortNames[default.Name] or default.Name) or "None")

                local KeybindModule = Instance.new("Frame")
                local KeybindButton = Instance.new("TextButton")
                local KeybindCorner = Instance.new("UICorner")
                local KeybindText = Instance.new("TextLabel")
                local KeybindValue = Instance.new("TextButton")
                local ValueCorner = Instance.new("UICorner")

                KeybindModule.Name = "KeybindModule"
                KeybindModule.Parent = ContentContainer
                KeybindModule.BackgroundTransparency = 1
                KeybindModule.Size = UDim2.new(1, 0, 0, 36)

                KeybindButton.Name = "KeybindButton"
                KeybindButton.Parent = KeybindModule
                KeybindButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                KeybindButton.Size = UDim2.new(1, 0, 0, 36)
                KeybindButton.AutoButtonColor = false
                KeybindButton.Text = ""

                KeybindCorner.CornerRadius = UDim.new(0, 8)
                KeybindCorner.Name = "KeybindCorner"
                KeybindCorner.Parent = KeybindButton

                KeybindText.Name = "KeybindText"
                KeybindText.Parent = KeybindButton
                KeybindText.BackgroundTransparency = 1
                KeybindText.Position = UDim2.new(0, 15, 0, 0)
                KeybindText.Size = UDim2.new(0.5, 0, 1, 0)
                KeybindText.Font = Enum.Font.Gotham
                KeybindText.Text = text
                KeybindText.TextColor3 = TextColor
                KeybindText.TextSize = 14
                KeybindText.TextXAlignment = Enum.TextXAlignment.Left

                KeybindValue.Name = "KeybindValue"
                KeybindValue.Parent = KeybindButton
                KeybindValue.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                KeybindValue.Position = UDim2.new(1, -120, 0.5, -14)
                KeybindValue.Size = UDim2.new(0, 100, 0, 28)
                KeybindValue.AutoButtonColor = false
                KeybindValue.Font = Enum.Font.GothamSemibold
                KeybindValue.Text = keyTxt
                KeybindValue.TextColor3 = TextColor
                KeybindValue.TextSize = 13

                ValueCorner.CornerRadius = UDim.new(0, 6)
                ValueCorner.Name = "ValueCorner"
                ValueCorner.Parent = KeybindValue

                services.UserInputService.InputBegan:Connect(
                    function(inp, gpe)
                        if gpe then
                            return
                        end
                        if inp.UserInputType ~= Enum.UserInputType.Keyboard then
                            return
                        end
                        if inp.KeyCode ~= bindKey then
                            return
                        end
                        callback(bindKey.Name)
                    end
                )

                KeybindValue.MouseButton1Click:Connect(
                    function()
                        KeybindValue.Text = "..."
                        local key = services.UserInputService.InputEnded:Wait()
                        local keyName = tostring(key.KeyCode.Name)
                        
                        if key.UserInputType ~= Enum.UserInputType.Keyboard or banned[keyName] then
                            KeybindValue.Text = keyTxt
                            return
                        end
                        
                        bindKey = Enum.KeyCode[keyName]
                        keyTxt = shortNames[keyName] or keyName
                        KeybindValue.Text = keyTxt
                    end
                )

                KeybindValue:GetPropertyChangedSignal("TextBounds"):Connect(
                    function()
                        KeybindValue.Size = UDim2.new(0, math.clamp(KeybindValue.TextBounds.X + 20, 60, 150), 0, 28)
                    end
                )
                
                -- Hover effect
                local HoverEffect = Instance.new("Frame")
                HoverEffect.Name = "HoverEffect"
                HoverEffect.Parent = KeybindButton
                HoverEffect.BackgroundColor3 = MainColor
                HoverEffect.BackgroundTransparency = 0.95
                HoverEffect.Size = UDim2.new(1, 0, 1, 0)
                HoverEffect.ZIndex = -1
                local HoverCorner = Instance.new("UICorner")
                HoverCorner.CornerRadius = UDim.new(0, 8)
                HoverCorner.Parent = HoverEffect
                HoverEffect.Visible = false
                
                KeybindButton.MouseEnter:Connect(function()
                    HoverEffect.Visible = true
                end)
                
                KeybindButton.MouseLeave:Connect(function()
                    HoverEffect.Visible = false
                end)
            end

            function section.Textbox(section, text, flag, default, callback)
                local callback = callback or function() end
                assert(text, "No text provided")
                assert(flag, "No flag provided")
                assert(default, "No default text provided")

                library.flags[flag] = default

                local TextboxModule = Instance.new("Frame")
                local TextboxButton = Instance.new("TextButton")
                local TextboxCorner = Instance.new("UICorner")
                local TextboxText = Instance.new("TextLabel")
                local InputBox = Instance.new("TextBox")
                local InputCorner = Instance.new("UICorner")

                TextboxModule.Name = "TextboxModule"
                TextboxModule.Parent = ContentContainer
                TextboxModule.BackgroundTransparency = 1
                TextboxModule.Size = UDim2.new(1, 0, 0, 36)

                TextboxButton.Name = "TextboxButton"
                TextboxButton.Parent = TextboxModule
                TextboxButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                TextboxButton.Size = UDim2.new(1, 0, 0, 36)
                TextboxButton.AutoButtonColor = false
                TextboxButton.Text = ""

                TextboxCorner.CornerRadius = UDim.new(0, 8)
                TextboxCorner.Name = "TextboxCorner"
                TextboxCorner.Parent = TextboxButton

                TextboxText.Name = "TextboxText"
                TextboxText.Parent = TextboxButton
                TextboxText.BackgroundTransparency = 1
                TextboxText.Position = UDim2.new(0, 15, 0, 0)
                TextboxText.Size = UDim2.new(0.4, 0, 1, 0)
                TextboxText.Font = Enum.Font.Gotham
                TextboxText.Text = text
                TextboxText.TextColor3 = TextColor
                TextboxText.TextSize = 14
                TextboxText.TextXAlignment = Enum.TextXAlignment.Left

                InputBox.Name = "InputBox"
                InputBox.Parent = TextboxButton
                InputBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                InputBox.Position = UDim2.new(0.6, 0, 0.5, -14)
                InputBox.Size = UDim2.new(0.35, 0, 0, 28)
                InputBox.Font = Enum.Font.Gotham
                InputBox.PlaceholderText = default
                InputBox.Text = default
                InputBox.TextColor3 = TextColor
                InputBox.TextSize = 14
                InputBox.ClearTextOnFocus = false

                InputCorner.CornerRadius = UDim.new(0, 6)
                InputCorner.Name = "InputCorner"
                InputCorner.Parent = InputBox

                InputBox.FocusLost:Connect(function()
                    if InputBox.Text == "" then
                        InputBox.Text = default
                    end
                    library.flags[flag] = InputBox.Text
                    callback(InputBox.Text)
                end)

                -- Hover effect
                local HoverEffect = Instance.new("Frame")
                HoverEffect.Name = "HoverEffect"
                HoverEffect.Parent = TextboxButton
                HoverEffect.BackgroundColor3 = MainColor
                HoverEffect.BackgroundTransparency = 0.95
                HoverEffect.Size = UDim2.new(1, 0, 1, 0)
                HoverEffect.ZIndex = -1
                local HoverCorner = Instance.new("UICorner")
                HoverCorner.CornerRadius = UDim.new(0, 8)
                HoverCorner.Parent = HoverEffect
                HoverEffect.Visible = false
                
                TextboxButton.MouseEnter:Connect(function()
                    HoverEffect.Visible = true
                end)
                
                TextboxButton.MouseLeave:Connect(function()
                    HoverEffect.Visible = false
                end)
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
                local SliderContainer = Instance.new("Frame")
                local SliderCorner = Instance.new("UICorner")
                local SliderText = Instance.new("TextLabel")
                local SliderValue = Instance.new("TextLabel")
                local SliderBar = Instance.new("Frame")
                local BarCorner = Instance.new("UICorner")
                local SliderFill = Instance.new("Frame")
                local FillCorner = Instance.new("UICorner")
                local SliderKnob = Instance.new("Frame")
                local KnobCorner = Instance.new("UICorner")
                local MinButton = Instance.new("TextButton")
                local MaxButton = Instance.new("TextButton")

                SliderModule.Name = "SliderModule"
                SliderModule.Parent = ContentContainer
                SliderModule.BackgroundTransparency = 1
                SliderModule.Size = UDim2.new(1, 0, 0, 56)

                SliderContainer.Name = "SliderContainer"
                SliderContainer.Parent = SliderModule
                SliderContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                SliderContainer.Size = UDim2.new(1, 0, 0, 56)

                SliderCorner.CornerRadius = UDim.new(0, 8)
                SliderCorner.Name = "SliderCorner"
                SliderCorner.Parent = SliderContainer

                SliderText.Name = "SliderText"
                SliderText.Parent = SliderContainer
                SliderText.BackgroundTransparency = 1
                SliderText.Position = UDim2.new(0, 15, 0, 8)
                SliderText.Size = UDim2.new(0.6, 0, 0, 20)
                SliderText.Font = Enum.Font.Gotham
                SliderText.Text = text
                SliderText.TextColor3 = TextColor
                SliderText.TextSize = 14
                SliderText.TextXAlignment = Enum.TextXAlignment.Left

                SliderValue.Name = "SliderValue"
                SliderValue.Parent = SliderContainer
                SliderValue.BackgroundTransparency = 1
                SliderValue.Position = UDim2.new(0.6, 0, 0, 8)
                SliderValue.Size = UDim2.new(0.35, 0, 0, 20)
                SliderValue.Font = Enum.Font.GothamSemibold
                SliderValue.Text = tostring(default)
                SliderValue.TextColor3 = MainColor
                SliderValue.TextSize = 14
                SliderValue.TextXAlignment = Enum.TextXAlignment.Right

                SliderBar.Name = "SliderBar"
                SliderBar.Parent = SliderContainer
                SliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                SliderBar.Position = UDim2.new(0, 15, 0, 35)
                SliderBar.Size = UDim2.new(1, -30, 0, 6)

                BarCorner.CornerRadius = UDim.new(1, 0)
                BarCorner.Name = "BarCorner"
                BarCorner.Parent = SliderBar

                SliderFill.Name = "SliderFill"
                SliderFill.Parent = SliderBar
                SliderFill.BackgroundColor3 = MainColor
                SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)

                FillCorner.CornerRadius = UDim.new(1, 0)
                FillCorner.Name = "FillCorner"
                FillCorner.Parent = SliderFill

                SliderKnob.Name = "SliderKnob"
                SliderKnob.Parent = SliderBar
                SliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                SliderKnob.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
                SliderKnob.Size = UDim2.new(0, 16, 0, 16)

                KnobCorner.CornerRadius = UDim.new(1, 0)
                KnobCorner.Name = "KnobCorner"
                KnobCorner.Parent = SliderKnob

                MinButton.Name = "MinButton"
                MinButton.Parent = SliderContainer
                MinButton.BackgroundTransparency = 1
                MinButton.Position = UDim2.new(0, 5, 0, 35)
                MinButton.Size = UDim2.new(0, 10, 0, 6)
                MinButton.Font = Enum.Font.GothamBold
                MinButton.Text = "-"
                MinButton.TextColor3 = Color3.fromRGB(150, 150, 150)
                MinButton.TextSize = 16

                MaxButton.Name = "MaxButton"
                MaxButton.Parent = SliderContainer
                MaxButton.BackgroundTransparency = 1
                MaxButton.Position = UDim2.new(1, -15, 0, 35)
                MaxButton.Size = UDim2.new(0, 10, 0, 6)
                MaxButton.Font = Enum.Font.GothamBold
                MaxButton.Text = "+"
                MaxButton.TextColor3 = Color3.fromRGB(150, 150, 150)
                MaxButton.TextSize = 16

                local funcs = {
                    SetValue = function(self, value)
                        if value then
                            local percent = (value - min) / (max - min)
                            percent = math.clamp(percent, 0, 1)
                            
                            if precise then
                                value = tonumber(string.format("%.2f", tostring(min + (max - min) * percent)))
                            else
                                value = math.floor(min + (max - min) * percent)
                            end
                        else
                            local percent = (mouse.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X
                            percent = math.clamp(percent, 0, 1)
                            
                            if precise then
                                value = tonumber(string.format("%.2f", tostring(min + (max - min) * percent)))
                            else
                                value = math.floor(min + (max - min) * percent)
                            end
                        end
                        
                        value = math.clamp(value, min, max)
                        library.flags[flag] = value
                        SliderValue.Text = tostring(value)
                        
                        local percent = (value - min) / (max - min)
                        Tween(
                            SliderFill,
                            TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {Size = UDim2.new(percent, 0, 1, 0)}
                        )
                        
                        Tween(
                            SliderKnob,
                            TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {Position = UDim2.new(percent, -8, 0.5, -8)}
                        )
                        
                        callback(value)
                    end,
                    Module = SliderModule
                }

                funcs:SetValue(default)

                local dragging = false

                SliderBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        funcs:SetValue()
                    end
                end)

                services.UserInputService.InputEnded:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)

                services.UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        funcs:SetValue()
                    end
                end)

                MinButton.MouseButton1Click:Connect(function()
                    local currentValue = library.flags[flag]
                    funcs:SetValue(currentValue - 1)
                end)

                MaxButton.MouseButton1Click:Connect(function()
                    local currentValue = library.flags[flag]
                    funcs:SetValue(currentValue + 1)
                end)

                -- Hover effect
                local HoverEffect = Instance.new("Frame")
                HoverEffect.Name = "HoverEffect"
                HoverEffect.Parent = SliderContainer
                HoverEffect.BackgroundColor3 = MainColor
                HoverEffect.BackgroundTransparency = 0.95
                HoverEffect.Size = UDim2.new(1, 0, 1, 0)
                HoverEffect.ZIndex = -1
                local HoverCorner = Instance.new("UICorner")
                HoverCorner.CornerRadius = UDim.new(0, 8)
                HoverCorner.Parent = HoverEffect
                HoverEffect.Visible = false
                
                SliderContainer.MouseEnter:Connect(function()
                    HoverEffect.Visible = true
                end)
                
                SliderContainer.MouseLeave:Connect(function()
                    HoverEffect.Visible = false
                end)

                return funcs
            end

            function section.Dropdown(section, text, flag, options, callback)
                local callback = callback or function() end
                local options = options or {}
                assert(text, "No text provided")
                assert(flag, "No flag provided")

                library.flags[flag] = nil

                local DropdownModule = Instance.new("Frame")
                local DropdownButton = Instance.new("TextButton")
                local DropdownCorner = Instance.new("UICorner")
                local DropdownText = Instance.new("TextLabel")
                local DropdownIcon = Instance.new("ImageLabel")
                local OptionsContainer = Instance.new("Frame")
                local OptionsList = Instance.new("UIListLayout")
                local OptionsCorner = Instance.new("UICorner")

                DropdownModule.Name = "DropdownModule"
                DropdownModule.Parent = ContentContainer
                DropdownModule.BackgroundTransparency = 1
                DropdownModule.ClipsDescendants = true
                DropdownModule.Size = UDim2.new(1, 0, 0, 36)

                DropdownButton.Name = "DropdownButton"
                DropdownButton.Parent = DropdownModule
                DropdownButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                DropdownButton.Size = UDim2.new(1, 0, 0, 36)
                DropdownButton.AutoButtonColor = false
                DropdownButton.Text = ""

                DropdownCorner.CornerRadius = UDim.new(0, 8)
                DropdownCorner.Name = "DropdownCorner"
                DropdownCorner.Parent = DropdownButton

                DropdownText.Name = "DropdownText"
                DropdownText.Parent = DropdownButton
                DropdownText.BackgroundTransparency = 1
                DropdownText.Position = UDim2.new(0, 15, 0, 0)
                DropdownText.Size = UDim2.new(0.8, 0, 1, 0)
                DropdownText.Font = Enum.Font.Gotham
                DropdownText.Text = text .. " | 请选择"
                DropdownText.TextColor3 = TextColor
                DropdownText.TextSize = 14
                DropdownText.TextXAlignment = Enum.TextXAlignment.Left

                DropdownIcon.Name = "DropdownIcon"
                DropdownIcon.Parent = DropdownButton
                DropdownIcon.BackgroundTransparency = 1
                DropdownIcon.Position = UDim2.new(1, -30, 0.5, -10)
                DropdownIcon.Size = UDim2.new(0, 20, 0, 20)
                DropdownIcon.Image = "rbxassetid://6031094679"
                DropdownIcon.ImageColor3 = MainColor
                DropdownIcon.Rotation = 0

                OptionsContainer.Name = "OptionsContainer"
                OptionsContainer.Parent = DropdownModule
                OptionsContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                OptionsContainer.Position = UDim2.new(0, 0, 0, 41)
                OptionsContainer.Size = UDim2.new(1, 0, 0, 0)
                OptionsContainer.ClipsDescendants = true

                OptionsCorner.CornerRadius = UDim.new(0, 8)
                OptionsCorner.Name = "OptionsCorner"
                OptionsCorner.Parent = OptionsContainer

                OptionsList.Name = "OptionsList"
                OptionsList.Parent = OptionsContainer
                OptionsList.SortOrder = Enum.SortOrder.LayoutOrder
                OptionsList.Padding = UDim.new(0, 2)

                local isOpen = false
                local selectedOption = nil

                local function toggleDropdown()
                    isOpen = not isOpen
                    
                    Tween(
                        DropdownIcon,
                        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {Rotation = isOpen and 180 or 0}
                    )
                    
                    if isOpen then
                        OptionsContainer.Size = UDim2.new(1, 0, 0, OptionsList.AbsoluteContentSize.Y + 10)
                        DropdownModule.Size = UDim2.new(1, 0, 0, 36 + OptionsList.AbsoluteContentSize.Y + 15)
                    else
                        OptionsContainer.Size = UDim2.new(1, 0, 0, 0)
                        DropdownModule.Size = UDim2.new(1, 0, 0, 36)
                    end
                end

                DropdownButton.MouseButton1Click:Connect(toggleDropdown)

                OptionsList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    if isOpen then
                        OptionsContainer.Size = UDim2.new(1, 0, 0, OptionsList.AbsoluteContentSize.Y + 10)
                        DropdownModule.Size = UDim2.new(1, 0, 0, 36 + OptionsList.AbsoluteContentSize.Y + 15)
                    end
                end)

                local funcs = {}
                
                funcs.AddOption = function(self, option)
                    local OptionButton = Instance.new("TextButton")
                    local OptionCorner = Instance.new("UICorner")

                    OptionButton.Name = "Option_" .. option
                    OptionButton.Parent = OptionsContainer
                    OptionButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                    OptionButton.Size = UDim2.new(1, -10, 0, 28)
                    OptionButton.Position = UDim2.new(0, 5, 0, 0)
                    OptionButton.AutoButtonColor = false
                    OptionButton.Font = Enum.Font.Gotham
                    OptionButton.Text = "  " .. option
                    OptionButton.TextColor3 = TextColor
                    OptionButton.TextSize = 13
                    OptionButton.TextXAlignment = Enum.TextXAlignment.Left

                    OptionCorner.CornerRadius = UDim.new(0, 6)
                    OptionCorner.Name = "OptionCorner"
                    OptionCorner.Parent = OptionButton

                    OptionButton.MouseButton1Click:Connect(function()
                        selectedOption = option
                        DropdownText.Text = text .. " | " .. option
                        library.flags[flag] = option
                        callback(option)
                        toggleDropdown()
                    end)

                    -- Hover effect for option
                    local OptionHover = Instance.new("Frame")
                    OptionHover.Name = "OptionHover"
                    OptionHover.Parent = OptionButton
                    OptionHover.BackgroundColor3 = MainColor
                    OptionHover.BackgroundTransparency = 0.9
                    OptionHover.Size = UDim2.new(1, 0, 1, 0)
                    OptionHover.ZIndex = -1
                    local HoverCorner = Instance.new("UICorner")
                    HoverCorner.CornerRadius = UDim.new(0, 6)
                    HoverCorner.Parent = OptionHover
                    OptionHover.Visible = false
                    
                    OptionButton.MouseEnter:Connect(function()
                        OptionHover.Visible = true
                    end)
                    
                    OptionButton.MouseLeave:Connect(function()
                        OptionHover.Visible = false
                    end)
                end

                funcs.RemoveOption = function(self, option)
                    local optionBtn = OptionsContainer:FindFirstChild("Option_" .. option)
                    if optionBtn then
                        optionBtn:Destroy()
                    end
                end

                funcs.SetOptions = function(self, newOptions)
                    for _, v in pairs(OptionsContainer:GetChildren()) do
                        if v:IsA("TextButton") then
                            v:Destroy()
                        end
                    end
                    
                    for _, v in pairs(newOptions) do
                        funcs:AddOption(v)
                    end
                end

                funcs:SetOptions(options)

                -- Hover effect for dropdown
                local HoverEffect = Instance.new("Frame")
                HoverEffect.Name = "HoverEffect"
                HoverEffect.Parent = DropdownButton
                HoverEffect.BackgroundColor3 = MainColor
                HoverEffect.BackgroundTransparency = 0.95
                HoverEffect.Size = UDim2.new(1, 0, 1, 0)
                HoverEffect.ZIndex = -1
                local HoverCorner = Instance.new("UICorner")
                HoverCorner.CornerRadius = UDim.new(0, 8)
                HoverCorner.Parent = HoverEffect
                HoverEffect.Visible = false
                
                DropdownButton.MouseEnter:Connect(function()
                    HoverEffect.Visible = true
                end)
                
                DropdownButton.MouseLeave:Connect(function()
                    HoverEffect.Visible = false
                end)

                return funcs
            end

            return section
        end
        return tab
    end
    
    return window
end

return library