//VotingBooth.ash
//Auto-votes. Biases the kingdom towards more ghosts, because those are more useful in-run.
//Also logs daily initiatives in the format:
//VOTING_BOOTH_LOG•daycount•class•path
//Useful for spading.

//If using this in a script:
//import "VotingBooth.ash";
//voteInVotingBooth();

boolean __voting_setting_allow_ml = true; //set to false if you do not want +monster level in-run
boolean __voting_setting_make_extra_adventure_in_run_super_important = false; //set to true if you always want that +1 adventure. high-end runs don't?

boolean __voting_setting_use_absentee_ballots = false; //this is not yet written
boolean __voting_setting_confirm_initiatives_in_run = false; //set this to true if you want a confirmation box before we vote. or just vote by hand
string __voting_version = "1.0";


boolean [string] __voting_negative_effects = $strings[Add sedatives to the water supply.,Distracting noises broadcast through compulsory teeth-mounted radio receivers.,Emissions cap on all magic-based combustion.,Exercise ban.,Mandatory 6pm curfew.,Requirement that all weapon handles be buttered.,Safety features added to all melee weapons.,Shut down all local dog parks.,State nudity initiative.,Vaccination reversals for all citizens.,All bedsheets replaced with giant dryer sheets.,All citizens required to look all four ways before crossing the street.,Ban on petroleum-based gels and poumades.,Increased taxes at all income levels.,Mandatory item tithing.,Reduced public education spending.];

