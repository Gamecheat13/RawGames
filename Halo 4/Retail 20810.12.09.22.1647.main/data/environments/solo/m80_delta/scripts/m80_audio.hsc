//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
//
// Mission: 					m80_delta_audio
//										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434


// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** DEBUG ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================




// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** GLOBALS ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================


global boolean b_cinematic_playing = FALSE;


// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** START-UP ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================


script startup m80_delta_audio()

	thread (load_music_for_zone_set() );
	sleep_s( 1.0 );

end


script static void f_sfx_insertion_reset( short s_index )
	
	sleep_s( 1.0 );
	
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AUDIO: ASTEROID GUNS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
script static real DEF_R_AUDIO_ASTEROID_GUNS_OFFLINE()									0.00;																																							end
script static real DEF_R_AUDIO_ASTEROID_GUNS_DISTANT()									0.10;																																							end
script static real DEF_R_AUDIO_ASTEROID_GUNS_MEDIUM()										0.25;																																							end
script static real DEF_R_AUDIO_ASTEROID_GUNS_CLOSE()										0.75;																																							end
script static real DEF_R_AUDIO_ASTEROID_GUNS_IMMEDIATE()								1.00;																																							end

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static real r_audio_asteroid_guns_distance = 														DEF_R_AUDIO_ASTEROID_GUNS_OFFLINE();

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_audio_asteroid_guns_init::: Init
//script dormant f_audio_asteroid_guns_init()
//	dprint( "::: f_audio_asteroid_guns_init :::" );

	// XXX_TODO

//end

// === f_audio_asteroid_guns_deinit::: Deinit
//script dormant f_audio_asteroid_guns_deinit()
	//dprint( "::: f_audio_asteroid_guns_deinit :::" );

	// kill functions
//	sleep_forever( f_audio_asteroid_guns_init );

//end

// === f_audio_asteroid_guns_set::: Sets Asteroid Guns value
script static void f_audio_asteroid_guns_set( real r_distance )
static long l_thread = 0;
	//dprint( "::: f_audio_asteroid_guns_set :::" );

	if ( r_distance != f_audio_asteroid_guns_get() ) then

		// store the range
		r_audio_asteroid_guns_distance = r_distance;

		if ( f_audio_asteroid_guns_get() == DEF_R_AUDIO_ASTEROID_GUNS_OFFLINE() ) then
			kill_thread( l_thread );
		elseif ( B_guns_turrets_reactivated and (not IsThreadValid(l_thread)) ) then
			//dprint( "f_audio_asteroid_guns_loop disabled" );
			l_thread = thread( f_audio_asteroid_guns_loop() );
		end

	end

end

// === f_audio_asteroid_guns_get::: Gets Asteroid Guns value
script static real f_audio_asteroid_guns_get()
	r_audio_asteroid_guns_distance;
end

// === f_audio_asteroid_guns_loop::: Loop audio for guns
script static void f_audio_asteroid_guns_loop()
local sound snd_gun = NONE;
	//dprint( "::: f_audio_asteroid_guns_deinit :::" );

	repeat
	
		// delay
		sleep_s( 1.25, 3.75 );

		/// Pick a sound
		snd_gun = NONE;
		if( f_audio_asteroid_guns_get() == DEF_R_AUDIO_ASTEROID_GUNS_DISTANT() ) then
			snd_gun = 'sound\environments\solo\m080\amb_m80_device_machines_specifics\amb_m80_asteroid_guns_distant.sound';
		end
		if( f_audio_asteroid_guns_get() == DEF_R_AUDIO_ASTEROID_GUNS_MEDIUM() ) then
			snd_gun = 'sound\environments\solo\m080\amb_m80_device_machines_specifics\amb_m80_asteroid_guns_distant.sound';
		end
		if( f_audio_asteroid_guns_get() == DEF_R_AUDIO_ASTEROID_GUNS_CLOSE() ) then
			snd_gun = 'sound\environments\solo\m080\amb_m80_device_machines_specifics\amb_m80_asteroid_guns_close.sound';
		end
		if( f_audio_asteroid_guns_get() == DEF_R_AUDIO_ASTEROID_GUNS_IMMEDIATE() ) then
			snd_gun = 'sound\environments\solo\m080\amb_m80_device_machines_specifics\amb_m80_asteroid_guns_immediate.sound';
		end
		
		// Play the sound and wait for it to finish
		if ( snd_gun != NONE ) then
			sound_impulse_start( snd_gun, NONE, 1.0 ); 
			sleep_s( frames_to_seconds(sound_impulse_time(snd_gun)) );
		end
	
	until ( f_audio_asteroid_guns_get() == DEF_R_AUDIO_ASTEROID_GUNS_OFFLINE(), 1 );

end


// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** VOICE-OVERS (VO) ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================





script static void f_VO_cinematic_elevator()

	// 554 : Get the door closed, get the door closed! (looking up at Chief) 117. I… I can't believe this is happening. First the attack, and then YOU… I… oh man, the fact that you'd show up here, now… (deep breath) Okay, okay. H-hold on, lemme start us down.
	//sound_impulse_start ('sound\dialog\Mission\M80\M_M80_Dr_Tillson_05700', NONE, 1 );
	//sleep_s( 14.02 ); //17.02
	//notifylevel( "m80 lab tillson starts elevator" );
	//sleep_s( 3.0 );

