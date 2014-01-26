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
  return self


Model = (opts) ->
  self = {}
  self.name = opts.name
  self.columnList = opts.columnList
  self.records = ko.observableArray([])

  self.getParams = ->
    self.records()

  createRecord = ->
    Record(self.columnList)

  self.add = ->
    self.records.push createRecord()


  self.remove = (record) ->
    self.records.remove(record)


  return self

Record = (columnList) ->
  self = {}

  self.data = {}
  self.focus = {}
  for col in columnList
    self.data[col] = ''
    self.focus[col] = ko.observable(col == columnList[0])

  return self
