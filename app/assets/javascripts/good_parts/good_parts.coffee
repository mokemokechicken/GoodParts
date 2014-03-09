GoodParts = GoodParts ? {}

window.GoodParts = GoodParts


GoodParts.File = (name, content, meta) ->
  self =
    name: name
    content: content
    meta: meta ? {type: "src"}
    highlight_class: -> "brush: #{meta.language}"

  self.is_src = -> self.meta.type == "src"
  self.is_img = -> self.meta.type == "img"
  return self