module ForumsHelper

  def clean_post_content(content)
    content.gsub!(/<3/,'&lt;3')
    content.gsub!(/(\s+|^)>/,'\1&gt;')
    content.gsub!(/<(\s+|$)/,'&lt;\1')
    node = Nokogiri::HTML.parse(content)
    node.css("style,script,button,form,input").remove
    node.xpath("//@*[starts-with(name(),'on')]").remove
    node.xpath("//@*[starts-with(name(),'style')]").remove
    if node.css('p').size == 1 && node.css('body').inner_html.start_with?('<p>') && node.css('body').inner_html.end_with?('</p>')
      node.css('p').inner_html.gsub(/\n/, '<br/>')
    else
      node.css('body').inner_html.gsub(/\n/, '<br/>')
    end
  end

end
