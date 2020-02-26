--## SERVER

-- =================================================================================================
-- =================================================================================================
-- FX
-- =================================================================================================
-- =================================================================================================
-- -------------------------------------------------------------------------------------------------
-- ABILITY TIMER
-- -------------------------------------------------------------------------------------------------
--## CLIENT
-- === FlockEffects: calls an effect on a flock (CLIENT ONLY) after the flock is created, repeats every random seconds up to the "gap" in seconds
--  in intervals of tenths until there is no more flock
--		flock 		- the name of the flock
--		effect		- the effect tag to call on the flock
--		gap				- the number of max seconds between effects being called

function FlockEffects(flock:string_id, effect:tag, gap:number)
	--print ("Random effect on flock");
	SleepUntil ([| #flock_get_creatures(flock) > 0 ], 1);
	--print ("flock created");
	repeat
		local flock_list = flock_get_creatures (flock);
		if #flock_list >= 1 then
			local fl = flock_list[random_range(1,#flock_list)];
			effect_new (effect, fl);
			--effect_new (TAG('levels\campaignworld030\w3_halsey\fx\vignettes\banshee_crashes\banshee_explosion_lrg.effect'), fl);
			--print (fl);
			sleep_s (random_range (1, gap * 10) * 0.1);
		end
	until #flock_list == 0;
	--print ("no more random effects on flocks, because there are no more flocks");
end