// module_covernodes_utility.gsc

#include maps\_utility;
#include common_scripts\utility;
#include maps\feature_utility;

main()
{
	precacheItem("crossbow_sp");
	precacheItem("crossbow_explosive_alt_sp");
	precacheItem("crossbow_vzoom_alt_sp");
	precacheItem("explosive_bolt_sp");
	precacheItem("china_lake_sp");

	maps\feature_utility::add_ai_animtype( "default", character\c_rus_military1::main, character\c_rus_military1::precache );
	maps\feature_utility::add_ai_animtype( "spetsnaz", character\c_rus_spetznaz_1::main, character\c_rus_spetznaz_1::precache );

	maps\_load::main();

	level.title_screen[ "title" ] = "Cover node tutorial";
	level.title_screen[ "desc" ][ 0 ] = "This map shows every type of cover node available in the game.";
	level.title_screen[ "desc" ][ 1 ] = "You can also see build standards for use in your own map, ";
	level.title_screen[ "desc" ][ 2 ] = "and examples where AI looks good using each type of cover.";
	//level.title_screen[ "bullets" ][ 0 ] = "";
	
	//to use this util func the trigger needs to be named "trig_" + spawner.targetname
	
	//spawn_area_detailed(area, func, narration_text)
	level thread spawn_area_detailed("node_concealment_crouch",		::goto_cover,							concealment_crouch_text() );
	level thread spawn_area_detailed("node_concealment_prone",		::goto_cover,							concealment_prone_text() );
	level thread spawn_area_detailed("node_concealment_stand",		::goto_cover,							concealment_stand_text() );
	level thread spawn_area_detailed("node_cover_crouch",			::goto_cover,							cover_crouch_text() );
	level thread spawn_area_detailed("node_cover_crouch_window",	::goto_cover,							cover_crouch_window_text() );
	level thread spawn_area_detailed("node_cover_prone",			::goto_cover,							cover_prone_text() );
	level thread spawn_area_detailed("node_cover_right",			::goto_cover,							cover_right_text() );
	level thread spawn_area_detailed("node_cover_left",				::goto_cover,							cover_left_text() );
	level thread spawn_area_detailed("node_cover_stand",			::goto_cover,							cover_stand_text() );
	level thread spawn_area_detailed("node_cover_right_crouch",		::goto_cover,							cover_right_crouch_text() );
	level thread spawn_area_detailed("node_cover_left_crouch",		::goto_cover,							cover_left_crouch_text() );
	level thread spawn_area_detailed("node_balcony",				maps\module_covernodes::balcony_nodes,	cover_balcony_text() );
	level thread spawn_area_detailed("node_balcony_norailing",		maps\module_covernodes::balcony_nodes,	cover_balcony_norailing_text() );
	level thread spawn_area_detailed("node_guard_stand",			::goto_cover,							guard_stand_text() );
	level thread spawn_area_detailed("node_guard_crouch",			::goto_cover,							guard_crouch_text() );
	level thread spawn_area_detailed("node_turret",					::goto_cover,							turret_text() );
	level thread spawn_area_detailed("node_turret_prone",			::goto_cover,							turret_prone_text() );
	level thread spawn_area_detailed("node_pillar_stand",			::goto_cover,							pillar_stand_text() );
	level thread spawn_area_detailed("node_pillar_crouch",			::goto_cover,							pillar_crouch_text() );

	level.enable_player_vulnerability = true;
	level.friendlyFireDisabled = true;

	wait_for_first_player();
	level.test_player = get_players()[0];

	level.test_player GiveWeapon("crossbow_sp");
	level.test_player GiveWeapon("crossbow_vzoom_alt_sp");
	level.test_player GiveWeapon("crossbow_explosive_alt_sp");
	level.test_player GiveWeapon("china_lake_sp");

	feature_start();

	//anim.throwGrenadeAtPlayerASAP = true;
}

concealment_crouch_text()
{
	text = [];
	text[ "title" ] = "concealment_crouch nodes";
	text[ "desc" ][ 0 ] = "Build standard for crouch cover: 36 units high, 32 units wide.";
	text[ "bullets" ][ 0 ] = "Concealment nodes are best used when AI is behind non-flat cover.";
	text[ "bullets" ][ 1 ] = "AI will never play 'leaning' type animations for concealment type cover.";
	
	return text;	
}
concealment_prone_text()
{
	text = [];
	text[ "title" ] = "concealment_prone nodes";
	text[ "desc" ][ 0 ] = "Build standard for prone cover: 16 units high, or 32 units open underneath";
	text[ "bullets" ][ 0 ] = "Concealment nodes are best used when AI is behind non-flat cover.";
	text[ "bullets" ][ 1 ] = "AI will never play 'leaning' type animations for concealment type cover.";	
	
	return text;		
}