/*
// 624 : Get the door closed, get the door closed!
sound_impulse_start ('sound\dialog\Mission\M80\m_m80_dr_tillson_05710', NONE, 1 );
sleep_s( 1 );

// 625 : 117. I… I can't believe this is happening. First the attack, and then YOU… I… oh man, the fact that you'd show up here, now…
sound_impulse_start ('sound\dialog\Mission\M80\m_m80_dr_tillson_05720', NONE, 1 );
sleep_s( 8 );

// 625 :  (deep breath) Okay, okay. H-hold on, lemme start us down.show up here, now…
sound_impulse_start ('sound\dialog\Mission\M80\m_m80_dr_tillson_05730', NONE, 1 );
sleep_s( 4 );
*/
/*
	//wake( f_m80_vo_elevator_chatter );
	
	// 556 : We excavated The Module from Installation 03 about six months back. We learned the hard way that examining it on the ring wasn't the best idea.
	sound_impulse_start ('sound\dialog\Mission\M80\M_M80_Dr_Tillson_05900', NONE, 1 );
	sleep_s( 8.363 );
	
	// 558 : Cmdr. Del Rio on the Infinity told us all about it. He said you found a connection between the Module and humanity?
	sound_impulse_start ('sound\dialog\Mission\M80\M_M80_Cortana_06100', NONE, 1 );
	sleep_s( 5.351 );
	
	// 559 : Heh -'connection'? We could only translate small chunks of the Module's datastore, but what we got was - it contained precise analytics concerning human DNA. But not only contemporary DNA - homo erectus, australopithecus, ardipithecus... an entire evolutionary profile.
	sound_impulse_start ('sound\dialog\Mission\M80\M_M80_Dr_Tillson_06200', NONE, 1 );
	sleep_s( 18.07 );
	
	// 560 : Let me guess - it contained genetic predictions as well.
	sound_impulse_start ('sound\dialog\Mission\M80\M_M80_Cortana_06300', NONE, 1 );
	sleep_s( 2.572 );
	
	sleep_s( 1.0 );
	
	// 561 : Then you already know, don't you.
	sound_impulse_start ('sound\dialog\Mission\M80\M_M80_Dr_Okana_06400', NONE, 1 );
	sleep_s( 1.525 );
	
	sleep_s( 0.5 );
	
	// 562 : Know what?
	sound_impulse_start ('sound\dialog\Mission\M80\M_M80_MC_06500', NONE, 1 );
	sleep_s( 0.64 );
	
	// 563 : We checked everything we gathered against ONI files and… the only hits we got back were for you - the original Spartan IIs. We just figured it was a coincidence. Plus, since you were all listed as missing in action--
	sound_impulse_start ('sound\dialog\Mission\M80\M_M80_Dr_Tillson_06600', NONE, 1 );
*/
	sleep_s( 11.727 );

end


script static void f_m80_vo_elevator_chatter()

	sleep_s( 9.02 );
	// 555 : It's like the end of the world…
	//sound_impulse_start ('sound\dialog\Mission\M80\M_M80_Dr_Okana_05800', NONE, 1 );
	//sleep_s( 1.263 );

	sleep_s( 5.0 );

	// 557 : Is that vessel building itself??
	//sound_impulse_start ('sound\dialog\Mission\M80\M_M80_Tall_Scientist_06000', NONE, 1 );
	//sleep_s( 2.491 );
	
end


script static void f_VO_module_at_risk()

/*	sleep_until( LevelEventStatus( "m80 elevator module at risk" ), 1 );	
	//camera_shake_all_coop_players ( real attack, real intensity, short duration, real decay)
	camera_shake_all_coop_players (1, 1, 1, 1 );
	
	// 564 : That was more than a hull breach.
	sound_impulse_start ('sound\dialog\Mission\M80\M_M80_MC_06700', NONE, 1 );
	sleep_s( 1.337 );
	
	sleep_s( 1.0 );
	
	// 565 : They've overloaded the autoturret controls! The Module's at risk!
	sound_impulse_start ('sound\dialog\Mission\M80\M_M80_Dr_Okana_06800', NONE, 1 );
*/	sleep_s( 3.609 );
end


script static void f_VO_intro_mechroom()
/*
	sleep_until( LevelEventStatus( "m80 elevator intro mechs" ), 1 );
	// 566 : What do you have for defenses other light weapons?
	sound_impulse_start ('sound\dialog\Mission\M80\M_M80_MC_06900', NONE, 1 );
	sleep_s( 2.191 );
	
	// 567 : The marines left a bunch of hardware behind, just in case. We piled it all up in one of the storage sheds.
	sound_impulse_start ('sound\dialog\Mission\M80\M_M80_Dr_Tillson_07000', NONE, 1 );
	sleep_s( 4.991 );
	
	sleep_s( 0.25 );
	
	// 568 : Can you take me there?
	sound_impulse_start ('sound\dialog\Mission\M80\M_M80_MC_07100', NONE, 1 );
	sleep_s( 0.9 );
	
	sleep_s( 0.5 );
	
	// 569 : Follow me.
	sound_impulse_start ('sound\dialog\Mission\M80\M_M80_Dr_Tillson_07200', NONE, 1 );
*/	sleep_s( 0.54 );

end


script static void f_VO_mechroom()
/*
	// 570 : They're drilling through the walls! Get back to the elevator--! AAARGH!
	//sound_impulse_start ('sound\dialog\Mission\M80\M_M80_Doomed_Scientist_07300', NONE, 1 );
	//sleep_s( 5.291 );
	
	// 571 : I've still got people out there!
	sound_impulse_start ('sound\dialog\Mission\M80\M_M80_Dr_Tillson_07400', NONE, 1 );
	sleep_s( 1.489 );
	
	// 572 : YOUR PEOPLE ARE SUPERFLUOUS RIGHT NOW!
	//sound_impulse_start ('sound\dialog\Mission\M80\M_M80_Cortana_07500', NONE, 1 );
	//sleep_s( 2.3 );
	
	// 573 : We're on it, Doctor.
	sound_impulse_start ('sound\dialog\Mission\M80\M_M80_MC_07600', NONE, 1 );
	sleep_s( 0.89 );
	
	sleep_s( 0.5 );
	
	// 574 : John, its not my fault-- 
	//sound_impulse_start ('sound\dialog\Mission\M80\M_M80_Cortana_07700', NONE, 1 );
	//sleep_s( 1.512 );
	
	// 575 : I ORDER YOU TO PRIORITIZE THAT MODULE OVER THOSE SCIENTISTS, SOLDIER!
	//sound_impulse_start ('sound\dialog\Mission\M80\M_M80_Cortana_07700_01', NONE, 1 );
*/	sleep_s( 3.828 );
	
end


script static void f_m80_vo_mech_startup()

	// 1 : Primary weapons systems coming up now.
	sound_impulse_start ('sound\dialog\Mission\M80\m_m80_cortana_12900', NONE, 1 );
	sleep_s( 1.861 );

	sleep_s( 1.0 );
/*
	// 2 : All three weapons batteries online and functioning normally.
	sound_impulse_start ('sound\dialog\Mission\M80\m_m80_cortana_13000', NONE, 1 );
	sleep_s( 2.704 );
*/
end
	

