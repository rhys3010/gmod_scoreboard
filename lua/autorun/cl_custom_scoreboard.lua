--[[
* Custom Configurable Scoreboard
* @author Rhys Evans (http://rhysevans.xyz)
* @version 16/11/2017
]]

-- Split Scoreboard in teams
local TDM_SCOREBOARD = false

-- Derma modules
local Scoreboard = nil
local RedPlayerList = nil
local BluePlayerList = nil
local PlayerScrollPanel = nil
local PlayerList = nil

-- Color Constants
local COLOR_RED = Color(255, 51, 51, 200)
local COLOR_BLUE = Color(0, 102, 255, 200)
local COLOR_GREEN = Color(51, 255, 51, 200)

--[[
* Load Derma for title bar at top of scoreboard
]]
function createTitle()
  local TitlePanel = vgui.Create("DPanel", Scoreboard)
  TitlePanel:SetSize(Scoreboard:GetWide(), 50)
  TitlePanel:SetPos(0, 0)
  TitlePanel.Paint = function()
    draw.RoundedBox(0, 0, 0, TitlePanel:GetWide(), TitlePanel:GetTall(), Color(70, 70, 70, 200))
    draw.SimpleText(GetHostName(), "HudHintTextLarge", 10, 5, Color(255, 255, 255, 255))
    draw.SimpleText("Map: "..game.GetMap(), "HudHintTextLarge", 10, 25, Color(255, 255, 255, 255))
    draw.SimpleText("Players: "..table.Count(player.GetAll()).."/"..game.MaxPlayers(), "HudHintTextLarge", TitlePanel:GetWide() - 120, 15, Color(255, 255, 255, 255))
  end

  return TitlePanel
end


--[[
* Load Derma for team score panels
]]
function createScorePanel()

  -- Only Draw Team Scores if TDM is enabled
  local ScorePanel = vgui.Create("DPanel", Scoreboard)
  ScorePanel:SetSize(Scoreboard:GetWide()-100, 70)
  ScorePanel:SetPos(50, 70)
  ScorePanel.Paint = function()
    draw.RoundedBox(10, 0, 0, ScorePanel:GetWide()/2-50, ScorePanel:GetTall(), COLOR_RED)
    draw.SimpleText("RED", "DermaLarge", 10, 19, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
    draw.SimpleText(team.GetScore(1), "DermaLarge", ScorePanel:GetWide()/2 - 100, 19, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)

    draw.RoundedBox(10, ScorePanel:GetWide()/2 + 50, 0, ScorePanel:GetWide()/2 - 50, ScorePanel:GetTall(), COLOR_BLUE, TEXT_ALIGN_CENTER)
    draw.SimpleText("BLUE", "DermaLarge", ScorePanel:GetWide() - 10, 19, Color(255, 255, 255, 255),TEXT_ALIGN_RIGHT)
    draw.SimpleText(team.GetScore(2), "DermaLarge", ScorePanel:GetWide()/2 + 100, 19, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
  end
end

--[[
* Load Derma for player lists (team and single)
]]
function createPlayerList()

  PlayerScrollPanel = vgui.Create("DScrollPanel", Scoreboard)
  PlayerScrollPanel:SetSize(Scoreboard:GetWide(), Scoreboard:GetTall() - 20)
  PlayerScrollPanel:SetPos(0, 150)

  -- Split Scoreboard in two if TDM is enabled
  if(TDM_SCOREBOARD) then
    RedPlayerList = vgui.Create("DListLayout", PlayerScrollPanel)
    RedPlayerList:SetSize(PlayerScrollPanel:GetWide()/2-100, PlayerScrollPanel:GetTall())
    RedPlayerList:SetPos(50,0)
    RedPlayerList:MakeDroppable("PlayerPanel")
    RedPlayerList:DockPadding(0, 50, 0, 10)
    RedPlayerList.Paint = function()
      draw.RoundedBox(0, 0, 0, RedPlayerList:GetWide(), 40, Color(24, 24, 24, 255))
      draw.SimpleText("Player", "DermaDefaultBold", 52, 12, Color(255, 255, 255, 255))
      draw.SimpleText("Kills", "DermaDefaultBold", RedPlayerList:GetWide()-120, 12, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
      draw.SimpleText("Deaths", "DermaDefaultBold", RedPlayerList:GetWide()-70, 12, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
      draw.SimpleText("Ping", "DermaDefaultBold", RedPlayerList:GetWide()-20, 12, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
      draw.SimpleText(team.NumPlayers(1).." /16", "DermaDefaultBold", RedPlayerList:GetWide()/2, 12, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
      draw.RoundedBox(0, 0, 40, RedPlayerList:GetWide(), 10, COLOR_RED)
      draw.RoundedBox(0, 0, RedPlayerList:GetTall()-10, RedPlayerList:GetWide(), 10, COLOR_RED)
    end

    BluePlayerList = vgui.Create("DListLayout", PlayerScrollPanel)
    BluePlayerList:SetSize(PlayerScrollPanel:GetWide()/2-100, PlayerScrollPanel:GetTall())
    BluePlayerList:SetPos(PlayerScrollPanel:GetWide()/2+50, 0)
    BluePlayerList:MakeDroppable("PlayerPanel")
    BluePlayerList:DockPadding(0, 50, 0, 10)
    BluePlayerList.Paint = function()
      draw.RoundedBox(0, 0, 0, RedPlayerList:GetWide(), 40, Color(24, 24, 24, 255))
      draw.SimpleText("Player", "DermaDefaultBold", 52, 12, Color(255, 255, 255, 255))
      draw.SimpleText("Kills", "DermaDefaultBold", BluePlayerList:GetWide()-120, 12, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
      draw.SimpleText("Deaths", "DermaDefaultBold", BluePlayerList:GetWide()-70, 12, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
      draw.SimpleText("Ping", "DermaDefaultBold", BluePlayerList:GetWide()-20, 12, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
      draw.SimpleText(team.NumPlayers(2).." /16", "DermaDefaultBold", BluePlayerList:GetWide()/2, 12, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
      draw.RoundedBox(0, 0, 40, BluePlayerList:GetWide(), 10, COLOR_BLUE)
      draw.RoundedBox(0, 0, BluePlayerList:GetTall()-10, BluePlayerList:GetWide(), 10, COLOR_BLUE)
    end
  else
    PlayerList = vgui.Create("DListLayout", PlayerScrollPanel)
    PlayerList:SetSize(PlayerScrollPanel:GetWide()/2, PlayerScrollPanel:GetTall())
    PlayerList:SetPos(PlayerList:GetWide()/2, 0)
    PlayerList:MakeDroppable("PlayerPanel")
    PlayerList:DockPadding(0, 50, 0, 10)
    PlayerList.Paint = function()
      draw.RoundedBox(0, 0, 0, PlayerList:GetWide(), 40, Color(24, 24, 24, 255))
      draw.SimpleText("Player", "DermaDefaultBold", 52, 12, Color(255, 255, 255, 255))
      draw.SimpleText("Kills", "DermaDefaultBold", PlayerList:GetWide()-120, 12, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
      draw.SimpleText("Deaths", "DermaDefaultBold", PlayerList:GetWide()-70, 12, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
      draw.SimpleText("Ping", "DermaDefaultBold", PlayerList:GetWide()-20, 12, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
      draw.RoundedBox(0, 0, 40, PlayerList:GetWide(), 10, COLOR_GREEN)
      draw.RoundedBox(0, 0, PlayerList:GetTall()-10, PlayerList:GetWide(), 10, COLOR_GREEN)
    end

  end

end

--[[
* Load Derma for player entry
]]
function createPlayerPanel(ply, team)
  local PlayerPanel = nil

  if(!TDM_SCOREBOARD) then
    PlayerPanel = vgui.Create("DPanel", PlayerList)
    PlayerPanel:SetSize(PlayerList:GetWide(), 40)
    PlayerPanel:SetPos(0, 0)
    PlayerPanel.Paint = function()
      if(ply == LocalPlayer()) then
        draw.RoundedBox(0, PlayerPanel:GetWide() - PlayerList:GetWide(), 0, PlayerPanel:GetWide(), PlayerPanel:GetTall(), Color(111, 112, 109, 220))
      else
        draw.RoundedBox(0, 0, 0, PlayerPanel:GetWide(), PlayerPanel:GetTall(), Color(64, 65, 60, 220))
      end
      draw.RoundedBox(0, 0, 39, PlayerPanel:GetWide(), 10, Color(0, 0, 0, 100))

      draw.SimpleText(ply:GetName(), "DermaDefaultBold", 52, 12, Color(255, 255, 255))
      draw.SimpleText(ply:Ping(), "DermaDefaultBold", PlayerPanel:GetWide()-20, 12, Color(255, 255, 255), TEXT_ALIGN_CENTER)
      draw.SimpleText(ply:Deaths(), "DermaDefaultBold", PlayerPanel:GetWide()-70, 12, Color(255, 255, 255), TEXT_ALIGN_CENTER)
      draw.SimpleText(ply:Frags(), "DermaDefaultBold", PlayerPanel:GetWide()-120, 12, Color(255, 255, 255), TEXT_ALIGN_CENTER)

      if(!ply:Alive()) then
        draw.SimpleText("DEAD", "DermaDefaultBold", PlayerPanel:GetWide()/2, 12, Color(255, 0, 0, 200), TEXT_ALIGN_CENTER)
      end
    end
  end

  if(TDM_SCOREBOARD) then
    if team == 1 then
      PlayerPanel = vgui.Create("DPanel", RedPlayerList)
      PlayerPanel:SetSize(RedPlayerList:GetWide(), 40)
      PlayerPanel:SetPos(0,0)
      PlayerPanel.Paint = function()

        if(ply == LocalPlayer()) then
          draw.RoundedBox(0, PlayerPanel:GetWide() - BluePlayerList:GetWide(), 0, PlayerPanel:GetWide(), PlayerPanel:GetTall(), Color(111, 112, 109, 220))
        else
          draw.RoundedBox(0, 0, 0, PlayerPanel:GetWide(), PlayerPanel:GetTall(), Color(64, 65, 60, 220))
        end
        draw.RoundedBox(0, 0, 39, PlayerPanel:GetWide(), 10, Color(0, 0, 0, 100))

        draw.SimpleText(ply:GetName(), "DermaDefaultBold", 52, 12, Color(255, 255, 255))
        draw.SimpleText(ply:Ping(), "DermaDefaultBold", PlayerPanel:GetWide()-20, 12, Color(255, 255, 255), TEXT_ALIGN_CENTER)
        draw.SimpleText(ply:Deaths(), "DermaDefaultBold", PlayerPanel:GetWide()-70, 12, Color(255, 255, 255), TEXT_ALIGN_CENTER)
        draw.SimpleText(ply:Frags(), "DermaDefaultBold", PlayerPanel:GetWide()-120, 12, Color(255, 255, 255), TEXT_ALIGN_CENTER)

        if(!ply:Alive()) then
          draw.SimpleText("DEAD", "DermaDefaultBold", PlayerPanel:GetWide()/2, 12, Color(255, 0, 0, 200), TEXT_ALIGN_CENTER)
        end
      end
    end

    if team == 2 then
      PlayerPanel = vgui.Create("DPanel", BluePlayerList)
      PlayerPanel:SetSize(BluePlayerList:GetWide(), 40)
      PlayerPanel:SetPos(BluePlayerList:GetWide()/2, 0)
      PlayerPanel.Paint = function()

        if(ply == LocalPlayer()) then
          draw.RoundedBox(0, PlayerPanel:GetWide() - BluePlayerList:GetWide(), 0, PlayerPanel:GetWide(), PlayerPanel:GetTall(), Color(111, 112, 109, 220))
        else
          draw.RoundedBox(0, PlayerPanel:GetWide() - BluePlayerList:GetWide(), 0, PlayerPanel:GetWide(), PlayerPanel:GetTall(), Color(64, 65, 60, 220))
        end
        draw.RoundedBox(0, PlayerPanel:GetWide() - BluePlayerList:GetWide(), 39, PlayerPanel:GetWide(), 10, Color(0, 0, 0, 100))

        draw.SimpleText(ply:GetName(), "DermaDefaultBold", 52, 12, Color(255, 255, 255))
        draw.SimpleText(ply:Ping(), "DermaDefaultBold", PlayerPanel:GetWide()-20, 12, Color(255, 255, 255), TEXT_ALIGN_RIGHT)
        draw.SimpleText(ply:Deaths(), "DermaDefaultBold", PlayerPanel:GetWide()-70, 12, Color(255, 255, 255), TEXT_ALIGN_RIGHT)
        draw.SimpleText(ply:Frags(), "DermaDefaultBold", PlayerPanel:GetWide()-120, 12, Color(255, 255, 255), TEXT_ALIGN_RIGHT)

        if(!ply:Alive()) then
          draw.SimpleText("DEAD", "DermaDefaultBold", PlayerPanel:GetWide()/2, 12, Color(255, 0, 0, 200), TEXT_ALIGN_CENTER)
        end
      end
    end
  end

  if IsValid(PlayerPanel) then
    local PlayerAvatar = vgui.Create("AvatarImage", PlayerPanel)
    PlayerAvatar:SetSize(32, 32)
    PlayerAvatar:SetPos(10, 4)
    PlayerAvatar:SetPlayer(ply, 32)
  end
end

--[[
* Function to create and draw scoreboard
]]
function ShowScoreboard()
  -- Create scoreboard
  if !IsValid(Scoreboard) then
    Scoreboard = vgui.Create("DFrame")
    Scoreboard:SetSize(1500, 850)
    Scoreboard:Center()
    Scoreboard:SetTitle("")
    Scoreboard:SetDraggable(false)
    Scoreboard:ShowCloseButton(false)
    Scoreboard.Paint = function()
    end

    local TitlePanel = createTitle()
    -- Only Draw Team Scores if TDM is enabled
    if(TDM_SCOREBOARD) then
      createScorePanel()
    end

    createPlayerList()
  end

  -- Print names in order of teams
  if IsValid(Scoreboard) then
    if(TDM_SCOREBOARD) then
      RedPlayerList:Clear()
      BluePlayerList:Clear()
    else
      PlayerList:Clear()
    end
    local PLAYERS = player.GetAll()

    -- Sort table by Kills
    table.sort(PLAYERS, function(a, b) return a:Frags() > b:Frags() end)

    for k, v in pairs(PLAYERS) do
      if IsValid(v) then
        createPlayerPanel(v, v:Team())
      end
    end

    Scoreboard:Show()
    Scoreboard:MakePopup()
    Scoreboard:SetKeyboardInputEnabled(false)
  end

  -- Stop default scoreboard from opening
  return true
end

hook.Add("ScoreboardShow", "Open Scoreboard", ShowScoreboard)

--[[
* Hide scoreboard but keep it loaded
]]
function HideScoreboard()
  if IsValid(Scoreboard) then
    Scoreboard:Hide()
  end
end

hook.Add("ScoreboardHide", "Close Scoreboard", HideScoreboard)
