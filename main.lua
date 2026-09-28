-- Owner: 1cheatshubs 🧸
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

-- ID de la imagen para el logo en la esquina del menú
local LOGO_ASSET_ID = "rbxassetid://124997284454543"

-- ==========================================
-- RESTO DEL SCRIPT Y UI NEGRO Y AZUL MARINO (DARK THEME)
-- ==========================================

local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera

-- COLORES TEMA ULTRA DARK Y AZUL MARINO OSCURO
local COLOR_MAIN_BG = Color3.fromRGB(3, 3, 5)          -- Fondo casi negro absoluto
local COLOR_SIDEBAR = Color3.fromRGB(6, 8, 12)         -- Sidebar muy oscuro
local COLOR_CONTAINER = Color3.fromRGB(10, 12, 18)     -- Contenedores oscuros profundos
local COLOR_NAVY = Color3.fromRGB(10, 50, 120)        -- Azul Marino de bajo brillo
local COLOR_NAVY_LIGHT = Color3.fromRGB(40, 110, 190)  -- Accent / Resaltado
local COLOR_TEXT = Color3.fromRGB(200, 205, 215)      -- Texto ajustado suave

local success, parentTarget = pcall(function()
	return CoreGui
end)
if not success or not parentTarget then
	parentTarget = player:WaitForChild("PlayerGui")
end

if parentTarget:FindFirstChild("EssentialGui") then
	parentTarget.EssentialGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EssentialGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = parentTarget

-- ==========================================
-- PANTALLA DE CERRADO / INTRO FULLSCREEN (TAPA TODA LA PANTALLA)
-- ==========================================
task.spawn(function()
	local introGui = Instance.new("ScreenGui")
	introGui.Name = "EssentialIntroGui"
	introGui.ResetOnSpawn = false
	introGui.IgnoreGuiInset = true -- Ignora la barra superior de Roblox para cubrir el 100%
	introGui.DisplayOrder = 999999 -- Se dibuja por encima de cualquier otra interfaz
	introGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	introGui.Parent = parentTarget

	local introFrame = Instance.new("Frame", introGui)
	introFrame.Name = "IntroScreen"
	introFrame.Size = UDim2.new(1, 0, 1, 0)
	introFrame.Position = UDim2.new(0, 0, 0, 0)
	introFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	introFrame.BorderSizePixel = 0
	introFrame.ZIndex = 999999

	local introLogo = Instance.new("ImageLabel", introFrame)
	introLogo.Size = UDim2.new(0, 140, 0, 140)
	introLogo.Position = UDim2.new(0.5, -70, 0.4, -70)
	introLogo.BackgroundTransparency = 1
	introLogo.Image = LOGO_ASSET_ID
	introLogo.ScaleType = Enum.ScaleType.Fit
	introLogo.ImageTransparency = 1
	introLogo.ZIndex = 1000000

	local introText = Instance.new("TextLabel", introFrame)
	introText.Size = UDim2.new(1, 0, 0, 40)
	introText.Position = UDim2.new(0, 0, 0.4, 80)
	introText.BackgroundTransparency = 1
	introText.Font = Enum.Font.GothamBold
	introText.Text = "BIENVENIDO " .. player.Name .. " A ESSENTIAL"
	introText.TextColor3 = COLOR_TEXT
	introText.TextSize = 20
	introText.TextTransparency = 1
	introText.ZIndex = 1000000

	-- Animación de aparición
	TweenService:Create(introLogo, TweenInfo.new(0.8), {ImageTransparency = 0}):Play()
	TweenService:Create(introText, TweenInfo.new(0.8), {TextTransparency = 0}):Play()
	task.wait(2.2)

	-- Animación de desvanecimiento
	local tweenLogo = TweenService:Create(introLogo, TweenInfo.new(0.6), {ImageTransparency = 1})
	local tweenText = TweenService:Create(introText, TweenInfo.new(0.6), {TextTransparency = 1})
	local tweenBG = TweenService:Create(introFrame, TweenInfo.new(0.6), {BackgroundTransparency = 1})

	tweenLogo:Play()
	tweenText:Play()
	tweenBG:Play()

	tweenBG.Completed:Connect(function()
		introGui:Destroy()
	end)
end)

-- ==========================================
-- HUD DE AIMLOCK (CENTRO ARRIBA)
-- ==========================================
local aimlockHUD = Instance.new("Frame", screenGui)
aimlockHUD.Name = "AimlockHUD"
aimlockHUD.Size = UDim2.new(0, 220, 0, 45)
aimlockHUD.Position = UDim2.new(0.5, -110, 0, 15)
aimlockHUD.BackgroundColor3 = COLOR_MAIN_BG
aimlockHUD.BackgroundTransparency = 0.15
aimlockHUD.BorderSizePixel = 0
aimlockHUD.Visible = false

local hudCorner = Instance.new("UICorner", aimlockHUD)
hudCorner.CornerRadius = UDim.new(0, 8)

local hudStroke = Instance.new("UIStroke", aimlockHUD)
hudStroke.Color = COLOR_NAVY_LIGHT
hudStroke.Transparency = 0.4
hudStroke.Thickness = 1.5

local targetUserLabel = Instance.new("TextLabel", aimlockHUD)
targetUserLabel.Name = "TargetUser"
targetUserLabel.Size = UDim2.new(1, 0, 0, 22)
targetUserLabel.Position = UDim2.new(0, 0, 0, 3)
targetUserLabel.BackgroundTransparency = 1
targetUserLabel.Font = Enum.Font.GothamBold
targetUserLabel.Text = "TARGET: NONE"
targetUserLabel.TextColor3 = COLOR_TEXT
targetUserLabel.TextSize = 11

local targetPartLabel = Instance.new("TextLabel", aimlockHUD)
targetPartLabel.Name = "TargetPart"
targetPartLabel.Size = UDim2.new(1, 0, 0, 18)
targetPartLabel.Position = UDim2.new(0, 0, 0, 22)
targetPartLabel.BackgroundTransparency = 1
targetPartLabel.Font = Enum.Font.GothamBold
targetPartLabel.Text = "PART: HEAD"
targetPartLabel.TextColor3 = COLOR_NAVY_LIGHT
targetPartLabel.TextSize = 10


-- MENÚ PRINCIPAL (480x360)
local cheatsHub = Instance.new("Frame")
cheatsHub.Name = "EssentialHub"
cheatsHub.Size = UDim2.new(0, 480, 0, 360)
cheatsHub.Position = UDim2.new(0.5, -240, 0.5, -180)
cheatsHub.BackgroundColor3 = COLOR_MAIN_BG
cheatsHub.BackgroundTransparency = 0.03
cheatsHub.BorderSizePixel = 0
cheatsHub.Visible = true
cheatsHub.Parent = screenGui

local menuCorner = Instance.new("UICorner", cheatsHub)
menuCorner.CornerRadius = UDim.new(0, 12)

local menuStroke = Instance.new("UIStroke", cheatsHub)
menuStroke.Color = COLOR_NAVY
menuStroke.Transparency = 0.5
menuStroke.Thickness = 1.5

-- LOGO EN LA ESQUINA SUPERIOR (38x38)
local logoImage = Instance.new("ImageLabel", cheatsHub)
logoImage.Name = "LogoImage"
logoImage.Size = UDim2.new(0, 38, 0, 38)
logoImage.Position = UDim2.new(0, 10, 0, 6)
logoImage.BackgroundTransparency = 1
logoImage.Image = LOGO_ASSET_ID
logoImage.ScaleType = Enum.ScaleType.Fit

-- HEADER/TÍTULO
local titleLabel = Instance.new("TextLabel", cheatsHub)
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, -65, 0, 30)
titleLabel.Position = UDim2.new(0, 54, 0, 10)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "ESSENTIAL"
titleLabel.TextColor3 = COLOR_TEXT
titleLabel.TextSize = 13
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

local titleSub = Instance.new("TextLabel", titleLabel)
titleSub.Size = UDim2.new(1, 0, 1, 0)
titleSub.BackgroundTransparency = 1
titleSub.Font = Enum.Font.GothamBold
titleSub.Text = "v1.0"
titleSub.TextColor3 = COLOR_NAVY_LIGHT
titleSub.TextSize = 13
titleSub.TextXAlignment = Enum.TextXAlignment.Right

local divider = Instance.new("Frame", cheatsHub)
divider.Size = UDim2.new(1, -24, 0, 1)
divider.Position = UDim2.new(0, 12, 0, 48)
divider.BackgroundColor3 = COLOR_NAVY
divider.BackgroundTransparency = 0.7
divider.BorderSizePixel = 0

