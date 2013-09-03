/obj/screen
	name = ""
	icon = 'icons/mob/screen_gen.dmi'
	layer = 20.0
	unacidable = 1
	var/obj/master = null	//A reference to the object in the slot. Grabs or items, generally.


/obj/screen/text
	icon = null
	icon_state = null
	mouse_opacity = 0
	screen_loc = "CENTER-7,CENTER-7"
	maptext_height = 480
	maptext_width = 480


/obj/screen/inventory
	var/slot_id	//The indentifier for the slot. It has nothing to do with ID cards.


/obj/screen/close
	name = "close"

/obj/screen/close/Click()
	if(master)
		if(istype(master, /obj/item/weapon/storage))
			var/obj/item/weapon/storage/S = master
			S.close(usr)


/obj/screen/item_action
	var/obj/item/owner

/obj/screen/item_action/Click()
	if(!usr || !owner)
		return

	if(usr.stat || usr.restrained() || usr.stunned || usr.lying)
		return

	if(!(owner in usr))
		return

	owner.ui_action_click()

//This is the proc used to update all the action buttons. It just returns for all mob types except humans.
/mob/proc/update_action_buttons()
	return


/obj/screen/grab
	name = "grab"

/obj/screen/grab/Click()
	var/obj/item/weapon/grab/G = master
	G.s_click(src)

/obj/screen/grab/attack_hand()
	return

/obj/screen/grab/attackby()
	return


/obj/screen/storage
	name = "storage"

/obj/screen/storage/attack_hand(mob/user)
	if(master)
		var/obj/item/I = user.get_active_hand()
		if(I)
			master.attackby(I, user)


/obj/screen/zone_sel
	name = "damage zone"
	icon_state = "zone_sel"
	screen_loc = ui_zonesel
	var/selecting = "chest"

/obj/screen/zone_sel/Click(location, control,params)
	var/list/PL = params2list(params)
	var/icon_x = text2num(PL["icon-x"])
	var/icon_y = text2num(PL["icon-y"])
	var/old_selecting = selecting //We're only going to update_icon() if there's been a change

	switch(icon_y)
		if(1 to 9) //Legs
			switch(icon_x)
				if(10 to 15)
					selecting = "r_leg"
				if(17 to 22)
					selecting = "l_leg"
				else
					return
		if(10 to 13) //Hands and groin
			switch(icon_x)
				if(8 to 11)
					selecting = "r_arm"
				if(12 to 20)
					selecting = "groin"
				if(21 to 24)
					selecting = "l_arm"
				else
					return
		if(14 to 22) //Chest and arms to shoulders
			switch(icon_x)
				if(8 to 11)
					selecting = "r_arm"
				if(12 to 20)
					selecting = "chest"
				if(21 to 24)
					selecting = "l_arm"
				else
					return
		if(23 to 30) //Head, but we need to check for eye or mouth
			if(icon_x in 12 to 20)
				selecting = "head"
				switch(icon_y)
					if(23 to 24)
						if(icon_x in 15 to 17)
							selecting = "mouth"
					if(26) //Eyeline, eyes are on 15 and 17
						if(icon_x in 14 to 18)
							selecting = "eyes"
					if(25 to 27)
						if(icon_x in 15 to 17)
							selecting = "eyes"

	if(old_selecting != selecting)
		update_icon()

/obj/screen/zone_sel/update_icon()
	overlays.Cut()
	overlays += image('icons/mob/screen_gen.dmi', "[selecting]")


