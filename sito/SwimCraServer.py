from bottle import route, run, template, get,post, request, error, static_file
from pyngrok import ngrok
import ngrok
import sqlite3
#import requests
#import shutil


conn = sqlite3.connect('sensorsdata.db') # Warning: This file is created in the current directory
#conn.execute("CREATE TABLE sensorsdata (id INTEGER PRIMARY KEY, accelx REAL, accely REAL, accelz REAL, elevation REAL, pressure REAL, temperature REAL)")
#conn.execute("INSERT INTO sensorsdata (task,status) VALUES ('Read A-byte-of-python to get a good introduction into Python',0)")

data_sent = None

client = ngrok.Client("2OmnaBA4hgI1sRD4FhKTB5YDYdT_aG59uACn2SL7QwVCbXA6")
# List all online tunnels
for t in client.tunnels.list():
    print(t)





@route('/', method = 'POST')
def LogData():
    data = request.json #type dict
    global data_sent
    data_sent  = request.json
    #print(data['Elevation'])
    #data = request.POST.get('myDict', '').strip() #new = request.GET.get('task', '').strip()
    sql = "INSERT INTO sensorsdata (id, accelx, accely, accelz, elevation, pressure, temperature) VALUES (?, ?, ?, ?, ?, ?, ?)"
    cur = conn.cursor()
    cur.execute(sql, (data['id'], data['Accelx'], data['Accely'], data['Accelz'], data['Elevation'], data['Pressure'], data['Temperature']))
    conn.commit()
    
    return "everything ok"

@route('/', method = 'GET')
def home():
    global data_sent
    if data_sent:
        #return f"The received data is: {data_sent}"
        return "The received data is: {data_sent}"
    else:
        return "No data has been received yet"
    


@error(404)
def error404(error):
    return "I don't work but that's fine"



run(host='localhost', port=5000)