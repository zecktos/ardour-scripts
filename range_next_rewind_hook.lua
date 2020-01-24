ardour {
	["type"]    = "EditorHook",
	name        = "move Range and rewind",
	license     = "MIT",
	author      = "zecktos",
	description = [[moves the session range to the next marker and moves playhead to start triggerd by stoping playback]]
}

function signals ()
  s = LuaSignal.Set()
  s:add (
    {
      [LuaSignal.TransportStateChange] = true,
    }
  )
  return s
end

function factory ()
	return function ()
		if ( Session:transport_rolling ()) then
			-- not rolling, nothing to do.
			return
		end

		local pos = Session:transport_frame () -- current playhead position
		local loc = Session:locations () -- all marker locations

		local m = loc:first_mark_after (pos, false)

		if (m == -1) then
			-- no marker was found
			Session:goto_start ()
			return
		end
		
		local ran = loc:session_range_location () -- get session range
		ran:set_end (m, true, true, 0)
		ran:set_start (loc:first_mark_before (m, false), true, true, 0)
		Session:goto_start ()


	end
end
