GoodParts.ParamController.SelectParamController = (options) ->
  self = {}
  self.name = options.name ? 'SelectParam'
  self.meta = {}

  self.getParams = ->
    model.getParams()

  self.draw = (opts) ->
    canvas = opts.canvas
    view = GoodParts.ParamView('select/view.html', self)
    canvas.append(view.content)
    ko.applyBindings(model, canvas[0])

  model = Model
    name: self.name
    description: options.description
    values: options.values
    selected: options.selected

  self.serialize = ->
    model.serialize()

  self.deserialize = (obj) ->
    model.deserialize(obj)

  return self


Model = (opts) ->
  self = {}
  self.name = opts.name
  self.description = opts.description

  self.values = ko.observableArray opts.values
  self.selected = ko.observableArray opts.selected

  self.getParams = ->
    self.selected()

  self.serialize = ->
    self.selected()

  self.deserialize = (obj) ->
    self.selected(obj)

  return self

