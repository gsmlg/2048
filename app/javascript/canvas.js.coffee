class Canvas
  constructor: (opt)->
    @$el = $(opt.el || "#canvas")
    @el = @$el[0]
    @context = @el.getContext("2d")
    @el.width = 600
    @el.height = 600
    @matrix = [
      [0, 0, 0, 0],
      [0, 0, 0, 0],
      [0, 0, 0, 0],
      [0, 0, 0, 0]
      ]
    @

  setMatrix: (matrix)->
    @matrix = matrix
    @

  draw: ()->
    @drawMarix()


  drawMarix: ()->
    that = @
    @matrix.forEach((row, rowIndex)->
      row.forEach((grid, columnIndex)->
        that.drawBox(columnIndex, rowIndex, grid)
      )
    )
    @

  drawBox: (x, y, val)->
    ctx = @context
    margin = 10
    w = @el.width / 4
    iw = w - margin * 2
    h = @el.height / 4
    ih = h - margin * 2
    offsetX = x * w + 10
    offsetY = y * h + 10

    ctx.fillStyle = "#F5B075"
    ctx.fillRect(offsetX, offsetY, iw, ih)

    ctx.fillStyle = "#CFCFCF"
    ctx.font = "80px Consolas"
    ctx.textAlign = "center"
    ctx.textBaseline = "middle"
    val = if val == 0 then "" else val
    ctx.fillText(val, offsetX + (iw)/2, offsetY + (ih)/2, 180)

    ctx.stroke()

    @

  render: ()->
    @context.clearRect(0, 0, @el.width, @el.height)
    @draw()
    @


@Canvas = Canvas
