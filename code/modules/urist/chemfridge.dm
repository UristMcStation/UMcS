/*
	Chemfridge. Shameless copypaste of smartfridge
*/
/obj/machinery/chemfridge
	name = "\improper Chem Storage"
	desc = "Perfect for storing your drug stash"
	icon = 'icons/obj/vending.dmi'
	icon_state = "smartfridge"
	layer = 2.9
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 5
	active_power_usage = 100
	flags = NOREACT
	var/global/max_bottles = 29
	var/shelf[1]
	var/bottle_id = 1
	var/loaded = 0
	var/icon_on = "smartfridge"
	var/icon_off = "smartfridge-off"
	var/ispowered = 1 //starts powered
	var/isbroken = 0

/obj/machinery/chemfridge/proc/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/weapon/reagent_containers/glass/bottle) && !istype(O,/obj/item/weapon/reagent_containers/glass/bottle/robot))
		return 1
	return 0

/obj/machinery/chemfridge/proc/update_id()
	for(var/i=1, i<=shelf.len, i++)
		if(shelf[i]==null)
			bottle_id = i
			return
	bottle_id = shelf.len+1

/obj/machinery/chemfridge/power_change()
	if( powered() )
		src.ispowered = 1
		stat &= ~NOPOWER
		if(!isbroken)
			icon_state = icon_on
	else
		spawn(rand(0, 15))
		src.ispowered = 0
		stat |= NOPOWER
		if(!isbroken)
			icon_state = icon_off



/*******************
*   Item Adding
********************/

/obj/machinery/chemfridge/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(!src.ispowered)
		user << "<span class='notice'>\The [src] is unpowered and useless.</span>"
		return

	if(accept_check(O))
		if(loaded >= max_bottles)
			user << "<span class='notice'>\The [src] is full.</span>"
			return 1
		else
			user.before_take_item(O)
			O.loc = src
			if (shelf.len < bottle_id)
				shelf.Add(O)
			else
				shelf[bottle_id] = O
			loaded++
			update_id()
			user.visible_message("<span class='notice'>[user] has added \the [O] to \the [src].", \
								 "<span class='notice'>You add \the [O] to \the [src].")
	else
		user << "<span class='notice'>\The [src] smartly refuses [O].</span>"
		return 1

	updateUsrDialog()

/obj/machinery/chemfridge/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/chemfridge/attack_ai(mob/user as mob)
	return 0

/obj/machinery/chemfridge/attack_hand(mob/user as mob)
	user.set_machine(src)
	interact(user)

/*******************
*   Chemfridge Menu
********************/

/obj/machinery/chemfridge/interact(mob/user as mob)
	if(!src.ispowered)
		return

	var/dat = "<TT><b>Select an item:</b><br>"
	var/obj/item/weapon/reagent_containers/glass/O

	if (loaded == 0)
		dat += "<font color = 'red'>No product loaded!</font>"
	else
		for(var/i=1, i<=shelf.len, i++)
			if(shelf[i]!=null)
				O = shelf[i]
				dat += "<FONT color = 'blue'><B>[capitalize(O.name)] ([i])</B>:"
				dat += "<a href='byond://?src=\ref[src];vend=[i]'>Vend</A> "
				dat += "<br>"

		dat += "</TT>"
	user << browse("<HEAD><TITLE>[src] Supplies</TITLE></HEAD><TT>[dat]</TT>", "window=chemfridge")
	onclose(user, "chemfridge")
	return

/obj/machinery/chemfridge/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)

	var/N = text2num(href_list["vend"])
	if(shelf[N]!= null) // sanity
		var/obj/item/weapon/reagent_containers/glass/O = shelf[N]
		O.loc = src.loc
		loaded--
		shelf[N] = null
		update_id()
	else
		world << N


	src.updateUsrDialog()
	return
