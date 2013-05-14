//Adds the functionality for suits to have "pockets" of a sort in which to store small items.
//To add this functionality to any other suit, simply change its path to /suit/storage/[example]
//instead of simply /suit/[example] -Glloyd

/obj/item/clothing/suit/storage
	var/list/can_hold = new/list() //List of objects which this item can store (if set, it can't store anything else)
	var/list/cant_hold = new/list() //List of objects which this item can't store (in effect only if can_hold isn't set)
	var/max_w_class = 2 //Max size of objects that this object can store (in effect only if can_hold isn't set)
	var/max_combined_w_class = 4 //The sum of the w_classes of all the items in this storage item.
	var/storage_slots = 2 //The number of storage slots in this container.
	var/obj/screen/storage/boxes = null
	var/obj/screen/close/closer = null

/obj/item/clothing/suit/storage/proc/return_inv()

	var/list/L = list(  )

	L += src.contents

	for(var/obj/item/weapon/storage/S in src)
		L += S.return_inv()

	return L

/obj/item/clothing/suit/storage/proc/show_to(mob/user as mob)
	user.client.screen -= src.boxes
	user.client.screen -= src.closer
	user.client.screen -= src.contents
	user.client.screen += src.boxes
	user.client.screen += src.closer
	user.client.screen += src.contents
	user.s_active = src
	return

/obj/item/clothing/suit/storage/proc/hide_from(mob/user as mob)

	if(!user.client)
		return
	user.client.screen -= src.boxes
	user.client.screen -= src.closer
	user.client.screen -= src.contents
	return

/obj/item/clothing/suit/storage/proc/close(mob/user as mob)

	src.hide_from(user)
	user.s_active = null
	return

//This proc draws out the inventory and places the items on it. tx and ty are the upper left tile and mx, my are the bottom right.
//The numbers are calculated from the bottom-left The bottom-left slot being 1,1.
/obj/item/clothing/suit/storage/proc/orient_objs(tx, ty, mx, my)
	var/cx = tx
	var/cy = ty
	src.boxes.screen_loc = text("[tx]:,[ty] to [mx],[my]")
	for(var/obj/O in src.contents)
		O.screen_loc = text("[cx],[cy]")
		O.layer = 20
		cx++
		if (cx > mx)
			cx = tx
			cy--
	src.closer.screen_loc = text("[mx+1],[my]")
	return

//This proc draws out the inventory and places the items on it. It uses the standard position.
/obj/item/clothing/suit/storage/proc/standard_orient_objs(var/rows,var/cols)
	var/cx = 4
	var/cy = 2+rows
	src.boxes.screen_loc = text("4:16,2:16 to [4+cols]:16,[2+rows]:16")
	for(var/obj/O in src.contents)
		O.screen_loc = text("[cx]:16,[cy]:16")
		O.layer = 20
		cx++
		if (cx > (4+cols))
			cx = 4
			cy--
	src.closer.screen_loc = text("[4+cols+1]:16,2:16")
	return

//This proc determins the size of the inventory to be displayed. Please touch it only if you know what you're doing. -_-
/obj/item/clothing/suit/storage/proc/orient2hud(mob/user as mob)
	//var/mob/living/carbon/human/H = user
	var/row_num = 0
	var/col_count = min(7,storage_slots) -1
	if (contents.len > 7)
		row_num = round((contents.len-1) / 7) // 7 is the maximum allowed width.
	src.standard_orient_objs(row_num,col_count)
	return

