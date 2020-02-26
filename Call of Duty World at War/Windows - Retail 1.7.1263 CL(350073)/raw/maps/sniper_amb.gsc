#include maps\_utility;
#include maps\_ambientpackage;
#include maps\_music;

main()
{

	
	
	activateAmbientRoom( "outdoors_room", 0 );
	activateAmbientPackage( "outdoors_pkg", 0 );
	level thread play_clock_sounds();
	level thread play_air_raid_scene(30);
	level thread player_air_raid_timer();
	level thread play_quad_fly();
	
}
sound_follow_plane( planes, offset ) 
{ 
      org1 = Spawn( "script_origin", planes.origin + offset );  
      org1 PlaySound( "bombers_low_left" );
		
      org2 = Spawn( "script_origin", planes.origin + offset );  
      org2 PlaySound( "bombers_low_right" );

      while( IsDefined( planes ) ) 
      { 
           org1 MoveTo( planes.origin + offset, (0.25, 0, 0 )); 
		   org2 MoveTo( planes.origin + offset, (0.00, 0.25, 0) ); 
           wait( 0.25 ); 
      } 
  
    //  org waittill( "sounddone" ); 
    //  org Delete(); 
}
plane_shockwave()
{
	//wait (6);
	
	//TUEY Set's Music to BOMBER
	//setmusicstate("BOMBER");
	
	self endon ("death");
	
	origin_left = getent("bombers_low_left", "targetname");
	origin_right = getent("bombers_low_right", "targetname");
	target_left = getent(origin_left.target, "targetname");
	target_right = getent(origin_right.target, "targetname");

	while (distancesquared(origin_left.origin, self.origin) > 8000 * 8000)
	 {
	      wait( 0.1 );
	 }
	
	
	ent1 = spawn("script_origin", origin_left.origin);
	//ent1 thread line_to_me(origin_left);
	ent2 = spawn("script_origin", origin_right.origin);
	//ent2 thread line_to_me(origin_right);
	
	

	ent1 playsound ("bombers_low_left", "sound_done");
	ent2 playsound ("bombers_low_right", "sound_done");
	
	ent1 moveto (target_left.origin, 25);
	ent2 moveto (target_right.origin, 25);
	
	// Delete Entities when planes go by
	ent1 waittill ("sound_done");
	ent1 delete();
	ent2 delete();




}
line_to_me(guy)
{
	self endon( "death" );
	self endon ("movedone");
	while (1)
	{
		line (self.origin, guy.origin, (0,1,1));
		wait 0.05;
	}
	
}
play_low_plane_sounds(mph)
{
	self endon ("death");
	
	//plane endon (""); //TO DO Add endon if a plane gets to its end node
	level thread play_air_raid_scene(13);
	players = get_players();	
		
	miles = mph;
	units = miles * 63360;
	seconds_per_hour = 3600;
	ups = units / seconds_per_hour;
	seconds_before_plane_overhead = 6;
	distance_to_play_sound = ups * seconds_before_plane_overhead;

	while(distancesquared(self.origin, players[0].origin) > distance_to_play_sound * distance_to_play_sound)
	{
		wait( 0.1 );
	}
	
	self playloopsound ("low_flying_plane");
	wait (13);
	
	self stoploopsound();
	self waittill ("death");


}


mph_to_ups(mph)
{
	miles = mph;
	units = miles * 63360;
	seconds_per_hour = 3600;
	ups = units / seconds_per_hour;
	seconds_before_plane_overhead = 6;
	distance_to_play_sound = ups * seconds_before_plane_overhead;
}
play_fire_sounds()
{
	playsoundatposition ("fire_ignite",(0,0,0));
	fire_sounds = getentarray( "fire_origin", "targetname" );
	for( i  = 0; i < fire_sounds.size; i++ )
	{
		fire_sounds[i] playloopsound ("large_fire_building");
	
	}
}
play_clock_sounds()
{
	level.clock = getstruct("clock_origin", "targetname");
	
	ent_clock = spawn("script_origin", level.clock.origin);
	ent_clock playloopsound("amb_clock_tick_scripted");
	
	level waittill("dog_is_coming" );
	play_clock_gongs();

}
play_clock_gongs()
{
	
	
	ent1 = spawn("script_origin", level.clock.origin);
	wait(9);
	ent1 playsound ("amb_clock_gong", "sound_done");
	ent1 waittill ("sound_done");
	ent1 delete();

}
play_house_debris_sounds(spots)
{
		ent_audio = spawn ("script_origin", self.origin);
		ent_audio playsound ("wall_impact", "sound_done");
		ent_audio waittill("sound_done");
		ent_audio delete();
}
play_air_raid_scene(time)
{
	wait (time);
	level endon("siren_done_playing");
	ent1 = spawn ("script_origin", (-3059, -4365, 272));
	counter = 0;
	level thread play_distant_bombs(10);

	while (counter < 3)
	{
		counter = counter + 1;
		ent1 playsound ("amb_stalin_air_raid", "sound_done");
		ent1 waittill ("sound_done");			

	}
	wait(2.0);
	ent1 delete();	
	level notify ("siren_done_playing");
	
	

}
play_distant_bombs(time)
{
	wait (time);
	number_of_bombs = randomintrange(5,15);
	number_of_bombs_counter = 0;
	while (number_of_bombs_counter < number_of_bombs)
	{
		number_of_bombs_counter = number_of_bombs_counter + 1;
		playsoundatposition ("bomb_far_scripted", (-3059, -4365, 272));
		wait (randomfloatrange (0.2, 4));
		
	}

	

}
player_air_raid_timer()
{
	level waittill("go_go_ambient_planes");

	while(1)
	{
		time = randomintrange(10,20);
		plane_chance = randomintrange(0,2);
		number_of_planes = randomintrange(2,4);		
		if (plane_chance == 1)
		{
			times_to_play = (randomintrange (2, 4));
			play_ambient_planes(number_of_planes);
			level thread play_air_raid_scene(time);	
		}

		wait(15);

	}

}
play_ambient_planes(number_of_planes)
{
		origin_left = getent("bombers_low_left", "targetname");
		origin_right = getent("bombers_low_right", "targetname");
		target_left = getent(origin_left.target, "targetname");
		target_right = getent(origin_right.target, "targetname");

		for ( i =0; i < number_of_planes; i++)
		{
	
			wait(2);
			ent1 = spawn("script_origin", origin_left.origin);		
			ent2 = spawn("script_origin", origin_right.origin);
		
			ent1 playsound ("bombers_low_left_scripted", "sound_done");
			ent2 playsound ("bombers_low_left_scripted", "sound_done");
		
			ent1 moveto (target_left.origin, 25);
			ent2 moveto (target_right.origin, 25);
		
			// Delete Entities when planes go by
			ent1 waittill ("sound_done");
			ent1 delete();
			ent2 delete();

		}

	

}
change_music_state_delay(delaytime, statename)
{
	wait(delaytime);
	setmusicstate(statename);

}
play_random_crow_sounds(crow)
{
	level endon ("crow_flyaway");
	while (1)
	{
		wait randomintrange(1,4);
		crow playsound ("amb_raven");
	}

}
play_quad_fly()
{

	while(1)
	{
		wait(randomintrange(10,60));
		playsoundatposition("quad_fly", (0,0,0));
	}


}