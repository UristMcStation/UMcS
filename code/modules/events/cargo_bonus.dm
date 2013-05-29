/datum/round_event_control/cargo_bonus
	name = "Cargo Bonus"
	typepath = /datum/round_event/cargo_bonus
	weight = 5
	max_occurrences = 1

/datum/round_event/cargo_bonus
	announceWhen	= 5

/datum/round_event/cargo_bonus/announce()
	command_alert("Congratulations! [station_name()] was chosen for supply limit increase, please contact local cargo department for details!.", "Supply Alert")

/datum/round_event/cargo_bonus/start()
	supply_shuttle.points+=rand(100,500)