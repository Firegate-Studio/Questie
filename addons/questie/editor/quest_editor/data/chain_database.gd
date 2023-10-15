tool
extends Resource
class_name ChainDatabase 

export var id : String

export var chains : Array

func add_chain_data(data : ChainData):
    chains.append(data)

func remove_chain_data(chain_id : String):
    for chain_data in chains:
        if not chain_data.id == chain_id: continue

        chains.erase(chain_data)

func get_chain_data(chain_id : String)->ChainData:
    for chain_data in chains:
        if not chain_data.id == chain_id: continue

        return chain_data

    return null