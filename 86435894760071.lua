-- Cook An Animal

getgenv().autofarm = true -- auto get the stuff
getgenv().autosell = false -- set true if u want to sell thingy

local lplr = game.Players.LocalPlayer

local getPrompt = function(parent: Instance)
    for index, value in parent:GetDescendants() do
        if value:IsA('ProximityPrompt') then
            return value
        end
    end

    return nil
end

local getBestAnimal = function()
    for _, value in workspace.Animals:GetChildren() do
        if value:GetAttribute('Zone') ~= 'Farm' and value.Name ~= 'Carried' then
            return value
        end
    end

    return nil
end

local tab = {}
local remote2 = game:GetService("ReplicatedStorage"):WaitForChild("FrameworkRemotes"):WaitForChild("Inventory/Sell")
local remote = game:GetService("ReplicatedStorage"):WaitForChild("FrameworkRemotes"):WaitForChild("Table/ServeBest")

local shopPos = Vector3.new(19, 4, -44)
local origPos = Vector3.new(37, 4, -143)

while (getgenv().autofarm) do
    task.wait(0.1)
    remote:FireServer()

    for _, value in workspace.Animals:GetChildren() do
        if #value:GetChildren() == 0 then
            value:Destroy()
        end
    end

    if getgenv().autosell then
        lplr.Character.PrimaryPart.CFrame = CFrame.new(shopPos)

        task.wait(0.3)

        table.clear(tab)
    
        for _, value in lplr.Backpack:GetChildren() do
            if value.Name == 'Bat' then continue end
            table.insert(tab, value)
        end

        if #tab > 0 then
            remote2:InvokeServer(tab)
            table.clear(tab)
        end

        task.wait(0.5)
    end

    local animal = getBestAnimal()

    if not animal then continue end

    local newPos = animal.PrimaryPart.Position

    lplr.Character.PrimaryPart.CFrame = CFrame.new(newPos)

    task.wait(0.3)
    local prompt = getPrompt(animal)
    
    if prompt then
        fireproximityprompt(prompt)
    end

    task.wait(0.2)
    lplr.Character.PrimaryPart.CFrame = CFrame.new(origPos)
end
