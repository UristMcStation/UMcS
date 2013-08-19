/* bottleshelf.  Much todo
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
	var/global/max_n_of_items = 999 // Sorry but the BYOND infinite loop detector doesn't look things over 1000.
	var/icon_on = "smartfridge"
	var/icon_off = "smartfridge-off"
	var/item_quants = list()
	var/ispowered = 1 //starts powered
	var/isbroken = 0

/obj/machinery/chemfridge/proc/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/weapon/reagent_containers/glass/bottle) && !istype(O,/obj/item/weapon/reagent_containers/glass/bottle/robot))
		return 1
	return 0

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
		if(contents.len >= max_n_of_items)
			user << "<span class='notice'>\The [src] is full.</span>"
			return 1
		else
			user.before_take_item(O)
			O.loc = src
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

	if (contents.len == 0)
		dat += "<font color = 'red'>No product loaded!</font>"
	else
		for (var/obj/item/weapon/reagent_containers/glass/O in contents)
			dat += "<FONT color = 'blue'><B>[capitalize(O.name)]</B>:"
			dat += "<a href='byond://?src=\ref[src];vend=[O.name]'>Vend</A> "
			dat += "<br>"

		dat += "</TT>"
	user << browse("<HEAD><TITLE>[src] Supplies</TITLE></HEAD><TT>[dat]</TT>", "window=chemfridge")
	onclose(user, "chemfridge")
	return

/obj/machinery/chemfridge/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)

	var/N = href_list["vend"]

	for(var/obj/item/weapon/reagent_containers/glass/O in contents)
		if(O.name == N)
			O.loc = src.loc
			break

	src.updateUsrDialog()
	return
