const express = require('express')
const app = express()
const port = 5000
const bp = require('body-parser')
app.use(bp.json())
app.use(bp.urlencoded({
  extended: true
}))

app.post('/', function(req, res) {
  res.send(req.body)
  //console.log(req.body)
})

app.get('/contact', function(req, res) {
  res.send("contact page")
})

app.get('/profile/:id', function(req, res){
  res.send("you requested id " + req.params.id)
})

app.listen(port)