/obj/screen/Click(location, control, params)
	if(!usr)	return

	switch(name)
		if("toggle")
			if(usr.hud_used.inventory_shown)
				usr.hud_used.inventory_shown = 0
				usr.client.screen -= usr.hud_used.other
			else
				usr.hud_used.inventory_shown = 1
				usr.client.screen += usr.hud_used.other

			usr.hud_used.hidden_inventory_update()

		if("equip")
			if(ishuman(usr))
				var/mob/living/carbon/human/H = usr
				H.quick_equip()

		if("resist")
			if(isliving(usr))
				var/mob/living/L = usr
				L.resist()

		if("mov_intent")
			if(iscarbon(usr))
				var/mob/living/carbon/C = usr
				if(C.legcuffed)
					C << "<span class='notice'>You are legcuffed! You cannot run until you get [C.legcuffed] removed!</span>"
					C.m_intent = "walk"	//Just incase
					C.hud_used.move_intent.icon_state = "walking"
					return
				switch(usr.m_intent)
					if("run")
						usr.m_intent = "walk"
						usr.hud_used.move_intent.icon_state = "walking"
					if("walk")
						usr.m_intent = "run"
						usr.hud_used.move_intent.icon_state = "running"
				if(istype(usr,/mob/living/carbon/alien/humanoid))
					usr.update_icons()
		if("m_intent")
			if(!usr.m_int)
				switch(usr.m_intent)
					if("run")
						usr.m_int = "13,14"
					if("walk")
						usr.m_int = "14,14"
					if("face")
						usr.m_int = "15,14"
			else
				usr.m_int = null
		if("walk")
			usr.m_intent = "walk"
			usr.m_int = "14,14"
		if("face")
			usr.m_intent = "face"
			usr.m_int = "15,14"
		if("run")
			usr.m_intent = "run"
			usr.m_int = "13,14"
		if("Reset Machine")
			usr.unset_machine()
		if("internal")
			if(iscarbon(usr))
				var/mob/living/carbon/C = usr
				if(!C.stat && !C.stunned && !C.paralysis && !C.restrained())
					if(C.internal)
						C.internal = null
						C << "<span class='notice'>No longer running on internals.</span>"
						if(C.internals)
							C.internals.icon_state = "internal0"
					else
						if(!istype(C.wear_mask, /obj/item/clothing/mask))
							C << "<span class='notice'>You are not wearing a mask.</span>"
							return
						else
							if(istype(C.l_hand, /obj/item/weapon/tank))
								C << "<span class='notice'>You are now running on internals from the [C.l_hand] on your left hand.</span>"
								C.internal = C.l_hand
							else if(istype(C.r_hand, /obj/item/weapon/tank))
								C << "<span class='notice'>You are now running on internals from the [C.r_hand] on your right hand.</span>"
								C.internal = C.r_hand
							else if(ishuman(C))
								var/mob/living/carbon/human/H = C
								if(istype(H.s_store, /obj/item/weapon/tank))
									H << "<span class='notice'>You are now running on internals from the [H.s_store] on your [H.wear_suit].</span>"
									H.internal = H.s_store
								else if(istype(H.belt, /obj/item/weapon/tank))
									H << "<span class='notice'>You are now running on internals from the [H.belt] on your belt.</span>"
									H.internal = H.belt
								else if(istype(H.l_store, /obj/item/weapon/tank))
									H << "<span class='notice'>You are now running on internals from the [H.l_store] in your left pocket.</span>"
									H.internal = H.l_store
								else if(istype(H.r_store, /obj/item/weapon/tank))
									H << "<span class='notice'>You are now running on internals from the [H.r_store] in your right pocket.</span>"
									H.internal = H.r_store

							//Seperate so CO2 jetpacks are a little less cumbersome.
							if(!C.internal && istype(C.back, /obj/item/weapon/tank))
								C << "<span class='notice'>You are now running on internals from the [C.back] on your back.</span>"
								C.internal = C.back

							if(C.internal)
								if(C.internals)
									C.internals.icon_state = "internal1"
							else
								C << "<span class='notice'>You don't have an oxygen tank.</span>"
		if("act_intent")
			usr.a_intent_change("right")
		if("pull")
			usr.stop_pulling()
		if("throw/catch")
			if(!usr.stat && isturf(usr.loc) && !usr.restrained())
				usr:toggle_throw_mode()
		if("drop")
			usr.drop_item_v()
		if("swap")
			usr:swap_hand()
		if("hand")
			usr:swap_hand()
		if("r_hand")
			if(iscarbon(usr))
				var/mob/living/carbon/C = usr
				C.activate_hand("r")
		if("l_hand")
			if(iscarbon(usr))
				var/mob/living/carbon/C = usr
				C.activate_hand("l")
		if("module")
			if(issilicon(usr))
				if(usr:module)
					return
				usr:pick_module()

		if("radio")
			if(issilicon(usr))
				usr:radio_menu()
		if("panel")
			if(issilicon(usr))
				usr:installed_modules()

		if("store")
			if(issilicon(usr))
				usr:uneq_active()

		if("module1")
			if(usr:module_state_1)
				if(usr:module_active != usr:module_state_1)
					usr:inv1.icon_state = "inv1 +a"
					usr:inv2.icon_state = "inv2"
					usr:inv3.icon_state = "inv3"
					usr:module_active = usr:module_state_1
				else
					usr:inv1.icon_state = "inv1"
					usr:module_active = null

		if("module2")
			if(usr:module_state_2)
				if(usr:module_active != usr:module_state_2)
					usr:inv1.icon_state = "inv1"
					usr:inv2.icon_state = "inv2 +a"
					usr:inv3.icon_state = "inv3"
					usr:module_active = usr:module_state_2
				else
					usr:inv2.icon_state = "inv2"
					usr:module_active = null

		if("module3")
			if(usr:module_state_3)
				if(usr:module_active != usr:module_state_3)
					usr:inv1.icon_state = "inv1"
					usr:inv2.icon_state = "inv2"
					usr:inv3.icon_state = "inv3 +a"
					usr:module_active = usr:module_state_3
				else
					usr:inv3.icon_state = "inv3"
					usr:module_active = null

		else
			DblClick()