-- BARRA LATERAL (SIDEBAR DE PESTAÑAS)
local sidebar = Instance.new("Frame", cheatsHub)
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 110, 1, -60)
sidebar.Position = UDim2.new(0, 12, 0, 54)
sidebar.BackgroundTransparency = 1

local sidebarList = Instance.new("UIListLayout", sidebar)
sidebarList.SortOrder = Enum.SortOrder.LayoutOrder
sidebarList.Padding = UDim.new(0, 6)

-- CONTENEDOR DE CONTENIDO PRINCIPAL
local contentArea = Instance.new("Frame", cheatsHub)
contentArea.Name = "ContentArea"
contentArea.Size = UDim2.new(1, -144, 1, -60)
contentArea.Position = UDim2.new(0, 132, 0, 54)
contentArea.BackgroundTransparency = 1

-- PESTAÑAS (COMBAT, VISUAL, MISC)
local combatTabFrame = Instance.new("ScrollingFrame", contentArea)
combatTabFrame.Name = "CombatTab"
combatTabFrame.Size = UDim2.new(1, 0, 1, 0)
combatTabFrame.BackgroundTransparency = 1
combatTabFrame.BorderSizePixel = 0
combatTabFrame.ScrollBarThickness = 3
combatTabFrame.Visible = true

local combatList = Instance.new("UIListLayout", combatTabFrame)
combatList.SortOrder = Enum.SortOrder.LayoutOrder
combatList.Padding = UDim.new(0, 6)

local visualTabFrame = Instance.new("ScrollingFrame", contentArea)
visualTabFrame.Name = "VisualTab"
visualTabFrame.Size = UDim2.new(1, 0, 1, 0)
visualTabFrame.BackgroundTransparency = 1
visualTabFrame.BorderSizePixel = 0
visualTabFrame.ScrollBarThickness = 3
visualTabFrame.Visible = false

local visualList = Instance.new("UIListLayout", visualTabFrame)
visualList.SortOrder = Enum.SortOrder.LayoutOrder
visualList.Padding = UDim.new(0, 6)

local miscTabFrame = Instance.new("ScrollingFrame", contentArea)
miscTabFrame.Name = "MiscTab"
miscTabFrame.Size = UDim2.new(1, 0, 1, 0)
miscTabFrame.BackgroundTransparency = 1
miscTabFrame.BorderSizePixel = 0
miscTabFrame.ScrollBarThickness = 3
miscTabFrame.Visible = false

local miscList = Instance.new("UIListLayout", miscTabFrame)
miscList.SortOrder = Enum.SortOrder.LayoutOrder
miscList.Padding = UDim.new(0, 6)

-- BOTONES DE PESTAÑA
local function createTabButton(text, layoutOrder)
	local btn = Instance.new("TextButton", sidebar)
	btn.Size = UDim2.new(1, 0, 0, 32)
	btn.BackgroundColor3 = COLOR_SIDEBAR
	btn.BackgroundTransparency = 0.3
	btn.Font = Enum.Font.GothamBold
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(100, 110, 125)
	btn.TextSize = 11
	btn.LayoutOrder = layoutOrder
	btn.AutoButtonColor = false

	local corner = Instance.new("UICorner", btn)
	corner.CornerRadius = UDim.new(0, 6)

	local stroke = Instance.new("UIStroke", btn)
	stroke.Name = "TabStroke"
	stroke.Color = COLOR_NAVY
	stroke.Transparency = 0.9
	stroke.Thickness = 1

	return btn
end

local combatTabBtn = createTabButton("COMBAT", 1)
local visualTabBtn = createTabButton("VISUAL", 2)
local miscTabBtn   = createTabButton("MISC", 3)

local function setTabActive(btn, active)
	local stroke = btn:FindFirstChild("TabStroke")
	if active then
		btn.BackgroundColor3 = COLOR_CONTAINER
		btn.TextColor3 = COLOR_TEXT
		if stroke then stroke.Color = COLOR_NAVY; stroke.Transparency = 0.4 end
	else
		btn.BackgroundColor3 = COLOR_SIDEBAR
		btn.TextColor3 = Color3.fromRGB(100, 110, 125)
		if stroke then stroke.Color = COLOR_NAVY; stroke.Transparency = 0.9 end
	end
end

setTabActive(combatTabBtn, true)

combatTabBtn.MouseButton1Click:Connect(function()
	combatTabFrame.Visible = true
	visualTabFrame.Visible = false
	miscTabFrame.Visible = false
	setTabActive(combatTabBtn, true)
	setTabActive(visualTabBtn, false)
	setTabActive(miscTabBtn, false)
end)

visualTabBtn.MouseButton1Click:Connect(function()
	combatTabFrame.Visible = false
	visualTabFrame.Visible = true
	miscTabFrame.Visible = false
	setTabActive(combatTabBtn, false)
	setTabActive(visualTabBtn, true)
	setTabActive(miscTabBtn, false)
end)

miscTabBtn.MouseButton1Click:Connect(function()
	combatTabFrame.Visible = false
	visualTabFrame.Visible = false
	miscTabFrame.Visible = true
	setTabActive(combatTabBtn, false)
	setTabActive(visualTabBtn, false)
	setTabActive(miscTabBtn, true)
end)


-- BOTONES SIMPLES PARA COMBAT Y MISC
local function styleButton(btn, text)
	btn.Size = UDim2.new(1, -6, 0, 32)
	btn.BackgroundColor3 = COLOR_CONTAINER
	btn.BackgroundTransparency = 0.3
	btn.Font = Enum.Font.GothamMedium
	btn.Text = "  " .. text
	btn.TextColor3 = COLOR_TEXT
	btn.TextSize = 11
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.AutoButtonColor = false
	
	local corner = Instance.new("UICorner", btn)
	corner.CornerRadius = UDim.new(0, 6)
	
	local stroke = Instance.new("UIStroke", btn)
	stroke.Name = "BtnStroke"
	stroke.Color = COLOR_NAVY
	stroke.Transparency = 0.85
	stroke.Thickness = 1

	local dot = Instance.new("Frame", btn)
	dot.Name = "StatusDot"
	dot.Size = UDim2.new(0, 6, 0, 6)
	dot.Position = UDim2.new(1, -16, 0.5, -3)
	dot.BackgroundColor3 = Color3.fromRGB(25, 28, 35)
	dot.BorderSizePixel = 0
	Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.1, BackgroundColor3 = COLOR_SIDEBAR}):Play()
	end)
	
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.3, BackgroundColor3 = COLOR_CONTAINER}):Play()
	end)
end

local function setButtonState(btn, state)
	local dot = btn:FindFirstChild("StatusDot")
	local stroke = btn:FindFirstChild("BtnStroke")
	if state then
		btn.TextColor3 = COLOR_TEXT
		if dot then TweenService:Create(dot, TweenInfo.new(0.15), {BackgroundColor3 = COLOR_NAVY_LIGHT}):Play() end
		if stroke then stroke.Color = COLOR_NAVY_LIGHT; stroke.Transparency = 0.3 end
	else
		btn.TextColor3 = Color3.fromRGB(110, 120, 135)
		if dot then TweenService:Create(dot, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(25, 28, 35)}):Play() end
		if stroke then stroke.Color = COLOR_NAVY; stroke.Transparency = 0.85 end
	end
end

-- ESTRUCTURA PARA OPCIONALES EN PESTAÑA VISUAL
local ColorOptions = {
	{ Name = "Azul Marino", Color = COLOR_NAVY },
	{ Name = "Azul C.", Color = COLOR_NAVY_LIGHT },
	{ Name = "Rojo", Color = Color3.fromRGB(255, 50, 50) },
	{ Name = "Verde", Color = Color3.fromRGB(50, 255, 100) },
	{ Name = "Amarillo", Color = Color3.fromRGB(255, 230, 50) }
}

