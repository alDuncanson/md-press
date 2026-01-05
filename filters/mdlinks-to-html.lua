-- Rewrite relative Markdown links to .html
-- Examples:
--   docs/intro.md        -> docs/intro.html
--   chapter.md#section   -> chapter.html#section
-- External links (http, https, mailto, etc.) are left alone.

local function is_relative_markdown_link(target)
  if target:match('^https?://') or target:match('^mailto:') or target:match('^%w+://') then
    return false
  end
  return target:match('%.md') ~= nil
end

return {
  {
    Link = function(el)
      local target = el.target
      if is_relative_markdown_link(target) then
        -- Match .md at end or .md followed by fragment
        local path, frag = target:match('^(.-)%.md(#.*)$')
        if not path then
          path = target:match('^(.-)%.md$')
          frag = ''
        end
        if path then
          el.target = path .. '.html' .. frag
        end
      end
      return el
    end
  }
}
