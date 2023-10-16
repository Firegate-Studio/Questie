extends Node

var journal_is_open : bool = false

var quest_journal

func _enter_tree():
	quest_journal = $"../CanvasLayer/QuestJournal"

func _input(event):

	if Input.is_key_pressed(KEY_J) and event.is_pressed() and not event.is_echo():

		if journal_is_open: 
			quest_journal.hide()
			journal_is_open = false
		else:
			quest_journal.show()
			journal_is_open = true