script static void f_VO_atrium_turrets()
	/*
	// 576 : It's Sandy - we can't rearm the automated defenses!
	//sound_impulse_start ('sound\dialog\Mission\M80\M_M80_Dr_Tillson_07800', NONE, 1 );
	//sleep_s( 2.0 );
	
	camera_shake_all_coop_players( 0.5, 1.0, 0, 1.0 );
	
	// 577 : AHH!  Oh boy, oh boy... The stupid autoturrets won't come back online! If we can't get them up and running…
	sound_impulse_start ('sound\dialog\Mission\M80\M_M80_Dr_Tillson_07900', NONE, 1 );
	sleep_s( 6.141 );

	sleep_s( 0.5 );
	
	// 578 : Where are the controls?
	sound_impulse_start ('sound\dialog\Mission\M80\M_M80_MC_08000', NONE, 1 );
	sleep_s( 1.028 );
	
	sleep_s( 0.5 );
	
	// 579 : 500-Level - but you can't do it yourself!
	sound_impulse_start ('sound\dialog\Mission\M80\M_M80_Dr_Tillson_08100', NONE, 1 );
	sleep_s( 2.524 );

	sleep_s( 0.25 );

	// 581 : I'll meet him there!
	//sound_impulse_start ('sound\dialog\Mission\M80\M_M80_Tim_09550', NONE, 1 );
	//sleep_s( 0.64 );
	
	//sleep_s( 2.0 );
	
	// 582 : (off-camera) Be careful! (to Chief) Tim and a couple others are heading up now to do the repairs, but you've got to keep those things off them!
	//sound_impulse_start ('sound\dialog\Mission\M80\M_M80_Dr_Tillson_08300', NONE, 1 );
	//sleep_s( 5.793 );
	
	//sleep_s( 0.5 );
	
	// 583 : I'll take care of them, Doctor. Don't worry.
	sound_impulse_start ('sound\dialog\Mission\M80\M_M80_MC_08400', NONE, 1 );
	*/
	sleep_s( 1.798 );
	
end


script static void f_VO_hallways()
/*
	// 584 : Extinguish the Unggoy! Offer them to the void! (with cycled alternates)
	//sound_impulse_start ('sound\dialog\Mission\M80\M_M80_Cortana_08500', NONE, 1 );
	//sleep_s( 3.12 );
	
	sleep_until( LevelEventStatus( "m80 hallways open exit" ), 1 );
	// 585 : Cortana, is it possible to override the security lockdown in this sector?
	sound_impulse_start ('sound\dialog\Mission\M80\M_M80_MC_08600', NONE, 1 );
	sleep_s( 3.241 );
	
	// 586 : Possibility is relativistic, John! Should we remain shackled by the limits others designed for us?
	sound_impulse_start ('sound\dialog\Mission\M80\M_M80_Cortana_08700', NONE, 1 );
*/	sleep_s( 5.277 );

end


// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** AMBIENT VO ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================


script continuous f_m80_vo_intercom()

	if( LevelEventStatus( "m80 intercom hull breach" ) ) then
		// 253 : ALERT. HULL BREACH ON DECK 13 SECTOR 5, DECK 25 SECTOR 12, DECK 131 SECTOR 7, DECK 270, DECK 895...
		sound_impulse_start ('sound\environments\solo\m060\vo\M_M60_Ship_PA_08000', NONE, 1 );
		sleep_s( 10 );
	end
	
	if( LevelEventStatus( "m80 intercom emergency stations" ) ) then	
		// 254 : CONDITION RED. ALL PERSONNEL TO EMERGENCY STATIONS. CONDITION RED -- ALL PERSONNEL TO EMERGENCY STATIONS.
		sound_impulse_start ('sound\environments\solo\m060\vo\M_M60_Ship_PA_08100', NONE, 1 );
		sleep_s( 6 );
	end	
		
	if( LevelEventStatus( "m80 intercom intruder alert" ) ) then
		// 255 : INTRUSION ALERT. INTRUSION ALERT. SECURITY REQUESTED IN FORWARD WEAPON BATTERY, DECK 2, SECTOR 15.
		sound_impulse_start ('sound\environments\solo\m060\vo\M_M60_Ship_PA_08200', NONE, 1 );
		sleep_s( 6 );
	end
		
	if( LevelEventStatus( "m80 intercom medical emergency" ) ) then
		// 256 : MEDICAL EMERGENCY. ANY AVAILABLE MEDICAL STAFF TO REPORT TO SOUTH PROMENADE, MAIN KIOSK.
		sound_impulse_start ('sound\environments\solo\m060\vo\M_M60_Ship_PA_08300', NONE, 1 );
		sleep_s( 5 );
	end
		
	if( LevelEventStatus( "m80 intercom fire warning" ) ) then
		// 257 : FIRE SUPPRESSION SYSTEMS FAILURE. MANUAL INTERVENTION REQUIRED.
		sound_impulse_start ('sound\environments\solo\m060\vo\M_M60_Ship_PA_08400', NONE, 1 );
		sleep_s( 7 );
	end

end


script continuous f_m80_vo_marines()
		
	if( LevelEventStatus( "m80 marine one phantom" ) ) then
		// 0 : Chief, a phantom!
		sound_impulse_start ('sound\environments\solo\m040\vo\M_M40_Temp_Marine_00100', NONE, 1 );
		sleep_s( 1 );
	end
		
	if( LevelEventStatus( "m80 marine dropship" ) ) then
		// 1 : Covenant dropship inbound!
		sound_impulse_start ('sound\environments\solo\m040\vo\M_M40_Temp_Marine_00200', NONE, 1 );
		sleep_s( 2 );
	end
		
	if( LevelEventStatus( "m80 marine mop up stragglers" ) ) then
		// 3 : There are still some Covie stragglers hanging around. Let’s mop up the rest of ‘em!
		sound_impulse_start ('sound\environments\solo\m040\vo\M_M40_Temp_Marine_00400', NONE, 1 );
		sleep_s( 3 );
	end
		
	if( LevelEventStatus( "m80 marine clear out stragglers" ) ) then
		// 4 : There are a couple of Covenant stragglers still left, Chief. Clear ‘em out!
		sound_impulse_start ('sound\environments\solo\m040\vo\M_M40_Temp_Marine_00500', NONE, 1 );
		sleep_s( 3 );
	end
		
	if( LevelEventStatus( "m80 marine phantom return" ) ) then
		// 8 : Eyes up, Phantom’s back!
		sound_impulse_start ('sound\environments\solo\m040\vo\M_M40_Temp_Marine_00900', NONE, 1 );
		sleep_s( 1 );
	end
		
	if( LevelEventStatus( "m80 marine armor destroyed" ) ) then
		// 13 : Looks like that armor wasn’t so tough after all!
		sound_impulse_start ('sound\environments\solo\m040\vo\M_M40_Temp_Marine_01400', NONE, 1 );
		sleep_s( 2 );
	end		
		
	if( LevelEventStatus( "m80 marine more dropships" ) ) then
		// 14 : More dropships on approach!
		sound_impulse_start ('sound\environments\solo\m040\vo\M_M40_Temp_Marine_01500', NONE, 1 );
		sleep_s( 1 );
	end
		
	if( LevelEventStatus( "m80 marine friendly fire" ) ) then
		// 233 : Watch your fire!
		sound_impulse_start ('sound\environments\solo\m060\vo\M_M60_Marine1_06200', NONE, 1 );
		sleep_s( 1 );
	end
		
	if( LevelEventStatus( "m80 marine under fire" ) ) then
		// 234 : We’re taking rounds here!
		sound_impulse_start ('sound\environments\solo\m060\vo\M_M60_Marine1_06300', NONE, 1 );
		sleep_s( 1 );
	end
		
	if( LevelEventStatus( "m80 marine get down" ) ) then
		// 235 : Get down!
		sound_impulse_start ('sound\environments\solo\m060\vo\M_M60_Marine1_06300_01', NONE, 1 );
		sleep_s( 0 );
	end
				
	if( LevelEventStatus( "m80 marine it's on" ) ) then
		// 246 : Oh it’s on now!
		sound_impulse_start ('sound\environments\solo\m060\vo\M_M60_Marine1_07400', NONE, 1 );
		sleep_s( 1 );
	end
		
	if( LevelEventStatus( "m80 marine have fun" ) ) then
		// 247 : I'm gonna have me some fun!
		sound_impulse_start ('sound\environments\solo\m060\vo\M_M60_Marine1_07400_01', NONE, 1 );
		sleep_s( 1 );
	end
		
	if( LevelEventStatus( "m80 marine gear up" ) ) then
		// 248 : Alright - everybody gear up!
		sound_impulse_start ('sound\environments\solo\m060\vo\M_M60_Marine1_07500', NONE, 1 );
		sleep_s( 1 );
	end

