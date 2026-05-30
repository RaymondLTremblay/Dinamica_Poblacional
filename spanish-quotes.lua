-- spanish-quotes.lua
-- Convierte las comillas dobles en comillas angulares («comillas latinas»),
-- la convención tipográfica preferida en español.
--
-- Con la extensión `smart` de Pandoc (activada por defecto en Quarto), un
-- fragmento como "texto" se interpreta como un nodo Quoted de tipo
-- DoubleQuote. Este filtro reescribe ese nodo con « » en lugar de “ ”.
--
-- Las comillas simples (SingleQuote) se dejan sin tocar: en español el
-- segundo nivel de entrecomillado usa comillas dobles “ ” y el tercero
-- comillas simples ‘ ’, por lo que conviene revisar manualmente los casos
-- de comillas anidadas.

function Quoted(el)
  if el.quotetype == "DoubleQuote" then
    local out = pandoc.List()
    out:insert(pandoc.Str("«"))
    out:extend(el.content)
    out:insert(pandoc.Str("»"))
    return out
  end
end
