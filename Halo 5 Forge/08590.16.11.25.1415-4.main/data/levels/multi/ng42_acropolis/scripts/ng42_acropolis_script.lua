--## SERVER

--	343	//		  												
--	343	//						Acropolis
--	343	//		composition name: ambient_vista																							


--//=========//	Startup Scripts	//=========////
function startup.d_acropolis_script()
	CreateThread (ambient_vista);
	--CreateThread (theater_of_war);
end

--//=========//	Vignette Scripts	//=========////

function ambient_vista():void
--	pup_vignette_enable(false);
-- print("starting timer");
	composer_play_show("ambient_vista");
end

--- ---- -- - - - - - -


-- function theater_of_war():void                                                                                                        -- TO DO: Make join in progress compatible
     -- CreateThread(tow_aa_battery_1);                                                                                                 -- First cluster of AA fire. Cycles between 5 different points of origin.
     -- CreateThread(tow_aa_battery_2);                                                                                                 -- Second cluster of AA fire
     -- CreateThread(tow_aa_battery_3);                                                                                                 -- Third cluster of AA fire
-- end

-- function tow_aa_battery_1():void
     -- RunClientScript("cycle_aa_shots_helper_11");
     -- RunClientScript("cycle_aa_shots_helper_12");
     -- RunClientScript("cycle_aa_shots_helper_13");
     -- sleep_s(2);                                                                                                                               -- This delay is so that when players
                                                                                                                                                -- -- first see it there's not
                                                                                                                                                -- -- a solid wall of fire.
     -- RunClientScript("cycle_aa_shots_helper_14");
     -- RunClientScript("cycle_aa_shots_helper_15");
-- end
-- function tow_aa_battery_2():void
     -- RunClientScript("cycle_aa_shots_helper_21");
     -- RunClientScript("cycle_aa_shots_helper_22");
     -- RunClientScript("cycle_aa_shots_helper_23");
     -- sleep_s(2);                                                                                                                               -- this is so that when players
                                                                                                                                                 -- -- first see it there's not
                                                                                                                                                -- -- a solid wall of fire
     -- RunClientScript("cycle_aa_shots_helper_24");
     -- RunClientScript("cycle_aa_shots_helper_25");

-- end
-- function tow_aa_battery_3():void
     -- RunClientScript("cycle_aa_shots_helper_31");
     -- RunClientScript("cycle_aa_shots_helper_32");
     -- RunClientScript("cycle_aa_shots_helper_33");
     -- sleep_s(2);                                                                                                                               -- this is so that when players
                                                                                                                                                -- -- first see it there's not
                                                                                                                                                -- -- a solid wall of fire
     -- RunClientScript("cycle_aa_shots_helper_34");
     -- RunClientScript("cycle_aa_shots_helper_35");
-- end

-- --## CLIENT 

-- global b_aa_battery_1:boolean = false;
-- global b_aa_battery_2:boolean = false;