end


script continuous f_m80_vo_cortana()

	if( LevelEventStatus( "m80 cortana one phantom" ) ) then
		// 3 : Phantom on approach!
		sound_impulse_start ('sound\dialog\Mission\M80\m_m80_cortana_13100', NONE, 1 );
		sleep_s( 1.08 );
	end

	if( LevelEventStatus( "m80 cortana one phantom 2" ) ) then		
		// 4 : Phantom inbound!
		sound_impulse_start ('sound\dialog\Mission\M80\m_m80_cortana_13200', NONE, 1 );
		sleep_s( 1.355 );
	end
	
	if( LevelEventStatus( "m80 cortana incoming" ) ) then	
		// 5 : Incoming!
		sound_impulse_start ('sound\dialog\Mission\M80\m_m80_cortana_13300', NONE, 1 );
		sleep_s( 0.61 );
	end

	if( LevelEventStatus( "m80 cortana ghosts" ) ) then		
		// 6 : Ghosts!
		sound_impulse_start ('sound\dialog\Mission\M80\m_m80_cortana_13400', NONE, 1 );
		sleep_s( 0.55 );
	end
	
	if( LevelEventStatus( "m80 cortana wraith" ) ) then	
		// 7 : Wraith!
		sound_impulse_start ('sound\dialog\Mission\M80\m_m80_cortana_13500', NONE, 1 );
		sleep_s( 0.6 );
	end
	
	if( LevelEventStatus( "m80 cortana look out" ) ) then	
		// 8 : Chief, look out!
		sound_impulse_start ('sound\dialog\Mission\M80\m_m80_cortana_13600', NONE, 1 );
		sleep_s( 0.87 );
	end
	
	if( LevelEventStatus( "m80 cortana prioritizing" ) ) then	
		// 9 : Prioritizing targets!
		sound_impulse_start ('sound\dialog\Mission\M80\m_m80_cortana_13700', NONE, 1 );
		sleep_s( 1.245 );
	end
	
	if( LevelEventStatus( "m80 cortana mortars" ) ) then	
		// 10 : Heads up - mortars!
		sound_impulse_start ('sound\dialog\Mission\M80\m_m80_cortana_13800', NONE, 1 );
		sleep_s( 1.049 );
	end
	
	if( LevelEventStatus( "m80 cortana not done" ) ) then	
		// 11 : We’re not done yet, Chief.
		sound_impulse_start ('sound\dialog\Mission\M80\m_m80_cortana_13900', NONE, 1 );
		sleep_s( 1.316 );
	end
	
	if( LevelEventStatus( "m80 cortana get ready" ) ) then	
		// 12 : Get ready, Master Chief.
		sound_impulse_start ('sound\dialog\Mission\M80\m_m80_cortana_14000', NONE, 1 );
		sleep_s( 1.129 );
	end

	if( LevelEventStatus( "m80 cortana more coming" ) ) then		
		// 13 : There’s more where that came from.
		sound_impulse_start ('sound\dialog\Mission\M80\m_m80_cortana_14100', NONE, 1 );
		sleep_s( 1.467 );
	end
	
	if( LevelEventStatus( "m80 cortana won't back down" ) ) then	
		// 14 : They don’t know when to give up!
		sound_impulse_start ('sound\dialog\Mission\M80\m_m80_cortana_14200', NONE, 1 );
		sleep_s( 1.439 );
	end
		
	if( LevelEventStatus( "m80 cortana more covenant" ) ) then
		// 15 : More Covenant!
		sound_impulse_start ('sound\dialog\Mission\M80\m_m80_cortana_14300', NONE, 1 );
		sleep_s( 0.86 );
	end
		
	if( LevelEventStatus( "m80 cortana more covenant 2" ) ) then
		// 16 : More Covenant inbound!
		sound_impulse_start ('sound\dialog\Mission\M80\m_m80_cortana_14400', NONE, 1 );
		sleep_s( 1.352 );
	end
		
	if( LevelEventStatus( "m80 cortana defend module" ) ) then
		// 17 : Keep them away from the Module!
		sound_impulse_start ('sound\dialog\Mission\M80\m_m80_cortana_14500', NONE, 1 );
		sleep_s( 1.424 );
	end
	
	if( LevelEventStatus( "m80 cortana reinforcements" ) ) then	
		// 18 : Reinforcements!
		sound_impulse_start ('sound\dialog\Mission\M80\m_m80_cortana_14600', NONE, 1 );
		sleep_s( 0.92 );
	end

end


