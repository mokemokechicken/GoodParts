Model = ->
  result: ko.observable()
  message: ko.observable()
  isGeneratorFound: ko.observable(true)
  downloadURL: (file) ->
    "data:application/data," + encodeURIComponent(file.content)

  onDownload: (file) ->
    window.open("data:application/data;filename=#{file.name}," + encodeURIComponent(file.content))


GoodParts.ViewController.GenerateViewController = (opts) ->
  self = {}
  options = opts
  # input
  main_area = $("##{options.main}")
  canvas_area = $("##{options.canvas}")
  submit_btn = $("##{options.submit}")
  prefix = options.prefix ? 'good_parts-'
  generator_name = location.hash[1..]

  # View binding
  model = Model()
  ko.applyBindings(model, main_area[0])

  # Generator
  findGenerator = ->
    generator = GoodParts.Generator[generator_name]
    if generator
      generator()
    else
      model.message("Generator #{generator_name} does not exist")
      model.isGeneratorFound(false)

  generator = findGenerator()

  submit_btn.on "click", ->
    model.result
      files: generator.generate()
    SyntaxHighlighter.highlight()

  #
  self.start = ->
    if model.isGeneratorFound()
      for pc in generator.requiredParams()
        div_id = "#{prefix}#{generator.name}-#{pc.name}"
        canvas_area.append($("<div id='#{div_id}'>"))
        pc.draw
          canvas: $("##{div_id}")

  return self



