GoodParts.Generator.SampleGenerator = ->
  self = {}
  self.name = 'sample'
  self.meta = {}
  mapParam = GoodParts.ParamController.MapParamController
    name: 'SampleMapParam'
    paramList: [
      {key: 'name', value: '', placeholder: 'ClassName'}
      {key: 'age' , value: '', placeholder: 'YourAge'}
    ]

  self.requiredParams = -> [mapParam]

  self.generate = ->
    code1 = GoodParts.CodeRenderer.render('sample/sample_rb.ect', mapParam.getParams())
    code2 = GoodParts.CodeRenderer.render('sample/sample_m.ect', mapParam.getParams())
    [
      GoodParts.File('file1', code1, language: 'ruby')
      GoodParts.File('file2', code2, language: 'objc')
    ]

  return self
