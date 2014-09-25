///
GoodParts.Generator.SampleGenerator = ->
  self = {}
  self.name = 'sample'
  self.meta = {}
  params = {}
  createParam = ->
    params.map = GoodParts.ParamController.MapParamController
      name: 'Key-Value'
      paramList: [
        {key: 'ClassName', value: '', placeholder: 'ClassName'}
        {key: 'SuperClass' , value: '', placeholder: 'SuperClass'}
      ]
    params.record = GoodParts.ParamController.RecordParamController
      name: 'Record'
      columnList: ['name', 'type', 'length']

  self.requiredParams = ->
    createParam()
    [params.map, params.record]

  self.generate = ->
    code1 = GoodParts.CodeRenderer.render 'sample/sample_rb.ect',
      map: params.map.getParams()
      records: params.record.getParams()
    code2 = GoodParts.CodeRenderer.render('sample/sample_m.ect', params.map.getParams())

    [
      GoodParts.File('file1.rb', code1, language: 'ruby')
      GoodParts.File('file2.m', code2, language: 'objc')
    ]

  self.serialize = ->
    (param.serialize() for param in [params.map, params.record])

  self.deserialize = (obj) ->
    params.map.deserialize(obj[0])
    params.record.deserialize(obj[1])


  return self
///
