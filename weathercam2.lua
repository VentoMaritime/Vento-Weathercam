Lua
obs = obslua

path = ""
interval = 900
timer_active = false

function script_description()
    return "Tager automatisk et screenshot af det aktuelt valgte billede i OBS med et fast interval."
end

function take_screenshot()
    local source = obs.obs_frontend_get_current_scene()
    if source ~= nil then
        obs.obs_frontend_take_screenshot()
        obs.obs_source_release(source)
    end
end

function script_properties()
    local props = obs.obs_properties_create()
    obs.obs_properties_add_int(props, "interval", "Interval i sekunder", 10, 86400, 1)
    obs.obs_properties_add_button(props, "test_btn", "Tag screenshot nu", take_screenshot)
    return props
end

function script_update(settings)
    interval = obs.obs_data_get_int(settings, "interval")
    obs.timer_remove(take_screenshot)
    if interval > 0 then
        obs.timer_add(take_screenshot, interval * 1000)
    end
end

function script_unload()
    obs.timer_remove(take_screenshot)
end