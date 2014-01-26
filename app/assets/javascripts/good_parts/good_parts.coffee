GoodParts = GoodParts ? {}

window.GoodParts = GoodParts


GoodParts.File = (name, content, meta) ->
  self =
    name: name
    content: content
    meta: meta ? {}
  return self