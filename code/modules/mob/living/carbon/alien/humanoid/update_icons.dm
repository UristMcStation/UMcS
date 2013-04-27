//Xeno Overlays Indexes//////////
#define X_L_HAND_LAYER			1
#define X_R_HAND_LAYER			2
#define X_TOTAL_LAYERS			2
/////////////////////////////////

/mob/living/carbon/alien/humanoid
	var/list/overlays_lying[X_TOTAL_LAYERS]
	var/list/overlays_standing[X_TOTAL_LAYERS]

/mob/living/carbon/alien/humanoid/update_icons()
	lying_prev = lying	//so we don't update overlays for lying/standing unless our stance changes again
	update_hud()		//TODO: remove the need for this to be here
	overlays.Cut()
	if(stat == DEAD)
		//If we mostly took damage from fire
		if(fireloss > 125)
			icon_state = "alien[caste]_husked"
		else
			icon_state = "alien[caste]_dead"
		for(var/image/I in overlays_lying)
			overlays += I
	else if(lying)
		if(resting)
			icon_state = "alien[caste]_sleep"
		else if(stat == UNCONSCIOUS)
			icon_state = "alien[caste]_unconscious"
		else
			icon_state = "alien[caste]_l"
		for(var/image/I in overlays_lying)
			overlays += I
	else
		if(m_intent == "run")		icon_state = "alien[caste]_running"
		else						icon_state = "alien[caste]_s"
		for(var/image/I in overlays_standing)
			overlays += I

/mob/living/carbon/alien/humanoid/regenerate_icons()
	..()
	if (monkeyizing)	return

	update_inv_r_hand(0)
	update_inv_l_hand(0)
	update_inv_pockets(0)
	update_hud()
	update_icons()


/mob/living/carbon/alien/humanoid/update_hud()
	if(client)
		client.screen |= contents


/mob/living/carbon/alien/humanoid/update_inv_pockets(update_icons = 1)
	if(l_store)
		l_store.screen_loc = ui_alien_storage_l
	if(r_store)
		r_store.screen_loc = ui_alien_storage_r

	if(update_icons)
		update_icons()


/mob/living/carbon/alien/humanoid/update_inv_r_hand(update_icons = 1)
	if(r_hand)
		var/t_state = r_hand.item_state
		if(!t_state)
			t_state = r_hand.icon_state
		r_hand.screen_loc = ui_rhand
		overlays_standing[X_R_HAND_LAYER]	= image("icon" = 'icons/mob/items_righthand.dmi', "icon_state" = t_state)
	else
		overlays_standing[X_R_HAND_LAYER]	= null
	if(update_icons)
		update_icons()

/mob/living/carbon/alien/humanoid/update_inv_l_hand(update_icons = 1)
	if(l_hand)
		var/t_state = l_hand.item_state
		if(!t_state)
			t_state = l_hand.icon_state
		l_hand.screen_loc = ui_lhand
		overlays_standing[X_L_HAND_LAYER]	= image("icon" = 'icons/mob/items_lefthand.dmi', "icon_state" = t_state)
	else
		overlays_standing[X_L_HAND_LAYER]	= null
	if(update_icons)
		update_icons()


//Xeno Overlays Indexes//////////
#undef X_L_HAND_LAYER
#undef X_R_HAND_LAYER
#undef X_TOTAL_LAYERS
