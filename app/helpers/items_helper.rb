module ItemsHelper

  def item_encyclopedia_link(item_template_name)
    link_to raw("<i class='fa fa-info' alt='Encyclopedia' title='Encyclopedia'></i>"), item_encyclopedia_path(item_template_name.gsub(/ /, '_').downcase), target: '_blank'
  end

end
