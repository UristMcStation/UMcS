

/obj/structure/reagent_dispensers
	name = "Dispenser"
	desc = "..."
	icon = 'icons/obj/objects.dmi'
	icon_state = "watertank"
	density = 1
	anchored = 0
	flags = FPRINT
	pressure_resistance = 2*ONE_ATMOSPHERE

	var/amount_per_transfer_from_this = 10
	var/possible_transfer_amounts = list(10,25,50,100)

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		return

	New()
		var/datum/reagents/R = new/datum/reagents(1000)
		reagents = R
		R.my_atom = src
		if (!possible_transfer_amounts)
			src.verbs -= /obj/structure/reagent_dispensers/verb/set_APTFT
		..()

	examine()
		set src in view()
		..()
		if (!(usr in view(2)) && usr!=src.loc) return
		usr << "\blue It contains:"
		if(reagents && reagents.reagent_list.len)
			for(var/datum/reagent/R in reagents.reagent_list)
				usr << "\blue [R.volume] units of [R.name]"
		else
			usr << "\blue Nothing."

	verb/set_APTFT() //set amount_per_transfer_from_this
		set name = "Set transfer amount"
		set category = "Object"
		set src in view(1)
		var/N = input("Amount per transfer from this:","[src]") as null|anything in possible_transfer_amounts
		if (N)
			amount_per_transfer_from_this = N

	ex_act(severity)
		switch(severity)
			if(1.0)
				del(src)
				return
			if(2.0)
				if (prob(50))
					new /obj/effect/effect/water(src.loc)
					del(src)
					return
			if(3.0)
				if (prob(5))
					new /obj/effect/effect/water(src.loc)
					del(src)
					return
			else
		return

	blob_act()
		if(prob(50))
			new /obj/effect/effect/water(src.loc)
			del(src)







//Dispensers
/obj/structure/reagent_dispensers/watertank
	name = "watertank"
	desc = "A watertank"
	icon = 'icons/obj/objects.dmi'
	icon_state = "watertank"
	amount_per_transfer_from_this = 10
	New()
		..()
		reagents.add_reagent("water",1000)

/obj/structure/reagent_dispensers/fueltank
	name = "fueltank"
	desc = "A fueltank"
	icon = 'icons/obj/objects.dmi'
	icon_state = "weldtank"
	amount_per_transfer_from_this = 10
	var/obj/item/device/assembly_holder/bombpart = null

	New()
		..()
		reagents.add_reagent("fuel",1000)

	examine()
		..()
		if(bombpart)
			usr << "\blue There is a igniter assembly attached to it!"

	attackby(obj/item/weapon/W as obj,mob/user as mob)
		if(istype(W,/obj/item/device/assembly_holder))
			rig(W,user)
		if(istype(W,/obj/item/weapon/wrench) && bombpart)
			user << "\blue You remove the igniter assembly from the fueltank."
			bombpart.loc = src.loc
			bombpart.master = null
			bombpart = null

	proc/rig(W,user)
		var/obj/item/device/assembly_holder/S = W
		var/mob/M = user
		if(!S.secured)
			return
		if(bombpart)
			usr << "The fueltank is already rigged!"
			return
		if(isigniter(S.a_left) == isigniter(S.a_right))
			return
		if(isinfared(S.a_left) || isinfared(S.a_right))
			return
		if(istype(S.a_left,/obj/item/device/assembly/mousetrap) || istype(S.a_right,/obj/item/device/assembly/mousetrap))
			return
		M.drop_item()

		src.bombpart = S
		S.master = src
		S.loc = src

		usr << "\blue You rig the fueltank!"

		return

	receive_signal()
		visible_message("\icon[src] *beep* *beep*", "*beep* *beep*")
		sleep(10)
		if(!src)
			return
		ex_act()

	HasProximity(atom/movable/AM as mob|obj)
		if(bombpart)
			bombpart.HasProximity(AM)


	bullet_act(var/obj/item/projectile/Proj)
		if(istype(Proj ,/obj/item/projectile/beam)||istype(Proj,/obj/item/projectile/bullet))
			message_admins("[key_name_admin(Proj.firer)] triggered a fueltank explosion.")
			log_game("[key_name(Proj.firer)] triggered a fueltank explosion.")
			explosion(src.loc,-1,0,2)
			if(src)
				del(src)



	blob_act()
		explosion(src.loc,0,1,5,7,10)
		if(src)
			del(src)

	ex_act()
		explosion(src.loc,-1,0,2)
		if(src)
			del(src)

/obj/structure/reagent_dispensers/peppertank
	name = "Pepper Spray Refiller"
	desc = "Refill pepper spray canisters."
	icon = 'icons/obj/objects.dmi'
	icon_state = "peppertank"
	anchored = 1
	density = 0
	amount_per_transfer_from_this = 45
	New()
		..()
		reagents.add_reagent("condensedcapsaicin",1000)


/obj/structure/reagent_dispensers/water_cooler
	name = "Water-Cooler"
	desc = "A machine that dispenses water to drink"
	amount_per_transfer_from_this = 5
	icon = 'icons/obj/vending.dmi'
	icon_state = "water_cooler"
	possible_transfer_amounts = null
	anchored = 1
	New()
		..()
		reagents.add_reagent("water",500)


/obj/structure/reagent_dispensers/beerkeg
	name = "beer keg"
	desc = "A beer keg"
	icon = 'icons/obj/objects.dmi'
	icon_state = "beertankTEMP"
	amount_per_transfer_from_this = 10
	New()
		..()
		reagents.add_reagent("beer",1000)

/obj/structure/reagent_dispensers/beerkeg/blob_act()
	explosion(src.loc,0,3,5,7,10)
	del(src)

/obj/structure/reagent_dispensers/virusfood
	name = "Virus Food Dispenser"
	desc = "A dispenser of virus food."
	icon = 'icons/obj/objects.dmi'
	icon_state = "virusfoodtank"
	amount_per_transfer_from_this = 10
	anchored = 1

	New()
		..()
		reagents.add_reagent("virusfood", 1000)