/obj/screen/inventory/attack_hand(mob/user)
	if(user.attack_ui(slot_id))
		user.update_inv_l_hand(0)
		user.update_inv_r_hand(0)

/obj/screen/inventory/attack_paw(mob/user)
	return attack_hand(user)

/mob/living/carbon/human/verb/quick_equip()
	set name = "quick-equip"
	set hidden = 1

	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		var/obj/item/I = H.get_active_hand()
		if(!I)
			H << "<span class='notice'>You are not holding anything to equip.</span>"
			return
		if(H.equip_to_appropriate_slot(I))
			if(hand)
				update_inv_l_hand(0)
			else
				update_inv_r_hand(0)
		else
			H << "\red You are unable to equip that."

/mob/living/verb/resist()
	set name = "Resist"
	set category = "IC"

	if(!isliving(usr) || usr.next_move > world.time)
		return
	usr.next_move = world.time + 20

	var/mob/living/L = usr

	//resisting grabs (as if it helps anyone...)
	if(!L.stat && L.canmove && !L.restrained())
		var/resisting = 0
		for(var/obj/O in L.requests)
			del(O)
			resisting++
		for(var/obj/item/weapon/grab/G in usr.grabbed_by)
			resisting++
			if(G.state == GRAB_PASSIVE)
				del(G)
			else
				if(G.state == GRAB_AGGRESSIVE)
					if(prob(25))
						L.visible_message("<span class='warning'>[L] has broken free of [G.assailant]'s grip!</span>")
						del(G)
				else
					if(G.state == GRAB_NECK)
						if(prob(5))
							L.visible_message("<span class='warning'>[L] has broken free of [G.assailant]'s headlock!</span>")
							del(G)
		if(resisting)
			L.visible_message("<span class='warning'>[L] resists!</span>")


	//unbuckling yourself
	if(L.buckled && L.last_special <= world.time)
		if(iscarbon(L))
			var/mob/living/carbon/C = L
			if(C.handcuffed)
				C.next_move = world.time + 100
				C.last_special = world.time + 100
				C.visible_message("<span class='warning'>[usr] attempts to unbuckle themself!</span>", \
							"<span class='notice'>You attempt to unbuckle yourself. (This will take around 2 minutes and you need to stay still.)</span>")
				spawn(0)
					if(do_after(usr, 1200))
						if(!C.buckled)
							return
						C.visible_message("<span class='danger'>[usr] manages to unbuckle themself!</span>", \
											"<span class='notice'>You successfully unbuckle yourself.</span>")
						C.buckled.manual_unbuckle(C)
			else
				L.buckled.manual_unbuckle(L)
		else
			L.buckled.manual_unbuckle(L)

	//Breaking out of a locker?
	else if(loc && istype(loc, /obj/structure/closet))
		var/obj/structure/closet/C = L.loc
		var/breakout_time = 2 //2 minutes by default
		if(istype(L.loc, /obj/structure/closet/critter) && !C.welded)
			breakout_time = 0.75 //45 seconds if it's an unwelded critter crate

		if(C.opened || (!C.welded && !C.locked))
			return	//Door's open, not locked or welded, no point in resisting.

		//okay, so the closet is either welded or locked... resist!!!
		usr.next_move = world.time + 100
		L.last_special = world.time + 100
		L << "<span class='notice'>You lean on the back of [C] and start pushing the door open. (this will take about [breakout_time] minutes.)</span>"
		for(var/mob/O in viewers(C))
			O << "<span class='warning'>[C] begins to shake violently!</span>"

		if(do_after(usr,(breakout_time*60*10))) //minutes * 60seconds * 10deciseconds
			if(!C || !L || L.stat != CONSCIOUS || L.loc != C || C.opened || (!C.locked && !C.welded))
				return
			//we check after a while whether there is a point of resisting anymore and whether the user is capable of resisting

			C.welded = 0 //applies to all lockers lockers
			C.locked = 0 //applies to critter crates and secure lockers only
			C.broken = 1 //applies to secure lockers only
			L.visible_message("<span class='danger'>[L] successfully broke out of [C]!</span>", \
							"<span class='notice'>You successfully break out of [C]!</span>")
			if(istype(C.loc, /obj/structure/bigDelivery)) //Do this to prevent contents from being opened into nullspace (read: bluespace)
				var/obj/structure/bigDelivery/BD = C.loc
				BD.attack_hand(usr)
			C.open()

	//breaking out of handcuffs
	else if(iscarbon(L))
		var/mob/living/carbon/CM = L
		if(CM.handcuffed && CM.canmove && (CM.last_special <= world.time))
			CM.next_move = world.time + 100
			CM.last_special = world.time + 100
			if(isalienadult(CM) || (HULK in usr.mutations))//Don't want to do a lot of logic gating here.
				CM.visible_message("<span class='warning'>[CM] is trying to break [CM.handcuffed]!</span>", \
							"<span class='notice'>You attempt to break [CM.handcuffed]. (This will take around 5 seconds and you need to stand still.)</span>")
				spawn(0)
					if(do_after(CM, 50))
						if(!CM.handcuffed || CM.buckled)
							return
						CM.visible_message("<span class='danger'>[CM] manages to break [CM.handcuffed]!</span>" , \
										"<span class='notice'>You successfully break [CM.handcuffed]!</span>")
						CM.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!" ))
						del(CM.handcuffed)
						CM.handcuffed = null
						CM.update_inv_handcuffed(0)
			else
				var/obj/item/weapon/handcuffs/HC = CM.handcuffed
				var/breakouttime = 1200 //A default in case you are somehow handcuffed with something that isn't an obj/item/weapon/handcuffs type
				var/displaytime = 2 //Minutes to display in the "this will take X minutes."
				if(istype(HC)) //If you are handcuffed with actual handcuffs... Well what do I know, maybe someone will want to handcuff you with toilet paper in the future...
					breakouttime = HC.breakouttime
					displaytime = breakouttime / 600 //Minutes
				CM.visible_message("<span class='warning'>[usr] attempts to remove [HC]!</span>", \
						"<span class='notice'>You attempt to remove [HC]. (This will take around [displaytime] minutes and you need to stand still.)</span>")
				spawn(0)
					if(do_after(CM, breakouttime))
						if(!CM.handcuffed || CM.buckled)
							return // time leniency for lag which also might make this whole thing pointless but the server
						CM.visible_message("<span class='danger'>[CM] manages to remove [CM.handcuffed]!</span>", \
										"<span class='notice'>You successfully remove [CM.handcuffed].</span>")
						CM.handcuffed.loc = usr.loc
						CM.handcuffed = null
						CM.update_inv_handcuffed(0)
		else if(CM.legcuffed && CM.canmove && (CM.last_special <= world.time))
			CM.next_move = world.time + 100
			CM.last_special = world.time + 100
			if(isalienadult(CM) || (HULK in usr.mutations))//Don't want to do a lot of logic gating here.
				CM.visible_message("<span class='warning'>[CM] is trying to break [CM.legcuffed]!</span>", \
						"<span class='notice'>You attempt to break [CM.legcuffed]. (This will take around 5 seconds and you need to stand still.)</span>")
				spawn(0)
					if(do_after(CM, 50))
						if(!CM.legcuffed || CM.buckled)
							return
						CM.visible_message("<span class='danger'>[CM] manages to break [CM.legcuffed]!</span>", \
											"<span class='notice'>You successfully break [CM.legcuffed].</span>")
						CM.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!" ))
						del(CM.legcuffed)
						CM.legcuffed = null
						CM.update_inv_legcuffed(0)
			else
				var/obj/item/weapon/legcuffs/HC = CM.legcuffed
				var/breakouttime = 1200 //A default in case you are somehow legcuffed with something that isn't an obj/item/weapon/legcuffs type
				var/displaytime = 2 //Minutes to display in the "this will take X minutes."
				if(istype(HC)) //If you are legcuffed with actual legcuffs... Well what do I know, maybe someone will want to legcuff you with toilet paper in the future...
					breakouttime = HC.breakouttime
					displaytime = breakouttime / 600 //Minutes
				CM.visible_message("<span class='warning'>[CM] attempts to remove [HC]!</span>", \
						"<span class='notice'>You attempt to remove [HC]. (This will take around [displaytime] minutes and you need to stand still.)</span>")
				spawn(0)
					if(do_after(CM, breakouttime))
						if(!CM.legcuffed || CM.buckled)
							return	//time leniency for lag which also might make this whole thing pointless but the server
						CM.visible_message("<span class='danger'>[CM] manages to remove [CM.legcuffed]!</span>", \
											"<span class='notice'>You successfully remove [CM.legcuffed].</span>")
						CM.legcuffed.loc = usr.loc
						CM.legcuffed = null
						CM.update_inv_legcuffed(0)