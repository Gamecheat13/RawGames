#include maps\_utility;
main()
{
	intelligence_items = getentarray ("intelligence_item", "targetname");
	println ("intelligence.gsc:             intelligence items:", intelligence_items.size);

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
	
	self trigger_off();	
	
	level thread maps\_utility::play_sound_in_space("intelligence_pickup",self.item.origin);
	
	
	self.used = 1;
	self.item hide();
	self trigger_off();
}

