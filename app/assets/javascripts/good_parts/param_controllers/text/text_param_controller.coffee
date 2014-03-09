GoodParts.ParamController.TextParamController = (options) ->
  self = {}
  self.name = options.name ? 'TextParam'
  self.meta = {}

  self.getParams = ->
    model.getParams()

  self.draw = (opts) ->
    canvas = opts.canvas
    view = GoodParts.ParamView('text/view.html', self)
    canvas.append(view.content)
    ko.applyBindings(model, canvas[0])

  model = TextParamModel
    name: self.name
    description: options.description
    opts: options
    content: options.content

  self.serialize = ->
    model.serialize()

  self.deserialize = (obj) ->
    model.deserialize(obj)

  return self


TextParamModel = (opts) ->
  self = {}
  self.name = opts.name
  self.rows = opts.opts.rows || 30
  self.cols = opts.opts.cols || 80
  self.description = opts.description
  content = opts.content

  self.getParams = ->
    self.text()

  self.text = ko.observable content

  self.serialize = ->
    self.text()

  self.deserialize = (obj) ->
    self.text(obj)

  return self