local function createVisualOption(parent, title, layoutOrder, hasColorPicker)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, -6, 0, hasColorPicker and 54 or 32)
	container.BackgroundColor3 = COLOR_CONTAINER
	container.BackgroundTransparency = 0.3
	container.LayoutOrder = layoutOrder
	container.Parent = parent

	local corner = Instance.new("UICorner", container)
	corner.CornerRadius = UDim.new(0, 6)

	local stroke = Instance.new("UIStroke", container)
	stroke.Name = "OptStroke"
	stroke.Color = COLOR_NAVY
	stroke.Transparency = 0.85
	stroke.Thickness = 1

	local toggleBtn = Instance.new("TextButton", container)
	toggleBtn.Size = UDim2.new(1, 0, 0, 32)
	toggleBtn.BackgroundTransparency = 1
	toggleBtn.Font = Enum.Font.GothamMedium
	toggleBtn.Text = "     " .. title
	toggleBtn.TextColor3 = Color3.fromRGB(110, 120, 135)
	toggleBtn.TextSize = 11
	toggleBtn.TextXAlignment = Enum.TextXAlignment.Left

	local dot = Instance.new("Frame", toggleBtn)
	dot.Name = "StatusDot"
	dot.Size = UDim2.new(0, 6, 0, 6)
	dot.Position = UDim2.new(0, 8, 0.5, -3)
	dot.BackgroundColor3 = Color3.fromRGB(25, 28, 35)
	dot.BorderSizePixel = 0
	Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

	local colorBtn = nil
	local selectedColorIndex = 1

	if hasColorPicker then
		colorBtn = Instance.new("TextButton", container)
		colorBtn.Size = UDim2.new(1, -16, 0, 16)
		colorBtn.Position = UDim2.new(0, 8, 0, 32)
		colorBtn.BackgroundColor3 = COLOR_SIDEBAR
		colorBtn.Font = Enum.Font.GothamBold
		colorBtn.Text = "Color: " .. ColorOptions[1].Name
		colorBtn.TextColor3 = ColorOptions[1].Color
		colorBtn.TextSize = 9
		Instance.new("UICorner", colorBtn).CornerRadius = UDim.new(0, 4)

		colorBtn.MouseButton1Click:Connect(function()
			selectedColorIndex = selectedColorIndex + 1
			if selectedColorIndex > #ColorOptions then selectedColorIndex = 1 end
			colorBtn.Text = "Color: " .. ColorOptions[selectedColorIndex].Name
			colorBtn.TextColor3 = ColorOptions[selectedColorIndex].Color
		end)
	end

	return {
		Container = container,
		ToggleBtn = toggleBtn,
		ColorBtn = colorBtn,
		GetColorIndex = function() return selectedColorIndex end,
		SetColorIndex = function(idx)
			selectedColorIndex = idx
			if colorBtn then
				colorBtn.Text = "Color: " .. ColorOptions[selectedColorIndex].Name
				colorBtn.TextColor3 = ColorOptions[selectedColorIndex].Color
			end
		end,
		GetColor = function() return ColorOptions[selectedColorIndex].Color end,
		SetState = function(state)
			if state then
				toggleBtn.TextColor3 = COLOR_TEXT
				TweenService:Create(dot, TweenInfo.new(0.15), {BackgroundColor3 = COLOR_NAVY_LIGHT}):Play()
				stroke.Color = COLOR_NAVY_LIGHT
				stroke.Transparency = 0.3
			else
				toggleBtn.TextColor3 = Color3.fromRGB(110, 120, 135)
				TweenService:Create(dot, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(25, 28, 35)}):Play()
				stroke.Color = COLOR_NAVY
				stroke.Transparency = 0.85
			end
		end
	}
end


-- ASIGNACIÓN DE BOTONES EN PESTAÑA COMBAT
local aimlockButton = Instance.new("TextButton")
aimlockButton.Name = "AimlockButton"
styleButton(aimlockButton, "Aimlock")
aimlockButton.LayoutOrder = 1
aimlockButton.Parent = combatTabFrame

local aimSmoothButton = Instance.new("TextButton")
aimSmoothButton.Name = "AimSmoothButton"
styleButton(aimSmoothButton, "Aim Mode: Fuerte")
aimSmoothButton.LayoutOrder = 2
aimSmoothButton.Parent = combatTabFrame
if aimSmoothButton:FindFirstChild("StatusDot") then aimSmoothButton.StatusDot:Destroy() end

local aimlockKeyButton = Instance.new("TextButton")
aimlockKeyButton.Name = "AimlockKeyButton"
styleButton(aimlockKeyButton, "Keybind: [F]")
aimlockKeyButton.LayoutOrder = 3
aimlockKeyButton.Parent = combatTabFrame
if aimlockKeyButton:FindFirstChild("StatusDot") then aimlockKeyButton.StatusDot:Destroy() end

-- SLIDER FOV DENTRO DE COMBAT
local fovSliderFrame = Instance.new("Frame")
fovSliderFrame.Name = "FOVSliderFrame"
fovSliderFrame.Size = UDim2.new(1, -6, 0, 32)
fovSliderFrame.BackgroundColor3 = COLOR_CONTAINER
fovSliderFrame.BackgroundTransparency = 0.3
fovSliderFrame.LayoutOrder = 4
fovSliderFrame.Parent = combatTabFrame

local fovCorner = Instance.new("UICorner", fovSliderFrame)
fovCorner.CornerRadius = UDim.new(0, 6)

local fovStroke = Instance.new("UIStroke", fovSliderFrame)
fovStroke.Color = COLOR_NAVY
fovStroke.Transparency = 0.85
fovStroke.Thickness = 1

local fovLabel = Instance.new("TextLabel", fovSliderFrame)
fovLabel.Size = UDim2.new(1, -16, 0, 12)
fovLabel.Position = UDim2.new(0, 8, 0, 3)
fovLabel.BackgroundTransparency = 1
fovLabel.Font = Enum.Font.GothamMedium
fovLabel.Text = "FOV: 5000"
fovLabel.TextColor3 = COLOR_TEXT
fovLabel.TextSize = 9
fovLabel.TextXAlignment = Enum.TextXAlignment.Left

local sliderLineBg = Instance.new("Frame", fovSliderFrame)
sliderLineBg.Size = UDim2.new(1, -16, 0, 4)
sliderLineBg.Position = UDim2.new(0, 8, 0, 20)
sliderLineBg.BackgroundColor3 = COLOR_SIDEBAR
sliderLineBg.BorderSizePixel = 0
Instance.new("UICorner", sliderLineBg).CornerRadius = UDim.new(1, 0)

local sliderLineFill = Instance.new("Frame", sliderLineBg)
sliderLineFill.Size = UDim2.new(1, 0, 1, 0)
sliderLineFill.BackgroundColor3 = COLOR_NAVY
sliderLineFill.BorderSizePixel = 0
Instance.new("UICorner", sliderLineFill).CornerRadius = UDim.new(1, 0)

local sliderButton = Instance.new("TextButton", sliderLineBg)
sliderButton.Size = UDim2.new(0, 8, 0, 8)
sliderButton.Position = UDim2.new(1, -4, 0.5, -4)
sliderButton.BackgroundColor3 = COLOR_TEXT
sliderButton.Text = ""
sliderButton.AutoButtonColor = false
Instance.new("UICorner", sliderButton).CornerRadius = UDim.new(1, 0)

local noRecoilButton = Instance.new("TextButton")
noRecoilButton.Name = "NoRecoilButton"
styleButton(noRecoilButton, "No Recoil")
noRecoilButton.LayoutOrder = 5
noRecoilButton.Parent = combatTabFrame


-- ASIGNACIÓN DE OPCIONES EN PESTAÑA VISUAL
local espOpt = createVisualOption(visualTabFrame, "ESP Player", 1, false)
local charmsOpt = createVisualOption(visualTabFrame, "Chams Optimizado", 2, true)
local skeletonOpt = createVisualOption(visualTabFrame, "Skeleton ESP", 3, true)
local espWeaponOpt = createVisualOption(visualTabFrame, "ESP Weapons", 4, false)
local dropItemsOpt = createVisualOption(visualTabFrame, "ESP Drops", 5, false)
local whitelistOpt = createVisualOption(visualTabFrame, "Whitelist Panel", 6, false)


-- ASIGNACIÓN DE OPCIONES EN PESTAÑA MISC
local saveConfigBtn = Instance.new("TextButton")
styleButton(saveConfigBtn, "Guardar Configuración")
saveConfigBtn.LayoutOrder = 1
saveConfigBtn.Parent = miscTabFrame
if saveConfigBtn:FindFirstChild("StatusDot") then saveConfigBtn.StatusDot:Destroy() end

local menuKeyBtn = Instance.new("TextButton")
styleButton(menuKeyBtn, "Keybind Menú: [RightControl]")
menuKeyBtn.LayoutOrder = 2
menuKeyBtn.Parent = miscTabFrame
if menuKeyBtn:FindFirstChild("StatusDot") then menuKeyBtn.StatusDot:Destroy() end


-- CONTENEDOR WHITELIST (DESPLEGABLE A LA IZQUIERDA DEL MENU)
local whitelistContainerFrame = Instance.new("ScrollingFrame")
whitelistContainerFrame.Name = "WhitelistContainer"
whitelistContainerFrame.Size = UDim2.new(0, 140, 0, 280)
whitelistContainerFrame.Position = UDim2.new(0, -150, 0, 0)
whitelistContainerFrame.BackgroundColor3 = COLOR_MAIN_BG
whitelistContainerFrame.BackgroundTransparency = 0.03
whitelistContainerFrame.BorderSizePixel = 0
whitelistContainerFrame.Visible = false
whitelistContainerFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
whitelistContainerFrame.ScrollBarThickness = 2
whitelistContainerFrame.Parent = cheatsHub

