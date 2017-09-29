module ApplicationHelper
  def full_title(base_title, page_title)
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def store_feed_item(item, phrase)
    FeedItems::CreatorWorker.perform_async({
      organization_id: item.try(:organization_id),
      user_id: item.try(:user_id),
      parent_type: item.class.name,
      parent_id: item.id,
      phrase: phrase,
      created_at: item.created_at
    })
  end

  def markdown(text)
    options = {
      filter_html:     true,
      hard_wrap:       true,
      link_attributes: { rel: 'nofollow', target: "_blank" },
      space_after_headers: true,
      fenced_code_blocks: true
    }

    extensions = {
      autolink:           true,
      superscript:        true,
      disable_indented_code_blocks: true
    }

    renderer = Redcarpet::Render::HTML.new(options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)

    markdown.render(text).html_safe
  end
end
