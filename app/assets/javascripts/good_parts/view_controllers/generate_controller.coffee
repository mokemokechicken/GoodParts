GoodParts.ViewController.GenerateViewController = (opts) ->
  self = {}
  options = opts
  # input
  main_area = $("##{options.main}")
  canvas_area = $("##{options.canvas}")
  submit_btn = $("##{options.submit}")
  prefix = options.prefix ? 'good_parts-'

  # Generator
  generator = GoodParts.Generator.SampleGenerator()          # this should to be dynamic? create

  self.start = ->
    ko.applyBindings(self, main_area[0])
    for pc in generator.requiredParams()
      div_id = "#{prefix}#{generator.name}-#{pc.name}"
      canvas_area.append($("<div id='#{div_id}'>"))
      pc.draw
        canvas: $("##{div_id}")

  self.result = ko.observable()

  submit_btn.on "click", ->
    files = generator.generate()
    console.log(files)
    self.result
      files: files
    SyntaxHighlighter.highlight()

  return self