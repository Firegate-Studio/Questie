extends Resource

# The constraint identifier 
export(String) var uuid = UUID.generate()

# the quest owning this constraint
export(String) var owner