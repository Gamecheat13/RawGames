--## SERVER

-- Global Warming Up Callbacks
-- Copyright (C) Microsoft. All rights reserved.



-- Callbacks from C++

function WarmingUpEndServerCallback()
    ShowLoadingScreen(false);
    CallEvent(g_eventTypes.warmingUpEndServerCallback, nil);
end

--## CLIENT
function WarmingUpBeginClientCallback()
    -- This is called on main thread, please don't go heavy work here
    -- FYI, This callback triggers eariler than level script startup initialization
    -- which is one of the requirements for audio.
    ShowLoadingScreen(true);
end

function WarmingUpEndClientCallback()
    -- This is called on main thread, please don't go heavy work here
    ShowLoadingScreen(false);
end
