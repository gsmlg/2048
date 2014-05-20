#= require ./canvas
#= require ./controller

class Game
  constructor: ()->
    @canvas = new Canvas({el: "#canvas"})
    @controller = new Controller()
    @

  connect: ()->
    @pub = new WebSocket("ws://#{window.location.host}/pub")
    @sub = new WebSocket("ws://#{window.location.host}/sub")

    that = @

    @controller.onctrl((ctrl)->
      msg = JSON.stringify({event: ctrl})
      that.pub.send(msg)
    )

    @sub.onmessage = (event)->
      msg = JSON.parse event.data
      that.canvas.setMatrix(msg)
      that.canvas.render()

    @

  run: ()->
    @connect()
    @controller.listen()
    @canvas.render()
    @



App = new Game()

App.run()

@App = App
