Model = (opts) ->
  self =
    result: ko.observable()
    message: ko.observable()
    isGeneratorFound: ko.observable(true)
    downloadURL: (file) ->
      "data:application/data," + encodeURIComponent(file.content)

    onDownload: (file) ->
      window.open("data:application/data;filename=#{file.name}," + encodeURIComponent(file.content))

    onGenerate: (obj) ->
      opts.onGenerate(obj) if opts.onGenerate

    onSerialize: (obj) ->
      opts.onSerialize(obj) if opts.onSerialize

  return self


GoodParts.ViewController.GenerateViewController = (opts) ->
  self = {}
  options = opts
  # input
  main_area = $("##{options.main}")
  canvas_area = $("##{options.canvas}")
  # submit_btn = $("##{options.submit}")
  prefix = options.prefix ? 'good_parts-'
  generator_name = location.hash[1..]

  # Generator
  findGenerator = ->
    generator = GoodParts.Generator[generator_name]
    if generator
      generator()
    else
      model.message("Generator #{generator_name} does not exist")
      model.isGeneratorFound(false)

  generator = findGenerator()

  self.generate = ->
    model.result
      files: generator.generate()
    SyntaxHighlighter.highlight()

  self.serialize = ->
    console.log(generator.serialize())

  # View binding
  model = Model(onGenerate: self.generate, onSerialize: self.serialize)
  ko.applyBindings(model, main_area[0])

  #
  self.start = ->
    if model.isGeneratorFound()
      for pc in generator.requiredParams()
        div_id = "#{prefix}#{generator.name}-#{pc.name}"
        canvas_area.append($("<div id='#{div_id}'>"))
        pc.draw
          canvas: $("##{div_id}")

  return self



