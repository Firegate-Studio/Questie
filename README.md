# Questie for Godot Engine
Questie is a plugin for building quest quickly.

# Getting Started
Download the repository from https://github.com/Firegate-Studio/Questie.git and copy the folder at `res://addons/questie` inside your addons project folder.

The first time you will run your project, the tool will not be able by default. If this is the case follow these steps:
1. go to `project->project settings->plugins`
2. enable questie `plugin` clicking on the `checkbox`

If all is done weel you should see the questie tab near the asset library tab.

> sometime questie will not work as intended; to solve this problem you can relaunch your application or reload the project from `project->reload project`.

At this point if you check your file system, you can notice an uknown folder called questie. Inside, you can find 2 resource files (`quest-db.tres`, `item-db.tres`). Do not try to modify them manually but use a tool provided by questie instead. 

> Files inside the questie folder MUST NOT be modified for any reason. Questie comes with a bunch of tools which provides a faster and elegant way to interact with these items; so DO NOT touch them unless you want try the risk to lose all your hard work.

# Quest Editor
How you can see, questie has several tabs. The quest editor allows to create your quest and store them inside the quest-db.tres located at `res://questie/quest-db.tres`.

Clicking on the treasure button, you can create a new quest. By clicking the message on your workspace will disappear leaving space to the quest workspace.

## Workspace Architecture

So far the workspace presents the following fields:
* **Title**: The quest name
* **Description**: A brief about the quest (i.e., during the night a wandering knight comes to the village)
* **Constraints**: Rulsed that must be respected before this quest can be activated form the triggers
* **Triggers**: What will trigger, then activate this quest
* **Tasks**: Are the main objective of the quest. These tasks must be completed or failed before you can claim your reward.
* **Rewards**: The things/items you will get after compleating all the quest tasks

## Quest Blocks

On the right side of the workspace you can se a list of items subdivided by category. These items are called blocks and are needed to construct your quest.

Reading the category you can deduct in which are will be placed.

### Constraint: Has Item
This block check if an item is present inside player inventory; and is divied in 3 parts:
* **Item**: the item you want check
* **Category**: the category of the object (see **Item Editor** for further informations)
* **Quantity**: the amount of the items the player must own.

> NB: These items must be created witch the **item editor** for work with these block; otherwise any selection will be **NULL**.

### Constraint: Has Quest
This block check if a specifi quest is active. 

The block is composed by these informations:
* **Quest**: If clicked will display all quest that exists inside the database.
* **UUID panel**: this panel will display the quest UUID when selected 

> The uuid panel is not editable. Selecting the quest will fill this poperty autonomously.

### Constraint: Quest State
This block defines a rule where a quest must be at the state value defined by the state field.

Using this block is equivalent to write:

```
if quest.state == QuestState.MyState: 
    return true
else:
    return false
```

#### PROPERTIES

* **Quest**: the UUID of the quest you want check
* **State**: the desired state you want for the quest

#### QUEEST STATE
The quest state allows these values:
1. **Idle**: is not active yet
2. **Ongoing**: currently active and in progress
3. **Failed**: the quest has failed and can not be completed anymore
4. **Completed**: the quest has been completed successfully

# Item Editor

The item editor(second tab), is a tool used to create all your item object and it is represented from theh item-db.tres located at `res://questie/item-db.tres`.

On the top-left corner of the window, you can see a bunch of button with a special icon representing the object that will be created by clicking on them.

* **Sword**: weapon item
* **Armor**: armor item
* **Potion**: consumable item
* **Wood**: material item
* **Star-Coin**: special item

The toilet paper is used to delete a created item instead.

Selecting a created item, the workspace dedicated to that item will appear. There are many workspaces; each dedicated to a specific item type.

> Clicking on any folder will not take any effect. The unique way to create an item is to use one of the buttons provided from the interface.

## Weapon Item Workspace
The weapon item is an object used to deal damage to a creature/enemy inside the game. So this workspace allows to customize the item basic informations as below:

* **Title**: the item name
* **Description**: the item description (i.e., the legendary sword owned from *Arthas Menthil* ...)

Any item could be usede to make money(based on your game economy), so it is provided a section to define the item merchandising.

* **Can be sold**: defines if this item can be aquired and sold by any vendor of the game
* **Purchase price**: the price to purchase this item
* **Sell price**: the amount of money you will get if you sell this item

At the end, the section about the damage the weapon deals:

* **Damage type**: the type of damage dealt from this weapon
* **min damage**: the minimum damage dealt from this weapon
* **max damage**: the maximum damage dealt from this weapon

## Armor Item Workspace
This object is used to describe armors items like chestplate, shoulder, ..., etc.

All Objects inherits from `item data` so its structure. In addiction data structure for armor as below:
* **Armor type**: the type of armor (i.e., darkness, fire, physical, ..., etc.)
* **Armor value**: the value of defense this armor provides.

