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
  return self

