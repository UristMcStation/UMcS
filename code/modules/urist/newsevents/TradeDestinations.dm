
var/list/weighted_randomevent_locations = list()
var/list/weighted_mundaneevent_locations = list()

/datum/trade_destination
	var/name = ""
	var/description = ""
	var/list/viable_random_events = list()
	var/list/temp_price_change[BIOMEDICAL]
	var/list/viable_mundane_events = list()

/datum/trade_destination/proc/get_custom_eventstring(var/event_type)
	return null

/datum/trade_destination/centcomm
	name = "CentComm"
	description = "NanoTrasen's administrative centre for Tau Ceti."
	viable_random_events = list(SECURITY_BREACH, CORPORATE_ATTACK, AI_LIBERATION)
	viable_mundane_events = list(ELECTION, RESIGNATION, CELEBRITY_DEATH)

/datum/trade_destination/eden
	name = "NSS Eden"
	description = "Medical station ran by New Green Cross (but owned by NT) for handling emergency cases from nearby colonies."
	viable_random_events = list(SECURITY_BREACH, CULT_CELL_REVEALED, BIOHAZARD_OUTBREAK, PIRATES, ALIEN_RAIDERS)
	viable_mundane_events = list(RESEARCH_BREAKTHROUGH, RESEARCH_BREAKTHROUGH, BARGAINS, GOSSIP)

/datum/trade_destination/anansi/get_custom_eventstring(var/event_type)
	if(event_type == RESEARCH_BREAKTHROUGH)
		return "Thanks to research conducted on the NSS Eden, New Green Cross Society wishes to announce a major breakthough in the field of \
		[pick("mind-machine interfacing","neuroscience","nano-augmentation","genetics")]. NanoTrasen is expected to announce a co-exploitation deal within the fortnight."
	return null

/datum/trade_destination/icarus
	name = "NNV Icarus"
	description = "Corvette assigned to patrol NSS Exodus local space."
	viable_random_events = list(SECURITY_BREACH, AI_LIBERATION, PIRATES)

/datum/trade_destination/redolant
	name = "OAV Redolant"
	description = "Osiris Atmospherics station in orbit around the only gas giant insystem. They retain tight control over shipping rights, and Osiris warships protecting their prize are not an uncommon sight in Tau Ceti."
	viable_random_events = list(INDUSTRIAL_ACCIDENT, PIRATES, CORPORATE_ATTACK)
	viable_mundane_events = list(RESEARCH_BREAKTHROUGH, RESEARCH_BREAKTHROUGH)

/datum/trade_destination/redolant/get_custom_eventstring(var/event_type)
	if(event_type == RESEARCH_BREAKTHROUGH)
		return "Thanks to research conducted on the OAV Redolant, Osiris Atmospherics wishes to announce a major breakthough in the field of \
		[pick("plasma research","high energy flux capacitance","super-compressed materials","theoretical particle physics")]. NanoTrasen is expected to announce a co-exploitation deal within the fortnight."
	return null

/datum/trade_destination/belt
	name = "NX7 2541"
	description = "A co-operative effort between the Outer Rim Miners Alliance and NanoTrasen to exploit the rich outer asteroid belt of the Tau Ceti system."
	viable_random_events = list(PIRATES, INDUSTRIAL_ACCIDENT)
	viable_mundane_events = list(TOURISM)

/datum/trade_destination/ryclies
	name = "Ryclies I"
	description = "a major hiveworld  planet, a towering city that calls itself a planet. Every mile of land is pavement, skyscraper and industry. A major Terran Confederacy planet, it also has a large corporate presence on it."
	viable_random_events = list(RIOTS, INDUSTRIAL_ACCIDENT, BIOHAZARD_OUTBREAK, CULT_CELL_REVEALED, FESTIVAL, MOURNING)
	viable_mundane_events = list(BARGAINS, GOSSIP, SONG_DEBUT, MOVIE_RELEASE, ELECTION, TOURISM, RESIGNATION, CELEBRITY_DEATH)

/datum/trade_destination/new_antares
	name = "New Antares"
	description = "Heavily industrialised rocky planet containing the majority of the planet-bound resources in the system, New Antares is torn by unrest and has very little wealth to call it's own except in the hands of the corporations who jostle with NT for control."
	viable_random_events = list(RIOTS, INDUSTRIAL_ACCIDENT, BIOHAZARD_OUTBREAK, CULT_CELL_REVEALED, FESTIVAL, MOURNING)
	viable_mundane_events = list(ELECTION, TOURISM, RESIGNATION)

/datum/trade_destination/luthien
	name = "Luthien IV"
	description = "A small colony established on a feral, untamed world (largely jungle). Savages and wild beasts attack the outpost regularly, although NT maintains tight military control."
	viable_random_events = list(WILD_ANIMAL_ATTACK, CULT_CELL_REVEALED, FESTIVAL, MOURNING, ANIMAL_RIGHTS_RAID, ALIEN_RAIDERS)
	viable_mundane_events = list(ELECTION, TOURISM, BIG_GAME_HUNTERS, RESIGNATION)

/datum/trade_destination/leare
	name = "Leare"
	description = "A cold, metal-deficient world, NT maintains large pastures in whatever available space in an attempt to salvage something from this profitless colony."
	viable_random_events = list(WILD_ANIMAL_ATTACK, CULT_CELL_REVEALED, FESTIVAL, MOURNING, ANIMAL_RIGHTS_RAID, ALIEN_RAIDERS)
	viable_mundane_events = list(ELECTION, TOURISM, BIG_GAME_HUNTERS, RESIGNATION)
