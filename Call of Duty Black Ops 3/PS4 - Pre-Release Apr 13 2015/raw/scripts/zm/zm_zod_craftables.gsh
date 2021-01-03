//////////////////////////////////////////////////////////
//	PICKUP ITEMS (CAN ONLY CARRY ONE AT A TIME)







// names of the ritual-site craftables







// names of the memento craftable pieces





// names of the relic craftable pieces





// the interdimensional gun




	


//////////////////////////////////////////////////////////
//	QUEST UI
//

	
// Client field for whether the team has the quest_key shared item
// 1 if team has the quest key, 0 otherwise; use this clientfield to drive the UI, and to determine when a ritual can be initiated (goes to 0 during the ritual, and is returned to 1 when successfully completed)


	
// Clientfield for each character's item - contains the current holder of the item
// 
// The clientfield names for each character's item are CLIENTFIELD_QUEST_STATE_BASE plus one of the ZOD_NAME_s above
// The value is set to one of the ZOD RITUAL VALUES below
//


// ZOD RITUAL VALUES
// enum of the player characters + none (value to set the held-state of an item)







	
// Clientfield for each character's item - contains the current quest state of the item
// 
// The clientfield names for each character's item are CLIENTFIELD_QUEST_STATE_BASE plus one of the ZOD_NAME_s above
// The value is set to one of the UI CLIENTFIELD QUEST UI STATE VALUES below
//

	
// UI CLIENTFIELD QUEST UI STATE VALUES








