/datum/round_event_control/special_delivery
	name = "Special Delivery"
	typepath = /datum/round_event/special_delivery
	weight = 5
	max_occurrences = 1


/datum/round_event/special_delivery
	startWhen = 12
	announceWhen = 0
	var/possibleContent = list("Guns" = 3, "Slimes" = 2, "Ids" = 3, "Mech" = 3,"Rigs"=2,"RCD"=2)


/datum/round_event/special_delivery/announce()
	command_alert("@7%-BZZZZT-ackage secured.Delivery inbound. Destination: [station_name()].BZZZ-tify cre-^4*)#-BZZT ", "Centcomm Notice")

/datum/round_event/special_delivery/start()
	if(ferry_location==0)//So we're not sending people back.
		for(var/obj/effect/landmark/C in landmarks_list)
			if(C.name == "Ferry Delivery Spawn")
				var/content =  pickweight(possibleContent)
				if (content)
					switch(content)
						if("Guns")
							//GUNS
							var/obj/structure/closet/crate/A = new /obj/structure/closet/crate(C.loc)
							new /obj/item/weapon/gun/energy/gun(A)
							new /obj/item/weapon/gun/energy/gun(A)
							new /obj/item/weapon/gun/energy/ionrifle(A)
							new /obj/item/weapon/gun/energy/stunrevolver(A)
						if("Slimes")
							//SLIMES (Blind rushing the ferry is fun)
							var/obj/structure/closet/A = new /obj/structure/closet(C.loc)
							new /mob/living/carbon/slime/adult(A)
							new /mob/living/carbon/slime/adult(A)
						if("Rigs")
							//RIGS
							var/obj/structure/closet/A = new /obj/structure/closet(C.loc)
							new /obj/item/clothing/suit/space/rig/medical(A)
							new /obj/item/clothing/suit/space/rig/security(A)
							new /obj/item/clothing/head/helmet/space/rig/medical(A)
							new /obj/item/clothing/head/helmet/space/rig/security(A)
						if("Ids")
							//IDS
							var/obj/structure/closet/A = new /obj/structure/closet/(C.loc)
							var/obj/item/weapon/card/id/B = null
							for(var/i=1; i<=5; i++)
								var/rank = pick("Chef","Chemist","Janitor","Cargo Technician","Station Engineer","Scientist","Security Officer")
								var/datum/job/chosen_job = null
								for(var/datum/job/J in job_master.occupations)
									if(J.title == rank)
										chosen_job = J
										break
								if(chosen_job)
									B = new chosen_job.idtype(A)
									B.access = chosen_job.get_access()
									B.assignment = rank
									B.registered_name = "[B.assignment]"
									B.name = "[B.assignment]"
						if("Mech")
							//MECHANIZED CHAOS
							var/obj/mecha/combat/durand/D =  new /obj/mecha/combat/durand(C.loc) //Could be random one as well.
							var/obj/item/mecha_parts/mecha_equipment/E = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/lmg
							E.attach(D)
							E = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/scattershot
							E.attach(D)
						if("RCD")
							//RCDS
							var/obj/structure/closet/A = new /obj/structure/closet(C.loc)
							for(var/i=1; i<=4; i++)
								var/obj/item/weapon/rcd/B = new /obj/item/weapon/rcd(A)
								B.matter = 30
								B.desc = "A RCD. It currently holds [B.matter]/30 matter-units." //Ugh. Probably should add helper proc to RCD

						//Probably needs few more things to keep it fresh
				break
		move_ferry()


