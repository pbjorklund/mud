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
