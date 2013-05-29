/datum/round_event_control/special_delivery
	name = "Special Delivery"
	typepath = /datum/round_event/special_delivery
	weight = 5
	max_occurrences = 1


/datum/round_event/special_delivery
	startWhen = 10
	var/possibleContent = list("Guns" = 5, "Slimes" = 2, "Ids" = 2, "Mech" = 5)


/datum/round_event/special_delivery/announce()
	command_alert("@7%-BZZZZT-ackage secured.Delivery inbound. Destination: [station_name()].BZZZ-tify cre-^4*)#-BZZT ", "Centcomm Notice")

/datum/round_event/special_delivery/start()
	for(var/obj/effect/landmark/C in landmarks_list)
		if(C.name == "Ferry Delivery Spawn")
			var/content =  pickweight(possibleContent)
			if (content)
				switch(content)
					if("Guns")
						//GUNS
						var/obj/structure/closet/crate/A = new /obj/structure/closet/crate(C.loc)
						new /obj/item/weapon/gun/energy(A)
						new /obj/item/weapon/gun/energy/ionrifle(A)
						new /obj/item/weapon/gun/energy/stunrevolver(A)
					if("Slimes")
						//SLIMES (Blind rushing the ferry is fun)
						var/obj/structure/closet/A = new /obj/structure/closet(C.loc)
						new /mob/living/carbon/slime/adult(A)
						new /mob/living/carbon/slime/adult(A)
					if("Ids")
						//CHAOS
						var/obj/structure/closet/crate/A = new /obj/structure/closet/crate(C.loc)
						new /obj/item/weapon/card/id/captains_spare(A)
						new /obj/item/weapon/card/id/captains_spare(A)
						new /obj/item/weapon/card/id/captains_spare(A)
						new /obj/item/weapon/card/id/captains_spare(A)
					if("Mech")
						//MECHANIZED CHAOS
						var/obj/mecha/combat/durand/D =  new /obj/mecha/combat/durand(C.loc) //Could be random one as well.
						var/obj/item/mecha_parts/mecha_equipment/E = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/lmg
						E.attach(D)
						E = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/scattershot
						E.attach(D)
					//Probably needs few more things to keep it fresh
			break
	move_ferry()


