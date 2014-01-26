Model = ->
  self = {}
  generator_list = for key, gen of GoodParts.Generator
    name: key
    url: "generator##{key}"
  # self.controllers = ko.observableArray(generator_list)
  self.controllers = generator_list
  self.message = ko.observable()
  return self

GoodParts.ViewController.IndexViewController = (opts) ->
  self = {}
  options = opts
  main_area = $("##{options.main}")

  # View binding
  model = Model()
  ko.applyBindings(model, main_area[0])
  console.log(model.controllers)

  self.start = ->
    console.log(model)

  return self
