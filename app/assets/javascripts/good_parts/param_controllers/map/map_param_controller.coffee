GoodParts.ParamController.MapParamController = (options) ->
  self = {}
  self.name = options.name ? 'MapParam'
  self.meta = {}

  self.getParams = ->
    model.getParams()

  self.draw = (opts) ->
    canvas = opts.canvas
    view = GoodParts.ParamView('map/view.html', self)
    canvas.append(view.content)
    ko.applyBindings(model, canvas[0])

  model = MapParamModel
    name: self.name
    paramList: options.paramList

  self.serialize = ->
    model.serialize()

  self.deserialize = (obj) ->
    model.deserialize(obj)

  return self


MapParamModel = (opts) ->
  self = {}
  self.name = opts.name
  paramList = opts.paramList

  self.getParams = ->
    ret = {}
    for param in paramList
      ret[param.key] = param.value
    ret

  self.params = ko.observableArray paramList

  self.serialize = ->
    self.params()

  self.deserialize = (obj) ->
    self.params(obj)

  return self