-- function cycle_aa_shots(                                                                                                   -- This is the main function. It fires the effect from 1 of 3 points of origin, waits, then repeats.
                                     -- effect:tag,                                                                                     -- effect in this format: TAG('path' --[[(assumes everything up to 'tags\'--]]) 
                                     -- pta:point,                                                                                -- origin point 1 (facing values matter)
                                     -- ptb:point,                                                                                -- origin point 2 
                                     -- ptc:point,                                                                                -- origin point 3 
                                     -- var:boolean                                                                                     -- condition on which to kill effects (firing will continue until this value is set to false)
                                     -- ):void
     -- repeat
           -- local dice:number = random_range(1,3);                                                                          -- randomize between 3 options
           -- if(dice == 1)then                                                                                                    -- option 1
                -- effect_new(effect, pta);
           -- elseif(dice == 2)then                                                                                           -- option 2
                -- effect_new(effect, ptb);
           -- else                                                                                                                 -- option 3
                -- effect_new(effect, ptc);                                                                              
           -- end
           -- sleep_s(random_range(2, 6));                                                                                    -- sleep for 2 - 6 seconds, for randomization
     -- until(var);
-- end

-- function cycle_aa_shots_helper_11():void
           -- cycle_aa_shots(
          -- TAG('objects\vehicles\human\turrets\storm_unsc_artillery\weapon\fx\dummy_firing.effect'),
           -- POINTS.ps_tow_aa_1.p1a,
           -- POINTS.ps_tow_aa_1.p1b,
           -- POINTS.ps_tow_aa_1.p1c,
           -- b_aa_battery_1);
-- end
-- function cycle_aa_shots_helper_12():void
           -- cycle_aa_shots(
          -- TAG('objects\vehicles\human\turrets\storm_unsc_artillery\weapon\fx\dummy_firing.effect'),
           -- POINTS.ps_tow_aa_1.p2a,
           -- POINTS.ps_tow_aa_1.p2b,
           -- POINTS.ps_tow_aa_1.p2c,
           -- b_aa_battery_1);
-- end
-- function cycle_aa_shots_helper_13():void
           -- cycle_aa_shots(
          -- TAG('objects\vehicles\human\turrets\storm_unsc_artillery\weapon\fx\dummy_firing.effect'),
           -- POINTS.ps_tow_aa_1.p3a,
           -- POINTS.ps_tow_aa_1.p3b,
           -- POINTS.ps_tow_aa_1.p3c,
           -- b_aa_battery_1);
-- end
-- function cycle_aa_shots_helper_14():void
           -- cycle_aa_shots(
          -- TAG('objects\vehicles\human\turrets\storm_unsc_artillery\weapon\fx\dummy_firing.effect'),
           -- POINTS.ps_tow_aa_1.p4a,
           -- POINTS.ps_tow_aa_1.p4b,
           -- POINTS.ps_tow_aa_1.p4c,
           -- b_aa_battery_1);
-- end
-- function cycle_aa_shots_helper_15():void
           -- cycle_aa_shots(
          -- TAG('objects\vehicles\human\turrets\storm_unsc_artillery\weapon\fx\dummy_firing.effect'),
           -- POINTS.ps_tow_aa_1.p5a,
           -- POINTS.ps_tow_aa_1.p5b,
           -- POINTS.ps_tow_aa_1.p5c,
           -- b_aa_battery_1);
-- end
-- function cycle_aa_shots_helper_21():void
           -- cycle_aa_shots(
          -- TAG('objects\vehicles\human\turrets\storm_unsc_artillery\weapon\fx\dummy_firing.effect'),
           -- POINTS.ps_tow_aa_2.p1a,
           -- POINTS.ps_tow_aa_2.p1b,
           -- POINTS.ps_tow_aa_2.p1c,
           -- b_aa_battery_1);
-- end
-- function cycle_aa_shots_helper_22():void
           -- cycle_aa_shots(
          -- TAG('objects\vehicles\human\turrets\storm_unsc_artillery\weapon\fx\dummy_firing.effect'),
           -- POINTS.ps_tow_aa_2.p2a,
           -- POINTS.ps_tow_aa_2.p2b,
           -- POINTS.ps_tow_aa_2.p2c,
           -- b_aa_battery_1);
-- end
-- function cycle_aa_shots_helper_23():void
           -- cycle_aa_shots(
          -- TAG('objects\vehicles\human\turrets\storm_unsc_artillery\weapon\fx\dummy_firing.effect'),
           -- POINTS.ps_tow_aa_2.p3a,
           -- POINTS.ps_tow_aa_2.p3b,
           -- POINTS.ps_tow_aa_2.p3c,
           -- b_aa_battery_1);
-- end
-- function cycle_aa_shots_helper_24():void
           -- cycle_aa_shots(
          -- TAG('objects\vehicles\human\turrets\storm_unsc_artillery\weapon\fx\dummy_firing.effect'),
           -- POINTS.ps_tow_aa_2.p4a,
           -- POINTS.ps_tow_aa_2.p4b,
           -- POINTS.ps_tow_aa_2.p4c,
           -- b_aa_battery_1);
-- end
-- function cycle_aa_shots_helper_25():void
           -- cycle_aa_shots(
          -- TAG('objects\vehicles\human\turrets\storm_unsc_artillery\weapon\fx\dummy_firing.effect'),
           -- POINTS.ps_tow_aa_2.p5a,
           -- POINTS.ps_tow_aa_2.p5b,
           -- POINTS.ps_tow_aa_2.p5c,
           -- b_aa_battery_1);
-- end
-- function cycle_aa_shots_helper_31():void
           -- cycle_aa_shots(
          -- TAG('objects\vehicles\human\turrets\storm_unsc_artillery\weapon\fx\dummy_firing.effect'),
           -- POINTS.ps_tow_aa_3.p1a,
           -- POINTS.ps_tow_aa_3.p1b,
           -- POINTS.ps_tow_aa_3.p1c,
           -- b_aa_battery_1);
-- end
-- function cycle_aa_shots_helper_32():void
           -- cycle_aa_shots(
          -- TAG('objects\vehicles\human\turrets\storm_unsc_artillery\weapon\fx\dummy_firing.effect'),
           -- POINTS.ps_tow_aa_3.p2a,
           -- POINTS.ps_tow_aa_3.p2b,
           -- POINTS.ps_tow_aa_3.p2c,
           -- b_aa_battery_1);
-- end
-- function cycle_aa_shots_helper_33():void
           -- cycle_aa_shots(
          -- TAG('objects\vehicles\human\turrets\storm_unsc_artillery\weapon\fx\dummy_firing.effect'),
           -- POINTS.ps_tow_aa_3.p3a,
           -- POINTS.ps_tow_aa_3.p3b,
           -- POINTS.ps_tow_aa_3.p3c,
           -- b_aa_battery_1);
-- end
-- function cycle_aa_shots_helper_34():void
           -- cycle_aa_shots(
          -- TAG('objects\vehicles\human\turrets\storm_unsc_artillery\weapon\fx\dummy_firing.effect'),
           -- POINTS.ps_tow_aa_3.p4a,
           -- POINTS.ps_tow_aa_3.p4b,
           -- POINTS.ps_tow_aa_3.p4c,
           -- b_aa_battery_1);
-- end
-- function cycle_aa_shots_helper_35():void
           -- cycle_aa_shots(
          -- TAG('objects\vehicles\human\turrets\storm_unsc_artillery\weapon\fx\dummy_firing.effect'),
           -- POINTS.ps_tow_aa_3.p5a,
           -- POINTS.ps_tow_aa_3.p5b,
           -- POINTS.ps_tow_aa_3.p5c,
           -- b_aa_battery_1);
-- end

function startupClient.AcropolisMixState():void
	sound_impulse_start(TAG('sound\031_states\031_st_osiris_global\031_st_osiris_global_levelloaded\031_st_osiris_global_levelloaded_mp_acropolis.sound'), nil, 1)
end