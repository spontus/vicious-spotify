local io = { popen = io.popen, input = io.input }
local setmetatable = setmetatable
local string = { gmatch = string.gmatch }

-- Spotify: Current playing song from spotify (Linux Preview)
module("vicious.widgets.spotify")


local function worker(format, warg)
    local spotify  = {
        ["{State}"]  = "N/A",
        ["{Artist}"] = "N/A",
        ["{Title}"]  = "N/A",
        ["{Album}"]  = "N/A",
    }

    local tmp_file = '/tmp/vicious-spotify'
    io.popen('/bin/bash -c "exec /usr/bin/qdbus org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get org.mpris.MediaPlayer2.Player PlaybackStatus " > ' .. tmp_file):close()
    local tmp = io.input(tmp_file)
    local state = tmp:read("*l")
    tmp:close()
    if state == 'Playing' then
	spotify["{State}"] = 'Playing'
	local metadata = io.popen('/bin/bash -c "exec /usr/bin/qdbus org.mpris.MediaPlayer2.spotify / org.freedesktop.MediaPlayer2.GetMetadata"')
	for line in metadata:lines() do
	  for k, v in string.gmatch(line,"xesam:(%w+):(.*)") do
	    if	   k == "album"  then spotify["{Album}"]  = v
	    elseif k == "artist" then spotify["{Artist}"] = v
	    elseif k == "title"  then spotify["{Title}"]  = v
	    end
	  end
       end
       metadata:close()
    else
       spotify["{State}"] = 'Paused'
    end
    return spotify
end

setmetatable(_M, { __call = function(_, ...) return worker(...) end })
