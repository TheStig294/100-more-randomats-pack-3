net.Receive("RdmtSpecDobbeessBegin", function()
    hook.Add("Think", "RdmtSpecDobbeesThink", function()
        for _, e in ipairs(ents.GetAll()) do
            if e:GetNWBool("RdmtSpecDobbees", false) then
                e:SetNotSolid(true)
            end
        end
    end)
end)

net.Receive("RdmtSpecDobbeesEnd", function()
    hook.Remove("Think", "RdmtSpecDobbeesThink")
end)