### Armor type
The armor type reperesent the kind of damage that the armor can block. When declearing an armor type, the armor value indicates the amount of damage that will be reduces if the same kind of the armor type.

> If an enemy casts a fireball spell that deal a damage of 50, and the player has the same armor type (Fire for this case) with an armor value of 45; so the damage dealt from the opponent will be reduced by 45 because the damage type and armor type matches.

So far the armor type is defines as follow:
* **Physic**: reduce damage based on `physical` type
* **Fire**: reduce damage based on `fire` type
* **Water**: reduce damage based on `water` type
* **Nature**: reduce damage based on `nature` type
* **Air**: reduce damage based on `air` type
* **Darkness**: reduce damage based on `darkness` type
* **Spirit**: reduce damaged based on `spirit` type

## Consumable Item Workspace
The consumable item is an object used for utility purposes like recover health, recover stamina, enchant weapons, ..., and so long.

Just like for the weapon item, it inherits is structure from a generic item data. Further more adds a section dedicated for its information:
* **value**: the value used for this consumable. It could be used to increase character health or apply a some status.

> NB: The item editor is thought to provide a smart way to store items information. If you want use these information for a specific purpose; you can do it when implementing these items. The editor will only stores this data inside the `item database` and that's all.

## Special Item Workspace
A special item is an object that can not be defined with all previos categories. As special item it could be both a weapon and a material. For example, if we have an item called **dark lord ring** that provides a damage reduction against dark magic(just like armor does), it is a crafting materials(material item) to create an incredible weapon, and can exists only one for game; so it is called special item because merges information from the armor item and material item.

Looking the inspector this item has the possibility to be the union of each item category and to be treated as both of them. Enabling the checkmark `as...`, this item can be used just like that item.

Further more, it has a checkbox called `is_unique` which defines if this item should be unique for the game. If the case, enabling the checkbutton, player can own only one of this item in the inventory.

## Game Inventories
![](https://i.ytimg.com/vi/cSjYzuQSETQ/maxresdefault.jpg)

Questie provides some inventories which can be used to store items while playing.

* **Weighted**: an inventory that allows to add items from `item database` untill the **max weight** is reached. For this inventory, the quantity for each slot is infinite; limited only from the current weight (i.e, fallout inventory system).
* **Slot Based**: an inventory that allows to add items untill a free slot is availbale. For this inventory there is not a quantity, each item fills a slot; if there is no slot available, the player must free at least one slot to add another item.
* **Grid**(Not ported yet): an inventory where the items can fill one or more slots based on their size. When the size to add an item is not availble (i.e., trying to fill 2x1 but only 1x1 is free); the item will not be added to the inventory (i.e, Diablo 3, Path of exile, Last epoch, ..., etc.)
* **Realistic**: an inventory with limited capacity for each slot. The number of items that can be added is infinite; but has a several limited capacity. This is called realistic, because just like the real life the amount of items you can carry is limited (i.e., Dark Soul inventory)

### Adding an inventory to the scene
To add an inventory to your scene you follow these instructions:
1. RMB on the root node / `CTRL+SHIFT+A` with root node selected
2. From the **search panel** type the inventory name (i.e., WeightedInventory, SlotInventory, ..., etc.)
3. Select the inventory you want add
4. Press `ok button` or enter key on your keyboard

If all is done right, the inventory should be visible as sub-node of your root node.

### Extending inventory nodes
All inventories are not provinding any kind of interface. They contains only methods to store and removes items from the item database. 

If you want extends an inventory class to support any user interface you can do it by GDScript as follow:
```
class_name MyCustomInventory
extends WeightedInventory

# all variables and methods are inherited from the WeightInventory class

export(Resource) var slot_template = preload("res://MyFolder/Slot.tscn")

# Override add_item function to support update user interface update
func add_item(var uuid, var quantity : int = 1)->void:
    # Inherites from funciton declaration in parent class
    .add_item(uuid, quantity)

    # ... your code here ...
```

After your are done with your `custom_inventory.gd` with the same procedure of the previous section from the step 2 if you type the `class_name` (is the same name you gave in the script), you will retrieve your custom node from the list. 

### Extending Inventory Behaviors
When an item is added or removed from any inventory which comes with questie, some events (signals in godot) will be thrown as follow:
* **push_item**: called when an item is added to the inventory
* **item_quantity_changed**: called when an item quantity changes
* **erase_item**: called when an item is removed from the inventory

You can add functions to execute when these signals are emitted as shown:

```
# ... inside your class ...

func _enter_tree():
    connect("push_item", self, "MyCallback")

func _exit_tree():
    disconnect("push_item", self, "MyCallback")

# Will be called when push_item signal will be emitted    
func MyCallback():
    # ... you code here ...
```

if you want emit these signals, instead:
```
# ... inside your class ...

func your_function():
    emit_signal("push_item")
```

For further information about signals you can check [godot documentation](https://docs.godotengine.org/it/stable/getting_started/step_by_step/signals.html)


