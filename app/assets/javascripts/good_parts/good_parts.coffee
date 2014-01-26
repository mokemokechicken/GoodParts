GoodParts = GoodParts ? {}

window.GoodParts = GoodParts


GoodParts.File = (name, content, meta) ->
  self =
    name: name
    content: content
    meta: meta ? {}
    highlight_class: -> "brush: #{meta.language}"
  return self