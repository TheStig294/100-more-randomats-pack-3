net.Receive("WhatItsLike2RandomatHideNames", function()
    hook.Add("TTTTargetIDPlayerName", "WhatItsLikeRandomatHideNames", function(ply, client, text, clr) return false, clr end)
end)

net.Receive("WhatItsLike2RandomatEnd", function()
    hook.Remove("TTTTargetIDPlayerName", "WhatItsLikeRandomatHideNames")
end)