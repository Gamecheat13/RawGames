// Maw scans chief during the beacon puppeteer
script static void fx_maw_scan_chief(object current_puppet)
	dprint ("fx_maw_scan_chief()");
	//sleep(1);
	effect_new_on_object_marker(environments\solo\m10_crash\fx\scan_exterior\didact_scan_chief.effect, current_puppet, body);
	effect_new_on_object_marker(environments\solo\m10_crash\fx\scan_exterior\didact_focus_scan.effect, maw_door, fx_focus_scan_start);
end

script static void fx_maw_scan_chief_end()
	dprint ("fx_maw_scan_chief_end()");
	//sleep(1);
	//effect_kill_object_marker(environments\solo\m10_crash\fx\scan_exterior\didact_scan_chief.effect, current_puppet, body);
	effect_kill_object_marker(environments\solo\m10_crash\fx\scan_exterior\didact_focus_scan.effect, maw_door, fx_focus_scan_start);
end
