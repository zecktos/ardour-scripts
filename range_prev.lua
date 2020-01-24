ardour {
	["type"]    = "EditorAction",
	name        = "move Range to previous Marker",
	license     = "MIT",
	author      = "zecktos",
	description = [[moves the session range to previous marker]]
}

function signals ()
  s = LuaSignal.Set()
  s:add (
    {
      [LuaSignal.TransportStateChange] = true,
      [LuaSignal.SoloChanged] = true
    }
  )
  return s
end

function factory ()
	return function ()

		local pos = Session:transport_frame () -- current playhead position
		local loc = Session:locations () -- all marker locations

		local m = loc:first_mark_after (pos, false)
		
		if (m == -1) then
			return
		end

		m = loc:first_mark_before (m, false)

		local ms = loc:first_mark_before (m, false)

		if (ms == -1) then
			return
		end

		local ran = loc:session_range_location () -- get session range
		ran:set_start(ms, true, true, 0)
		ran:set_end (m, true, true, 0)
		Session:goto_start ()

	end
end