concealment_stand_text()
{
	text = [];
	text[ "title" ] = "concealment_stand nodes" ;
	text[ "desc" ][ 0 ] = "Build standard for standing cover: 48 units high, 32 units wide";
	text[ "bullets" ][ 0 ] = "Concealment nodes are best used when AI is behind non-flat cover.";
	text[ "bullets" ][ 1 ] = "AI will never play 'leaning' type animations for concealment type cover.";
	
	return text;		
}

cover_crouch_text()
{
	text = [];
	text[ "title" ] = "cover_crouch nodes";
	text[ "desc" ][ 0 ] = "Build standard for crouch cover: 36 units high, 32 units wide";
	text[ "bullets" ][ 0 ] = "'Cover' node types should be used against flat surfaces.";
	text[ "bullets" ][ 1 ] = "AI will play leaning animations when these nodes are used.";
	
	return text;		
}

cover_crouch_window_text()
{
	text = [];
	text[ "title" ] =  "crouch_cover_window nodes";
	text[ "desc" ][ 0 ] = "Build standard for window cover: 36 units high, 40 units wide";
	text[ "bullets" ][ 0 ] = "'Cover' node types should be used against flat surfaces.";
	text[ "bullets" ][ 1 ] = "AI will play leaning animations when these nodes are used.";
	text[ "bullets" ][ 2 ] = "Windows can be a good place to use balcony deaths!";
	
	return text;		
}

cover_prone_text()
{
	text = [];
	text[ "title" ] =  "cover_prone nodes";
	text[ "desc" ][ 0 ] = "Build standard for prone cover: 16 units high, or 32 units open underneath";
	text[ "bullets" ][ 0 ] = "'Cover' node types should be used against flat surfaces.";
	text[ "bullets" ][ 1 ] = "AI will play leaning animations when these nodes are used.";
	
	return text;		
}

cover_right_text()
{
	text = [];
	text[ "title" ] =  "cover_right stand nodes" ;
	text[ "desc" ][ 0 ] = "Build standards for cover right: flat corner surface 48+ units tall ";
	text[ "bullets" ][ 0 ] = "This is used for corner cover like outside a door.";
	text[ "bullets" ][ 1 ] = "AI can also crouch at these nodes if 'dont_stand' is checked.";
	
	return text;		
}

cover_left_text()
{
	text = [];
	text[ "title" ] =  "cover_left stand nodes" ;
	text[ "desc" ][ 0 ] = "Build standards for cover left: flat corner surface 48+ units tall ";
	text[ "bullets" ][ 0 ] = "This is used for corner cover like outside a door.";
	text[ "bullets" ][ 1 ] = "AI can also crouch at these nodes if 'dont_stand' is checked.";
	
	return text;		
}

cover_stand_text()
{
	text = [];
	text[ "title" ] = "cover_stand nodes";
	text[ "desc" ][ 0 ] = "Build standard for standing cover: 48 units high, 32 units wide";
	text[ "bullets" ][ 0 ] = "'Cover' node types should be used against flat surfaces.";
	text[ "bullets" ][ 1 ] = "AI will play leaning animations when these nodes are used.";	
	
	return text;		
}


cover_right_crouch_text()
{
	text = [];
	text[ "title" ] =  "cover_right_crouch nodes" ;
	text[ "desc" ][ 0 ] = "Build standards for cover right: flat corner surface 36 units tall ";
	text[ "bullets" ][ 0 ] = "This is used for corner cover like outside a door.";
	text[ "bullets" ][ 1 ] = "AI can also stand at these nodes if 'dont_stand' isn't checked.";
	
	return text;		
}

cover_left_crouch_text()
{
	text = [];
	text[ "title" ] =  "cover_left_crouch nodes" ;
	text[ "desc" ][ 0 ] = "Build standards for cover left: flat corner surface 36 units tall ";
	text[ "bullets" ][ 0 ] = "This is used for corner cover like outside a door.";
	text[ "bullets" ][ 1 ] = "AI can also stand at these nodes if 'dont_stand' isn't checked.";
	
	return text;		
}

cover_balcony_text()
{
	title = [];
	title[ "title" ] = "Cover_balcony" ;
	title[ "desc" ][ 0 ] = "Build standard for railing cover: 36 units high";
	title[ "bullets" ][ 0 ] = "Balcony deaths are enabled by checking 'Balcony' on the node in Radiant.";
	title[ "bullets" ][ 1 ] = "Each node will normally play a balcony death only 1-3 times.";
	title[ "bullets" ][ 2 ] = "The function 'balcony_deaths' in module_covernodes.gsc overrides this.";
	
	return title;	
}

