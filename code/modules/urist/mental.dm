/*
Mental Illness are invisible, non-contagious diseases that the Psychologist can treat.
*/

#define DISORDER_CHANCE 5 //The percent chance a new crewmember will have a random mental disorder
#define RANDOM_DISORDER 0 //If 0, a player selected for a disorder can choose which one they receive

/datum/disease/mental //Stuff that's common to all mental illnesses
	form = "Mental Illness"
	affected_species = list("Human")
	spread_type = NON_CONTAGIOUS
	longevity = 0
	curable = 0
	can_carry = 0
	hidden = list(1, 1)

/*Define the disorders themselves
They all need to have defined max_stages, cure, and cure_id variables, as well as a stage_act() proc.
Since they don't show up on health scanners, anything else is just fluff for the moment.
*/

/datum/disease/mental/sad //Basically just a placeholder
	name = "Space Affective Disorder"
	desc = "Spending a long time away from a planetary environment can cause minor despression"
	severity = "Minor"
	max_stages = 4
	cure = "citalopram"
	cure_id = "citalopram"
	//cure_list = list("citalopram", "paroxetine") //ToDo: figure out how cure_list works

/datum/disease/mental/sad/stage_act()
	..()
	switch(stage)//Latent in the early stages
		if(3)
			if(prob(1))
				affected_mob << "\red You feel unhappy."
			if(prob(1))
				affected_mob.emote(pick("sigh","frown"))
		if(4)
			if(prob(2))
				affected_mob << "\red You feel SAD!"
			if(prob(2))
				affected_mob.emote(pick("sigh","frown"))

/datum/disease/mental/depression //A serious mood disorder
	name = "Space Depression"
	desc = "Depression in SPAAAAACE!"
	severity = "Major"
	max_stages = 6
	cure = "citalopram"
	cure_id = null //Space depression has no cure, but it can be treated
	stage_prob = 2 //Should advance pretty slowly

/datum/disease/mental/depression/stage_act()
	..()
	switch(stage)//Stages 1-3 are latent, with no adverse symptons
		if(4)//Stage 4 gives messages and is treatable
			if(affected_mob.reagents.has_reagent("citalopram")||affected_mob.reagents.has_reagent("paroxetine")) //Treatable, but ultimately incurable
				stage = 1
				return
			if(prob(2))
				affected_mob.emote(pick("sigh","frown","mumble"))
			if(prob(2))
				affected_mob << "\red [pick("You feel empty inside.","You feel sad for no reason.",\
				"You're starting to lose interest in the world.")]"

		if(5)//Various bad things start to happen at stage 5
			if(affected_mob.reagents.has_reagent("citalopram")||affected_mob.reagents.has_reagent("paroxetine")) //Treatable, but ultimately incurable
				stage = 1
				return
			if(prob(1))
				affected_mob.halloss += rand(1,8)
				affected_mob << "\red Your [pick("body","head")] aches."
			if(prob(3))
				affected_mob.bodytemperature -= rand(10,20)
			if(prob(1))
				affected_mob.nutrition -= rand(50,100)
			if(prob(3))
				affected_mob.emote(pick("sigh","frown","mumble","groan","stare"))
			if(prob(3))
				affected_mob << "\red [pick("You feel empty inside.","You feel down in the dumps.",\
				"You don't really care about anything anymore.","You want to lay down and cry.")]"
		if(6)
			if(affected_mob.reagents.has_reagent("citalopram")||affected_mob.reagents.has_reagent("paroxetine"))
				stage = 1
				return
			if(prob(2))
				affected_mob.halloss += rand(5,15)
				affected_mob << "\red Your [pick("body","head")] aches."
				return
			if(prob(5))
				affected_mob.bodytemperature -= rand(20,30)
				return
			if(prob(2))
				affected_mob.nutrition -= rand(100,200)
			if(prob(4))
				affected_mob.emote(pick("sigh","frown","mumble","groan","stare","whimper","cry"))
			if(prob(4))
				affected_mob << "\red [pick("You can't do anything right, can you?", "Aren't you just worthless?",\
				"Why don't you kill yourself already?", "You feel empty inside.",\
				"You feel crushing despair.", "You don't really care about anything anymore.",\
				"You want to lay down and cry.")]"



//These procs assign a random mental disorder to new crewmembers based on the preset DISORDER_CHANCE
//They don't have any safety checks, so there might be some weird edge case that breaks them. ToDo: fix this, obviously

/mob/proc/roll_disorder() //If a certain low number is rolled, assign a mental disease to the mob and add a prescription to their backpack
	if(prob(DISORDER_CHANCE))

		//Pick a disorder
		var/datum/disease/mental/D
		if(RANDOM_DISORDER == 0)//Disorder choice is on
			spawn(0)//I need to take another look at this. The selection should time out after a while? -CoZarctan
				switch(input(src, "What kind of crazy are you?") in list("SAD", "Depression"))//Add new disorders to this list
					if("SAD")
						D = new /datum/disease/mental/sad
					if("Depression")
						D = new /datum/disease/mental/depression
				src.give_disorder(D)
		else
			var/disorder_type = pick(/datum/disease/mental/sad, /datum/disease/mental/depression)//Add new disorders to this list so they'll be picked
			D = new disorder_type
			src.give_disorder(D)


/proc/assign_disorders()
	for(var/mob/living/carbon/human/player in player_list)
		player.roll_disorder()

/mob/proc/give_disorder(var/datum/disease/mental/D)
//Assign the disorder
	var/mob/living/carbon/human/H = src
	D.carrier = 0
	D.holder = H
	D.affected_mob = H
	src.viruses += D

	//Adds a note to medical records //Still have to get this working! -Cozarctan
	/*
	var/datum/data/record/R = find_record("mi_dis", "None", data_core.medical)
	R.fields["ma_dis"]		= "[D.name]"
	R.fields["ma_dis_d"]	= "Treat with [D.cure]."
	*/

	//Add an empty pill bottle to backpack if it exists.
	switch(H.backbag)
		if(1)
			var/obj/item/weapon/storage/pill_bottle/prescription/B = new /obj/item/weapon/storage/pill_bottle(src)
			B.name = "Bottle of [D.cure] pills"
			src.equip_to_slot_or_del(B, slot_l_hand)
		if(2 || 3)
			var/obj/item/weapon/storage/backpack/BPK = src.get_item_by_slot(slot_back)
			var/obj/item/weapon/storage/pill_bottle/prescription/B = new /obj/item/weapon/storage/pill_bottle/prescription
			B.name = "[D.cure] prescription"
			B.loc = BPK
			B.on_enter_storage(BPK)

