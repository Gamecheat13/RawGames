-- Copyright (c) Microsoft. All rights reserved.

-- These need to match the entries in the player globals tag so that we can reference them in
-- Lua. It's more efficient to have them pre hashed as well.
global k_playerRepresentationstrings = table.makePermanent
{
	"spartan_default",
	"forge_monitor",
	"spartan_locke",
	"spartan_buck",
	"spartan_tanaka",
	"spartan_vale",
	"spartan_chief",
	"spartan_chiefcrackedvisor",
	"spartan_fred",
	"spartan_kelly",
	"spartan_linda",
	"elite_default",
	"spartan_health_proto",
	"spartan_speed_proto",
	"training_spartan",
	"armor_socket_test_assault",
	"armor_socket_test_support",
	"armor_socket_test_recon",
	"multi_ability_test"
};

global k_playerRepresentations = table.makePermanent {};
for k,v in ipairs (k_playerRepresentationstrings) do
	k_playerRepresentations[v] = get_string_id_from_string(v);
end
