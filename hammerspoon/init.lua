hs.autoLaunch(true)
hs.loadSpoon("EmmyLua") -- writes lua_ls annotations for hs.* (see .luarc.json)

-- Notes vault sync (notes-sync.sh = commit, fetch, rebase, push).
-- Sleep: push before the lid closes. Login/wake: internet shows up ~5 min
-- later, so retry every 30s for 15 min, then notify.
local script = hs.configdir .. "/notes-sync.sh"
local OFFLINE = 75 -- notes-sync.sh exits with this when github is unreachable
local task, retryUntil

local function sync(silent)
	if task and task:isRunning() then
		return
	end
	task = hs.task
		.new("/bin/bash", function(code, _, err)
			if code == OFFLINE and retryUntil and os.time() < retryUntil then
				return
			end
			retryUntil = nil
			if not silent then
				hs.notify.show(
					code == 0 and "Notes synced ✓" or "Notes sync failed",
					"",
					code == OFFLINE and "offline" or err
				)
			end
		end, { script })
		:start()
end

local function syncSoon()
	retryUntil = os.time() + 15 * 60
	sync()
end

-- globals so they aren't garbage collected
notesRetry = hs.timer.doEvery(30, function()
	if retryUntil then
		sync()
	end
end)
notesSleep = hs.caffeinate.watcher
	.new(function(event)
		if event == hs.caffeinate.watcher.systemWillSleep then
			sync(true) -- a failed push here is retried on wake
		elseif event == hs.caffeinate.watcher.systemDidWake then
			syncSoon()
		end
	end)
	:start()

syncSoon() -- Hammerspoon starts at login
