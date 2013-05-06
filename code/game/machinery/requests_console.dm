/******************** Requests Console ********************/
/** Originally written by errorage, updated by: Carn, needs more work though. I just added some security fixes */

var/req_console_assistance = list()
var/req_console_supplies = list()
var/req_console_information = list()
var/list/obj/machinery/requests_console/allConsoles = list()

/obj/machinery/requests_console
	name = "Requests Console"
	desc = "A console intended to send requests to diferent departments on the station."
	anchored = 1
	icon = 'icons/obj/terminals.dmi'
	icon_state = "req_comp0"
	var/department = "Unknown" //The list of all departments on the station (Determined from this variable on each unit) Set this to the same thing if you want several consoles in one department
	var/list/messages = list() //List of all messages
	var/departmentType = 0
		// 0 = none (not listed, can only repeplied to)
		// 1 = assistance
		// 2 = supplies
		// 3 = info
		// 4 = ass + sup //Erro goddamn you just HAD to shorten "assistance" down to "ass"
		// 5 = ass + info
		// 6 = sup + info
		// 7 = ass + sup + info
	var/newmessagepriority = 0
		// 0 = no new message
		// 1 = normal priority
		// 2 = high priority
		// 3 = extreme priority - not implemented, will probably require some hacking... everything needs to have a hidden feature in this game.
	var/screen = 0
		// 0 = main menu,
		// 1 = req. assistance,
		// 2 = req. supplies
		// 3 = relay information
		// 4 = write msg - not used
		// 5 = choose priority - not used
		// 6 = sent successfully
		// 7 = sent unsuccessfully
		// 8 = view messages
		// 9 = authentication before sending
		// 10 = send announcement
	var/silent = 0 // set to 1 for it not to beep all the time
//	var/hackState = 0
		// 0 = not hacked
		// 1 = hacked
	var/announcementConsole = 0
		// 0 = This console cannot be used to send department announcements
		// 1 = This console can send department announcementsf
	var/open = 0 // 1 if open
	var/announceAuth = 0 //Will be set to 1 when you authenticate yourself for announcements
	var/msgVerified = "" //Will contain the name of the person who varified it
	var/msgStamped = "" //If a message is stamped, this will contain the stamp name
	var/message = "";
	var/dpt = ""; //the department which will be receiving the message
	var/priority = -1 ; //Priority of the message being sent
	luminosity = 0

/obj/machinery/requests_console/power_change()
	..()
	update_icon()

/obj/machinery/requests_console/update_icon()
	if(stat & NOPOWER)
		if(icon_state != "req_comp_off")
			icon_state = "req_comp_off"
	else
		if(icon_state == "req_comp_off")
			icon_state = "req_comp0"

/obj/machinery/requests_console/New()
	name = "[department] Requests Console"
	allConsoles += src
	//req_console_departments += department
	switch(departmentType)
		if(1)
			if(!("[department]" in req_console_assistance))
				req_console_assistance += department
		if(2)
			if(!("[department]" in req_console_supplies))
				req_console_supplies += department
		if(3)
			if(!("[department]" in req_console_information))
				req_console_information += department
		if(4)
			if(!("[department]" in req_console_assistance))
				req_console_assistance += department
			if(!("[department]" in req_console_supplies))
				req_console_supplies += department
		if(5)
			if(!("[department]" in req_console_assistance))
				req_console_assistance += department
			if(!("[department]" in req_console_information))
				req_console_information += department
		if(6)
			if(!("[department]" in req_console_supplies))
				req_console_supplies += department
			if(!("[department]" in req_console_information))
				req_console_information += department
		if(7)
			if(!("[department]" in req_console_assistance))
				req_console_assistance += department
			if(!("[department]" in req_console_supplies))
				req_console_supplies += department
			if(!("[department]" in req_console_information))
				req_console_information += department


/obj/machinery/requests_console/attack_hand(var/mob/user)
	if(..(user))
		return
	var/dat = ""
	if(!open)
		switch(screen)
			if(1)	//req. assistance
				dat += text("Which department do you need assistance from?<BR><BR>")
				dat += "<table width='100%'>"
				for(var/dpt in req_console_assistance)
					if (dpt != department)
						dat += text("<tr>")
						dat += text("<td width='55%'>[dpt]</td>")
						dat += text("<td width='45%'><A href='?src=\ref[src];write=[ckey(dpt)]'>Message</A> <A href='?src=\ref[src];write=[ckey(dpt)];priority=2'>High Priority</A></td>")
						dat += text("</tr>")
