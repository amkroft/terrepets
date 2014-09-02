module TableHelper

  def sortable(column, title = nil)
    title ||= column.titleize
    
    if column == params[:sort_by]
      if params[:direction].eql?('desc')
        direction = 'asc'
        arrow = "<i class='fa fa-caret-up' style='color: white;'></i>"
      else
        direction = 'desc'
        arrow = "<i class='fa fa-caret-down' style='color: white;'></i>"
      end
    else
      direction = 'asc'
      arrow = "<i class='fa fa-angle-down' style='color: white;'></i>"
    end

    path_options = {controller: params[:controller], action: params[:action], sort_by: column, direction: direction }
    link_to raw("<span style='color: white;'>#{title}</span> " + arrow), path_options
  end

end