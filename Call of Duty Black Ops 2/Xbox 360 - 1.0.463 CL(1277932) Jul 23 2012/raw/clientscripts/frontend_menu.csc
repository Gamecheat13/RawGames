#include clientscripts\_utility;

#define SCALE_SMALL					0.01
#define SCALE_BIG					0.04
#define SCALE_LERP_TIME				(1/(60/20))
#define SCALE_DELTA					((SCALE_BIG-SCALE_BIG)/20)
#define SYNTHETIC_CLIP_DISTANCE		10
#define LUI_MAIN_LANDING_MENU		"main"

frontend_menu_init()
{
	level.onSUIMessage = ::onSUIMessage;

	setup_ui3d();
	
	clients = getmaxlocalclients();
	for (i=0;i<clients;i++)
	{
		if (localclientactive(i))
		{
			ForceGameModeMappings( i, "default" );
		}
	}

	LuiLoad("T6.main");
	thread menu_auto_start();
}

setup_ui3d()
{
	// 2 512x512 windows split vertically
	ui3dsetwindow( 0, 0, 0, 0.5, 1 );
	ui3dsetwindow( 1, 0.5, 0, 0.5, 1 );
	ui3dsetwindow( 2, 0, 0, 0, 0 );
	ui3dsetwindow( 3, 0, 0, 0, 0 );
	ui3dsetwindow( 4, 0, 0, 0, 0 );
	ui3dsetwindow( 5, 0, 0, 0, 0 );
}

menu_video_mapping()
{
//	wait(1);
//	val=0;
//	foreach(menu in level.menus)
//	{
//		for (i=0;i<menu.names.size;i++)
//		{
//			gridx = 8;
//			gridy = 8;
//			menu.icon[i] mapshaderconstant( 0, 0, "scriptVector0" ); 
//			menu.icon[i] mapshaderconstant( 0, 1, "scriptVector1" ); 
//			menu.icon[i] mapshaderconstant( 0, 2, "scriptVector2" );
//			menu.icon[i] mapshaderconstant( 0, 3, "scriptVector3" );
//			menu.icon[i] setshaderconstant( 0, 0, val, 0, 0, 0 );
//			menu.icon[i] setshaderconstant( 0, 1, gridx, gridy, 0, 0 );
//			val++;
//		}
//	}
}

menu_auto_start()
{
	localClientNum=0;
	wait(1);
	//activate our user activity monitor
	//SuiEnable(localClientNum);
	
	//LuiEnable(localClientNum,LUI_MAIN_LANDING_MENU);
}

onSUIMessage(localClientNum,param1,param2)
{
	switch(param1)
	{
	case "ENABLE":
		break;
	case "DISABLE":
		break;
	case "BUTTON_RTRIG":
	case "BACKSPACE":
		if (param2=="down")
		{
			if (!IsLuiEnabled(localClientNum))
			{
				LuiEnable(localClientNum,LUI_MAIN_LANDING_MENU);
			}
			else
			{
				LuiDisable(localClientNum);
			}
		}
		break;
	}
}
