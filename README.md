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
The weapon item is an obect used to deal damage to a creature/enemy inside the game. So this workspace allows to customize the item basic informations as below:

* **Title**: the item name
* **Description**: the item description (i.e., the legendary sword owned from *Arthas Menthil* ...)

Any item could be usede to make money(based on your game economy), so it is provided a section to define the item merchandising.

* **Can be sold**: defines if this item can be aquired and sold by any vendor of the game
* **Purchase price**: the price to purchase this item
* **Sell price**: the amount of money you will get if you sell this item

At the end, the section about the damage the wepoan deal:

* **Damage type**: the type of damage dealt from this weapon
* **min damage**: the minimum damage dealt from this weapon
* **max damage**: the maximum damage dealt from this weapon





