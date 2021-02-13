from flask import  request,  send_file, render_template, redirect, jsonify, url_for
import random

activeRooms = {0}
activeUsers = {(0, 0)}
activeHosts={(0, 0)}

def home():
    return render_template("home.html")
    
def createRoom():
    room_id = 0
    while(True):
        room_id = random.randrange(100, 10000)

        if room_id not in activeRooms:
            # add current room to activeRooms
            activeRooms.add(room_id)
            break

   	#ready data for return
    host_id = addUser(room_id)
    activeHosts.add((room_id, host_id))
    print(host_id)
    returnData = {"Room-id": room_id}
    
    #return data
    return jsonify(returnData)

	
def closeRoom(room_id):
	# delete all users with room id
    room_id = int(room_id)
    if room_id in activeRooms:
        activeRooms.discard(room_id) # delete room id
        return jsonify({"status":"ok"})
    else:
        return jsonify({"status":"room not found"})

def addUser(room_id):
    
    user_id = 0
    room_id = int(room_id)
    if room_id not in activeRooms:
        return jsonify({"status": "room not found"})

    while(True):
        user_id = random.randrange(2000, 200000)
        if user_id not in activeUsers:
            activeUsers.add((room_id, user_id))
            break
    
    return jsonify({"room-id":room_id, "user-id": user_id, "status":"ok"})

def getUsers(room_id):
    room_id = int(room_id)
    print(room_id)
    if room_id not in activeRooms:
        return jsonify({"status": "room not found"})
    temp=[]

    for i in activeUsers:
        if(i[0] == room_id):
            temp.append(i[1])
    return jsonify(temp)

def seekTo(room_id, seek_time):
    return jsonify({"status":"building"})
    

def getCurrentTime(room_id):
    room_id = int(room_id)

# $env:FLASK_APP = "helloflask.py"
# $env:FLASK_ENV = "development"
