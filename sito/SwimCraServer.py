from bottle import route, run, template, get,post, request, error
from pyngrok import ngrok
import ngrok
import socket


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
    return (data)

@error(404)
def error404(error):
    return "I don't work but that's fine"



run(host='localhost', port=5000)