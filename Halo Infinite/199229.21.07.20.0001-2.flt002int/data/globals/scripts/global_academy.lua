-- Copyright (c) Microsoft. All rights reserved.

--## SERVER


   --_____ _      ____  ____          _                 _____          _____  ______ __  ____     __
  --/ ____| |    / __ \|  _ \   /\   | |          /\   / ____|   /\   |  __ \|  ____|  \/  \ \   / /
 --| |  __| |   | |  | | |_) | /  \  | |         /  \ | |       /  \  | |  | | |__  | \  / |\ \_/ / 
 --| | |_ | |   | |  | |  _ < / /\ \ | |        / /\ \| |      / /\ \ | |  | |  __| | |\/| | \   /  
 --| |__| | |___| |__| | |_) / ____ \| |____   / ____ \ |____ / ____ \| |__| | |____| |  | |  | |   
  --\_____|______\____/|____/_/    \_\______| /_/    \_\_____/_/    \_\_____/|______|_|  |_|  |_|   
----           

global AcademyScoringTypeEnum = table.makeEnum
	{
		noScoring = 1,
		timerScoring = 2,
		pointScoring = 3, 
		countdownScoring = 4,
	};

global AcademyChallengeTypeEnum = table.makeEnum
	{
		academyTutorial = 1,
		timer = 2,
		points = 3,
		shortCountdown = 4,
		medCountdown = 5,
		longCountdown = 6,
		epicCountdown = 7,
	};

--## CLIENT

global AcademyTutorialScreen = table.makeEnum
	{
		controller = 1,
	};
