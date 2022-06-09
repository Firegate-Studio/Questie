# A task node which tracks if the player reached a specific location

extends Node

# The [uuid] of the quest who owns this task
var questUUID : String

const QUESTIE_BUILTIN = true

# if [has_timer] the task will be an amount of seconds for being completed
var has_timer : bool = false

# The amount of time in seconds
var countdown : float  = -1

enum _state {
    IDLE, # the task is not active
    ONGOING, # the task is in-prgress - nothing happening
    COMPLETED, # the task has been completed
    FAILED # the task can't be fullfilled anymore
}
var state : int = _state.IDLE

func _process(delta):
    # check if the player has reached the location
    if has_timer: 
        countdown = clamp(countdown - delta, 0, 9999)
        if countdown == 0: 
            state = _state.FAILED
            print("[questie] task failed")
            # **TODO**: update quest info

    # check if the player has reached the location
    # update quest journal
        
    pass




