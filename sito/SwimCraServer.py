from bottle import route, run, template, get,post, request, error

@route('/hello/<name>')
def index(name):
    return template('<b>Hello {{name}}</b>!', name=name)


@route('/', method = 'POST')
def home():
    data = request.body
    return (data)

@error(404)
def error404(error):
    return "I don't work but that's fine"



run(host='localhost', port=5000)