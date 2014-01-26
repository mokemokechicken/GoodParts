GoodParts.ParamController.RecordParamController = (options) ->
  self = {}
  self.name = options.name ? 'RecordParam'
  self.meta = {}

  self.getParams = ->
    model.getParams()

  self.draw = (opts) ->
    canvas = opts.canvas
    view = GoodParts.ParamView('record/view.html', self)
    canvas.append(view.content)
    ko.applyBindings(model, canvas[0])

  model = Model
    name: self.name
    columnList: options.columnList

  self.serialize = ->
    model.serialize()

  self.deserialize = (obj) ->
    model.deserialize(obj)

  return self


Model = (opts) ->
  self = {}
  self.name = opts.name
  self.columnList = opts.columnList
  self.records = ko.observableArray([])

  self.getParams = ->
    (r.data for r in self.records())

  createRecord = (data) ->
    Record(self.columnList, data)

  self.new_record = ->
    self.add()

  self.add = (data) ->
    self.records.push createRecord(data)


  self.remove = (record) ->
    self.records.remove(record)

  self.serialize = ->
    self.getParams()

  self.deserialize = (obj) ->
    self.records([])
    for data in obj
      self.add(data)

  return self

Record = (columnList, data) ->
  self = {}
  data = data ? {}
  self.data = {}
  self.focus = {}
  for col in columnList
    self.data[col] = data[col]
    self.focus[col] = ko.observable(col == columnList[0])

  return self