local wlContainerCorner = Instance.new("UICorner", whitelistContainerFrame)
wlContainerCorner.CornerRadius = UDim.new(0, 10)

local wlContainerStroke = Instance.new("UIStroke", whitelistContainerFrame)
wlContainerStroke.Color = COLOR_NAVY
wlContainerStroke.Transparency = 0.5
wlContainerStroke.Thickness = 1.5

local wlListLayout = Instance.new("UIListLayout", whitelistContainerFrame)
wlListLayout.SortOrder = Enum.SortOrder.LayoutOrder
wlListLayout.Padding = UDim.new(0, 4)


-- CAMBIO DE NOMBRE A ESSENTIAL
task.spawn(function()
	local function applyNameChange(char)
		if not char then return end
		local humanoid = char:WaitForChild("Humanoid", 10)
		if humanoid then
			humanoid.DisplayName = "Essential"
		end
		
		local head = char:WaitForChild("Head", 10)
		if head then
			for _, desc in ipairs(char:GetDescendants()) do
				if desc:IsA("TextLabel") and (desc.Text:find(player.Name) or desc.Text:find(player.DisplayName)) then
					desc.Text = "Essential"
				end
			end
		end
	end

	if player.Character then
		applyNameChange(player.Character)
	end
	player.CharacterAdded:Connect(applyNameChange)
end)


-- ABRIR / CERRAR PANEL MEDIANTE TECLA PERSONALIZABLE
local isOpen = true
local currentMenuKey = Enum.KeyCode.RightControl
local isBindingMenuKey = false

local function toggleMenu()
	isOpen = not isOpen
	if isOpen then
		cheatsHub.Visible = true
		cheatsHub.BackgroundTransparency = 0.8
		TweenService:Create(cheatsHub, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			BackgroundTransparency = 0.03
		}):Play()
	else
		whitelistContainerFrame.Visible = false
		local defaultTween = TweenService:Create(cheatsHub, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
			BackgroundTransparency = 1
		})
		defaultTween:Play()
		defaultTween.Completed:Connect(function()
			if not isOpen then
				cheatsHub.Visible = false
			end
		end)
	end
end

UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe or isBindingMenuKey then return end
	if currentMenuKey and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == currentMenuKey then
		toggleMenu()
	end
end)

-- CONFIGURAR KEYBIND DE MENÚ EN MISC
menuKeyBtn.MouseButton1Click:Connect(function()
	if isBindingMenuKey then return end
	isBindingMenuKey = true
	menuKeyBtn.Text = "  Keybind Menú: [...]"
	menuKeyBtn.TextColor3 = Color3.fromRGB(255, 180, 50)

	local conn
	conn = UserInputService.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Keyboard then
			currentMenuKey = input.KeyCode
			menuKeyBtn.Text = "  Keybind Menú: [" .. input.KeyCode.Name .. "]"
			menuKeyBtn.TextColor3 = COLOR_TEXT
			isBindingMenuKey = false
			conn:Disconnect()
		end
	end)
end)


-- LÓGICAS Y FUNCIONALIDADES
local globalFOVRadius = 5000
local WhitelistedPlayers = {}


-- LÓGICA SLIDER FOV
task.spawn(function()
	local minFOV = 10
	local maxFOV = 5000
	local draggingSlider = false

	local function updateSlider(input)
		local pos = math.clamp((input.Position.X - sliderLineBg.AbsolutePosition.X) / sliderLineBg.AbsoluteSize.X, 0, 1)
		sliderLineFill.Size = UDim2.new(pos, 0, 1, 0)
		sliderButton.Position = UDim2.new(pos, -4, 0.5, -4)
		
		globalFOVRadius = math.floor(minFOV + (maxFOV - minFOV) * pos)
		fovLabel.Text = "FOV: " .. globalFOVRadius
	end

	sliderButton.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			draggingSlider = true
		end
	end)

	sliderLineBg.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			draggingSlider = true
			updateSlider(input)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			draggingSlider = false
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			updateSlider(input)
		end
	end)
end)


