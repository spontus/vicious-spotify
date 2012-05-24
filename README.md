vicious-spotify
===============

Vicious-widget for awesome that displays the current playing song in Spotify (Linux Preview)


usage
-----
Just drop spotify.lua into the directory with the other vicious-widgets, example: /usr/share/awesome/lib/vicious/widgets/

Put this in your rc.lua

    spotifywidget = wibox.widget.textbox()
    
    vicious.register( spotifywidget, vicious.widgets.spotify, function ( widget, args)
        if args["{State}"] == 'Playing' then
            return '<span color="green">' .. args["{Artist}"] .. ' - ' .. args["{Title}"] .. '</span>'
        else
            return ''
        end
    end, 2)

Don't forget to add the widget to a wibox

    right_layout:add(spotifywidget)

