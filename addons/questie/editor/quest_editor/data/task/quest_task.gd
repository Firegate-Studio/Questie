extends Resource

export(String) var uuid = UUID.generate()

export(String) var owner 

enum TaskComplention{
	ONGOING,                    # actually in progress
	COMPLETED,                  # completed with success
	FAILED                      # can't be completed anymore
}
export(TaskComplention) var state = TaskComplention.ONGOING

