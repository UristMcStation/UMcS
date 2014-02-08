/*
Mental Illness are invisible, non-contagious diseases that the Psychologist can treat.
*/

#define DISORDER_CHANCE 100 //The percent chance a new crewmember will have a random mental disorder

/datum/disease/mental //Stuff that's common to all mental illnesses
	form = "Mental Illness"
	affected_species = list("Human")
	spread_type = NON_CONTAGIOUS
	longevity = 0
	curable = 0
	can_carry = 0
	hidden = list(1, 1) //Comment this out for easy testing

/*Define the disorders themselves
They all need to have defined max_stages, cure, and cure_id variables, as well as a stage_act() proc.
Since they don't show up on health scanners, anything else is just fluff for the moment.
*/

/datum/disease/mental/sad //Basically just a placeholder
	name = "Space Affective Disorder"
	desc = "Spending a long time away from a planetary environment can cause minor despression"
	agent = "Space Stations"
	severity = "Minor"
	max_stages = 2
	cure = "methylphendiate"
	cure_id = "methylphendiate"
	//cure_list = list("methylphenidate", "citalopram", "paroxetine") //ToDo: figure out how cure_list works
	cure_chance = 100

/datum/disease/mental/sad/stage_act()
	..()
	switch(stage)
		if(1)
			if(prob(1))
				affected_mob << "\red You feel unhappy."
		if(2)
			if(prob(2))
				affected_mob << "\red You feel SAD!"



//These procs assign a random mental disorder to new crewmembers based on the preset DISORDER_CHANCE
//They don't have any safety checks, so there might be some weird edge case that breaks them. ToDo: fix this, obviously

/mob/proc/roll_disorder() //If a certain low number is rolled, assign a mental disease to the mob and add a prescription to their backpack
	if(prob(DISORDER_CHANCE))
		//Assign the illness
		var/datum/disease/mental/disorder_type = pick(/datum/disease/mental/sad)//Add new disorders to this list so they'll be picked
		var/datum/disease/mental/D = new disorder_type
		var/mob/living/carbon/human/H = src
		D.carrier = 1
		D.holder = H
		D.affected_mob = H
		H.viruses += D

		//Add an empty pill bottle to backpack if it exists.
		switch(H.backbag)
			if(1)
				var/obj/item/weapon/storage/pill_bottle/prescription/B = new /obj/item/weapon/storage/pill_bottle(H)
				B.name = "Bottle of [D.cure] pills"
				H.equip_to_slot_or_del(B, slot_l_hand)
			if(2 || 3)
				var/obj/item/weapon/storage/backpack/BPK = H.get_item_by_slot(slot_back)
				var/obj/item/weapon/storage/pill_bottle/prescription/B = new /obj/item/weapon/storage/pill_bottle/prescription
				B.name = "[D.cure] prescription"
				B.loc = BPK
				B.on_enter_storage(BPK)

/proc/assign_disorders()
	for(var/mob/living/carbon/human/player in player_list)
		player.roll_disorder()