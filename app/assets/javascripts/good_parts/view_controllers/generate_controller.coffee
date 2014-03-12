Model = (opts) ->
  self =
    result: ko.observable()
    message: ko.observable()
    isGeneratorFound: ko.observable(true)
    description: opts.description
    downloadURL: (file) ->
      "data:application/data," + encodeURIComponent(file.content)

    onDownload: (file) ->
      window.open("data:application/data;filename=#{file.name}," + encodeURIComponent(file.content))

    onGenerate: (obj) ->
      opts.onGenerate(obj) if opts.onGenerate

    onSerialize: (obj) ->
      opts.onSerialize(obj) if opts.onSerialize

    onDeserialize: (obj) ->
      opts.onDeserialize(obj) if opts.onDeserialize

  return self


GoodParts.ViewController.GenerateViewController = (opts) ->
  self = {}
  options = opts
  # input
  main_area = $("##{options.main}")
  canvas_area = $("##{options.canvas}")
  # submit_btn = $("##{options.submit}")
  prefix = options.prefix ? 'good_parts-'
  [generator_name, serializeKey] = location.hash[1..].split("--")

  # Generator
  findGenerator = ->
    generator = GoodParts.Generator[generator_name]
    if generator
      generator()
    else
      model.message("Generator #{generator_name} does not exist")
      model.isGeneratorFound(false)

  generator = findGenerator()

  doGenerate = (files) ->
    model.result
      files: files
    SyntaxHighlighter.highlight()

  self.generate = ->
    self.serialize().done (res) ->
      serializeKey = res.key
      location.hash = "##{generator_name}--#{serializeKey}"
      files = generator.generate(serializeKey)  # anydata's key
      if files.done  # assume files is Promise Object
        files.done (fs) ->
          model.message("")
          doGenerate(fs)
        .fail (message) -> model.message(message)
      else
        doGenerate(files)

  self.serialize = ->
    s = JSON.stringify(generator.serialize())
    $.ajax "/anydata",
      type: 'POST'
      data: s
      contentType: 'application/binary'

  self.deserialize = (key) ->
    $.get("/anydata/#{key}").done (data) ->
      generator.deserialize(JSON.parse(data))

  # View binding
  model = Model
    onGenerate: self.generate
    onSerialize: self.serialize
    onDeserialize: self.deserialize
    description: generator.meta.description
  ko.applyBindings(model, main_area[0])

  #
  self.start = ->
    if model.isGeneratorFound()
      for pc in generator.requiredParams()
        div_id = "#{prefix}#{generator.name}-#{pc.name}"
        canvas_area.append($("<div id='#{div_id}'>"))
        pc.draw
          canvas: $("##{div_id}")
      if serializeKey
        self.deserialize(serializeKey)

  return self