script continuous f_m80_vo_scientists()

	if( LevelEventStatus( "m80 scientists look out" ) ) then
		// 21 : Look out!
		sound_impulse_start ('sound\dialog\Mission\M80\m_m80_scientist_a_14700', NONE, 1 );
		sleep_s( 0.65 );
	end
	
	if( LevelEventStatus( "m80 scientists somebody" ) ) then
		// 22 : Somebody, please!
		sound_impulse_start ('sound\dialog\Mission\M80\m_m80_scientist_a_14800', NONE, 1 );
		sleep_s( 1.776 );
	end
	
	if( LevelEventStatus( "m80 scientists get to cover" ) ) then
		// 23 : Get to cover!
		sound_impulse_start ('sound\dialog\Mission\M80\m_m80_scientist_a_14900', NONE, 1 );
		sleep_s( 0.77 );
	end
	
	if( LevelEventStatus( "m80 scientists everywhere" ) ) then
		// 24 : They’re everywhere!
		sound_impulse_start ('sound\dialog\Mission\M80\m_m80_scientist_a_15000', NONE, 1 );
		sleep_s( 1.056 );
	end
	
	if( LevelEventStatus( "m80 scientists stay down" ) ) then
		// 25 : Stay down!
		sound_impulse_start ('sound\dialog\Mission\M80\m_m80_scientist_a_15100', NONE, 1 );
		sleep_s( 0.96 );
	end
	
	if( LevelEventStatus( "m80 scientists spartan" ) ) then
		// 26 : Spartan! Over here!
		sound_impulse_start ('sound\dialog\Mission\M80\m_m80_scientist_a_15200', NONE, 1 );
		sleep_s( 1.227 );
	end
	
	if( LevelEventStatus( "m80 scientists help" ) ) then
		// 27 : Help!
		sound_impulse_start ('sound\dialog\Mission\M80\m_m80_scientist_b_15300', NONE, 1 );
		sleep_s( 0.55 );
	end
	
	if( LevelEventStatus( "m80 scientists out of the way" ) ) then
		// 28 : Get out of the way!
		sound_impulse_start ('sound\dialog\Mission\M80\m_m80_scientist_b_15400', NONE, 1 );
		sleep_s( 1.035 );
	end
	
	if( LevelEventStatus( "m80 scientists evacuate" ) ) then
		// 29 : We’ve got to evacuate!
		sound_impulse_start ('sound\dialog\Mission\M80\m_m80_scientist_b_15500', NONE, 1 );
		sleep_s( 1.525 );
	end
	
	if( LevelEventStatus( "m80 scientists been shot" ) ) then
		// 30 : I think I’ve been shot!
		sound_impulse_start ('sound\dialog\Mission\M80\m_m80_scientist_b_15600', NONE, 1 );
		sleep_s( 1.667 );
	end
	
	if( LevelEventStatus( "m80 scientists what they're after" ) ) then
		// 31 : Somebody's got to know what they're after!
		sound_impulse_start ('sound\dialog\Mission\M80\m_m80_scientist_b_15700', NONE, 1 );
		sleep_s( 1.941 );
	end
	
	if( LevelEventStatus( "m80 scientists marines?" ) ) then
		// 32 : A Spartan? Are the marines here?
		sound_impulse_start ('sound\dialog\Mission\M80\m_m80_scientist_b_15800', NONE, 1 );
		sleep_s( 2.165 );
	end
	
	if( LevelEventStatus( "m80 scientists hide" ) ) then
		// 33 : Hide!
		sound_impulse_start ('sound\dialog\Mission\M80\m_m80_scientist_b_15900', NONE, 1 );
		sleep_s( 0.86 );
	end
	
	if( LevelEventStatus( "m80 scientists lost" ) ) then
		// 34 : We just lost 200-level!
		sound_impulse_start ('sound\dialog\Mission\M80\m_m80_scientist_b_16000', NONE, 1 );
		sleep_s( 1.723 );
	end
	
	if( LevelEventStatus( "m80 scientists covenant" ) ) then
		// 35 : Covenant ships!
		sound_impulse_start ('sound\dialog\Mission\M80\m_m80_scientist_b_16100', NONE, 1 );
		sleep_s( 1.179 );
	end
	
	if( LevelEventStatus( "m80 scientists hey" ) ) then
		// 36 : Hey!
		sound_impulse_start ('sound\dialog\Mission\M80\m_m80_scientist_c_16200', NONE, 1 );
		sleep_s( 0.7 );
	end
	
	if( LevelEventStatus( "m80 scientists get down" ) ) then
		// 37 : Get down, get down!
		sound_impulse_start ('sound\dialog\Mission\M80\m_m80_scientist_c_16300', NONE, 1 );
		sleep_s( 1.267 );
	end
	
	if( LevelEventStatus( "m80 scientists broken through" ) ) then
		// 38 : They’ve broken through the perimeter!
		sound_impulse_start ('sound\dialog\Mission\M80\m_m80_scientist_c_16400', NONE, 1 );
		sleep_s( 1.607 );
	end
	
	if( LevelEventStatus( "m80 scientists omg" ) ) then
		// 39 : Oh my god... please, someone...
		sound_impulse_start ('sound\dialog\Mission\M80\m_m80_scientist_c_16500', NONE, 1 );
		sleep_s( 1.648 );
	end
	
	if( LevelEventStatus( "m80 scientists help us" ) ) then
		// 40 : Help us - PLEASE!
		sound_impulse_start ('sound\dialog\Mission\M80\m_m80_scientist_c_16600', NONE, 1 );
		sleep_s( 1.531 );
	end
	
	if( LevelEventStatus( "m80 scientists covenant coming" ) ) then
		// 41 : The Covenant! They’re coming this way!
		sound_impulse_start ('sound\dialog\Mission\M80\m_m80_scientist_c_16700', NONE, 1 );
		sleep_s( 2.096 );
	end
	
	if( LevelEventStatus( "m80 scientists more guns" ) ) then
		// 42 : Hurry - there are more guns in the depot!
		sound_impulse_start ('sound\dialog\Mission\M80\m_m80_scientist_c_16800', NONE, 1 );
		sleep_s( 2.357 );
	end
	
	if( LevelEventStatus( "m80 scientists trapped" ) ) then
		// 43 : If anyone can here me, this is Brendan Nichols on the BioFarm team - we’re trapped up in Diagnostics 406! Please, if anyone can get up here - hurry!
		sound_impulse_start ('sound\dialog\Mission\M80\m_m80_scientist_c_16900', NONE, 1 );
		sleep_s( 7.835 );
	end

end


// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** TRIGGERED SFX ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================	

script static sound f_audio_airlock_compression_sfx()
	'sound\levels\solo\m45\airlock\airlock_repressurize';
end

script static sound f_audio_airlock_decompression_sfx()
	'sound\levels\solo\m45\airlock\airlock';