//This proc return 1 if the item can be picked up and 0 if it can't.
//Set the stop_messages to stop it from printing messages
/obj/item/clothing/suit/storage/proc/can_be_inserted(obj/item/W, stop_messages = 0)
	if(!istype(W)) return //Not an item

	if(loc == W)
		return 0 //Means the item is already in the storage item
	if(contents.len >= storage_slots)
		if(!stop_messages)
			usr << "<span class='notice'>[src] is full, make some space.</span>"
		return 0 //Storage item is full

	if(can_hold.len)
		var/ok = 0
		for(var/A in can_hold)
			if(istype(W, text2path(A) ))
				ok = 1
				break
		if(!ok)
			if(!stop_messages)
				usr << "<span class='notice'>[src] cannot hold [W].</span>"
			return 0

	for(var/A in cant_hold) //Check for specific items which this container can't hold.
		if(istype(W, text2path(A) ))
			if(!stop_messages)
				usr << "<span class='notice'>[src] cannot hold [W].</span>"
			return 0

	if(W.w_class > max_w_class)
		if(!stop_messages)
			usr << "<span class='notice'>[W] is too big for this [src].</span>"
		return 0

	var/sum_w_class = W.w_class
	for(var/obj/item/I in contents)
		sum_w_class += I.w_class //Adds up the combined w_classes which will be in the storage item if the item is added to it.

	if(sum_w_class > max_combined_w_class)
		if(!stop_messages)
			usr << "<span class='notice'>[src] is full, make some space.</span>"
		return 0

	if(W.w_class >= w_class && (istype(W, /obj/item/clothing/suit/storage)))
		if(!istype(src, /obj/item/weapon/storage/backpack/holding))	//bohs should be able to hold backpacks again. The override for putting a boh in a boh is in backpack.dm.
			if(!stop_messages)
				usr << "<span class='notice'>[src] cannot hold [W] as it's a storage item of the same size.</span>"
			return 0 //To prevent the stacking of same sized storage items.
	return 1

//This proc handles items being inserted. It does not perform any checks of whether an item can or can't be inserted. That's done by can_be_inserted()
//The stop_warning parameter will stop the insertion message from being displayed. It is intended for cases where you are inserting multiple items at once,
//such as when picking up all the items on a tile with one click.
/obj/item/clothing/suit/storage/proc/handle_item_insertion(obj/item/W, prevent_warning = 0)
	if(!istype(W)) return 0
	if(usr)
		usr.u_equip(W)
	W.loc = src
	W.on_enter_storage(src)
	if(usr)
		if(usr.client && usr.s_active != src)
			usr.client.screen -= W
		W.dropped(usr)
		add_fingerprint(usr)

		if(!prevent_warning && !istype(W, /obj/item/weapon/gun/energy/crossbow))
			for(var/mob/M in viewers(usr, null))
				if(M == usr)
					usr << "<span class='notice'>You put the [W] into [src].</span>"
				else if(in_range(M, usr)) //If someone is standing close enough, they can tell what it is...
					M.show_message("<span class='notice'>[usr] puts [W] into [src].</span>")
				else if(W && W.w_class >= 3.0) //Otherwise they can only see large or normal items from a distance...
					M.show_message("<span class='notice'>[usr] puts [W] into [src].</span>")

		orient2hud(usr)
		if(usr.s_active)
			usr.s_active.show_to(usr)
	update_icon()
	return 1

//Call this proc to handle the removal of an item from the storage item. The item will be moved to the atom sent as new_target
/obj/item/clothing/suit/storage/proc/remove_from_storage(obj/item/W, atom/new_location)
	if(!istype(W)) return 0

	for(var/mob/M in range(1, loc))
		if(M.s_active == src)
			if(M.client)
				M.client.screen -= W

	if(new_location)
		if(ismob(loc))
			W.dropped(usr)
		if(ismob(new_location))
			W.layer = 20
		else
			W.layer = initial(W.layer)
		W.loc = new_location
	else
		W.loc = get_turf(src)

	if(usr)
		orient2hud(usr)
		if(usr.s_active)
			usr.s_active.show_to(usr)
	if(W.maptext)
		W.maptext = ""
	W.on_exit_storage(src)
	update_icon()
	return 1

