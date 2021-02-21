from flask import Flask
import myroutes

app = Flask(__name__, static_url_path='/static')
##adding routes

app.add_url_rule('/', view_func = myroutes.home)
app.add_url_rule('/createRoom/<room_id>', view_func = myroutes.createRoom)
app.add_url_rule('/closeRoom/<room_id>', view_func=myroutes.closeRoom)
app.add_url_rule('/getMessages/<room_id>', view_func=myroutes.getMessages)
app.add_url_rule('/sendMessage/<room_id>/<message>', view_func=myroutes.sendMessage)

#main
if __name__ == '__main__':
    app.run()