cover_balcony_norailing_text()
{
	title = [];
	title[ "title" ] = "Cover_balcony_norailing" ;
	title[ "desc" ][ 0 ] = "Notice there is no railing here. Use these on tops of buildings or high ledges";
	title[ "bullets" ][ 0 ] = "Balcony_norailing deaths are enabled by checking 'Balcony_norail' on the node in Radiant.";
	title[ "bullets" ][ 1 ] = "Each node will normally play a balcony death only 1-3 times.";
	title[ "bullets" ][ 2 ] = "The function 'balcony_deaths' in module_covernodes.gsc overrides this.";
	
	return title;		
}

guard_stand_text()
{
	text = [];
	text[ "title" ] = "guard_stand nodes";
	text[ "desc" ][ 0 ] = "Guard nodes are for use out in the open where there is no cover";
	text[ "bullets" ][ 0 ] = "Use these when there are no objects for AI to hide behind.";
	text[ "bullets" ][ 1 ] = "Guard nodes are not checked in normal scripts AI when seeking cover.";
	text[ "bullets" ][ 2 ] = "If you want to send a guy to a guard node, it must be done manually.";
	
	return text;		
}

guard_crouch_text()
{
	text = [];
	text[ "title" ] = "guard_crouch nodes";
	text[ "desc" ][ 0 ] = "Guard nodes are for use out in the open where there is no cover";
	text[ "bullets" ][ 0 ] = "Use these when there are no objects for AI to hide behind.";
	text[ "bullets" ][ 1 ] = "Guard nodes are not checked in normal scripts AI when seeking cover.";
	text[ "bullets" ][ 2 ] = "If you want to send a guy to a guard node, it must be done manually.";
	
	return text;		
}

turret_text()
{
	text = [];
	text[ "title" ] = "turret nodes";
	text[ "desc" ][ 0 ] = "MG turret emplacement height standard: between 30 and 36 units tall";
	text[ "bullets" ][ 0 ] = "Send AI to a turret node when the node is targeting a turret weapon,";
	text[ "bullets" ][ 1 ] = "and the AI will jump on the turret";
	text[ "bullets" ][ 2 ] = "For more information about machine gun turrets, check out module_mg";
	
	return text;		
}

turret_prone_text()
{
	text[ "title" ] = "turret_prone nodes";
	text[ "desc" ][ 0 ] = "Send AI to a turret node when the node is targeting a turret weapon,";
	text[ "desc" ][ 1 ] = "and the AI will jump on the turret";
	text[ "bullets" ][ 0 ] = "For more information about machine gun turrets, check out module_mg";
	
	return text;		
}

pillar_stand_text()
{
	text = [];
	text[ "title" ] = "pillar_stand nodes";
	text[ "desc" ][ 0 ] = "Build standard for standing pillar nodes: 48+ units high, 32 units wide";
	text[ "bullets" ][ 0 ] = "Pillar nodes are useful when the AI can look left and right from the same position";
	text[ "bullets" ][ 1 ] = "You can disable AI looking left or right by checking 'dont_left' or 'dont_right' on the node in Radiant";
	
	return text;		
}

pillar_crouch_text()
{
	text = [];
	text[ "title" ] = "pillar_crouch nodes";
	text[ "desc" ][ 0 ] = "Build standard for crouching pillar nodes: 36 units high, 32 units wide";
	text[ "bullets" ][ 0 ] = "Pillar nodes are useful when the AI can look left and right from the same position";
	text[ "bullets" ][ 1 ] = "You can disable AI looking left or right by checking 'dont_left' or 'dont_right' on the node in Radiant";
	
	return text;		
}

print_node_type(guy)
{
	guy endon("death");

	while (true)
	{
		player = get_players()[0];
		eye = player get_eye();
		bullet_trace = BulletTrace(eye, eye + AnglesToForward(player GetPlayerAngles()) * 5000, true, player);
		if (IsDefined(bullet_trace["entity"]) && bullet_trace["entity"] == guy)
		{
			Print3d(self.origin, self.type, (1, 1, 1), 1, 1, 1);
		}

		wait .05;
	}
}

goto_cover( guys )
{
	// at least one guy
	guy = guys[0];
	
	if(!IsDefined(guy))
	{
		return;
	}

	for( i=0; i < guys.size; i++ )
	{
		guys[i] thread delay_combat();
	}

	array_wait(guys, "death");
	wait(3);
}

delay_combat()
{
	self endon("death");

	self.ignoreall = true;
	self.disableexits = true;
	self.grenadeammo = 0; //999

	if ((self.targetname != "node_balcony_ai") && (self.targetname != "node_balcony_norailing_ai"))
	{
		self.health = self.health * 10;
	}

	self waittill("goal");
	
	//pause before turning back on
	wait( 2 );
	self.ignoreall = false;	
}

