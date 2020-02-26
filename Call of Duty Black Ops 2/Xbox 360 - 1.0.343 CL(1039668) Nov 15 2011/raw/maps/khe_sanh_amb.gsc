//////////////////////////////////////////////////////////
//
// khe_sanh_amb.gsc
// description: level ambience script for khe_sanh
// scripter: 
//
/////////////////////////////////////////////////////////

#include maps\_ambientpackage;
#include maps\_music;
#include common_scripts\utility;
#include maps\_utility;


main()
{
	
	wait_for_first_player();	
	
 	level thread play_intro_alarm();
 	level thread play_go_go_go();
 	level thread m60_turret_audio_thread();

}
play_intro_music()
{
	//Clears Snapshot
	clientnotify ("ints");
	wait(0.5);
	level thread play_radio();	
}
play_radio()
{
	radio = getent ("tent_radio", "targetname");
	radio playsound ("mus_creedence_intro_radio");
	wait (20);	
	//Clears Snapshot
	clientnotify ("intn");
	wait (0.8);
	setmusicstate ("JEEP_RIDE");
	
	
}
play_intro_alarm()
{
	while(1)
	{
		playsoundatposition ("amb_alarm", (-5799, 4228, 154));	
		wait(2);
		
	}	
	
}
play_go_go_go()
{
	level.timing_thingy = 0;
	while (level.timing_thingy  < 10)
	{
		rand = randomintrange (0, 1);
		if (rand == 0)
		{
			playsoundatposition ("vox_khe1_s01_500_us0", (-7592, 4608, -64));
		}
		else
		{
			playsoundatposition ("vox_khe1_s01_501_us0", (-7592, 4608, -64));
		}
		wait randomintrange(6,12);
		level.timing_thingy  = level.timing_thingy  + 1;
		
	}		
		
	
}

m60_turret_audio_thread()
{
	m60_ent = getentarray( "m60_khe_sanh" , "script_noteworthy" );
	if(IsDefined(m60_ent))
	{
		for ( i = 0; i < m60_ent.size; i++ )
		{
			m60_ent[i] thread m60_turret_audio( "wpn_m60_turret_fire_loop_plr" , "wpn_m60_turret_fire_loop_ring_plr" , "wpn_m60_turret_fire_loop_npc" , "wpn_m60_turret_fire_loop_ring_npc" );
		}
	}
}

m60_turret_audio( alias1 , alias2 , alias3 , alias4 )//1= plr loop 2 = plr ringoff 3 = npc loop 4 = npc ringoff
{
	self endon( "death" );
	player = get_players()[0];
	while(1)
	{
		//PrintLn("M60 0");
		turret_user = self GetTurretOwner();
		if( (Player.usingturret) && IsDefined(turret_user) && (turret_user == player) )
		{
			weapon_overheating = player isWeaponOverheating();
			while( (Player.usingturret) && (!player AttackButtonPressed() || weapon_overheating) )//waiting while you are on turret and not firing or overheating
			{
				//PrintLn("M60 1");
				weapon_overheating = player isWeaponOverheating();
				wait( 0.05 );
			}
			while( (Player.usingturret) && player AttackButtonPressed() && !weapon_overheating )// firing turret
			{
				//PrintLn("M60 2 " + player.usingturret + " " + player attackbuttonpressed() + " " + weapon_overheating);
				weapon_overheating = player isWeaponOverheating();
				player playloopsound( alias1 );
				wait( 0.05 );
			}
			if( (Player.usingturret) && !player AttackButtonPressed() )//if the player lets go of the trigger
			{
				//PrintLn("M60 3");
				player stoploopsound();
				player playsound( alias2 );
				wait_network_frame();
			}
			else if( (!Player.usingturret) && player AttackButtonPressed() )//this is if you are hollding the trigger and press x to get off the turret
			{
				//PrintLn("M60 4");
				player stoploopsound();
				player playsound( alias2 );
			}
			else if( (Player.usingturret) && player AttackButtonPressed()&& weapon_overheating )//this is for overheat
			{
				//PrintLn("M60 5");
				player stoploopsound();
				player playsound( alias2 );
				player playsound( "wpn_turret_overheat_plr" );
				while( weapon_overheating )//waits for overheat to finish
				{
					weapon_overheating = player isWeaponOverheating();
					wait( 0.05 );
				}
			}
			if( (!Player.usingturret))//this is a special case that covers the time that it takes to recognize your not on the turret.
			{
				//PrintLn("M60 6");
				player stoploopsound();
			}
		}
		while( IsTurretActive( self ) && (!Player.usingturret) )
		{
			//PrintLn("spawn");
			sound_ent = spawn( "script_origin" , self.origin);
			while(!IsTurretFiring( self ))
			{
				//PrintLn("M60 0");
				wait( 0.05 );
			}
			while(IsTurretFiring( self ))
			{
				//PrintLn("M60 1");
				sound_ent playloopsound( alias3 );
				wait( 0.05 );
			}
			//PrintLn("delete");
			playsoundatposition( alias4 , self.origin );
			sound_ent Delete();
			wait_network_frame();
			
		}
		wait( 0.05 );	
	}
}
