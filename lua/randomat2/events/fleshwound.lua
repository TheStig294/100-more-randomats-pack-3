local EVENT = {}
EVENT.Title = "It's just a flesh wound."
EVENT.Description = "Everyone has a flesh wound"
EVENT.id = "fleshwound"

function EVENT:Begin()
    for i, ply in pairs(self:GetAlivePlayers()) do
        timer.Simple(0.1, function()
            ply:GiveEquipmentItem(tonumber(GetEquipmentItem(ROLE_TRAITOR, EQUIP_FLSHWND).id))

            if ply:HasEquipmentItem(EQUIP_FLSHWND) then
                if ply.flshwnd == false then
                    ply:ChatPrint("You have been given a Flesh Wound. Upon reaching 1 HP you will survive for 5 seconds")
                end

                ply.flshwnd = true
                ply.flshwndtimer = true
            end
        end)
    end
end

function EVENT:Condition()
    return isnumber(EQUIP_FLSHWND)
end

Randomat:register(EVENT)