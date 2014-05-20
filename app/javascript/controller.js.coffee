class Controller

  LEFT = 37
  UP = 38
  RIGHT = 39
  DOWN = 40

  constructor: ()->
    @

  onctrl: (callback)->
    @_control ?= []
    @_control.push(callback)
    @

  trigger: (event)->
    console.log event
    @_control ?= []
    @_control.forEach((fn)->
      fn(event)
    )
    @

  listen: ()->
    that = @
    $(document).on('keydown', (event)->
      switch event.which
        when LEFT
          that.trigger 'left'
        when UP
          that.trigger 'up'
        when RIGHT
          that.trigger 'right'
        when DOWN
          that.trigger 'down'
        else notPrevent = true
      event.preventDefault() if notPrevent?
    )
    @

@Controller = Controller
