-- DEBUG - DON'T REMOVE THIS COMMENT
-- Da Rules:
--   1) Script files starting with "-- DEBUG" are allowed to use debug functions and variables.
--   2) Such script files are ignored by the Release game.
--   3) Other files are not allowed to use functions and variables defined in a "-- DEBUG" file.
-- This ensures that debug functionality is not directly or indirectly used by the Release game.

-- global variables to be used for temporary storage by the console (because you can't define global variables on the console)
global g_temp1:any = nil;
global g_temp2:any = nil;
global g_temp3:any = nil;
global g_temp4:any = nil;
global g_temp5:any = nil;

global g_debugPlayerPositionThread:thread = nil;
function DebugPlayerPosition()
	if g_debugPlayerPositionThread == nil then
		g_debugPlayerPositionThread = CreateThread(DoDebugPlayerPosition);
	else
		KillThread(g_debugPlayerPositionThread);
		uip_window_remove("DebugPlayerPositionWindow");
		g_debugPlayerPositionThread = nil;
	end
end

function DoDebugPlayerPosition()

	uip_window_create("DebugPlayerPosition");
	uip_textblock_add("DebugPlayerPosition", "Text", "");
	uip_elem_set_x("DebugPlayerPosition", "Text", 50);
	uip_elem_set_y("DebugPlayerPosition", "Text", 100);
	uip_textblock_set_color("DebugPlayerPosition", "Text", "Gold");
	uip_textblock_set_fill("DebugPlayerPosition", "Text", "DarkSlateGray");
	uip_textblock_set_size("DebugPlayerPosition", "Text", 12);

	repeat

	local debugString:string= string.format("Player Position: (%.2f,%.2f,%.2f)", object_get_x(PLAYERS.player0), object_get_y(PLAYERS.player0), object_get_z(PLAYERS.player0));
	uip_textblock_set_text("DebugPlayerPosition", "Text", debugString);

	Sleep(1);

	until false

end

-- If on server, runs code locally.
-- If on client, sends the function to the server to be executed.
function RunScriptOnServer(code:string)
	if (IsServer()) then
		loadstring(code)();
	else
		ServerCmd(code);
	end
end

function ToggleDeathlessPlayerServer()
	cheat_deathless_player = not cheat_deathless_player;
	RunOnServerAndAllClients("print", "deathless player = ", cheat_deathless_player);
end

function DropTagOnServer(tagToDrop:tag)
	RunOnServerAndAllClients("DropToPlayer", PLAYERS.local0, tagToDrop);
end

function DropTagVariantOnServer(tagToDrop:tag, variant:string)
	RunOnServerAndAllClients("DropVariantToPlayer", PLAYERS.local0, tagToDrop, variant);
end

function DropTagPermutationOnServer(tagToDrop:tag, permutation:string)
	RunOnServerAndAllClients("DropPermutationToPlayer", PLAYERS.local0, tagToDrop, permutation);
end

function DropTagConfigurationOnServer(object:tag, configuration:tag)
	RunOnServerAndAllClients("DropObjectConfigurationToPlayer", PLAYERS.local0, object, configuration);
end

--## CLIENT

remoteClient["print"] = print
remoteClient["DropToPlayer"] = DropToPlayer
remoteClient["DropVariantToPlayer"] = DropVariantToPlayer
remoteClient["DropPermutationToPlayer"] = DropPermutationToPlayer
remoteClient["DropObjectConfigurationToPlayer"] = DropObjectConfigurationToPlayer

--## SERVER

remoteServer["print"] = print
remoteServer["DropToPlayer"] = DropToPlayer
remoteServer["DropVariantToPlayer"] = DropVariantToPlayer
remoteServer["DropPermutationToPlayer"] = DropPermutationToPlayer
remoteServer["DropObjectConfigurationToPlayer"] = DropObjectConfigurationToPlayer
remoteServer["TestSetPlayerPosition"] = TestSetPlayerPosition
remoteServer["unit_add_weapon"] = unit_add_weapon