//allow_interacting_with_user set to false disables a user_confirm, so the user cannot prevent a script from obtaining the voted badge
void voteInVotingBooth(boolean allow_interacting_with_user)
{
	print_html("VotingBooth v" + __voting_version + ".");
	buffer page_text = visit_url("place.php?whichplace=town_right&action=townright_vote");
	
	if (__voting_setting_use_absentee_ballots)
	{
	}
	
	
	
	
	
	//Here's where the script decides which initiatives are best.
	//I spent like ten seconds on it, so feel free to change it.
	//Larger numbers are the best initiatives.
	float [string] initiative_priorities;
	initiative_priorities["State-mandated bed time of 8PM."] = 100; //+1 Adventure(s) per day
	initiative_priorities["Repeal leash laws."] = 75; //+2 Familiar Experience Per Combat
	initiative_priorities["Institute GBLI (Guaranteed Basic Loot Income.)"] = 50; //+15% Item Drops from Monsters
	initiative_priorities["Reduced taxes at all income levels."] = 45; //+30% Meat from Monsters
	initiative_priorities["Mandatory morning calisthenics for all citizens."] = 42; //Muscle +25%
	initiative_priorities["Compulsory dance lessons every weekend."] = 41; //Moxie +25%
	initiative_priorities["Replace all street signs with instructions for arcane rituals."] = 40; //Mysticality +25%
	initiative_priorities["Addition of 37 letters to end of alphabet so existing names are all earlier in queues."] = 35; //+25% Combat Initiative
	initiative_priorities["Subsidies for health potion manufacturers."] = 32; //Maximum HP +30%
	initiative_priorities["Open a local portal to a dimension of pure arcane power."] = 31; //Spell Damage +20%
	initiative_priorities["Free civic weapon sharpening program."] = 31; //Weapon Damage +100%
	initiative_priorities["Require all garments to be fleece-lined."] = 30; //Serious Cold Resistance (+3)
	initiative_priorities["Make all new clothes out of asbestos."] = 30; //Serious Hot Resistance (+3)
	initiative_priorities["Widespread distribution of \"CENSORED\" bars."] = 30; //Serious Sleaze Resistance (+3)
	initiative_priorities["Outlaw black clothing and white makeup."] = 30; //Serious Spooky Resistance (+3)
	initiative_priorities["Free public nose-plug dispensers."] = 30; //Serious Stench Resistance (+3)
	initiative_priorities["A chicken in every pot!"] = 25; //+30% Food Drops from Monsters
	initiative_priorities["Carbonate the water supply."] = 20; //Maximum MP +30%
	initiative_priorities["Kingdomwide air-conditioning subsidies."] = 20; //+10 Cold Damage
	initiative_priorities["Pocket flamethrowers issued to all citizens."] = 20; //+10 Hot Damage
	initiative_priorities["Artificial butter flavoring dispensers on every street corner."] = 20; //+10 Sleaze Damage
	initiative_priorities["All forms of deodorant are now illegal."] = 20; //+10 Stench Damage
	initiative_priorities["All forms of deodorant are now illegal."] = 20; //+10 Stench Damage
	initiative_priorities["Compulsory firearm and musical instrument safety training for all citizens."] = 20; //Ranged Damage +100%
	initiative_priorities["Emergency eye make-up stations installed in all public places."] = 15; //+4 Moxie Stats Per Fight
	initiative_priorities["Require boxing videos to be played on all bar televisions."] = 15; //+4 Muscle Stats Per Fight
	initiative_priorities["Deployment of a network of aerial mana-enhancement drones."] = 15; //+4 Mysticality Stats Per Fight
	initiative_priorities["Municipal journaling initiative."] = 15; //+3 Stats Per Fight
	initiative_priorities["Happy Hour extended by 23 additional hours."] = 10; //+30% Booze Drops from Monsters
	initiative_priorities["Subsidies for dentists."] = 10; //+30% Candy Drops from Monsters
	initiative_priorities["Sales tax free weekend for back-to-school shopping."] = 10; //+30% Gear Drops from Monsters
	initiative_priorities["Ban belts."] = 10; //+30% Pants Drops from Monsters
	initiative_priorities["Mandatory martial arts classes for all citizens."] = 0; //+20 Damage to Unarmed Attacks
	initiative_priorities["\"Song that Never Ends\" pumped throughout speakers in all of Kingdom."] = -100; //+10 to Monster Level
	//Alter priorities depending on state:
	if (my_level() < 13)
	{
		//Want stats:
		stat primestat = my_primestat();
		if (primestat == $stat[muscle])
			initiative_priorities["Require boxing videos to be played on all bar televisions."] = 60; //+4 Muscle Stats Per Fight
		else if (primestat == $stat[mysticality])
			initiative_priorities["Deployment of a network of aerial mana-enhancement drones."] = 60; //+4 Mysticality Stats Per Fight
		else if (primestat == $stat[moxie])
			initiative_priorities["Emergency eye make-up stations installed in all public places."] = 60; //+4 Moxie Stats Per Fight
		initiative_priorities["Municipal journaling initiative."] = 50; //+3 Stats Per Fight
	}
	//We only choose +ML while in-run and it's allowed.
	boolean king_liberated = get_property("kingLiberated").to_boolean();
	if (__voting_setting_allow_ml && !king_liberated)
		initiative_priorities["\"Song that Never Ends\" pumped throughout speakers in all of Kingdom."] = 50; //+10 to Monster Level
	//In-run, +1 adventure is like rounding? Except in HCO I suppose.
	if (!__voting_setting_make_extra_adventure_in_run_super_important && !king_liberated)
		initiative_priorities["State-mandated bed time of 8PM."] = 40; //+1 Adventure(s) per day
	//Out of run, familiar experience is... marginal?
	if (king_liberated)
		initiative_priorities["Repeal leash laws."] = 25; //+2 Familiar Experience Per Combat





	string [string] initiative_descriptions;
	initiative_descriptions["State-mandated bed time of 8PM."] = "+1 Adventure(s) per day";
	initiative_descriptions["Repeal leash laws."] = "+2 Familiar Experience Per Combat";
	initiative_descriptions["Emergency eye make-up stations installed in all public places."] = "+4 Moxie Stats Per Fight";
	initiative_descriptions["Require boxing videos to be played on all bar televisions."] = "+4 Muscle Stats Per Fight";
	initiative_descriptions["Deployment of a network of aerial mana-enhancement drones."] = "+4 Mysticality Stats Per Fight";
	initiative_descriptions["\"Song that Never Ends\" pumped throughout speakers in all of Kingdom."] = "+10 to Monster Level";
	initiative_descriptions["Institute GBLI (Guaranteed Basic Loot Income.)"] = "+15% Item Drops from Monsters";
	initiative_descriptions["Municipal journaling initiative."] = "+3 Stats Per Fight";
	initiative_descriptions["Reduced taxes at all income levels."] = "+30% Meat from Monsters";
	initiative_descriptions["Compulsory dance lessons every weekend."] = "Moxie +25%";
	initiative_descriptions["Mandatory morning calisthenics for all citizens."] = "Muscle +25%";
	initiative_descriptions["Replace all street signs with instructions for arcane rituals."] = "Mysticality +25%";
	initiative_descriptions["Open a local portal to a dimension of pure arcane power."] = "Spell Damage +20%";
	initiative_descriptions["Subsidies for health potion manufacturers."] = "Maximum HP +30%";
	initiative_descriptions["Require all garments to be fleece-lined."] = "Serious Cold Resistance (+3)";
	initiative_descriptions["Make all new clothes out of asbestos."] = "Serious Hot Resistance (+3)";
	initiative_descriptions["Widespread distribution of \"CENSORED\" bars."] = "Serious Sleaze Resistance (+3)";
	initiative_descriptions["Outlaw black clothing and white makeup."] = "Serious Spooky Resistance (+3)";
	initiative_descriptions["Free public nose-plug dispensers."] = "Serious Stench Resistance (+3)";
	initiative_descriptions["Free civic weapon sharpening program."] = "Weapon Damage +100%";
	initiative_descriptions["Addition of 37 letters to end of alphabet so existing names are all earlier in queues."] = "+25% Combat Initiative";
	initiative_descriptions["A chicken in every pot!"] = "+30% Food Drops from Monsters";
	initiative_descriptions["Carbonate the water supply."] = "Maximum MP +30%";
	initiative_descriptions["Kingdomwide air-conditioning subsidies."] = "+10 Cold Damage";
	initiative_descriptions["Pocket flamethrowers issued to all citizens."] = "+10 Hot Damage";
	initiative_descriptions["Artificial butter flavoring dispensers on every street corner."] = "+10 Sleaze Damage";
	initiative_descriptions["All forms of deodorant are now illegal."] = "+10 Stench Damage";
	initiative_descriptions["All forms of deodorant are now illegal."] = "+10 Stench Damage";
	initiative_descriptions["Compulsory firearm and musical instrument safety training for all citizens."] = "Ranged Damage +100%";
	initiative_descriptions["Happy Hour extended by 23 additional hours."] = "+30% Booze Drops from Monsters";
	initiative_descriptions["Subsidies for dentists."] = "+30% Candy Drops from Monsters";
	initiative_descriptions["Sales tax free weekend for back-to-school shopping."] = "+30% Gear Drops from Monsters";
	initiative_descriptions["Ban belts."] = "+30% Pants Drops from Monsters";
	initiative_descriptions["Mandatory martial arts classes for all citizens."] = "+20 Damage to Unarmed Attacks";

	initiative_descriptions["Add sedatives to the water supply."] = "-10 to Monster Level";
	initiative_descriptions["Distracting noises broadcast through compulsory teeth-mounted radio receivers."] = "-3 Stats Per Fight";
	initiative_descriptions["Emissions cap on all magic-based combustion."] = "Spell Damage -50%";
	initiative_descriptions["Exercise ban."] = "Muscle -20";
	initiative_descriptions["Mandatory 6pm curfew."] = "+-2 Adventure(s) per day";
	initiative_descriptions["Requirement that all weapon handles be buttered."] = "-10% chance of Critical Hit";
	initiative_descriptions["Safety features added to all melee weapons."] = "Weapon Damage -50%";
	initiative_descriptions["Shut down all local dog parks."] = "-2 Familiar Experience Per Combat";
	initiative_descriptions["State nudity initiative."] = "-50% Gear Drops from Monsters";
	initiative_descriptions["Vaccination reversals for all citizens."] = "Maximum HP -50%";
	initiative_descriptions["All bedsheets replaced with giant dryer sheets."] = "Maximum MP -50%";
	initiative_descriptions["All citizens required to look all four ways before crossing the street."] = "-30% Combat Initiative";
	initiative_descriptions["Ban on petroleum-based gels and poumades."] = "Moxie -20";
	initiative_descriptions["Increased taxes at all income levels."] = "-30% Meat from Monsters";
	initiative_descriptions["Mandatory item tithing."] = "-20% Item Drops from Monsters";
	initiative_descriptions["Reduced public education spending."] = "Mysticality -20";
	
	string [int][int] platform_matches = page_text.group_string("<blockquote>(.*?)</blockquote>");
	
	int desired_g = random(2) + 1;
	
	//Bias the global votes towards ghosts:
	if (platform_matches.count() == 2)
	{
		foreach key in platform_matches
		{
			string platform = platform_matches[key][1];
			boolean zoinks = false;
			//print_html(key + ": " + platform);
			
			foreach s in $strings[seance to summon their ancient spirits,you like to see your deceased loved ones again,don't think I need to tell you that graveyards are a terribly inefficient use of space,is possible that this might displace and anger your,How could you possibly vote against kindness energy] //'
			{
				if (platform.contains_text(s))
				{
					zoinks = true;
					break;
				}
			}
			
			
			if (zoinks)
			{
				print_html("Voting for ghosts.");
				desired_g = key + 1;
				break;
			}
		}
	}

	string [int][int] local_initiative_matches = page_text.group_string("<input type=\"checkbox\".*?value=\"([0-9])\".*?> (.*?)<");
	
	string [int] initiative_names;
	int [string] initiative_values;
	string log_delimiter = "•";
	
	buffer log;
	log.append("VOTING_BOOTH_LOG");
	log.append(log_delimiter);
	log.append(my_daycount());
	log.append(log_delimiter);
	log.append(my_class());
	log.append(log_delimiter);
	log.append(my_path());
	print_html("<strong>Available initiatives:</strong>");
	foreach key in local_initiative_matches
	{
		int initaitive_value = local_initiative_matches[key][1].to_int();
		string initiative_name = local_initiative_matches[key][2];
		
		
		log.append(log_delimiter);
		log.append(initiative_name);
		
		//print_html("\"" + initiative_name + "\": " + initaitive_value + " (" + initiative_descriptions[initiative_name] + ")");
		print_html("&nbsp;&nbsp;&nbsp;&nbsp;" + initiative_descriptions[initiative_name]);
		if (__voting_negative_effects contains initiative_name) continue;
		
		
		initiative_names[initiative_names.count()] = initiative_name;
		initiative_values[initiative_name] = initaitive_value;
		
		if (!(initiative_priorities contains initiative_name))
			abort("Unknown initiative \"" + initiative_name + "\". Tell Ezandora about it, there's probably some one-character typo somewhere.");
		float priority = initiative_priorities[initiative_name];
		
	}
	print_html("");
	logprint(log);
	sort initiative_names by -initiative_priorities[value];
	if (initiative_names.count() < 2)
	{
		print_html("Internal error: Not enough local initiatives.");
		visit_url("choice.php?option=2&whichchoice=1331"); //cancel out
		return;
	}
	print_html("<strong>Chosen initiatives:</strong>");
	foreach key, name in initiative_names
	{
		if (key > 1) continue;
		print_html("&nbsp;&nbsp;&nbsp;&nbsp;" + initiative_descriptions[name]);
	}
	if (__voting_setting_confirm_initiatives_in_run && (true || !can_interact()))
	{
		boolean yes = user_confirm("Do you want to vote for these initiatives?\n\n" + initiative_descriptions[initiative_names[0]] + "\n" + initiative_descriptions[initiative_names[1]]);
		if (!yes)
		{
			print_html("Not voting.");
			return;
		}
	}
	//print_html("initiative_names = " + initiative_names.to_json());
	visit_url("choice.php?option=1&whichchoice=1331&g=" + desired_g + "&local[]=" + initiative_values[initiative_names[0]] + "&local[]=" + initiative_values[initiative_names[1]]);
	
	//https://www.kingdomofloathing.com/choice.php?pwd&option=1&whichchoice=1331&g=1&local[]=0&local[]=2
	//pwd&option=1&whichchoice=1331&g=1&local%5B%5D=0&local%5B%5D=2
	//option=1&whichchoice=1331&g=
	//g - 1 or 2, depending on the global vote
}

void voteInVotingBooth()
{
	voteInVotingBooth(false);
}

void main()
{
	voteInVotingBooth(true);
}