function Str(el)
  -- match pkg::fun()
  if el.text:match("^[%w%.]+::[%w%.]+%(%)$") then
    return pandoc.Span(el.text, pandoc.Attr("", {"fn"}))

  -- match fun()
  elseif el.text:match("^[%w%.]+%(%)$") then
    return pandoc.Span(el.text, pandoc.Attr("", {"fn"}))
  end
end