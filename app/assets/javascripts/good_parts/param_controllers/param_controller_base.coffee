#class ParamContoller
#  name: 'Param'
#  meta: {}
#  getParams: -> null
#  draw: -> null
#  serialize: -> obj
#  deserialize: (obj) ->

ParamView = (template, data) ->
  self = {}
  html = GoodParts.ParamViewRenderer.render(template, data)
  self.content = $(html)
  return self

GoodParts.ParamController = GoodParts.ParamController ? {}
#GoodParts.ParamViewRenderer = ECT(root: '/assets/good_parts/param_controllers')
GoodParts.ParamViewRenderer = ECT(root: '/template/good_parts/param_controllers')
GoodParts.ParamView = ParamView
