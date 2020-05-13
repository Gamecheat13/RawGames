script continuous elite_test()

sleep_until(volume_test_players (tv_elite), 1);
pup_play_show(elites);
sleep_until (ai_living_count(gymElite_squad) < 1);
sleep(20);
end

script continuous elite_spawn_test()

sleep_until(volume_test_players (tv_elite_place), 1);
ai_place(gymElite_squad);
sleep_until (ai_living_count(gymElite_squad) < 1);
sleep(20);
end

script continuous grunt_test()

sleep_until(volume_test_players (tv_grunt), 1);
pup_play_show(grunts);
sleep_until (ai_living_count(gymStormGrunt_squad) < 1);
sleep(20);
end

script continuous crawler_test()

sleep_until(volume_test_players (tv_crawler), 1);
pup_play_show(crawlers);
sleep_until (ai_living_count(gymPawn_squad) < 1);
sleep(20);
end

script continuous knight_test()

sleep_until(volume_test_players (tv_knight), 1);
pup_play_show(knights);
sleep_until (ai_living_count(gymKnight_squad) < 1);
sleep(20);
end

script continuous chief_test()

sleep_until(volume_test_players (tv_chief), 1);
pup_play_show(chiefs);
sleep_until (ai_living_count(gymMasterchief_squad) < 1);
sleep(20);
end

script continuous chief_phonebooth_test()

sleep_until(volume_test_players (tv_chief_phonebooth), 1);
pup_play_show(chief_phonebooth);
sleep_until (ai_living_count(gymMasterchief_squad) < 1);
sleep(20);
end

script continuous elite_phonebooth_test()

sleep_until(volume_test_players (tv_elite_phonebooth), 1);
pup_play_show(elite_phonebooth);
sleep_until (ai_living_count(gymMasterchief_squad) < 1);
sleep(20);
end


script continuous jackal_test()

sleep_until(volume_test_players (tv_jackals), 1);
pup_play_show(jackals);
sleep_until (ai_living_count(gymJackal_squad) < 1);
sleep(20);
end