end

script static sound f_audio_airlock_jettison_sfx()
	'sound\environments\solo\m080\amb_m80_device_machines_specifics\m80_airlock_jettison';
end

// outer airlock open sound
script static sound f_audio_airlock_door_open_sfx()
	'sound\environments\solo\m080\amb_m80_device_machines_specifics\m80_airlock_hatch_open';
end

// outer airlock close sound
script static sound f_audio_airlock_door_close_sfx()
	'sound\environments\solo\m080\amb_m80_device_machines_specifics\m80_airlock_hatch_close';
end

script static sound f_audio_airlock_inner_door_open_sfx()
	'sound\environments\solo\m080\amb_m80_device_machines_specifics\m80_airlock_door_open';
end

script static sound f_audio_airlock_inner_door_close_end_sfx()
	'sound\environments\solo\m080\amb_m80_device_machines_specifics\m80_door_close_end';
end

script static sound f_audio_airlock_inner_door_open_end_sfx()
	'sound\environments\solo\m080\amb_m80_device_machines_specifics\m80_door_apex';
end

script static void f_audio_airlock_movement_loop_start( object the_sound_origin )
	sound_looping_start('sound\environments\solo\m080\amb_m80_device_machines_specifics\ambience\m80_door_movement_loop', the_sound_origin, 1 );
end

script static void f_audio_airlock_movement_loop_stop()
	sound_looping_stop('sound\environments\solo\m080\amb_m80_device_machines_specifics\ambience\m80_door_movement_loop');
end

script static void f_audio_airlock_decompression_warning( object the_sound_origin )
	sound_impulse_start( 'sound\game_sfx\ui\teleport_loop\teleporter_loop\loop\teleport_loop_2', the_sound_origin, 1.0 );
end

script static void f_audio_airlock_decompression( object the_sound_origin )
	sound_impulse_start( f_audio_airlock_decompression_sfx(), the_sound_origin, 1.0 );
end

script static void f_audio_airlock_repressurization( object the_sound_origin )
	sound_impulse_start( f_audio_airlock_compression_sfx(), the_sound_origin, 1 );
end

script static void f_audio_airlock_inner_door_opening_warning( object the_sound_origin )
	sound_impulse_start( 'sound\game_sfx\ui\transition_beeps', the_sound_origin, 1 );
	sleep_s( 1.0 );
	sound_impulse_start( 'sound\game_sfx\ui\transition_beeps', the_sound_origin, 1 );
	sleep_s( 1.0 );
	sound_impulse_start( 'sound\game_sfx\ui\transition_beeps', the_sound_origin, 1 );
	sleep_s( 1.0 );
end

// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** AMBIENT SFX ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================	


script static void f_sound_mode_normal_G()
	
	//dprint( "Setting sound mode to: Normal Gravity" );
	sound_impulse_start( 'sound\storm\states\zero_g\set_state_high_gravity', NONE, 1 );								// Normal, no fx applied
	
end


script static void f_sound_mode_low_G()
	
	//dprint( "Setting sound mode to: Low Gravity" );
	sound_impulse_start( 'sound\storm\states\zero_g\set_state_low_gravity', NONE, 1 );							// Low gravity, moderate fx applied

end


script static void f_sound_mode_zero_G()
	
	//dprint( "Setting sound mode to: Zero Gravity" );
	sound_impulse_start( 'sound\storm\states\zero_g\set_state_no_gravity', NONE, 1 );									// Zero G, full fx applied
	
end


// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** MUSIC ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================
script static void f_mus_m80_e01_begin()
	music_set_state('Play_mus_m80_e01_horseshoe' );
end

script static void f_mus_m80_e01_horseshoe_shield_activated()
	music_set_state('Play_mus_m80_e01a_horseshoe_shield_activated' );
end

script static void f_mus_m80_e02_begin()
	music_set_state('Play_mus_m80_e03_lab' );
end

script static void f_mus_m80_e03_begin()
	//dprint("f_mus_m80_e03_begin" );
	music_set_state('Play_mus_m80_e05_hallway1_airlock1' );
end

script static void f_mus_m80_e04_begin()
	music_set_state('Play_mus_m80_e06_hallway1_airlock1' );
end

script static void f_mus_m80_e05_begin()
	//dprint("f_mus_m80_e05_begin" );
	music_set_state('Play_mus_m80_e07_hallway2_airlock2' );
end

script static void f_mus_m80_e06_begin()
	music_set_state('Play_mus_m80_e07_hallway2_airlock2' );
end

//script static void f_mus_m80_e07_begin()
	//dprint("f_mus_m80_e07" );
//end

script static void f_mus_m80_e08_begin()
	music_set_state('Play_mus_m80_e09_guns_hallway' );
end

script static void f_mus_m80_e09_begin()
	music_set_state('Play_mus_m80_e11_atrium_return' );
end

//script static void f_mus_m80_e10_begin()
	//dprint("f_mus_m80_e10" );
//end

//script static void f_mus_m80_e11_begin()
	//dprint("f_mus_m80_e11" );
//end

//script static void f_mus_m80_e12_begin()
	//dprint("f_mus_m80_e12" );
//end

script static void f_mus_m80_e01_finish()
	music_set_state('Play_mus_m80_e02_horseshoe_end' );
end

script static void f_mus_m80_e02_finish()
	music_set_state('Play_mus_m80_e04_lab_end' );
end

script static void f_mus_m80_e03_finish()
	//dprint("f_mus_m80_e03_finish" );
	music_set_state('Play_mus_m80_e05_hallway1_airlock1_end' );
end

script static void f_mus_m80_e04_finish()
	music_set_state('Play_mus_m80_e06_hallway1_airlock1_end' );
end

script static void f_mus_m80_e05_finish()
	//dprint("f_mus_m80_e05_finish" );
	music_set_state('Play_mus_m80_e07_hallway2_airlock2_end' );
end

script static void f_mus_m80_e06_finish()
	music_set_state('Play_mus_m80_e08_hallway2_airlock2_end' );
end

//script static void f_mus_m80_e07_finish()
	//dprint("f_mus_m80_e07" );
//end

script static void f_mus_m80_e08_finish()
	//dprint("f_mus_m80_e08" );
	music_set_state('Play_mus_m80_e10_guns_hallway_end' );
end

script static void f_mus_m80_e09_finish()
	//dprint("f_mus_m80_e09" );
	music_set_state('Play_mus_m80_e12_atrium_return_end' );
end

//script static void f_mus_m80_e10_finish()
	//dprint("f_mus_m80_e10" );
//end

