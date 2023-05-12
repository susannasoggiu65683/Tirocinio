from bottle import route, run, template, get,post, request, error
from pyngrok import ngrok
import ngrok
import os
#import shutil

client = ngrok.Client("2OmnaBA4hgI1sRD4FhKTB5YDYdT_aG59uACn2SL7QwVCbXA6")

# List all online tunnels
for t in client.tunnels.list():
    print(t)

@route('/hello/<name>')
def index(name):
    return template('<b>Hello {{name}}</b>!', name=name)

@route('/', method = 'GET')
def home():
    return "Hello frog"

@route('/', method = 'POST')
def home():
    data = request.body
    with open("C:\\Users\\susyv\\Desktop\\testnuoto.FIT", "w") as f: #path del server dir + nome file da salvare
        f.write(data) #contenuto che vai a salvare dentro il file
    #shutil.copy(input_file, output_directory)  
    success = os.path.exists("C:\\Users\susyv\\Desktop\\testnuoto.FIT")
    return "success"

@error(404)
def error404(error):
    return "I don't work but that's fine"




run(host='localhost', port=5000)