GoodParts = GoodParts ? {}

window.GoodParts = GoodParts


GoodParts.File = (name, content, meta) ->
  meta.type ?= "src"
  self =
    name: name
    content: content
    meta: meta
    highlight_class: -> "brush: #{meta.language}"

  self.is_src = -> self.meta.type == "src"
  self.is_img = -> self.meta.type == "img"
  self.is_html = -> self.meta.type == "html"
  return self