//						if (hackState == 1)
//							dat += text(" or <A href='?src=\ref[src];write=[ckey(dpt)];priority=3'>EXTREME</A>)")
				dat += "</table>"
				dat += text("<BR><A href='?src=\ref[src];setScreen=0'><< Back</A><BR>")

			if(2)	//req. supplies
				dat += text("Which department do you need supplies from?<BR><BR>")
				dat += "<table width='100%'>"
				for(var/dpt in req_console_supplies)
					if (dpt != department)
						dat += text("<tr>")
						dat += text("<td width='55%'>[dpt]</td>")
						dat += text("<td width='45%'><A href='?src=\ref[src];write=[ckey(dpt)]'>Message</A> <A href='?src=\ref[src];write=[ckey(dpt)];priority=2'>High Priority</A></td>")
						dat += text("</tr>")
//						if (hackState == 1)
//							dat += text(" or <A href='?src=\ref[src];write=[ckey(dpt)];priority=3'>EXTREME</A>)")
				dat += "</table>"
				dat += text("<BR><A href='?src=\ref[src];setScreen=0'><< Back</A><BR>")

			if(3)	//relay information
				dat += text("Which department would you like to send information to?<BR><BR>")
				dat += "<table width='100%'>"
				for(var/dpt in req_console_information)
					if (dpt != department)
						dat += text("<tr>")
						dat += text("<td width='55%'>[dpt]</td>")
						dat += text("<td width='45%'><A href='?src=\ref[src];write=[ckey(dpt)]'>Message</A> <A href='?src=\ref[src];write=[ckey(dpt)];priority=2'>High Priority</A></td>")
						dat += text("</tr>")
//						if (hackState == 1)
//							dat += text(" or <A href='?src=\ref[src];write=[ckey(dpt)];priority=3'>EXTREME</A>)")
				dat += "</table>"
				dat += text("<BR><A href='?src=\ref[src];setScreen=0'><< Back</A><BR>")

			if(6)	//sent successfully
				dat += text("<span class='good'>Message sent.</span><BR><BR>")
				dat += text("<A href='?src=\ref[src];setScreen=0'>Continue</A><BR>")

			if(7)	//unsuccessful; not sent
				dat += text("<span class='bad'>An error occurred.</span><BR><BR>")
				dat += text("<A href='?src=\ref[src];setScreen=0'>Continue</A><BR>")

			if(8)	//view messages
				for (var/obj/machinery/requests_console/Console in allConsoles)
					if (Console.department == department)
						Console.newmessagepriority = 0
						Console.icon_state = "req_comp0"
						Console.luminosity = 1
				newmessagepriority = 0
				icon_state = "req_comp0"
				for(var/msg in messages)
					dat += text("<div class='block'>[msg]</div>")
				dat += text("<BR><A href='?src=\ref[src];setScreen=0'><< Back to Main Menu</A><BR>")

			if(9)	//authentication before sending
				dat += text("<B>Message Authentication</B><BR><BR>")
				dat += text("<b>Message for [dpt]: </b>[message]<BR><BR>")
				dat += text("<div class='notice'>You may authenticate your message now by scanning your ID or your stamp</div><BR>")
				dat += text("<b>Validated by:</b> [msgVerified ? msgVerified : "<i>Not Validated</i>"]<br>");
				dat += text("<b>Stamped by:</b> [msgStamped ? msgStamped : "<i>Not Stamped</i>"]<br><br>");
				dat += text("<A href='?src=\ref[src];department=[dpt]'>Send Message</A><BR>");
				dat += text("<BR><A href='?src=\ref[src];setScreen=0'><< Discard Message</A><BR>")

			if(10)	//send announcement
				dat += text("<h3>Station-wide Announcement</h3>")
				if(announceAuth)
					dat += text("<div class='notice'>Authentication accepted</div><BR>")
				else
					dat += text("<div class='notice'>Swipe your card to authenticate yourself</div><BR>")
				dat += text("<b>Message: </b>[message ? message : "<i>No Message</i>"]<BR>")
				dat += text("<A href='?src=\ref[src];writeAnnouncement=1'>[message ? "Edit" : "Write"] Message</A><BR><BR>")
				if (announceAuth && message)
					dat += text("<A href='?src=\ref[src];sendAnnouncement=1'>Announce Message</A><BR>");
				else
					dat += text("<span class='linkOff'>Announce Message</span><BR>");
				dat += text("<BR><A href='?src=\ref[src];setScreen=0'><< Back</A><BR>")

			else	//main menu
				screen = 0
				announceAuth = 0
				if (newmessagepriority == 1)
					dat += text("<div class='notice'>There are new messages</div><BR>")
				if (newmessagepriority == 2)
					dat += text("<div class='notice'>There are new <b>PRIORITY</b> messages</div><BR>")
				dat += text("<A href='?src=\ref[src];setScreen=8'>View Messages</A><BR><BR>")

				dat += text("<A href='?src=\ref[src];setScreen=1'>Request Assistance</A><BR>")
				dat += text("<A href='?src=\ref[src];setScreen=2'>Request Supplies</A><BR>")
				dat += text("<A href='?src=\ref[src];setScreen=3'>Relay Anonymous Information</A><BR><BR>")
				if(announcementConsole)
					dat += text("<A href='?src=\ref[src];setScreen=10'>Send Station-wide Announcement</A><BR><BR>")
				if (silent)
					dat += text("Speaker <A href='?src=\ref[src];setSilent=0'>OFF</A>")
				else
					dat += text("Speaker <A href='?src=\ref[src];setSilent=1'>ON</A>")

		//user << browse("[dat]", "window=request_console")
		//onclose(user, "req_console")
		var/datum/browser/popup = new(user, "req_console", "[department] Requests Console", 400, 440)
		popup.set_content(dat)
		popup.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))
		popup.open()
	return

