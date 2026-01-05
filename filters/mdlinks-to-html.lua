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
        local path, frag = target:match('^(.-)%.md(#.*)?$')
        if path then
          el.target = path .. '.html' .. (frag or '')
        end
      end
      return el
    end
  }
}