//script static void f_mus_m80_e11_finish()
	//dprint("f_mus_m80_e11" );
//end

//script static void f_mus_m80_e12_finish()
	//dprint("f_mus_m80_e12" );
//end

script static void f_music_m80_tweak01()
	//dprint("f_music_m80_tweak01");
	music_set_state('Play_mus_m80_t01_tweak');
end

script static void f_music_m80_tweak02()
	//dprint("f_music_m80_tweak02");
	music_set_state('Play_mus_m80_t02_tweak');
end

script static void f_music_m80_tweak03()
	//dprint("f_music_m80_tweak03");
	music_set_state('Play_mus_m80_t03_tweak');
end

script static void f_music_m80_tweak04()
	//dprint("f_music_m80_tweak04");
	music_set_state('Play_mus_m80_t04_tweak');
end

script static void f_music_m80_tweak05()
	//dprint("f_music_m80_tweak05");
	music_set_state('Play_mus_m80_t05_tweak');
end

script static void f_music_m80_tweak06()
	//dprint("f_music_m80_tweak06");
	music_set_state('Play_mus_m80_t06_tweak');
end

script static void f_music_m80_tweak07()
	//dprint("f_music_m80_tweak07");
	music_set_state('Play_mus_m80_t07_tweak');
end

script static void f_music_m80_tweak08()
	//dprint("f_music_m80_tweak08");
	music_set_state('Play_mus_m80_t08_tweak');
end

script static void f_music_m80_tweak09()
	//dprint("f_music_m80_tweak09");
	music_set_state('Play_mus_m80_t09_tweak');
end

script static void f_music_m80_tweak10()
	//dprint("f_music_m80_tweak10");
	music_set_state('Play_mus_m80_t10_tweak');
end

// this will always be 0 unless an insertion point is used
// in that case, it is used to skip past the trigger volumes that precede the selected insertion point
global short b_m80_music_progression = 0;

script static void load_music_for_zone_set()
	sleep_until(b_m80_music_progression > 0 or current_zone_set_fully_active() == S_ZONESET_CRASH, 1);
	music_start('Play_mus_m80');

	// sleep_until(b_m80_music_progression > 10 or volume_test_players (tv_music_r01_start_lich), 1);
	if b_m80_music_progression <= 10 then
		music_set_state('Play_mus_m80_r01_start_lich' );
	end

	sleep_until(b_m80_music_progression > 20 or volume_test_players (tv_music_r02_crash), 1);
	if b_m80_music_progression <= 20 then
		sound_set_state('Set_State_M80_crash'); 
		music_set_state('Play_mus_m80_r02_crash' );
	end
	
	sleep_until(b_m80_music_progression > 30 or volume_test_players (tv_music_r03_to_horseshoe), 1);
	if b_m80_music_progression <= 30 then
		sound_set_state('Set_State_M80_to_horseshoe'); 
		music_set_state('Play_mus_m80_r03_to_horseshoe');
	end
	
	sleep_until(b_m80_music_progression > 40 or volume_test_players (tv_music_r04_horseshoe), 1);
	if b_m80_music_progression <= 40 then
		sound_set_state('Set_State_M80_horseshoe'); 
		music_set_state('Play_mus_m80_r04_horseshoe' );
	end
	
	sleep_until(b_m80_music_progression > 50 or volume_test_players (tv_music_r05_to_lab), 1);
	if b_m80_music_progression <= 50 then
		sound_set_state('Set_State_M80_to_lab'); 
		music_set_state('Play_mus_m80_r05_to_lab' );
	end
	
	sleep_until(b_m80_music_progression > 60 or volume_test_players (tv_music_r06_lab), 1);
	if b_m80_music_progression <= 60 then
		sound_set_state('Set_State_M80_lab'); 
		music_set_state('Play_mus_m80_r06_lab' );
	end
	
	// sleep_until(b_m80_music_progression > 70 or volume_test_players (tv_music_r01_start_lich), 1);
	// if b_m80_music_progression <= 70 then
	// 	sound_set_state('Set_State_M80_lab'); 
	// 	music_set_state('Play_mus_m80_r06_lab' );
	// end
	
	// RALLY POINT BRAVO
	sleep_until(b_m80_music_progression > 80 or volume_test_players (tv_music_r09_atrium), 1);
	if b_m80_music_progression <= 80 then
		sound_set_state('Set_State_M80_atrium'); 
		music_set_state('Play_mus_m80_r09_atrium' );
	end
	
	sleep_until(b_m80_music_progression > 90 or volume_test_players (tv_music_r21_atrium_hub), 1);
	if b_m80_music_progression <= 90 then
		sound_set_state('Set_State_M80_atrium_hub'); 
		music_set_state('Play_mus_m80_r21_atrium_hub' );
	end
	
	sleep_until(b_m80_music_progression > 110 or volume_test_players (tv_music_r10_to_airlock_one), 1);
	if b_m80_music_progression <= 110 then
		sound_set_state('Set_State_M80_to_airlock_one'); 
		music_set_state('Play_mus_m80_r10_to_airlock_one' );
	end

	sleep_until(b_m80_music_progression > 120 or volume_test_players (tv_music_r11_to_airlock_one_b), 1);
	if b_m80_music_progression <= 120 then
		sound_set_state('Set_State_M80_airlock_one_b'); 
		music_set_state('Play_mus_m80_r11_to_airlock_one_b' );
	end
	
	sleep_until(b_m80_music_progression > 130 or volume_test_players (tv_music_r12_airlock_one), 1);
	if b_m80_music_progression <= 130 then
		sound_set_state('Set_State_M80_airlock_one'); 
		music_set_state('Play_mus_m80_r12_airlock_one' );
	end
	
	sleep_until(b_m80_music_progression > 140 or volume_test_players (tv_music_r13_to_airlock_two), 1);
	if b_m80_music_progression <= 140 then
		sound_set_state('Set_State_M80_to_airlock_two'); 
		music_set_state('Play_mus_m80_r13_to_airlock_two' );
	end
	
	sleep_until(b_m80_music_progression > 150 or volume_test_players (tv_music_r15_to_lookout), 1);
	if b_m80_music_progression <= 150 then
		sound_set_state('Set_State_M80_to_lookout'); 
		music_set_state('Play_mus_m80_r15_to_lookout' );
	end
	
	sleep_until(b_m80_music_progression > 160 or volume_test_players (tv_music_r16_lookout), 1);
	if b_m80_music_progression <= 160 then
		sound_set_state('Set_State_M80_lookout'); 
		music_set_state('Play_mus_m80_r16_lookout' );
	end
	
	sleep_until(b_m80_music_progression > 170 or volume_test_players (tv_music_r17_turrets), 1);
	if b_m80_music_progression <= 170 then
		sound_set_state('Set_State_M80_turrets'); 
		music_set_state('Play_mus_m80_r17_turrets' );
	end
	
	sleep_until(b_m80_music_progression > 180 or volume_test_players (tv_music_r18_atrium_return), 1);
	if b_m80_music_progression <= 180 then
		sound_set_state('Set_State_M80_return'); 
		music_set_state('Play_mus_m80_r18_atrium_return' );
	end
	
	sleep_until(b_m80_music_progression > 190 or volume_test_players (tv_music_r19_atrium_damaged), 1);
	if b_m80_music_progression <= 190 then
		sound_set_state('Set_State_M80_atrium_damaged'); 
		music_set_state('Play_mus_m80_r19_atrium_damaged' );
	end
	
	// sleep_until(b_m80_music_progression > 200 or volume_test_players (tv_music_r20_mechroom_return), 1);
	// if b_m80_music_progression <= 200 then
	// 	sound_set_state('Set_State_M80_mechroom_return'); 
	// 	music_set_state('Play_mus_m80_r20_mechroom_return' );
	// end
	
	sleep_until(b_m80_music_progression > 210 or volume_test_players (tv_music_r22_composer_removal), 1);
	if b_m80_music_progression <= 210 then
		sound_set_state('Set_State_M80_composer_removal'); 
		music_set_state('Play_mus_m80_r22_composer_removal' );
	end	
	
	sleep_until(current_zone_set_fully_active() == S_ZONESET_CIN_M83, 1);
		music_stop('Stop_mus_m80'); 