/obj/machinery/requests_console/Topic(href, href_list)
	if(..())	return
	usr.set_machine(src)
	add_fingerprint(usr)

	if(reject_bad_text(href_list["write"]))
		dpt = ckey(href_list["write"]) //write contains the string of the receiving department's name

		var/new_message = copytext(reject_bad_text(input(usr, "Write your message:", "Awaiting Input", "")),1,MAX_MESSAGE_LEN)
		if(new_message)
			message = new_message
			screen = 9
			if (text2num(href_list["priority"]) < 2)
				priority = -1
			else
				priority = text2num(href_list["priority"])
		else
			dpt = "";
			msgVerified = ""
			msgStamped = ""
			screen = 0
			priority = -1

	if(href_list["writeAnnouncement"])
		var/new_message = copytext(reject_bad_text(input(usr, "Write your message:", "Awaiting Input", "")),1,MAX_MESSAGE_LEN)
		if(new_message)
			message = new_message
			if (text2num(href_list["priority"]) < 2)
				priority = -1
			else
				priority = text2num(href_list["priority"])
		else
			message = ""
			announceAuth = 0
			screen = 0

	if(href_list["sendAnnouncement"])
		if(!announcementConsole)	return
		for(var/mob/M in player_list)
			if(!istype(M,/mob/new_player))
				M << "<b><font size = 3><font color = red>[department] announcement:</font color> [message]</font size></b>"
		announceAuth = 0
		message = ""
		screen = 0

	if( href_list["department"] && message )
		var/log_msg = message
		var/sending = message
		sending += "<br>"
		if (msgVerified)
			sending += msgVerified
			sending += "<br>"
		if (msgStamped)
			sending += msgStamped
			sending += "<br>"
		screen = 7 //if it's successful, this will get overrwritten (7 = unsufccessfull, 6 = successfull)
		if (sending)
			var/pass = 0
			for (var/obj/machinery/message_server/MS in world)
				if(!MS.active) continue
				MS.send_rc_message(href_list["department"],department,log_msg,msgStamped,msgVerified,priority)
				pass = 1

			if(pass)

				for (var/obj/machinery/requests_console/Console in allConsoles)
					if (ckey(Console.department) == ckey(href_list["department"]))
						switch(priority)
							if(2)		//High priority
								if(Console.newmessagepriority < 2)
									Console.newmessagepriority = 2
									Console.icon_state = "req_comp2"
								if(!Console.silent)
									playsound(Console.loc, 'sound/machines/twobeep.ogg', 50, 1)
									for (var/mob/O in hearers(5, Console.loc))
										O.show_message(text("\icon[Console] *The Requests Console beeps: 'PRIORITY Alert in [department]'"))
								Console.messages += "<span class='bad'>High Priority</span><BR><b>From:</b> <a href='?src=\ref[Console];write=[ckey(department)]'>[department]</a><BR>[sending]"

		//					if(3)		//Not implemanted, but will be 		//Removed as it doesn't look like anybody intends on implimenting it ~Carn
		//						if(Console.newmessagepriority < 3)
		//							Console.newmessagepriority = 3
		//							Console.icon_state = "req_comp3"
		//						if(!Console.silent)
		//							playsound(Console.loc, 'sound/machines/twobeep.ogg', 50, 1)
		//							for (var/mob/O in hearers(7, Console.loc))
		//								O.show_message(text("\icon[Console] *The Requests Console yells: 'EXTREME PRIORITY alert in [department]'"))
		//						Console.messages += "<B><FONT color='red'>Extreme Priority message from [ckey(department)]</FONT></B><BR>[message]"

							else		// Normal priority
								if(Console.newmessagepriority < 1)
									Console.newmessagepriority = 1
									Console.icon_state = "req_comp1"
								if(!Console.silent)
									playsound(Console.loc, 'sound/machines/twobeep.ogg', 50, 1)
									for (var/mob/O in hearers(4, Console.loc))
										O.show_message(text("\icon[Console] *The Requests Console beeps: 'Message from [department]'"))
								Console.messages += "<b>From:</b> <a href='?src=\ref[Console];write=[ckey(department)]'>[department]</a><BR>[sending]"

						screen = 6
						Console.luminosity = 2

				switch(priority)
					if(2)
						messages += "<span class='bad'>High Priority</span><BR><b>To:</b> [dpt]<BR>[sending]"
					else
						messages += "<b>To: [dpt]</b><BR>[sending]"
			else
				for (var/mob/O in hearers(4, src.loc))
					O.show_message(text("\icon[src] *The Requests Console beeps: 'NOTICE: No server detected!'"))


	//Handle screen switching
	switch(text2num(href_list["setScreen"]))
		if(null)	//skip
		if(1)		//req. assistance
			screen = 1
		if(2)		//req. supplies
			screen = 2
		if(3)		//relay information
			screen = 3
