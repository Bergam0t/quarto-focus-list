-- Likely inspired by the conversation here: https://github.com/orgs/quarto-dev/discussions/4626

function Div(el)
  if el.classes:includes("focus-list") then

    quarto.doc.add_html_dependency({
      name = "focus-list-styles",
      version = "1.0.0",
      stylesheets = {"focus-list.css"}
    })

    return pandoc.walk_block(el, {
      BulletList = function(list)
        for i, item in ipairs(list.content) do
          local attr = { class = "fragment" }
          -- Wrap list item content in a Div
          list.content[i] = { pandoc.Div(item, attr) }
        end
        return list
      end
    })

  end

end
