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
        values: ['Java', 'ObjC', 'Python', 'Ruby', 'JavaScript']
        selected: ['Java']
      scm: GoodParts.ParamController.TextParamController
        name: 'SCM'
        rows: 20

  self.generate = (serializeKey) ->
    attrs = params.attrs.getParams()
    lang = params.language.getParams()[0]?.toLowerCase()
    scm = params.scm.getParams()

    dfd = $.Deferred()
    pg_promise = $.post("#{SMC_SERVICE_URL}?lang=#{lang}", scm)
    pg_promise.fail (res) -> dfd.reject(res.responseText)
    img_promise = $.post("#{SMC_SERVICE_URL}?lang=graph", scm).then (res) ->
      $.ajax "/anydata",
        type: 'POST'
        data: res.impl
        contentType: 'application/binary'

    $.when(pg_promise, img_promise).done (r1, r2) ->
      pg_response = r1[0]
      img_response = r2[0]
      imgUrl = "#{location.origin}/dot/#{img_response.key}/png"
      ret = []
      ret.push GoodParts.File("#{attrs.name}.png", "", {language: 'img', type: 'img', src: imgUrl})
      if pg_response.header
        ret.push GoodParts.File("#{attrs.name}.#{FileExtNameMap(lang).header}", pg_response.header, language: lang)
      implLines = pg_response.impl.split("\n")
      implLines[0] += " Generator: #{location.href}"
      implText = implLines.join("\n")
      ret.push GoodParts.File("#{attrs.name}.#{FileExtNameMap(lang).impl}", implText, language: lang)
      dfd.resolve(ret)

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
