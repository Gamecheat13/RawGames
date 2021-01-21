--## CLIENT
global playersWithEffect:table = {};
function startupClient.InfectedEffectLoop ()
	while true do
		Sleep(1);
		if get_game_variant_bool_property(get_string_id_from_string("InfectedEffectEnabled")) == true then
			for key,aPlayer in pairs (players()) do
				if (get_player_team_designator(aPlayer) == MP_TEAM_DESIGNATOR.Second and player_get_unit(aPlayer) ~= nil) then
					if (playersWithEffect[aPlayer] == nil) then
						print("Playing infection effects on player");
						PlayInfectionEffect(aPlayer);
						playersWithEffect[aPlayer] = true;
					end
				else
					playersWithEffect[aPlayer] = nil;
				end
			end
		end
	end
end