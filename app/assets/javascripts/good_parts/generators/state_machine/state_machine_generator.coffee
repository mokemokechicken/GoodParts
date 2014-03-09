SMC_SERVICE_URL = 'http://smcservice.herokuapp.com/smc'
# SMC_SERVICE_URL = 'http://localhost:9000/smc'

GoodParts.Generator.StateMachineGenerator = ->
  self = {}
  self.name = 'StateMachine'
  self.meta = {}
  params = null

  paramList = ->
    initParams() if !params
    [params.attrs, params.language, params.scm]

  initParams= ->
    params =
      attrs: GoodParts.ParamController.MapParamController
        name: 'attrs'
        paramList: [
          {key: 'name', value: '', placeholder: 'name'}
        ]
      language: GoodParts.ParamController.SelectParamController
        name: 'Language'
        values: ['Java', 'ObjC', 'Python', 'Ruby', 'JavaScript', 'Graph']
        selected: ['Java']
      scm: GoodParts.ParamController.TextParamController
        name: 'SCM'
        rows: 20

  self.generate = ->
    attrs = params.attrs.getParams()
    lang = params.language.getParams()[0]?.toLowerCase()
    scm = params.scm.getParams()

    dfd = $.Deferred()
    $.post("#{SMC_SERVICE_URL}?lang=#{lang}", scm).done (res) ->
      console.log res
      ret = []
      if res.header
        ret.push GoodParts.File("#{attrs.name}.#{FileExtNameMap(lang).header}", res.header, language: lang)
      ret.push GoodParts.File("#{attrs.name}.#{FileExtNameMap(lang).impl}", res.impl, language: lang)
      dfd.resolve(ret)
    .fail (res) ->
      dfd.reject(res.responseText)
    $.post("#{SMC_SERVICE_URL}?lang=graph", scm).done (res) ->
      console.log(res.impl)
      viz = new Canviz('graph_canvas')
      viz.parse(res.impl)
    dfd.promise()

  self.requiredParams = -> paramList()

  self.serialize = ->
    (param.serialize() for param in paramList())

  self.deserialize = (obj) ->
    ps = paramList()
    for o, idx in obj
      ps[idx].deserialize(o)

  return self

FileExtNameMap = (lang) ->
  switch lang
    when "java" then {impl: "java"}
    when "objc" then {header: "h", impl: "m"}
    when "python" then {impl: "py"}
    when "ruby" then {impl: "rb"}
    when "javascript" then {impl: "js"}
    when 'graph' then {impl: "dot"}
    else {impl: "txt"}