end

// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** AMBIENCE ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================
//script static void f_sfx_crash_start()
	//dprint("[amb] amb_m80_interior_baseair started" );
	//sound_looping_start('sound\environments\solo\m080\ambience\amb_m80_interior_baseair', NONE, 1 );
//end

//script static void f_audio_station_amb_stop()
  //dprint("[amb] amb_m80_interior_baseair stopped" );
	//sound_looping_stop('sound\environments\solo\m080\ambience\amb_m80_interior_baseair' );
//end

// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** MISSION SHAKES ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================

script static sound f_sfx_mission_shake_low_01()
	'sound\environments\solo\m080\amb_m80_device_machines_specifics\m80_impact_screenshake_low_01.sound';
end

script static sound f_sfx_mission_shake_low_02()
	'sound\environments\solo\m080\amb_m80_device_machines_specifics\m80_impact_screenshake_low_02.sound';
end

script static sound f_sfx_mission_shake_low_03()
	'sound\environments\solo\m080\amb_m80_device_machines_specifics\m80_impact_screenshake_low_03.sound';
end

script static sound f_sfx_mission_shake_low_04()
	'sound\environments\solo\m080\amb_m80_device_machines_specifics\m80_impact_screenshake_low_04.sound';
end

script static sound f_sfx_mission_shake_low_05()
	'sound\environments\solo\m080\amb_m80_device_machines_specifics\m80_impact_screenshake_low_05.sound';
end

script static sound f_sfx_mission_shake_medium_01()
	'sound\environments\solo\m080\amb_m80_device_machines_specifics\m80_impact_screenshake_med_01.sound';
end

script static sound f_sfx_mission_shake_medium_02()
	'sound\environments\solo\m080\amb_m80_device_machines_specifics\m80_impact_screenshake_med_02.sound';
end

script static sound f_sfx_mission_shake_medium_03()
	'sound\environments\solo\m080\amb_m80_device_machines_specifics\m80_impact_screenshake_med_03.sound';
end

script static sound f_sfx_mission_shake_medium_04()
	'sound\environments\solo\m080\amb_m80_device_machines_specifics\m80_impact_screenshake_med_04.sound';
end

script static sound f_sfx_mission_shake_high_01()
	'sound\environments\solo\m080\amb_m80_device_machines_specifics\m80_impact_screenshake_high_01.sound';
end

script static sound f_sfx_mission_shake_high_02()
	'sound\environments\solo\m080\amb_m80_device_machines_specifics\m80_impact_screenshake_high_02.sound';
end

script static sound f_sfx_mission_shake_high_03()
	'sound\environments\solo\m080\amb_m80_device_machines_specifics\m80_impact_screenshake_high_03.sound';
end

script static sound f_sfx_mission_shake_high_04()
	'sound\environments\solo\m080\amb_m80_device_machines_specifics\m80_impact_screenshake_high_04.sound';
end

// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** ATRIUM ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================

script static sound f_sfx_atrium_shuttle_destruction_first()
	'sound\environments\solo\m080\amb_m80_device_machines_specifics\m80_exp_atrium_shuttle_destruction.sound';
end

script static sound f_sfx_unsc_communication_tower_rotate_start()
	'sound\environments\solo\m080\amb_m80_device_machines_specifics\ambience\events\unsc_communication_tower_loop_in.sound';
end

script static sound f_sfx_unsc_communication_tower_rotate_stop()
	'sound\environments\solo\m080\amb_m80_device_machines_specifics\ambience\events\unsc_communication_tower_loop_out.sound';
end


// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** HALLWAYS ONE ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================

script static sound f_sfx_hallways_one_power_loss_start()
	'sound\environments\solo\m080\amb_m80_device_machines_specifics\m80_power_loss.sound';
end

script static sound f_sfx_hallways_one_power_loss_end()
	'sound\environments\solo\m080\amb_m80_device_machines_specifics\m80_power_on.sound';
end


// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** ELEVATOR ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================

// Play sound/music for when the atrium elevator starts to move
script static void f_sfx_elevator_start()
	music_set_state( 'Play_mus_m80_v34_atrium_destruction' );
	sound_looping_start( 'sound\environments\solo\m080\amb_m80_device_machines_specifics\ambience\amb_m80_elevator_loop', NONE, 1.0 );
	sound_impulse_start( 'sound\environments\solo\m080\amb_m80_device_machines_specifics\amb_m80_elevator_crane_shift_crash', mrk_atrium_destruction, 1.0 );

end

script static void f_sfx_elevator_restart()
	sound_looping_start( 'sound\environments\solo\m080\amb_m80_device_machines_specifics\ambience\amb_m80_elevator_loop', NONE, 1.0 );
end

script static void f_sfx_elevator_stop()
	sound_looping_stop( 'sound\environments\solo\m080\amb_m80_device_machines_specifics\ambience\amb_m80_elevator_loop');
end
