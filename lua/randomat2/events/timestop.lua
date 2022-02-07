local EVENT = {}
EVENT.Title = "Time Stop"
EVENT.Description = "Freezes everything but players for 60 seconds"
EVENT.id = "timestop"
EVENT.IsEnabled = false

hook.Add("PreRegisterSWEP", "TimeStopRandomatGetStopFunction", function(swep, class)
    if class == "weapon_ttt_timestop" then
        function TimeStopRandomatStopTime()
            swep:StopTime()
        end

        function TimeStopRandomatStartTime()
            swep:StartTime()
            swep:OnRemove()
        end

        if not file.Exists("randomat/timestop_disabled.txt", "DATA") then
            RunConsoleCommand("ttt_randomat_timestop", "0")
            file.Write("randomat/timestop_disabled.txt", "")
        end
    end
end)

function EVENT:Begin()
    TimeStopRandomat = true
    initialTimeStopTime = GetConVar("ttt_timestop_time"):GetFloat()
    initialTimeStopRange = GetConVar("ttt_timestop_range"):GetFloat()
    initialTimeStopRandom = GetConVar("ttt_timestop_random"):GetFloat()
    initialTimeStopChance = GetConVar("ttt_timestop_random_chance"):GetFloat()
    GetConVar("ttt_timestop_time"):SetFloat(GetConVar("ttt_roundtime_minutes"):GetFloat() * 600)
    GetConVar("ttt_timestop_range"):SetFloat(-1)
    GetConVar("ttt_timestop_random"):SetFloat(1)
    GetConVar("ttt_timestop_random_chance"):SetFloat(0)
    TimeStopRandomatStopTime()

    timer.Simple(3, function()
        for k, v in pairs(player.GetAll()) do
            v:ScreenFade(SCREENFADE.OUT, Color(0, 0, 0, 200), 1, GetConVar("ttt_roundtime_minutes"):GetFloat() * 600)

            timer.Simple(1, function()
                v:ScreenFade(SCREENFADE.STAYOUT, Color(0, 0, 0, 200), 1, GetConVar("ttt_roundtime_minutes"):GetFloat() * 600)
            end)
        end
    end)

    timer.Simple(60, function()
        if TimeStopRandomat then
            self:End()
        end
    end)
end

function EVENT:End()
    if TimeStopRandomat then
        GetConVar("ttt_timestop_time"):SetFloat(initialTimeStopTime)
        GetConVar("ttt_timestop_range"):SetFloat(initialTimeStopRange)
        GetConVar("ttt_timestop_random"):SetFloat(initialTimeStopRandom)
        GetConVar("ttt_timestop_random_chance"):SetFloat(initialTimeStopChance)
        TimeStopRandomatStartTime()

        for k, v in pairs(player.GetAll()) do
            timer.Simple(1, function()
                v:ScreenFade(SCREENFADE.PURGE, Color(0, 0, 0, 0), 0, 0)
            end)
        end

        TimeStopRandomat = false
    end
end

function EVENT:Condition()
    return weapons.Get("weapon_ttt_timestop") ~= nil
end

Randomat:register(EVENT)