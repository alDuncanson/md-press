-- Rewrite relative Markdown links for PDF output
-- In a combined PDF, cross-document links become internal anchors or plain text
-- Examples:
--   docs/intro.md        -> plain text (link removed)
--   chapter.md#section   -> #section (anchor link)
-- External links (http, https, mailto, etc.) are preserved.

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
        -- Check if there's a fragment (anchor)
        local path, frag = target:match('^(.-)%.md(#.*)$')
        if frag then
          -- Keep just the anchor for internal PDF navigation
          el.target = frag
        else
          -- No anchor - convert to plain text (remove link)
          return el.content
        end
      end
      return el
    end
  }
}
