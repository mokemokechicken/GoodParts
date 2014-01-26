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
    code = GoodParts.CodeRenderer.render('sample/sample.rb.erb', mapParam.getParams())
    [GoodParts.File('file1', code, language: 'ruby')]

  return self
