from bottle import route, run, request, error
from pyngrok import ngrok
import ngrok
import sqlite3
import os
import json
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
"""
os.system("curl  http://127.0.0.1:4040/status > tunnels.json")
with open('tunnels.json') as data_file:    
    datajson = json.load(data_file)
msg = "ngrok URL's: \n"
for i in datajson['tunnels']:
  msg = msg + i['public_url'] +'\n'

print (msg)
"""


@route('/', method = 'POST')
def LogData():
    data = request.json #type dict
    global data_sent
    data_sent  = request.json
    idData = data['id']
    xData = data['Accelx']
    yData = data['Accely']
    zData = data['Accelz']
    elevationData = data['Elevation']
    pressureData = data['Pressure']
    temperatureData = data['Temperature']
    
    for i in range(len(elevationData)):

        for j in range(25):
            sql = "INSERT INTO sensorsdata (id, accelx, accely, accelz, elevation, pressure, temperature) VALUES (?, ?, ?, ?, ?, ?, ?)"
            cur = conn.cursor()
            cur.execute(sql, (idData, xData[25*i+j], yData[25*i+j], zData[25*i+j], elevationData[i], pressureData[i], temperatureData[i]))
            conn.commit()
    
    return "Data sent"

@route('/', method = 'GET')
def home():
    global data_sent
    if data_sent:
        return f"The received data is: {data_sent}"
    else:
        return "No data has been received yet"
    


@error(404)
def error404(error):
    return "I don't work but that's fine"



run(host='localhost', port=5000)