GoodParts.Generator.StateMachineGenerator = ->
  self = {}
  self.name = 'StateMachine'
  self.meta =
    description: """
      SMC という StateMachineCompilerを使ったGeneratorです。書き方については http://smc.sourceforge.net/SmcManual.htm を参考にしてください。
      生成されたコードを実行するには、共通のlibraryが必要なので、Navigation BarのDownloadのページをみてください。

      SMC サンプル: http://goodparts.d.yumemi.jp/generator#StateMachineGenerator--5ee40c306f44385df80e09af7f6b588985ff8c71
      SMC 記事集: https://yumemi.qiita.com/search?utf8=%E2%9C%93&sort=&q=SMC
"""
  params = null
  config = {}

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
        values: ['Java', 'ObjC', 'Python', 'Ruby', 'JavaScript', 'JavaScript(Y)', 'swift']
        selected: ['Java']
      scm: GoodParts.ParamController.TextParamController
        name: 'SCM'
        rows: 20

  configure = ->
    $.get("/generator/config").done (cfg) ->
      config.smc_service_url = cfg.smc_service_url
  configure()

  server_url = (lang) ->
    switch lang
      when 'javascript(y)', 'swift'
        '/generator/generate'
      else
        config.smc_service_url

  self.generate = (serializeKey) ->
    attrs = params.attrs.getParams()
    lang = params.language.getParams()[0]?.toLowerCase()
    scm = params.scm.getParams()

    dfd = $.Deferred()

    url = server_url lang
    pg_promise = $.ajax "#{url}?lang=#{lang}&name=#{attrs.name}",
      type: 'POST'
      data: scm
      contentType: 'text/plain; character-set=utf8'

    pg_promise.fail (res) -> dfd.reject(res.responseText)
    html_promise = $.post("#{config.smc_service_url}?lang=table", scm)
    img_promise = $.post("#{config.smc_service_url}?lang=graph", scm).then (res) ->
      $.ajax "/anydata",
        type: 'POST'
        data: res.impl
        contentType: 'application/binary'

    $.when(pg_promise, img_promise, html_promise).done (r1, r2, r3) ->
      pg_response = r1[0]
      img_response = r2[0]
      html_response = r3[0]
      imgUrl = "#{location.origin}/dot/#{img_response.key}/png"
      ret = []
      ret.push GoodParts.File("#{attrs.name}.png", "", {language: 'img', type: 'img', src: imgUrl})
      ret.push GoodParts.File("#{attrs.name}.html", html_response.impl, {language: 'html', type: 'html'})
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
    when "javascript", "javascript(y)" then {impl: "js"}
    when 'graph' then {impl: "dot"}
    when 'swift' then {impl: 'swift'}
    else {impl: "txt"}