-- SISTEMA DE WHITELIST
task.spawn(function()
	local isWLPanelOpen = false

	local function toggleWLPanel()
		isWLPanelOpen = not isWLPanelOpen
		whitelistContainerFrame.Visible = isWLPanelOpen
		whitelistOpt.SetState(isWLPanelOpen)
	end

	whitelistOpt.ToggleBtn.MouseButton1Click:Connect(toggleWLPanel)

	local function refreshWhiteListUI()
		for _, child in ipairs(whitelistContainerFrame:GetChildren()) do
			if child:IsA("TextButton") then
				child:Destroy()
			end
		end

		local playersList = Players:GetPlayers()
		whitelistContainerFrame.CanvasSize = UDim2.new(0, 0, 0, #playersList * 26)

		for _, p in ipairs(playersList) do
			if p ~= player then
				local pButton = Instance.new("TextButton")
				pButton.Size = UDim2.new(1, -6, 0, 22)
				pButton.Position = UDim2.new(0, 3, 0, 0)
				pButton.Font = Enum.Font.GothamMedium
				pButton.TextSize = 9
				pButton.TextColor3 = COLOR_TEXT
				pButton.Parent = whitelistContainerFrame

				Instance.new("UICorner", pButton).CornerRadius = UDim.new(0, 4)

				local isWhitelisted = WhitelistedPlayers[p.Name] == true

				if isWhitelisted then
					pButton.Text = "  [WL] " .. p.DisplayName
					pButton.BackgroundColor3 = COLOR_NAVY
				else
					pButton.Text = "  " .. p.DisplayName
					pButton.BackgroundColor3 = COLOR_SIDEBAR
				end

				pButton.MouseButton1Click:Connect(function()
					if WhitelistedPlayers[p.Name] then
						WhitelistedPlayers[p.Name] = nil
						pButton.Text = "  " .. p.DisplayName
						pButton.BackgroundColor3 = COLOR_SIDEBAR
					else
						WhitelistedPlayers[p.Name] = true
						pButton.Text = "  [WL] " .. p.DisplayName
						pButton.BackgroundColor3 = COLOR_NAVY
					end
				end)
			end
		end
	end

	Players.PlayerAdded:Connect(refreshWhiteListUI)
	Players.PlayerRemoving:Connect(refreshWhiteListUI)

	while true do
		if isWLPanelOpen then
			refreshWhiteListUI()
		end
		task.wait(2)
	end
end)

-- ESP PLAYER (SÓLO NOMBRE Y BARRA DE VIDA - SIN HIGHLIGHT/CHAMS)
local espEnabledStatus = false
task.spawn(function()
	local function removeESP(char)
		if not char then return end
		local head = char:FindFirstChild("Head")
		if head then 
			local b = head:FindFirstChild("EssentialPlayerESP") 
			if b then b:Destroy() end 
		end
	end

	local function applyESP(char)
		local plr = Players:GetPlayerFromCharacter(char)
		if not plr or plr == player or char == player.Character then 
			removeESP(char)
			return 
		end

		local head = char:FindFirstChild("Head")
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not head or not hum then return end

		local _, onScreen = Camera:WorldToViewportPoint(head.Position)
		local bill = head:FindFirstChild("EssentialPlayerESP")

		if not onScreen then
			if bill then bill.Enabled = false end
			return
		elseif bill then
			bill.Enabled = true
			return
		end

		removeESP(char)

		bill = Instance.new("BillboardGui")
		bill.Name = "EssentialPlayerESP"
		bill.Adornee = head
		bill.Size = UDim2.new(0, 160, 0, 35)
		bill.StudsOffset = Vector3.new(0, 2.8, 0)
		bill.AlwaysOnTop = true
		bill.MaxDistance = math.huge
		bill.Parent = head

		local isWL = WhitelistedPlayers[plr.Name] == true

		local name = Instance.new("TextLabel", bill)
		name.Size = UDim2.new(1, 0, 0, 16)
		name.BackgroundTransparency = 1
		name.Text = (isWL and "[WL] " or "") .. (plr.DisplayName ~= plr.Name and (plr.DisplayName .. " (@" .. plr.Name .. ")") or plr.Name)
		name.TextColor3 = isWL and Color3.fromRGB(255, 170, 40) or Color3.new(1, 1, 1)
		name.TextStrokeTransparency = 0
		name.Font = Enum.Font.GothamBold
		name.TextSize = 11

		local hpBg = Instance.new("Frame", bill)
		hpBg.Size = UDim2.new(1, -6, 0, 4)
		hpBg.Position = UDim2.new(0, 3, 0, 16)
		hpBg.BackgroundColor3 = COLOR_MAIN_BG
		Instance.new("UICorner", hpBg).CornerRadius = UDim.new(0, 3)

		local hpFill = Instance.new("Frame", hpBg)
		hpFill.Size = UDim2.new(1, 0, 1, 0)
		hpFill.BackgroundColor3 = Color3.fromRGB(80, 255, 100)
		Instance.new("UICorner", hpFill).CornerRadius = UDim.new(0, 3)

		local function updateHP()
			if hum and hum.Health > 0 then
				local r = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
				hpFill.Size = UDim2.new(r, 0, 1, 0)
			else
				removeESP(char)
			end
		end

		hum.HealthChanged:Connect(updateHP)
		updateHP()
	end

	RunService.Heartbeat:Connect(function()
		if espEnabledStatus then
			for _, p in ipairs(Players:GetPlayers()) do
				if p ~= player and p.Character then
					applyESP(p.Character)
				end
			end
		else
			for _, p in ipairs(Players:GetPlayers()) do
				if p ~= player and p.Character then
					removeESP(p.Character)
				end
			end
		end
	end)

	local function toggleESP()
		espEnabledStatus = not espEnabledStatus
		espOpt.SetState(espEnabledStatus)
		if not espEnabledStatus then
			for _, p in ipairs(Players:GetPlayers()) do
				if p ~= player and p.Character then
					removeESP(p.Character)
				end
			end
		end
	end

	espOpt.ToggleBtn.MouseButton1Click:Connect(toggleESP)
end)


-- CHAMS OPTIMIZADO (CON CAMBIO DE COLOR INDEPENDIENTE)
local charmsEnabled = false
task.spawn(function()
	local activeCharms = {}

	local function removeCharms(char)
		if activeCharms[char] then
			activeCharms[char]:Destroy()
			activeCharms[char] = nil
		end
	end

	local function applyCharms(char)
		if not char or char == player.Character then return end
		local color = charmsOpt.GetColor()
		
		local hl = activeCharms[char]
		if not hl or not hl.Parent then
			hl = Instance.new("Highlight")
			hl.Name = "EssentialChamsOpt"
			hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
			hl.Adornee = char
			hl.Parent = char
			activeCharms[char] = hl
		end

		hl.FillColor = color
		hl.FillTransparency = 0.4
		hl.OutlineColor = color
		hl.OutlineTransparency = 0
	end

	RunService.Heartbeat:Connect(function()
		if charmsEnabled then
			for _, p in ipairs(Players:GetPlayers()) do
				if p ~= player and p.Character then
					applyCharms(p.Character)
				end
			end
		else
			for char, _ in pairs(activeCharms) do
				removeCharms(char)
			end
		end
	end)

	local function toggleCharms()
		charmsEnabled = not charmsEnabled
		charmsOpt.SetState(charmsEnabled)
		if not charmsEnabled then
			for char, _ in pairs(activeCharms) do
				removeCharms(char)
			end
		end
	end

	charmsOpt.ToggleBtn.MouseButton1Click:Connect(toggleCharms)
end)


-- SKELETON ESP IMPLEMENTACIÓN
local skeletonEnabled = false
task.spawn(function()
	local skeletonDrawings = {}

	local SkeletonBones = {
		{"Head", "UpperTorso"},
		{"UpperTorso", "LowerTorso"},
		{"UpperTorso", "LeftUpperArm"},
		{"LeftUpperArm", "LeftLowerArm"},
		{"LeftLowerArm", "LeftHand"},
		{"UpperTorso", "RightUpperArm"},
		{"RightUpperArm", "RightLowerArm"},
		{"RightLowerArm", "RightHand"},
		{"LowerTorso", "LeftUpperLeg"},
		{"LeftUpperLeg", "LeftLowerLeg"},
		{"LeftLowerLeg", "LeftFoot"},
		{"LowerTorso", "RightUpperLeg"},
		{"RightUpperLeg", "RightLowerLeg"},
		{"RightLowerLeg", "RightFoot"},
		-- R6
		{"Head", "Torso"},
		{"Torso", "Left Arm"},
		{"Torso", "Right Arm"},
		{"Torso", "Left Leg"},
		{"Torso", "Right Leg"}
	}

	local function clearSkeletonDrawings()
		for _, lines in pairs(skeletonDrawings) do
			for _, line in ipairs(lines) do
				line.Visible = false
				line:Remove()
			end
		end
		skeletonDrawings = {}
	end

	RunService:BindToRenderStep("SkeletonESPUpdate", Enum.RenderPriority.Camera.Value + 1, function()
		if not skeletonEnabled then
			if next(skeletonDrawings) then clearSkeletonDrawings() end
			return
		end

		local currentColor = skeletonOpt.GetColor()

		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= player and p.Character then
				local char = p.Character
				if not skeletonDrawings[p] then
					skeletonDrawings[p] = {}
				end

				local lines = skeletonDrawings[p]
				local lineIdx = 1

				for _, bonePair in ipairs(SkeletonBones) do
					local partA = char:FindFirstChild(bonePair[1])
					local partB = char:FindFirstChild(bonePair[2])

					if partA and partB then
						local posA, visA = Camera:WorldToViewportPoint(partA.Position)
						local posB, visB = Camera:WorldToViewportPoint(partB.Position)

						if visA and visB and posA.Z > 0 and posB.Z > 0 then
							local line = lines[lineIdx]
							if not line then
								line = Drawing.new("Line")
								line.Thickness = 1.5
								lines[lineIdx] = line
							end

							line.From = Vector2.new(posA.X, posA.Y)
							line.To = Vector2.new(posB.X, posB.Y)
							line.Color = currentColor
							line.Visible = true
							lineIdx = lineIdx + 1
						end
					end
				end

				for i = lineIdx, #lines do
					lines[i].Visible = false
				end
			else
				if skeletonDrawings[p] then
					for _, line in ipairs(skeletonDrawings[p]) do
						line.Visible = false
						line:Remove()
					end
					skeletonDrawings[p] = nil
				end
			end
		end
	end)

	local function toggleSkeleton()
		skeletonEnabled = not skeletonEnabled
		skeletonOpt.SetState(skeletonEnabled)
		if not skeletonEnabled then
			clearSkeletonDrawings()
		end
	end

	skeletonOpt.ToggleBtn.MouseButton1Click:Connect(toggleSkeleton)
end)


-- ESP WEAPON INTEGRADO
local inventoryESPEnabled = false
task.spawn(function()
	local Items = ReplicatedStorage:WaitForChild("Items", 5)
	local WeaponRegistry = {}
	local PlayerBillboards = {}

	local RarityColors = {
		Common   = Color3.fromRGB(255, 255, 255),
		Uncommon = Color3.fromRGB(99, 255, 52),
		Rare     = Color3.fromRGB(51, 170, 255),
		Epic     = Color3.fromRGB(237, 44, 255),
		Legendary= Color3.fromRGB(255, 150, 0),
		Omega    = COLOR_NAVY_LIGHT,
	}

	local function registerItems(folder)
		if not folder then return end
		for _, tool in ipairs(folder:GetChildren()) do
			if tool:IsA("Tool") then
				local handle      = tool:FindFirstChild("Handle")
				local displayName = tool:GetAttribute("DisplayName") or tool.Name
				local itemId      = tool:GetAttribute("ItemId") or tool:GetAttribute("Id") or tool.Name
				local rarity      = tool:GetAttribute("RarityName") or "Common"
				local imageId     = tool:GetAttribute("ImageId") or "rbxassetid://7072725737"
				local key
				if handle then
					local mesh = handle:FindFirstChildOfClass("SpecialMesh")
					if mesh and mesh.MeshId ~= "" then
						key = mesh.MeshId .. (mesh.TextureId or "") .. "_RARITY_" .. rarity
					elseif handle:IsA("MeshPart") and handle.MeshId ~= "" then
						key = handle.MeshId .. (handle.TextureID or "") .. "_RARITY_" .. rarity
					end
				end
				if not key and itemId and itemId ~= "" and itemId ~= tool.Name then
					key = "ITEMID_" .. itemId .. "_RARITY_" .. rarity
				end
				if not key then
					key = "NAME_" .. displayName .. "_" .. tool.Name .. "_RARITY_" .. rarity
				end
				WeaponRegistry[key] = { Name = displayName, Rarity = rarity, ImageId = imageId, ToolName = tool.Name }
			end
		end
	end

	local function getItemKey(tool)
		local handle      = tool:FindFirstChild("Handle")
		local displayName = tool:GetAttribute("DisplayName") or tool.Name
		local itemId      = tool:GetAttribute("ItemId") or tool:GetAttribute("Id") or tool.Name
		local rarity      = tool:GetAttribute("RarityName") or "Common"
		if handle then
			local mesh = handle:FindFirstChildOfClass("SpecialMesh")
			if mesh and mesh.MeshId ~= "" then return mesh.MeshId .. (mesh.TextureId or "") .. "_RARITY_" .. rarity end
			if handle:IsA("MeshPart") and handle.MeshId ~= "" then return handle.MeshId .. (handle.TextureID or "") .. "_RARITY_" .. rarity end
		end
		if itemId and itemId ~= "" and itemId ~= tool.Name then return "ITEMID_" .. itemId .. "_RARITY_" .. rarity end
		return "NAME_" .. displayName .. "_" .. tool.Name .. "_RARITY_" .. rarity
	end

	local function getWeaponInfo(tool)
		if not tool or not tool:IsA("Tool") then return nil end
		return WeaponRegistry[getItemKey(tool)]
	end

	local function createBillboardForPlayer(targetPlayer)
		if not inventoryESPEnabled or targetPlayer == player then return end
		local char = targetPlayer.Character
		if not char then return end
		local root = char:FindFirstChild("HumanoidRootPart")
		if not root then return end
		
		if PlayerBillboards[targetPlayer] then
			PlayerBillboards[targetPlayer]:Destroy()
			PlayerBillboards[targetPlayer] = nil
		end

		local gui = Instance.new("BillboardGui")
		gui.Name = "WeaponESP_GUI"
		gui.Adornee      = root
		gui.Size         = UDim2.new(0, 70, 0, 16)
		gui.StudsOffset = Vector3.new(0, -5, 0)
		gui.AlwaysOnTop = true
		gui.Parent      = char

		local layout = Instance.new("UIListLayout", gui)
		layout.FillDirection         = Enum.FillDirection.Horizontal
		layout.SortOrder             = Enum.SortOrder.LayoutOrder
		layout.Padding               = UDim.new(0, 3)
		layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

		local function updateWeapons()
			for _, child in ipairs(gui:GetChildren()) do
				if child:IsA("ImageLabel") then
					child:Destroy()
				end
			end

			local tools = {}
			for _, bag in ipairs({ "Backpack", "StarterGear", "StarterPack" }) do
				local b = targetPlayer:FindFirstChild(bag)
				if b then
					for _, t in ipairs(b:GetChildren()) do
						if t:IsA("Tool") and t.Name ~= "Fists" then table.insert(tools, t) end
					end
				end
			end
			for _, t in ipairs(char:GetChildren()) do
				if t:IsA("Tool") and t.Name ~= "Fists" then table.insert(tools, t) end
			end

			for _, tool in ipairs(tools) do
				local info = getWeaponInfo(tool)
				if info then
					local img = Instance.new("ImageLabel", gui)
					img.Size                             = UDim2.new(0, 15, 0, 15)
					img.BackgroundTransparency = 0.3
					img.BackgroundColor3         = COLOR_SIDEBAR
					img.Image                    = info.ImageId
					Instance.new("UICorner", img).CornerRadius = UDim.new(0, 8)
					local stroke = Instance.new("UIStroke", img)
					stroke.Color     = RarityColors[info.Rarity] or Color3.new(1, 1, 1)
					stroke.Thickness = 1.5
				end
			end
		end

		updateWeapons()

		local backpack = targetPlayer:FindFirstChild("Backpack")
		if backpack then
			backpack.ChildAdded:Connect(updateWeapons)
			backpack.ChildRemoved:Connect(updateWeapons)
		end
		char.ChildAdded:Connect(function(c) if c:IsA("Tool") then updateWeapons() end end)
		char.ChildRemoved:Connect(function(c) if c:IsA("Tool") then updateWeapons() end end)

		PlayerBillboards[targetPlayer] = gui
	end

	RunService.Heartbeat:Connect(function()
		if inventoryESPEnabled then
			for p, gui in pairs(PlayerBillboards) do
				if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
					local _, onScreen = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
					gui.Enabled = onScreen
				end
			end
		end
	end)

	local function setupWeaponESPPlayer(targetPlayer)
		if targetPlayer == player then return end
		if targetPlayer.Character then
			task.spawn(function()
				createBillboardForPlayer(targetPlayer)
			end)
		end
		targetPlayer.CharacterAdded:Connect(function(newChar)
			task.wait(0.5)
			if inventoryESPEnabled then
				createBillboardForPlayer(targetPlayer)
			end
		end)
	end

	Players.PlayerAdded:Connect(setupWeaponESPPlayer)
	Players.PlayerRemoving:Connect(function(targetPlayer)
		if PlayerBillboards[targetPlayer] then
			PlayerBillboards[targetPlayer]:Destroy()
			PlayerBillboards[targetPlayer] = nil
		end
	end)

	if Items then
		for _, folderName in ipairs({ "gun", "melee", "throwable", "consumable", "farming", "misc", "rod", "fish" }) do
			local folder = Items:FindFirstChild(folderName)
			if folder then registerItems(folder) end
		end
	end

	for _, p in ipairs(Players:GetPlayers()) do
		setupWeaponESPPlayer(p)
	end

	local function toggleWeaponESP()
		inventoryESPEnabled = not inventoryESPEnabled
		espWeaponOpt.SetState(inventoryESPEnabled)
		if inventoryESPEnabled then
			for _, p in ipairs(Players:GetPlayers()) do
				createBillboardForPlayer(p)
			end
		else
			for p, gui in pairs(PlayerBillboards) do
				if gui then gui:Destroy() end
				PlayerBillboards[p] = nil
			end
		end
	end

	espWeaponOpt.ToggleBtn.MouseButton1Click:Connect(toggleWeaponESP)
end)

-- DROPPED ITEMS ESP
local dropItemsEnabled = false
task.spawn(function()
	local activeDropBillboards = {}
	local _itemRarityCache = {}

	local RarityColors = {
		Rare      = Color3.fromRGB(60, 180, 255),
		Epic      = COLOR_NAVY_LIGHT,
		Legendary = Color3.fromRGB(255, 165, 0),
		Omega     = Color3.fromRGB(255, 40, 70),
	}

	local ItemsFolder = ReplicatedStorage:WaitForChild("Items", 5)

	local function _buildRarityCache()
		_itemRarityCache = {}
		if not ItemsFolder then return end
		for _, folder in ipairs(ItemsFolder:GetChildren()) do
			if folder:IsA("Folder") then
				for _, item in ipairs(folder:GetChildren()) do
					_itemRarityCache[item.Name] = item:GetAttribute("RarityName") or "Common"
				end
			end
		end
	end
	_buildRarityCache()

	local function getRarityForDrop(model)
		return _itemRarityCache[model.Name] or "Common"
	end

	local function clearAllDropESP()
		for model, data in pairs(activeDropBillboards) do
			if data.gui then data.gui:Destroy() end
			if data.highlight then data.highlight:Destroy() end
		end
		activeDropBillboards = {}
	end

	local function createModernDropUI(model)
		if model.Name == "Money" or model.Name:lower():find("money") or model.Name:lower():find("cash") then
			return
		end

		local rarity = getRarityForDrop(model)
		if rarity == "Common" or rarity == "Uncommon" then
			return
		end

		local primaryPart = model:IsA("BasePart") and model or model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
		if not primaryPart then return end

		local color = RarityColors[rarity] or Color3.fromRGB(255, 255, 255)
		local stackAmt = model:GetAttribute("Amount") or model:GetAttribute("Stack") or 1

		local gui = Instance.new("BillboardGui")
		gui.Name = "ModernDropESP"
		gui.Adornee = primaryPart
		gui.Size = UDim2.new(0, 120, 0, 22)
		gui.StudsOffset = Vector3.new(0, 2, 0)
		gui.AlwaysOnTop = true
		gui.MaxDistance = math.huge
		gui.Parent = model

		local nameLabel = Instance.new("TextLabel", gui)
		nameLabel.Size = UDim2.new(1, 0, 1, 0)
		nameLabel.BackgroundTransparency = 1
		nameLabel.Font = Enum.Font.GothamBold
		nameLabel.Text = (stackAmt > 1 and ("x" .. tostring(stackAmt) .. " ") or "") .. model.Name
		nameLabel.TextColor3 = color
		nameLabel.TextStrokeTransparency = 0.2
		nameLabel.TextStrokeColor3 = Color3.fromRGB(10, 10, 10)
		nameLabel.TextSize = 11

		local highlight = Instance.new("Highlight")
		highlight.Name = "DropChams3D"
		highlight.Adornee = model
		highlight.FillColor = color
		highlight.FillTransparency = 0.6
		highlight.OutlineColor = color
		highlight.OutlineTransparency = 0
		highlight.Parent = model

		activeDropBillboards[model] = {
			gui = gui,
			highlight = highlight,
			part = primaryPart
		}
	end

	local function updateDropESP()
		if not dropItemsEnabled then return end

		local droppedFolder = workspace:FindFirstChild("DroppedItems") or workspace:FindFirstChild("Drops") or workspace

		for model, data in pairs(activeDropBillboards) do
			if not model or not model.Parent then
				if data.gui then data.gui:Destroy() end
				if data.highlight then data.highlight:Destroy() end
				activeDropBillboards[model] = nil
			else
				local _, onScreen = Camera:WorldToViewportPoint(data.part.Position)
				data.gui.Enabled = onScreen
			end
		end

		for _, model in ipairs(droppedFolder:GetChildren()) do
			if (model:IsA("Model") or model:IsA("BasePart")) and not activeDropBillboards[model] then
				createModernDropUI(model)
			end
		end
	end

	RunService.Heartbeat:Connect(function()
		if dropItemsEnabled then
			updateDropESP()
		end
	end)

	local function toggleDropItems()
		dropItemsEnabled = not dropItemsEnabled
		dropItemsOpt.SetState(dropItemsEnabled)
		if not dropItemsEnabled then
			clearAllDropESP()
		end
	end

	dropItemsOpt.ToggleBtn.MouseButton1Click:Connect(toggleDropItems)
end)

-- NO RECOIL
local noRecoilEnabled = false
task.spawn(function()
	local function applyNoRecoil(tool)
		if not tool:IsA("Tool") then return end
		
		for _, desc in ipairs(tool:GetDescendants()) do
			if desc:IsA("NumberValue") or desc:IsA("Vector3Value") then
				local name = desc.Name:lower()
				if name:find("recoil") or name:find("spread") or name:find("kick") or name:find("shake") then
					desc.Value = 0
				end
			end
		end

		if tool:GetAttributes() then
			for attrName, _ in pairs(tool:GetAttributes()) do
				local name = attrName:lower()
				if name:find("recoil") or name:find("spread") then
					tool:SetAttribute(attrName, 0)
				end
			end
		end
	end

	local function hookCharacter(char)
		char.ChildAdded:Connect(function(child)
			if noRecoilEnabled and child:IsA("Tool") then
				applyNoRecoil(child)
			end
		end)
		for _, child in ipairs(char:GetChildren()) do
			if noRecoilEnabled and child:IsA("Tool") then
				applyNoRecoil(child)
			end
		end
	end

	if player.Character then
		hookCharacter(player.Character)
	end
	player.CharacterAdded:Connect(hookCharacter)

	if player:FindFirstChild("Backpack") then
		player.Backpack.ChildAdded:Connect(function(child)
			if noRecoilEnabled and child:IsA("Tool") then
				applyNoRecoil(child)
			end
		end)
		for _, child in ipairs(player.Backpack:GetChildren()) do
			if noRecoilEnabled and child:IsA("Tool") then
				applyNoRecoil(child)
			end
		end
	end

	RunService.Heartbeat:Connect(function()
		if noRecoilEnabled then
			pcall(function()
				local char = player.Character
				if char then
					for _, tool in ipairs(char:GetChildren()) do
						if tool:IsA("Tool") then
							applyNoRecoil(tool)
						end
					end
				end
				local backpack = player:FindFirstChild("Backpack")
				if backpack then
					for _, tool in ipairs(backpack:GetChildren()) do
						if tool:IsA("Tool") then
							applyNoRecoil(tool)
						end
					end
				end
			end)
		end
	end)

	noRecoilButton.MouseButton1Click:Connect(function()
		noRecoilEnabled = not noRecoilEnabled
		setButtonState(noRecoilButton, noRecoilEnabled)
		if noRecoilEnabled then
			pcall(function()
				local char = player.Character
				if char then
					for _, tool in ipairs(char:GetChildren()) do
						if tool:IsA("Tool") then applyNoRecoil(tool) end
					end
				end
				local backpack = player:FindFirstChild("Backpack")
				if backpack then
					for _, tool in ipairs(backpack:GetChildren()) do
						if tool:IsA("Tool") then applyNoRecoil(tool) end
					end
				end
			end)
		end
	end)
end)

-- AIMLOCK
local AimlockEnabled = false
local AimModes = {"Ultrasuave", "Suave", "Mediano", "Fuerte"}
local CurrentModeIndex = 4
local CurrentKeybind = Enum.KeyCode.F
local CurrentInputType = Enum.UserInputType.Keyboard

task.spawn(function()
	local AimlockActive = false
	local LockedTargetChar = nil
	local isBindingKey = false

	local SmoothnessValues = {
		["Ultrasuave"] = 0.05,
		["Suave"]      = 0.15,
		["Mediano"]    = 0.40,
		["Fuerte"]     = 1.0
	}

	local FOVCircle = Drawing.new("Circle")
	FOVCircle.Thickness = 1.5
	FOVCircle.Color = COLOR_NAVY_LIGHT
	FOVCircle.Transparency = 0.5
	FOVCircle.Filled = false
	FOVCircle.Visible = true

	local isTKActive = false

	local function restoreCamera()
		Camera.CameraType = Enum.CameraType.Custom
		if player.Character then
			local humanoid = player.Character:FindFirstChild("Humanoid")
			if humanoid then
				Camera.CameraSubject = humanoid
			end
		end
		if _G.SpectateConnection then
			_G.SpectateConnection:Disconnect()
			_G.SpectateConnection = nil
		end
	end

	local function triggerAutoGlitch()
		if isTKActive then return end
		isTKActive = true
		restoreCamera()
		task.delay(1, function()
			if isTKActive then
				restoreCamera()
				isTKActive = false
			end
		end)
	end

	local function monitorCharacter(char)
		local humanoid = char:WaitForChild("Humanoid", 10)
		if humanoid then
			humanoid:GetPropertyChangedSignal("SeatPart"):Connect(function()
				if humanoid.SeatPart then
					triggerAutoGlitch()
				end
			end)
		end
	end

	if player.Character then
		monitorCharacter(player.Character)
	end
	player.CharacterAdded:Connect(monitorCharacter)

	local function IsAlive(char)
		local h = char and char:FindFirstChildOfClass("Humanoid")
		return h and h.Health > 0
	end

	local function GetAccurateTargetPosition(char)
		if not char then return nil, "NONE" end
		local head = char:FindFirstChild("Head")
		if head and head:IsA("BasePart") then
			return head.Position, "HEAD"
		end
		local upperTorso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
		if upperTorso then
			return upperTorso.Position, "TORSO"
		end
		return nil, "NONE"
	end

	local function GetClosestTarget()
		local closestChar, distMin = nil, math.huge
		local center = Camera.ViewportSize / 2
		
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= player and not WhitelistedPlayers[p.Name] and p.Character and IsAlive(p.Character) then
				local targetPos = GetAccurateTargetPosition(p.Character)
				if targetPos then
					local screenPos, onScreen = Camera:WorldToViewportPoint(targetPos)
					if onScreen then
						local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
						if dist < distMin and dist <= globalFOVRadius then
							distMin = dist
							closestChar = p.Character
						end
					end
				end
			end
		end
		return closestChar
	end

	aimlockButton.MouseButton1Click:Connect(function()
		AimlockEnabled = not AimlockEnabled
		setButtonState(aimlockButton, AimlockEnabled)
		if not AimlockEnabled then
			AimlockActive = false
			LockedTargetChar = nil
			aimlockHUD.Visible = false
		end
	end)

	aimSmoothButton.MouseButton1Click:Connect(function()
		CurrentModeIndex = CurrentModeIndex + 1
		if CurrentModeIndex > #AimModes then
			CurrentModeIndex = 1
		end
		local currentModeName = AimModes[CurrentModeIndex]
		aimSmoothButton.Text = "  Aim Mode: " .. currentModeName
	end)

	aimlockKeyButton.MouseButton1Click:Connect(function()
		if isBindingKey then return end
		isBindingKey = true
		aimlockKeyButton.Text = "  Keybind: [...]"
		aimlockKeyButton.TextColor3 = Color3.fromRGB(255, 180, 50)
		
		local connection
		connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
			if input.UserInputType == Enum.UserInputType.Keyboard then
				CurrentKeybind = input.KeyCode
				CurrentInputType = Enum.UserInputType.Keyboard
				isBindingKey = false
				aimlockKeyButton.Text = "  Keybind: [" .. input.KeyCode.Name .. "]"
				aimlockKeyButton.TextColor3 = COLOR_TEXT
				connection:Disconnect()
			elseif input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.MouseButton3 then
				CurrentKeybind = input.UserInputType
				CurrentInputType = Enum.UserInputType.MouseButton1
				isBindingKey = false
				local name = "Mouse1"
				if input.UserInputType == Enum.UserInputType.MouseButton2 then name = "Mouse2"
				elseif input.UserInputType == Enum.UserInputType.MouseButton3 then name = "Mouse3" end
				aimlockKeyButton.Text = "  Keybind: [" .. name .. "]"
				aimlockKeyButton.TextColor3 = COLOR_TEXT
				connection:Disconnect()
			elseif input.UserInputType == Enum.UserInputType.Gamepad1 then
				CurrentKeybind = input.KeyCode
				CurrentInputType = Enum.UserInputType.Gamepad1
				isBindingKey = false
				aimlockKeyButton.Text = "  Pad: [" .. input.KeyCode.Name .. "]"
				aimlockKeyButton.TextColor3 = COLOR_TEXT
				connection:Disconnect()
			end
		end)
	end)

	RunService:BindToRenderStep("RigidAimlockSystem", Enum.RenderPriority.Camera.Value + 100, function()
		FOVCircle.Radius = globalFOVRadius
		FOVCircle.Position = Camera.ViewportSize / 2
		FOVCircle.Visible = true

		local isExecutingAim = (AimlockEnabled and AimlockActive)

		if isExecutingAim then
			if not LockedTargetChar or not IsAlive(LockedTargetChar) then
				LockedTargetChar = GetClosestTarget()
			end

			local targetPlayer = LockedTargetChar and Players:GetPlayerFromCharacter(LockedTargetChar)
			if targetPlayer and WhitelistedPlayers[targetPlayer.Name] then
				LockedTargetChar = nil
			end

			if LockedTargetChar then
				local targetPos, partName = GetAccurateTargetPosition(LockedTargetChar)
				if targetPos then
					local currentPos = Camera.CFrame.Position
					local targetCFrame = CFrame.new(currentPos, targetPos)
					local modeName = AimModes[CurrentModeIndex]
					local smoothness = SmoothnessValues[modeName] or 1.0

					if smoothness >= 1.0 then
						Camera.CFrame = targetCFrame
					else
						Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, smoothness)
					end

					-- ACTUALIZAR HUD SUPERIOR
					aimlockHUD.Visible = true
					local targetPlrObj = Players:GetPlayerFromCharacter(LockedTargetChar)
					targetUserLabel.Text = "TARGET: " .. (targetPlrObj and targetPlrObj.Name:upper() or LockedTargetChar.Name:upper())
					targetPartLabel.Text = "PART: " .. partName
				end
			else
				aimlockHUD.Visible = false
			end
		else
			aimlockHUD.Visible = false
		end
	end)

	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed or isBindingKey then return end

		if AimlockEnabled then
			local triggered = false
			if CurrentInputType == Enum.UserInputType.Keyboard and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == CurrentKeybind then
				triggered = true
			elseif CurrentInputType == Enum.UserInputType.MouseButton1 and input.UserInputType == CurrentKeybind then
				triggered = true
			elseif CurrentInputType == Enum.UserInputType.Gamepad1 and input.UserInputType == Enum.UserInputType.Gamepad1 and input.KeyCode == CurrentKeybind then
				triggered = true
			end

			if triggered then
				LockedTargetChar = GetClosestTarget()
				if LockedTargetChar then
					AimlockActive = true
				end
			end
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		local released = false
		if CurrentInputType == Enum.UserInputType.Keyboard and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == CurrentKeybind then
			released = true
		elseif CurrentInputType == Enum.UserInputType.MouseButton1 and input.UserInputType == CurrentKeybind then
			released = true
		elseif CurrentInputType == Enum.UserInputType.Gamepad1 and input.UserInputType == Enum.UserInputType.Gamepad1 and input.KeyCode == CurrentKeybind then
			released = true
		end

		if released then
			AimlockActive = false
			LockedTargetChar = nil
			aimlockHUD.Visible = false
		end
	end)
