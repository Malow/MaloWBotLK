mb_BossModule_registeredModules = {}
function mb_BossModule_RegisterModule(name, onLoadFunc)
    mb_BossModule_registeredModules[name] = onLoadFunc
end

function mb_BossModule_LoadModule(name)
    if mb_BossModule_registeredModules[name] == nil then
        mb_SayRaid("No BossModule registered with the name: " .. tostring(name))
        return
    end

    mb_BossModule_registeredModules[name]()
    mb_SayRaid("Loaded " .. name .. " BossModule")
end

-- Return false to execute normal class-code, return true to prevent class-code
function mb_BossModule_PreOnUpdate()
    return false
end