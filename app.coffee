express = require("express")
http = require("http")
fs = require("fs")
sys = require("sys")

app = express.createServer()

app.configure 'development', ->

app.error (err, req, res, next) ->
  sys.puts "APP.ERROR: " + sys.inspect(err)
  next err

publicDir = __dirname + "/public"
srcDir = __dirname + "/src"

app.use express.compiler(src: srcDir, dest: publicDir, enable: ['coffeescript', "less"])
app.use express.static(publicDir)
app.use express.bodyParser()

apiHost = "localhost"
apiPort = 8000

app.all /^\/api\/(.*)/, (request, response) ->
    proxy_url = request.originalUrl
    console.log "redirecting to : #{proxy_url}"

    postData = JSON.stringify(request.body)

    postOptions =
        host: apiHost
        port: apiPort
        path: proxy_url
        method: request.method
        headers: request.headers

    postReq = http.request postOptions, (proxy_response) ->
        proxy_response.addListener "data", (chunk) ->
            response.write chunk, "binary"

        proxy_response.addListener "end", ->
            response.end()

        response.writeHead proxy_response.statusCode, proxy_response.headers

    if postData
      postReq.write(postData)
    postReq.end()

app.get /^\/mockups\/trips/, (request, response) ->
  fs.readFile "fixtures/trips.json", (err, data) ->
    if err
      response.send("Could not open file: #{err}")
    else
      response.send(data)


app.all /.*/, (request, response) ->
  fs.readFile __dirname + '/public/index.html', 'utf8', (err, text) ->
    response.send(text)



app.listen(3000)
