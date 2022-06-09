class_name UUID
extends Object

const MODULE8BIT = 256

static func get_random_int():
	randomize()
	return randi()%MODULE8BIT
	
static func get_uuid_bin():
	 return [
	get_random_int(), get_random_int(), get_random_int(), get_random_int(),
	get_random_int(), get_random_int(), ((get_random_int()) & 0x0f) | 0x40, get_random_int(),
	((get_random_int()) & 0x3f) | 0x80, get_random_int(), get_random_int(), get_random_int(),
	get_random_int(), get_random_int(), get_random_int(), get_random_int(),
  ]

# generates a new custom uuid
static func generate(): 
	var b = get_uuid_bin()
	return '%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-%02x%02x%02x%02x%02x%02x'% [
		b[0], b[1], b[2], b[3],b[4], b[5],b[6], b[7],b[8], b[9], b[10], b[11], b[12], b[13], b[14], b[15]]

