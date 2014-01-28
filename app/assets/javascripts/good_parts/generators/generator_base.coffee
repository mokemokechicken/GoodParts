class Generator
  requiredParams: -> []
  generate: -> []
  name: 'Generator'
  meta: {}

GoodParts.Generator = GoodParts.Generator ? {}
GoodParts.CodeRenderer = ECT(root: '/template/good_parts/generators', cache: false)
