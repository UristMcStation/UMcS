/obj/item/weapon/melee/chainofcommand
	name = "chain of command"
	desc = "A tool used by great men to placate the frothing masses."
	icon_state = "chain"
	item_state = "chain"
	flags = FPRINT | TABLEPASS | CONDUCT
	slot_flags = SLOT_BELT
	force = 10
	throwforce = 7
	w_class = 3
	origin_tech = "combat=4"
	attack_verb = list("flogged", "whipped", "lashed", "disciplined")

	suicide_act(mob/user)
		viewers(user) << "\red <b>[user] is strangling \himself with the [src.name]! It looks like \he's trying to commit suicide.</b>"
		return (OXYLOSS)

/obj/item/weapon/melee/bat
	name = "baseball bat"
	desc = "A baseball bat to play a well know game."
	icon_state = "bat"
	item_state = "bat"
	flags = FPRINT | TABLEPASS | CONDUCT
	slot_flags = SLOT_BELT
	force = 4
	throwforce = 6
	w_class = 3
	origin_tech = "combat=1"
	attack_verb = list("hit", "smashed", "bashed")
