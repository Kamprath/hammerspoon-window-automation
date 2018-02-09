return function(event, params)
    local notification = hs.notify.new({
        title = params.title or "URL Message",
        informativeText = params.message
    })

    -- set notification's image if an 'image' parameter is provided
    if params.image ~= nil then
        local path = hs.configdir .. '/images/' .. params.image
        local image = hs.image.imageFromPath(path)

        if image ~= nil then
            notification:contentImage(image)
        end
    end

    -- play system sound if 'sound' parameter is provided
    if params.sound ~= nil then
        hs.sound.getByName(params.sound):play()
    end

    notification:send()
end