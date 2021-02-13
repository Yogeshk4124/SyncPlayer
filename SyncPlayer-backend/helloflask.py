from flask import Flask
import myroutes

app = Flask(__name__, static_url_path='/static')
##adding routes

app.add_url_rule('/', view_func = myroutes.home)
app.add_url_rule('/createRoom', view_func = myroutes.createRoom)
app.add_url_rule('/closeRoom/<room_id>', view_func=myroutes.closeRoom,  methods=['GET', 'POST'])
app.add_url_rule('/addUser/<room_id>', view_func=myroutes.addUser,  methods=['GET', 'POST'])
app.add_url_rule('/getUsers/<room_id>', view_func=myroutes.getUsers,  methods=['GET', 'POST'])
app.add_url_rule('/seekTo/<room_id>/<seek_time>', view_func=myroutes.seekTo,  methods=['GET', 'POST'])

#main
if __name__ == '__main__':
    app.run()
