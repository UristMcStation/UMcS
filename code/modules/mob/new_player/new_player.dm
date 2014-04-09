//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

/mob/new_player
	var/ready = 0
	var/spawning = 0//Referenced when you want to delete the new_player later on in the code.
	var/totalPlayers = 0		 //Player counts for the Lobby tab
	var/totalPlayersReady = 0

	invisibility = 101

	density = 0
	stat = 2
	canmove = 0

	anchored = 1	//  don't get pushed around

	New()
		tag = "mob_[next_mob_id++]"
		mob_list += src

	proc/new_player_panel()

		var/output = "<center><p><a href='byond://?src=\ref[src];show_preferences=1'>Setup Character</A></p>"

		if(!ticker || ticker.current_state <= GAME_STATE_PREGAME)
			if(!ready)	output += "<p><a href='byond://?src=\ref[src];ready=1'>Declare Ready</A></p>"
			else	output += "<p><b>You are ready</b> <a href='byond://?src=\ref[src];ready=2'>Cancel</A></p>"

		else
			output += "<p><a href='byond://?src=\ref[src];late_join=1'>Join Game!</A></p>"

		output += "<p><a href='byond://?src=\ref[src];observe=1'>Observe</A></p>"

		if(!IsGuestKey(src.key))
			establish_db_connection()

			if(dbcon.IsConnected())
				var/isadmin = 0
				if(src.client && src.client.holder)
					isadmin = 1
				var/DBQuery/query = dbcon.NewQuery("SELECT id FROM erro_poll_question WHERE [(isadmin ? "" : "adminonly = false AND")] Now() BETWEEN starttime AND endtime AND id NOT IN (SELECT pollid FROM erro_poll_vote WHERE ckey = \"[ckey]\") AND id NOT IN (SELECT pollid FROM erro_poll_textreply WHERE ckey = \"[ckey]\")")
				query.Execute()
				var/newpoll = 0
				while(query.NextRow())
					newpoll = 1
					break

				if(newpoll)
					output += "<p><b><a href='byond://?src=\ref[src];showpoll=1'>Show Player Polls</A> (NEW!)</b></p>"
				else
					output += "<p><a href='byond://?src=\ref[src];showpoll=1'>Show Player Polls</A></p>"

		output += "</center>"

		//src << browse(output,"window=playersetup;size=210x240;can_close=0")
		var/datum/browser/popup = new(src, "playersetup", "<div align='center'>New Player Options</div>", 210, 240)
		popup.set_window_options("can_close=0")
		popup.set_content(output)
		popup.open(0)
		return

	Stat()
		..()

		statpanel("Lobby")
		if(client.statpanel == "Lobby" && ticker)
			if(ticker.hide_mode)
				stat("Game Mode:", "Secret")
			else
				stat("Game Mode:", "[master_mode]")

			if((ticker.current_state == GAME_STATE_PREGAME) && going)
				stat("Time To Start:", ticker.pregame_timeleft)
			if((ticker.current_state == GAME_STATE_PREGAME) && !going)
				stat("Time To Start:", "DELAYED")

			if(ticker.current_state == GAME_STATE_PREGAME)
				stat("Players: [totalPlayers]", "Players Ready: [totalPlayersReady]")
				totalPlayers = 0
				totalPlayersReady = 0
				for(var/mob/new_player/player in player_list)
					stat("[player.key]", (player.ready)?("(Playing)"):(null))
					totalPlayers++
					if(player.ready)totalPlayersReady++

	Topic(href, href_list[])
		if(src != usr)
			return 0

		if(!client)	return 0

		if(href_list["show_preferences"])
			client.prefs.ShowChoices(src)
			return 1

		if(href_list["ready"])
			ready = !ready

		if(href_list["refresh"])
			src << browse(null, "window=playersetup") //closes the player setup window
			new_player_panel()

		if(href_list["observe"])

			if(alert(src,"Are you sure you wish to observe? You will not be able to play this round!","Player Setup","Yes","No") == "Yes")
				if(!client)	return 1
				var/mob/dead/observer/observer = new()

				spawning = 1
				src << sound(null, repeat = 0, wait = 0, volume = 85, channel = 1) // MAD JAMS cant last forever yo

				observer.started_as_observer = 1
				close_spawn_windows()
				var/obj/O = locate("landmark*Observer-Start")
				src << "\blue Now teleporting."
				observer.loc = O.loc
				if(client.prefs.be_random_name)
					client.prefs.real_name = random_name(gender)
				observer.real_name = client.prefs.real_name
				observer.name = observer.real_name
				observer.key = key

				del(src)
				return 1

		if(href_list["late_join"])
			if(!ticker || ticker.current_state != GAME_STATE_PLAYING)
				usr << "\red The round is either not ready, or has already finished..."
				return
			LateChoices()

		if(href_list["SelectedJob"])

			if(!enter_allowed)
				usr << "\blue There is an administrative lock on entering the game!"
				return

			AttemptLateSpawn(href_list["SelectedJob"])
			return

		if(href_list["privacy_poll"])
			establish_db_connection()
			if(!dbcon.IsConnected())
				return
			var/voted = 0

			//First check if the person has not voted yet.
			var/DBQuery/query = dbcon.NewQuery("SELECT * FROM erro_privacy WHERE ckey='[src.ckey]'")
			query.Execute()
			while(query.NextRow())
				voted = 1
				break

			//This is a safety switch, so only valid options pass through
			var/option = "UNKNOWN"
			switch(href_list["privacy_poll"])
				if("signed")
					option = "SIGNED"
				if("anonymous")
					option = "ANONYMOUS"
				if("nostats")
					option = "NOSTATS"
				if("later")
					usr << browse(null,"window=privacypoll")
					return
				if("abstain")
					option = "ABSTAIN"

			if(option == "UNKNOWN")
				return

			if(!voted)
				var/sql = "INSERT INTO erro_privacy VALUES (null, Now(), '[src.ckey]', '[option]')"
				var/DBQuery/query_insert = dbcon.NewQuery(sql)
				query_insert.Execute()
				usr << "<b>Thank you for your vote!</b>"
				usr << browse(null,"window=privacypoll")

		if(!ready && href_list["preference"])
			if(client)
				client.prefs.process_link(src, href_list)
		else if(!href_list["late_join"])
			new_player_panel()

		if(href_list["showpoll"])
			handle_player_polling()
			return

		if(href_list["pollid"])
			var/pollid = href_list["pollid"]
			if(istext(pollid))
				pollid = text2num(pollid)
			if(isnum(pollid))
				src.poll_player(pollid)
			return

		if(href_list["votepollid"] && href_list["votetype"])
			var/pollid = text2num(href_list["votepollid"])
			var/votetype = href_list["votetype"]
			switch(votetype)
				if("OPTION")
					var/optionid = text2num(href_list["voteoptionid"])
					vote_on_poll(pollid, optionid)
				if("TEXT")
					var/replytext = href_list["replytext"]
					log_text_poll_reply(pollid, replytext)
				if("NUMVAL")
					var/id_min = text2num(href_list["minid"])
					var/id_max = text2num(href_list["maxid"])

					if( (id_max - id_min) > 100 )	//Basic exploit prevention
						usr << "The option ID difference is too big. Please contact administration or the database admin."
						return

					for(var/optionid = id_min; optionid <= id_max; optionid++)
						if(!isnull(href_list["o[optionid]"]))	//Test if this optionid was replied to
							var/rating
							if(href_list["o[optionid]"] == "abstain")
								rating = null
							else
								rating = text2num(href_list["o[optionid]"])
								if(!isnum(rating))
									return

							vote_on_numval_poll(pollid, optionid, rating)
				if("MULTICHOICE")
					var/id_min = text2num(href_list["minoptionid"])
					var/id_max = text2num(href_list["maxoptionid"])

					if( (id_max - id_min) > 100 )	//Basic exploit prevention
						usr << "The option ID difference is too big. Please contact administration or the database admin."
						return

					for(var/optionid = id_min; optionid <= id_max; optionid++)
						if(!isnull(href_list["option_[optionid]"]))	//Test if this optionid was selected
							vote_on_poll(pollid, optionid, 1)

	proc/IsJobAvailable(rank)
		var/datum/job/job = job_master.GetJob(rank)
		if(!job)	return 0
		if((job.current_positions >= job.total_positions) && job.total_positions != -1)	return 0
		if(jobban_isbanned(src,rank))	return 0
		if(!job.player_old_enough(src.client))	return 0
		return 1


	proc/AttemptLateSpawn(rank)
		if(!IsJobAvailable(rank))
			src << alert("[rank] is not available. Please try another.")
			return 0

		job_master.AssignRole(src, rank, 1)

		var/mob/living/carbon/human/character = create_character()	//creates the human and transfers vars and mind
		job_master.EquipRank(character, rank, 1)					//equips the human

		character.loc = pick(latejoin)
		character.lastarea = get_area(loc)

		if(character.mind.assigned_role != "Cyborg")
			data_core.manifest_inject(character)
			character.roll_disorder() //roll for mental disorders; see modules/urist/mental.dm
			ticker.minds += character.mind//Cyborgs and AIs handle this in the transform proc.	//TODO!!!!! ~Carn
			AnnounceArrival(character, rank)
		else
			character.Robotize()

		joined_player_list += character.ckey

		if(config.allow_latejoin_antagonists && emergency_shuttle.timeleft() > 300) //Don't make them antags if the station is evacuating
			ticker.mode.make_antag_chance(character)
		del(src)

	proc/AnnounceArrival(var/mob/living/carbon/human/character, var/rank)
		if (ticker.current_state == GAME_STATE_PLAYING)
			var/ailist[] = list()
			for (var/mob/living/silicon/ai/A in living_mob_list)
				ailist += A
			if (ailist.len)
				var/mob/living/silicon/ai/announcer = pick(ailist)
				if(character.mind)
					if((character.mind.assigned_role != "Cyborg") && (character.mind.special_role != "MODE"))
						announcer.say("[character.real_name] has signed up as [rank].")

	proc/LateChoices()
		var/mills = world.time // 1/10 of a second, not real milliseconds but whatever
		//var/secs = ((mills % 36000) % 600) / 10 //Not really needed, but I'll leave it here for refrence.. or something
		var/mins = (mills % 36000) / 600
		var/hours = mills / 36000

		var/dat = "<div class='notice'>Round Duration: [round(hours)]h [round(mins)]m</div>"

		if(emergency_shuttle) //In case Nanotrasen decides reposess Centcom's shuttles.
			if(emergency_shuttle.direction == 2) //Shuttle is going to centcom, not recalled
				dat += "<div class='notice red'>The station has been evacuated.</div><br>"
			if(emergency_shuttle.direction == 1 && emergency_shuttle.timeleft() < 300) //Shuttle is past the point of no recall
				dat += "<div class='notice red'>The station is currently undergoing evacuation procedures.</div><br>"

		var/available_job_count = 0
		for(var/datum/job/job in job_master.occupations)
			if(job && IsJobAvailable(job.title))
				available_job_count++;

		dat += "<div class='clearBoth'>Choose from the following open positions:</div><br>"
		dat += "<div class='jobs'><div class='jobsColumn'>"
		var/job_count = 0
		for(var/datum/job/job in job_master.occupations)
			if(job && IsJobAvailable(job.title))
				job_count++;
				if (job_count > round(available_job_count / 2))
					dat += "</div><div class='jobsColumn'>"
				var/position_class = "otherPosition"
				if (job.title in command_positions)
					position_class = "commandPosition"
				dat += "<a class='[position_class]' href='byond://?src=\ref[src];SelectedJob=[job.title]'>[job.title] ([job.current_positions])</a><br>"
		dat += "</div></div>"

		// Removing the old window method but leaving it here for reference
		//src << browse(dat, "window=latechoices;size=300x640;can_close=1")

		// Added the new browser window method
		var/datum/browser/popup = new(src, "latechoices", "Choose Profession", 440, 500)
		popup.add_stylesheet("playeroptions", 'html/browser/playeroptions.css')
		popup.set_content(dat)
		popup.open(0) // 0 is passed to open so that it doesn't use the onclose() proc


	proc/create_character()
		spawning = 1
		close_spawn_windows()

		var/mob/living/carbon/human/new_character = new(loc)
		new_character.lastarea = get_area(loc)

		if(config.force_random_names || appearance_isbanned(src))
			client.prefs.random_character()
			client.prefs.real_name = random_name(gender)
		client.prefs.copy_to(new_character)

		src << sound(null, repeat = 0, wait = 0, volume = 85, channel = 1) // MAD JAMS cant last forever yo

		if(mind)
			mind.active = 0					//we wish to transfer the key manually
			mind.transfer_to(new_character)					//won't transfer key since the mind is not active

		new_character.name = real_name

		ready_dna(new_character, client.prefs.blood_type)

		new_character.key = key		//Manually transfer the key to log them in

		return new_character


	Move()
		return 0


	proc/close_spawn_windows()

		src << browse(null, "window=latechoices") //closes late choices window
		src << browse(null, "window=playersetup") //closes the player setup window
		src << browse(null, "window=preferences") //closes job selection
		src << browse(null, "window=mob_occupation")
		src << browse(null, "window=latechoices") //closes late job selection
