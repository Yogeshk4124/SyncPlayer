from flask import  request,  send_file, render_template, redirect, jsonify, url_for
import random
rooms = set()
chats = set()

def home():
    return render_template("home.html")

def createRoom(room_id):
    if int(room_id) not in rooms:
    	rooms.add(int(room_id))
    response = {
        "status":"ok"
    }
    return response

def closeRoom(room_id):
    room_id = int(room_id)
    if room_id in rooms:
        rooms.discard(room_id)
        return jsonify({"status":"ok"})
    return jsonify({"status":"room not found"})
		
def sendMessage(room_id, message):
    if int(room_id) not in rooms:
        return jsonify({"status":"room not found"})

    room_id = int(room_id)
    chats.add((room_id, message))
    return jsonify({"status":"ok"})

def getMessages(room_id):

    room_id = int(room_id)
    if room_id not in rooms:
        return jsonify({"status":"room-not-found"})
    response = list()
    for i in chats:
        if i[0] == room_id:
            response.append(i[1])

    return jsonify(response)


	
# $env:FLASK_APP = "helloflask.py"
# $env:FLASK_ENV = "development"
