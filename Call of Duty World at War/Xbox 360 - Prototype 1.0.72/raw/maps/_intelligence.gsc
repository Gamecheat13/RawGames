#include maps\_hud_util;
#include maps\_utility;
main()
{
	intelligence_items = getentarray ("intelligence_item", "targetname");
	level.intelligence_items_found = 0;
	level.intelligence_items_total = intelligence_items.size;
	println ("intelligence.gsc:             intelligence items:", level.intelligence_items_total);

	for (i=0;i<intelligence_items.size;i++)
	{
		intelligence_items[i].item = getent(intelligence_items[i].target, "targetname");
		intelligence_items[i].used = 0;
		intelligence_items[i] thread intel_think();
	}
}


intel_think ()
{
	self setHintString (&"SCRIPT_INTELLIGENCE_PICKUP");
	self usetriggerrequirelookat();
	
	self waittill("trigger");
	
	level.intelligence_items_found++;
	level.intelligence_items_remaining = ( level.intelligence_items_total - level.intelligence_items_found );
	self trigger_off();	
	
	level thread maps\_utility::play_sound_in_space("intelligence_pickup",self.item.origin);
	
	//level.player thread updatePlayerScore ( 10 );
	
	thread intel_feedback();
	
	self.used = 1;
	self.item hide();
	self trigger_off();
}

intel_feedback()
{
	fade_in_time = .25;
	wait_time = 3.75;
	fade_out_time = 1;

	pnts_print = createFontString( "default", 1.5 );
	pnts_print setup_hud_elem();
	pnts_print.y = -75;

	pnts_print.label = &"SCRIPT_INTELLIGENCE_PTS";
	pnts_print setValue ( 20 );
	
	remaining_print = createFontString( "default", 1.5 );
	remaining_print setup_hud_elem();
	remaining_print.y = -60;

	if ( level.intelligence_items_remaining == 1)
		remaining_print.label = &"SCRIPT_INTELLIGENCE_ONEREMAINING";
	else
		remaining_print.label = &"SCRIPT_INTELLIGENCE_REMAINING";
		
	remaining_print setValue ( level.intelligence_items_remaining );

	pnts_print FadeOverTime( fade_in_time );
	pnts_print.alpha = .95;
	remaining_print FadeOverTime( fade_in_time );
	remaining_print.alpha = .95;
	wait fade_in_time;
	
	wait wait_time;
	
	pnts_print FadeOverTime( fade_out_time );
	pnts_print.alpha = 0;
	remaining_print FadeOverTime( fade_out_time );
	remaining_print.alpha = 0;
	wait fade_out_time;
	
	pnts_print Destroy();
	remaining_print Destroy();
}

setup_hud_elem()
{	
	self.color = ( 1, 1, 1 );
	self.alpha = 0;
	self.x = 0;
	self.alignx = "center";
	self.aligny = "middle";
	self.horzAlign = "center";
	self.vertAlign = "middle";
	self.foreground = true;
}
