MapParamContoller = (map) ->
  self = {}
  self.name = 'MapParam'
  self.meta = {}

  self.getParams = ->
    model.getParams()

  self.draw = (opts) ->
    canvas = opts.canvas
    view = MapParamView(opts)
    canvas.append(view.content)
    ko.applyBindings(model, canvas[0])

  model = MapParamModel map: map
  return self


MapParamModel = (opts) ->
  self = {}
  map = opts.map

  self.getParams = -> map

  paramList = ({key: k, value: v} for k, v of map)
  self.params = ko.observableArray paramList
  return self


MapParamView = (opts) ->
  self = {}
  self.content = $(html)
  return self


html = """
<ul data-bind="foreach: params">
  <li><span data-bind="text: key"> </span>: <span data-bind="text: value"> /span></li>
</ul>
"""


GoodParts.ParamControllerCollection.push MapParamContoller
