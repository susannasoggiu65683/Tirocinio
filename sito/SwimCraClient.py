import socket

client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client.connect(("tcp://7.tcp.eu.ngrok.io", 17656))

print(client.recv(1024).decode()) # cos'è 1024?
client.send("Hey server".encode())