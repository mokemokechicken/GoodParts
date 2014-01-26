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
    [GoodParts.File('file1', JSON.stringify(mapParam.getParams()))]

  return self
