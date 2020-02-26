#include maps\_utility;


	
autoexec init()
{
	setup_extracam();
}


#define CLIENT_FLAG_EXTRA_CAM 1
#define CLIENT_FLAG_GLASSES_CAM 2

//create an script origin to function as extra cam
setup_extracam()
{
	if( !Isdefined( level.e_extra_cam ))
	{
		level.e_extra_cam = spawn("script_model", (0, 0, 0) );
		level.e_extra_cam setmodel( "tag_origin" );
		level.e_extra_cam.angles = (0, 0, 0 );
	}	
}


//grab the current extracam in play, if somehow the extracam is deleted, create an new one.
get_extracam()
{
	assert( isdefined( level.e_extra_cam ), "You are missing the extra_cam entity, something must gone wrong");
	
	if( isdefined( level.e_extra_cam ) )
	{
		return level.e_extra_cam;
	}
}

//turn on the extracam
turn_on_extra_cam()
{
	assert( isdefined( level.e_extra_cam ), "level.e_extra_cam isn't defined, call _glasses::main" );
	level.e_extra_cam SetClientFlag( CLIENT_FLAG_GLASSES_CAM );
}


//turn off the extracam
turn_off_extra_cam()
{
	assert( isdefined( level.e_extra_cam ), "level.e_extra_cam isn't defined, call _glasses::main" );
	level.e_extra_cam ClearClientFlag( CLIENT_FLAG_GLASSES_CAM );

}


///////////////////
//Play a bink movie in a correct location on hud.
//Bink_name : string name of the bink movie. Mandatory
//Everything else below is Optional
//Duration : How long do you want to bink to play before closing the bink, automatically toggle on looping if duration is set.
//is_looping: boolean, whether or not to loop the bink movie, if this is true, an endon_notify must be passed in, send that notify to self to end the bink.
//is_in_memory: A boolean  - true if the bik is packed into a fast file (default = false).  If true, put the movie in share/raw/bik and add the line rawfile,bik/yourmovie.bik to your zone_source csv.  If false, put the file in share/discdata/video and do nothing in your zone_source csv.
//endon_notify: this must be set if you set is_looping to true, a notify to end the bink.
play_bink_on_hud_glasses( bink_name, duration, is_looping, is_in_memory, endon_notify )
{
	assert( IsDefined( bink_name ), "Undefined Bink name" );

	if( isdefined( is_looping ) )
	{
		assert( IsDefined( endon_notify ) , "if is a looping cinematic, then an endon notify must be defined" );
	}

	if( isdefined( duration ) )
	{
		is_looping = true;
	}

	if( !isdefined( is_looping ) )
	{
		is_looping = false;	
	}

	if( !isdefined(is_in_memory ) )
	{
		is_in_memory = false;	
	}

	temp_hud = create_on_screen_bink_hud(515, 20, 200, 175, "mtl_karma_retina_bink");	
		
	Start3DCinematic(bink_name, is_looping, is_in_memory);

	if( isdefined( duration ) )
	{
		wait(duration);
	}
	else if( isdefined( is_looping ) && is_looping != false )
	{
		self waittill(endon_notify);
	}
	else
	{
		level waittill("cine_notify", num);
		duration = GetCinematicTimeRemaining();
		wait(duration);
	}

		Stop3DCinematic();
		temp_hud destroy();
}

create_on_screen_bink_hud( x, y, width, height, material)
{
	movie_hud = NewHudElem();
	movie_hud.x = x;
	movie_hud.y = y;
	movie_hud.foreground = false; //Arcade Mode compatible
	movie_hud.sort = 0;
	movie_hud.alpha = 1;
	
	movie_hud SetShader( material, width, height );	
	
	return movie_hud;
}

