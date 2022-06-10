# A quest data represent a quest which should be contained inside the database.
# So far, this class represent an asset with persistent data such as the object class.
# Do not try to create a resource asset using "NewResource" command, instead use questie editor unless you know what are you doing.

tool
extends Resource
class_name QuestData

# Track the quest status.
# The possible values are: ONGOING, FAILED, COMPLETED 
enum QuestComplention{
    IDLE,               # Nothing happening 
    ONGOING,            # Activated and running
    FAILED,             # Can't be completed anymore
    COMPLETED           # Completed with success
}

# the unique identifier for a quest item. Each time a new quest data is generated a new uuid will be generated too.
export(String) var uuid

# The quest title
export(String) var title = "fill quest title here"

# The status of the quest
# for more details see 'QuestComplention'
export(QuestComplention) var status = QuestComplention.IDLE

# quest description for journal
export(String) var description = "fill quest description here"

# quest constraints represents rules that should be satisfied 
# to activate a quest when triggered
export(Array, Resource) var constraints

# A trigger represent a rule that must be fullfilled to activate a quest
export(Array, Resource) var triggers

# A task represent an objective that must be fullfilled to complete a quest
# (i.e. kill some mobs or collect a specific item)
export(Array, Resource) var tasks

# A reward represent a gift(reward) after all task will be completed.
# (i.e get experience or items)
export(Array, Resource) var rewards

