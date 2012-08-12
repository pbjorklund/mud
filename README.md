RMUD - Ruby Mud
===============

This is pre-alpha software. Do not use.
---------------------------------------

Rmud leverages eventmachine to create a event-driven and concurrent mud server written in ruby.

It's not optimal, or even correctly written right now. Hopefully it will stabilize in the future as my understanding of the concepts increase.

Structure
---------

### Server
Creates a ```EventMachine``` that creates new ```Mudconnection```s for each connection. 

The ```Server``` object is responsible for storing connections and the world instance.
Each ```MudConnection``` gets a reference to ```World``` upon creation.

### World
Responsible for world wide state. Such as connected ```Player```s and communication to all connections. It also contains the ```CommandParser``` used by ```PlayerController``` to perform actions from the client.

### MudConnection
Handles the sending of messages to the client and the connection itself.
When created a new ```PlayerController``` is instanciated. 
Since the controller needs to know the world which is created by the server we forward the setting of world on the connection to the controller with ```world=```.

### PlayerController
Responsible for handling actions related to the player and forwarding messages to the right objects.

Relationships
-------------
Server has MudConnections
Server creates World

World receieves Players from MudConnection
World creates CommandParser
World has Server

CommandParser has World
CommandParser has PlayerController
  - CommandParser#parse receives string with data and PlayerController

MudConnection has PlayerController
  - Delegates World sent by Server to PlayerController

PlayerController is initialized with MudConnection
PlayerController creates Player
PlayerController receieves World from MudConnection

Player has no other objects

Data flow
---------
MudConnection receives input from client and delegates it raw to PlayerController.

PlayerController creates Player when receiving data if no player is already created.

PlayerController delegates incoming data to CommandParser with a reference to ```self```

CommandParser interprets commands and sends messages to PlayerController for player related actions and sends messages to World for world-wide actions.

