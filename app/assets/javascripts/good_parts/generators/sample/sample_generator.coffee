GoodParts.Generator.SampleGenerator = ->
  self = {}
  self.name = 'sample'
  self.meta = {}
  params = {}
  createParam = ->
    params.map = GoodParts.ParamController.MapParamController
      name: 'Key-Value'
      paramList: [
        {key: 'name', value: '', placeholder: 'ClassName'}
        {key: 'age' , value: '', placeholder: 'YourAge'}
      ]
    params.record = GoodParts.ParamController.RecordParamController
      name: 'Record'
      columnList: ['name', 'type', 'length']

  self.requiredParams = ->
    createParam()
    [params.map, params.record]

  self.generate = ->
    code1 = GoodParts.CodeRenderer.render('sample/sample_rb.ect', params.map.getParams())
    code2 = GoodParts.CodeRenderer.render('sample/sample_m.ect', params.map.getParams())
    [
      GoodParts.File('file1.rb', code1, language: 'ruby')
      GoodParts.File('file2.m', code2, language: 'objc')
    ]

  return self