//		if(4)		//write message
//			screen = 4
		if(5)		//choose priority
			screen = 5
		if(6)		//sent successfully
			screen = 6
		if(7)		//unsuccessfull; not sent
			screen = 7
		if(8)		//view messages
			screen = 8
		if(9)		//authentication
			screen = 9
		if(10)		//send announcement
			if(!announcementConsole)	return
			screen = 10
		else		//main menu
			dpt = ""
			msgVerified = ""
			msgStamped = ""
			message = ""
			priority = -1
			screen = 0

	//Handle silencing the console
	switch( href_list["setSilent"] )
		if(null)	//skip
		if("1")	silent = 1
		else	silent = 0

	updateUsrDialog()
	return

					//err... hacking code, which has no reason for existing... but anyway... it's supposed to unlock priority 3 messanging on that console (EXTREME priority...) the code for that actually exists.
/obj/machinery/requests_console/attackby(var/obj/item/O as obj, var/mob/user as mob)
	/*
	if (istype(O, /obj/item/weapon/crowbar))
		if(open)
			open = 0
			icon_state="req_comp0"
		else
			open = 1
			if(hackState == 0)
				icon_state="req_comp_open"
			else if(hackState == 1)
				icon_state="req_comp_rewired"
	if (istype(O, /obj/item/weapon/screwdriver))
		if(open)
			if(hackState == 0)
				hackState = 1
				icon_state="req_comp_rewired"
			else if(hackState == 1)
				hackState = 0
				icon_state="req_comp_open"
		else
			user << "You can't do much with that."*/

	if (istype(O, /obj/item/weapon/card/id) || istype(O, /obj/item/device/pda))
		if(screen == 9)
			var/obj/item/weapon/card/id/T
			if (istype(O, /obj/item/device/pda))
				var/obj/item/device/pda/U = O
				T = U.id
			else
				T = O
			msgVerified = text("<font color='green'><b>Verified by [T.registered_name] ([T.assignment])</b></font>")
			updateUsrDialog()
		if(screen == 10)
			var/obj/item/weapon/card/id/ID
			if (istype(O,/obj/item/device/pda))
				var/obj/item/device/pda/V = O
				ID = V.id
			else
				ID = O
			if (access_RC_announce in ID.GetAccess())
				announceAuth = 1
			else
				announceAuth = 0
				user << "\red You are not authorized to send announcements."
			updateUsrDialog()
	if (istype(O, /obj/item/weapon/stamp))
		if(screen == 9)
			var/obj/item/weapon/stamp/T = O
			msgStamped = text("<font color='blue'><b>Stamped with the [T.name]</b></font>")
			updateUsrDialog()
	return