end)


-- ==========================================
-- SISTEMA DE CONFIGURACIÓN (SAVE / AUTO-LOAD)
-- ==========================================
local fileName = "Essential_Config.json"

local function saveConfig()
	local configData = {
		AimlockEnabled = AimlockEnabled,
		CurrentModeIndex = CurrentModeIndex,
		GlobalFOVRadius = globalFOVRadius,
		NoRecoilEnabled = noRecoilEnabled,
		
		ESPPlayer = espEnabledStatus,
		Charms = charmsEnabled,
		CharmsColorIdx = charmsOpt.GetColorIndex(),
		Skeleton = skeletonEnabled,
		SkeletonColorIdx = skeletonOpt.GetColorIndex(),
		ESPWeapons = inventoryESPEnabled,
		ESPDrops = dropItemsEnabled,
		
		AimKeybindName = typeof(CurrentKeybind) == "EnumItem" and CurrentKeybind.Name or tostring(CurrentKeybind),
		MenuKeybindName = typeof(currentMenuKey) == "EnumItem" and currentMenuKey.Name or tostring(currentMenuKey)
	}

	local success, jsonStr = pcall(function()
		return HttpService:JSONEncode(configData)
	end)

	if success and writefile then
		pcall(function()
			writefile(fileName, jsonStr)
		end)
		saveConfigBtn.Text = "  ¡Guardado con Éxito!"
		task.delay(1.5, function()
			saveConfigBtn.Text = "  Guardar Configuración"
		end)
	end
