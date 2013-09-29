/*
//////////////////////////////////////

Spiderlings!

	Very Very Noticable.
	Decreases resistance.
	Doesn't increase stage speed.
	Little transmittable.
	Medium Level.

Bonus
	Forces the affected mob to vomit
	spiderlings!
//////////////////////////////////////
*/

/datum/symptom/spiders

	name = "Spiderlings"
	stealth = -3
	resistance = -1
	stage_speed = 0
	transmittable = -2
	level = 6

/datum/symptom/spiders/Activate(var/datum/disease/advance/A)
	..()
	if(prob(SYMPTOM_ACTIVATION_PROB / 2))
		var/mob/living/M = A.affected_mob
		switch(A.stage)
			if(1)
				M << "<span class='notice'>[pick("You get slightly itchy.", "You feel full!")]</span>"
			if(2)
				M << "You get an itch in your throat."
			if(3)
				M << "You feel a wracking itch all over your body."
			if(4)
				M << "You vomit spiderlings!"
				view(7) << "<b>[M]</b> vomits spiderlings!"
				obj/effect/spider/spiderling = new(M.loc) //Hacky, but it should work.
			else
				M << "You vomit spiderlings!"
				view(7) << "<b>[M]</b> vomits spiderlings!"
				obj/effect/spider/spiderling = new(M.loc)

	return