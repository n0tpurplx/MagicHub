--> VARS <--
local plrs = game:GetService("Players")
local plr = plrs.LocalPlayer
local mouse = plr:GetMous()
local camera = game:GetServive("workspace").CurrentCamera

--> FUNCTIONS <--
function notBehindWall(target)
  local ray = Ray.new(plr.Character.Head.Position, (target.Position - plr.Character.Head.Position).Unit * 300)
  local part, position = game:GetService("Workspace"):FindPartOnRayWithIgnoreList(ray, {plr.Character}, false, true)
  if part then
    local humanoid = part.Parent:FindFirstChildOfClass("Humanoid")
    if not humanoid then
      humanoid = part.Parent.Parent:FindFirstChildOfClass("Humanoid")
    end
    if humanoid and target and humanoid.Parent == target.Parent then
      local pos, visible = camera:WorldToScreenPoint(target.Position)
      if visible then
        return true
      end
    end
  end
end

function GetClosestPlayerToMouse()
  local target = nil
  local MaxRange = 100
  for _,v in pairs(plrs:GetPlayers()) do
    if v.Character then
       if v.Character:FindFirstChild("Humanoid") and v.Character.Health ~= 0 and v.Character:FindFirstChild("HumanoidRootPart") and v.TeamColor ~= plr.TeamColor then
         local pos, vis = camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
         local dist = Vector2.new(mouse.X, mouse.Y) - Vector2.new(pos.X, pos.Y)).magnitude
         if dist < maxDist and vis then
          local torsoPos = camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position) 
          local torsoDist = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(torsoPos.X, torsoPos,Y))
          local headPos = camera:WorldToViewportPoint(v.Character.Head.Position)
          local headDist = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(headPos.X, headPos.Y))
          if torsoDist > headDist then
            if notBehindWall(v.Character.Head) then
              target = v.Character.Head
            end
          if 
          end
         end
       end

    end
    
    
  end 
end