end

local function loadConfig()
	if not readfile or not isfile or not isfile(fileName) then return end

	local success, result = pcall(function()
		return HttpService:JSONDecode(readfile(fileName))
	end)

	if success and type(result) == "table" then
		if result.AimlockEnabled ~= nil and result.AimlockEnabled ~= AimlockEnabled then
			AimlockEnabled = result.AimlockEnabled
			setButtonState(aimlockButton, AimlockEnabled)
		end

		if result.CurrentModeIndex then
			CurrentModeIndex = result.CurrentModeIndex
			aimSmoothButton.Text = "  Aim Mode: " .. AimModes[CurrentModeIndex]
		end

		if result.GlobalFOVRadius then
			globalFOVRadius = result.GlobalFOVRadius
			fovLabel.Text = "FOV: " .. globalFOVRadius
			local pos = math.clamp((globalFOVRadius - 10) / (5000 - 10), 0, 1)
			sliderLineFill.Size = UDim2.new(pos, 0, 1, 0)
			sliderButton.Position = UDim2.new(pos, -4, 0.5, -4)
		end

		if result.NoRecoilEnabled ~= nil and result.NoRecoilEnabled ~= noRecoilEnabled me
			noRecoilEnabled = result.NoRecoilEnabled
			setButtonState(noRecoilButton, noRecoilEnabled)
		end

		if result.ESPPlayer ~= nil and result.ESPPlayer ~= espEnabledStatus then
			espEnabledStatus = result.ESPPlayer
			espOpt.SetState(espEnabledStatus)
		end

		if result.Charms ~= nil and result.Charms ~= charmsEnabled then
			charmsEnabled = result.Charms
			charmsOpt.SetState(charmsEnabled)
		end
		if result.CharmsColorIdx then
			charmsOpt.SetColorIndex(result.CharmsColorIdx)
		end

		if result.Skeleton ~= nil and result.Skeleton ~= skeletonEnabled then
			skeletonEnabled = result.Skeleton
			skeletonOpt.SetState(skeletonEnabled)
		end
		if result.SkeletonColorIdx then
			skeletonOpt.SetColorIndex(result.SkeletonColorIdx)
		end

		if result.ESPWeapons ~= nil and result.ESPWeapons ~= inventoryESPEnabled then
			inventoryESPEnabled = result.ESPWeapons
			espWeaponOpt.SetState(inventoryESPEnabled)
		end

		if result.ESPDrops ~= nil and result.ESPDrops ~= dropItemsEnabled then
			dropItemsEnabled = result.ESPDrops
			dropItemsOpt.SetState(dropItemsEnabled)
		end

		if result.AimKeybindName then
			pcall(function()
				CurrentKeybind = Enum.KeyCode[result.AimKeybindName] or Enum.UserInputType[result.AimKeybindName] or Enum.KeyCode.F
				aimlockKeyButton.Text = "  Keybind: [" .. result.AimKeybindName .. "]"
			end)
		end

		if result.MenuKeybindName then
			pcall(function()
				currentMenuKey = Enum.KeyCode[result.MenuKeybindName] or Enum.KeyCode.RightControl
				menuKeyBtn.Text = "  Keybind Menú: [" .. result.MenuKeybindName .. "]"
			end)
		end
	end
end

saveConfigBtn.MouseButton1Click:Connect(saveConfig)

-- AUTOCARGAR AL EJECUTAR EL SCRIPT
task.spawn(function()
	task.wait(0.5)
	loadConfig()
end)
