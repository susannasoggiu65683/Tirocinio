from bottle import route, run, template, get,post, request, error
from pyngrok import ngrok
import ngrok
import socket

# Open a HTTP tunnel on the default port 80
# <NgrokTunnel: "http://<public_sub>.ngrok.io" -> "http://localhost:80">
#http_tunnel = ngrok.connect()
# Open a SSH tunnel
# <NgrokTunnel: "tcp://0.tcp.ngrok.io:12345" -> "localhost:22">
#ssh_tunnel = ngrok.connect(5000, "tcp")

"""
server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.bind(("localhost", 5000))
server.listen()

while True:
    client, addr = server.accept()
    client.send("Funziona?".encode())
    print(client.recv(1024).decode()) # cos'è 1024?
    client.close()
"""


client = ngrok.Client("2JrC2qePmCRd2tDVLRGlM85CsZP_6asEWnAF9GuS7mVGhaCah")

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