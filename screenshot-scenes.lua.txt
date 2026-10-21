Lua
obs = obslua

path = ""
prefix = ""
interval = 900
timer_active = false

function script_description()
    return "Tager automatisk screenshots med et fast tidsinterval."
end

function take_screenshot()
    local scenes = obs.obs_frontend_get_scene_names()
    if scenes ~= nil then
        for _, scene_name in ipairs(scenes) do
            local source = obs.obs_get_source_by_name(scene_name)
            if source ~= nil then
                obs.obs_frontend_take_source_screenshot(source)
                obs.obs_source_release(source)
            end
        end
    end
end

function timer_callback()
    take_screenshot()
end

function script_properties()
    local props = obs.obs_properties_create()
    obs.obs_properties_add_path(props, "path", "Path", obs.OBS_PATH_DIRECTORY, "", "")
    obs.obs_properties_add_text(props, "prefix", "Filename prefix", obs.OBS_TEXT_DEFAULT)
    obs.obs_properties_add_int(props, "interval", "Interval (sekunder)", 5, 86400, 1)
    obs.obs_properties_add_button(props, "go", "Tag screenshot nu", take_screenshot)
    return props
end

function script_update(settings)
    path = obs.obs_data_get_string(settings, "path")
    prefix = obs.obs_data_get_string(settings, "prefix")
    interval = obs.obs_data_get_int(settings, "interval")

    obs.timer_remove(timer_callback)
    if interval > 0 then
        obs.timer_add(timer_callback, interval * 1000)
    end
end

function script_unload()
    obs.timer_remove(timer_callback)
end