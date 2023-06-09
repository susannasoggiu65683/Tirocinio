from bottle import route, run, template, get,post, request, error, static_file
from pyngrok import ngrok
import ngrok
import sqlite3
import os
#import shutil


conn = sqlite3.connect('sensorsdata.db') # Warning: This file is created in the current directory
#conn.execute("CREATE TABLE sensorsdata (id INTEGER PRIMARY KEY, accelx REAL, accely REAL, accelz REAL, elevation REAL, pressure REAL, temperature REAL)")
#conn.execute("INSERT INTO sensorsdata (task,status) VALUES ('Read A-byte-of-python to get a good introduction into Python',0)")




client = ngrok.Client("2OmnaBA4hgI1sRD4FhKTB5YDYdT_aG59uACn2SL7QwVCbXA6")
postdata = None
# List all online tunnels
for t in client.tunnels.list():
    print(t)

@route('/hello/<name>')
def index(name):
    return template('<b>Hello {{name}}</b>!', name=name)




@route('/', method = 'POST')
def LogData():
    #postdata = request.body.read()
    data = request.POST.myDict.strip() #new = request.GET.get('task', '').strip()
    print("\n"+data+"\n")
    sql = "INSERT INTO sensorsdata (id, accelx, accely, accelz, elevation, pressure, temperature) VALUES (?, ?, ?, ?, ?, ?, ?)"
    cur = conn.cursor()
    cur.execute(sql, (5, data.Accelx, data.Accely, data.Accelz, data.Elevation, data.Pressure, data.Temperature))
    conn.commit()
    return postdata

@route('/', method = 'GET')
def home():
    return "Hello frog!"
    


@error(404)
def error404(error):
    return "I don't work but that's fine"



run(host='localhost', port=5000)