//This proc is called when you want to place an item into the storage item.
/obj/item/clothing/suit/storage/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/evidencebag) && src.loc != user)
		return

	..()
	if(isrobot(user))
		user << "\blue You're a robot. No."
		return //Robots can't interact with storage items.

	if(src.loc == W)
		return //Means the item is already in the storage item

	if(contents.len >= storage_slots)
		user << "\red \The [src] is full, make some space."
		return //Storage item is full

	if(can_hold.len)
		var/ok = 0
		for(var/A in can_hold)
			if(istype(W, text2path(A) ))
				ok = 1
				break
		if(!ok)
			user << "\red \The [src] cannot hold \the [W]."
			return

	for(var/A in cant_hold) //Check for specific items which this container can't hold.
		if(istype(W, text2path(A) ))
			user << "\red \The [src] cannot hold \the [W]."
			return

	if (W.w_class > max_w_class)
		user << "\red \The [W] is too big for \the [src]"
		return

	var/sum_w_class = W.w_class
	for(var/obj/item/I in contents)
		sum_w_class += I.w_class //Adds up the combined w_classes which will be in the storage item if the item is added to it.

	if(sum_w_class > max_combined_w_class)
		user << "\red \The [src] is full, make some space."
		return

	if(W.w_class >= src.w_class && (istype(W, /obj/item/weapon/storage)))
		if(!istype(src, /obj/item/weapon/storage/backpack/holding))	//bohs should be able to hold backpacks again. The override for putting a boh in a boh is in backpack.dm.
			user << "\red \The [src] cannot hold \the [W] as it's a storage item of the same size."
			return //To prevent the stacking of the same sized items.

	user.u_equip(W)
	playsound(src.loc, "rustle", 50, 1, -5)
	W.loc = src
	if ((user.client && user.s_active != src))
		user.client.screen -= W
	src.orient2hud(user)
	W.dropped(user)
	add_fingerprint(user)
	show_to(user)


/obj/item/clothing/suit/storage/dropped(mob/user as mob)
	return


/obj/item/clothing/suit/storage/MouseDrop(over_object, src_location, over_location)
	..()
	orient2hud(usr)
	if((over_object == usr && (in_range(src, usr) || usr.contents.Find(src))))
		if(usr.s_active)
			usr.s_active.close(usr)
		show_to(usr)

/obj/item/clothing/suit/storage/MouseDrop(obj/over_object)
	if(ishuman(usr))
		var/mob/M = usr
		if(!( istype(over_object, /obj/screen) ))
			return ..()
		if(!(loc == usr) || (loc && loc.loc == usr))
			return
		playsound(loc, "rustle", 50, 1, -5)
		if(!( M.restrained() ) && !( M.stat ))
			switch(over_object.name)
				if("r_hand")
					M.u_equip(src)
					M.put_in_r_hand(src)
				if("l_hand")
					M.u_equip(src)
					M.put_in_l_hand(src)
			add_fingerprint(usr)
			return
		if(over_object == usr && in_range(src, usr) || usr.contents.Find(src))
			if(usr.s_active)
				usr.s_active.close(usr)
			show_to(usr)

/obj/item/clothing/suit/storage/attack_paw(mob/user as mob)
	//playsound(src.loc, "rustle", 50, 1, -5) // what
	return src.attack_hand(user)

/obj/item/clothing/suit/storage/attack_hand(mob/user)
	playsound(loc, "rustle", 50, 1, -5)

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.l_store == src && !H.get_active_hand())	//Prevents opening if it's in a pocket.
			H.put_in_hands(src)
			H.l_store = null
			return
		if(H.r_store == src && !H.get_active_hand())
			H.put_in_hands(src)
			H.r_store = null
			return

	orient2hud(user)
	if(loc == user)
		if(user.s_active)
			user.s_active.close(user)
		show_to(user)
	else
		..()
		for(var/mob/M in range(1))
			if(M.s_active == src)
				close(M)
	add_fingerprint(user)

/obj/item/clothing/suit/storage/New()

	boxes = new /obj/screen/storage()
	boxes.name = "storage"
	boxes.master = src
	boxes.icon_state = "block"
	boxes.screen_loc = "7,7 to 10,8"
	boxes.layer = 19
	closer = new /obj/screen/close()
	closer.master = src
	closer.icon_state = "x"
	closer.layer = 20
	orient2hud()


/obj/item/clothing/suit/storage/emp_act(severity)
	if(!istype(src.loc, /mob/living))
		for(var/obj/O in contents)
			O.emp_act(severity)
	..()