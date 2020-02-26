-- object grunt_mech
--## SERVER

global g_isPvE = true;

function grunt_mech:init()
	
	CreateThread(DetermineIfPvE);
	CreateThread(beamKamikazi, self);
end

function DetermineIfPvE()
       repeat
       local lastTeam = nil;
       for k,v in pairs(players()) do
       local playerMPTeam = get_object_mp_team(v);
                                                
            if(lastTeam == nil) then
				lastTeam = playerMPTeam
            elseif (lastTeam ~= playerMPTeam) then
				g_isPvE = false;
                       end
            end
                                
       Sleep(1);
       until (not g_isPvE);
end

function CheckAllowKamikaze():boolean
       return g_isPvE;
end

function beamKamikazi(mech:object)
	if (random_range(0, 1) < 0.7) then
		return;
	end

	if (unit_has_weapon(object_get_ai(mech), TAG('objects\characters\grunt_mecha\weapons\grunt_mecha_beam_arm.weapon') ) ) then
		SleepUntil([|object_get_health(mech) <= 0.2], 1);

		if CheckAllowKamikaze() then
			object_cannot_take_damage(mech);
			unit_impervious(mech, true); 
			sleep_s(0.2);
			ai_grunt_kamikaze(object_get_ai(mech)); 
			object_set_maximum_vitality(mech, 6000);
			--need to set health twice because Kamikaze sets it somewhere during the animation
			object_set_health(mech, 0.2);
			sleep_s(1.9);
			object_set_health(mech, 0.2);
			object_can_take_damage(mech);
			unit_impervious(mech, false); 
			sleep_s(7);
			ai_kill(object_get_ai(mech));
		end
	end

end
