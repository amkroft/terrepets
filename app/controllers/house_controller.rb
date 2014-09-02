class HouseController < ApplicationController

	def index 
    @house = current_user.house
    reduce_hours_to_max
		set_house_index_variables
    check_for_badges
	end

  def run_hours
    @house = current_user.house
    # TODO keep track of mod(hours_run, 24) so can do allowance
    if current_user.pets.count == 0 
      redirect_to house_path , alert: 'You don\'t own any pets, adopt one before running hours.'
    elsif hours_to_run < 1
      redirect_to house_path, alert: 'You don\'t have any hours to run.'
    elsif !params[:data][:hours]
      redirect_to house_path, alert: 'Number of hours to run not specified.'
    else
      puts "#{Time.now}: User #{current_user.display_name} running #{params[:data][:hours]} hours."
      @force_run = false
      abstract_run_hours
    end
  end

  def force_run_hour
    raise CanCan::AccessDenied if !current_user.is_admin || Rails.env.production?
    @force_run = true
    abstract_run_hours
  end

  def incoming
    @items = Item.includes(:item_template).where(user_id: current_user.id, location: 2).load
    @items = @items.to_a.sort! {|x,y| x.item_template.name <=> y.item_template.name}
  end

private

  def abstract_run_hours
    @house = current_user.house

    case params[:data][:hours]
    when 'one'
      hours_to_run = 1
      @notes = 'One hour was run.<br>'
    when 'eight'
      hours_to_run = 8
      @notes = 'Eight hours were run.<br>'
    when 'all'
      hours_to_run = self.send(:hours_to_run)
      @notes = "#{hours_to_run} hours were run.<br>"
    else
      hours_to_run = 1
      @notes = 'One hour was run.<br>'
    end

    @notes = ""
    @hour_logs = []
    total_time = 0
    hours_run = 0

    pets = current_user.pets
    inventory = Item.includes(:item_template).where(user_id: current_user.id, location: 0).to_a

    
    hours_to_run.times do |hour|
      time = Benchmark.measure do
        new_logs = ""
        pets.each do |pet|
          @logs = pet.run_hour(inventory)
          @logs[:hour_logs].each { |log| log[:hour] = hour+1 }
          new_logs += @logs[:logs]
          @hour_logs += @logs[:hour_logs]
        end
        new_logs += update_allowance
        unless new_logs.empty?
          @notes += "<strong>Hour ##{hour+1}</strong><br>"
          @notes += new_logs
        end
      end
      total_time += time.real
      hours_run += 1
      if hours_run == hours_to_run
        # do nothing
      elsif total_time > 25
        flash[:alert] = "Running #{params[:data][:hours]} hours is taking too long.  #{pluralize(hours_run, 'hour')} were run."
        break
      else
        sleep(0.1)
      end
    end


    puts "Total time taken = #{total_time}"

    @house.last_hour_run += hours_run.hours if !@force_run

    House.transaction do
      @house.save
      save_hour_logs(@hour_logs)
      pets.each { |pet| pet.save }
    end

    @notes.chomp!
    set_house_index_variables
    render :index
  end

  def hours_to_run
    ((Time.now - @house.last_hour_run)/1.hour).to_i
  end

  def minutes_until_hour
    60 - ((Time.now - @house.last_hour_run)/1.minute).to_i
  end

  def reduce_hours_to_max
    # puts 'Hit reduce_hours_to_max'
    total_hours = ((Time.now - @house.last_hour_run)/1.hour).to_i
    # puts "Total hours: #{total_hours}"
    return if total_hours < House.max_hours
    # puts "House has more than House.max_hours"
    new_last_hour_run = @house.last_hour_run + (total_hours-House.max_hours).hour
    # puts "Updated house to set last_hour_run to : #{new_last_hour_run}"
    @house.update_attributes(:last_hour_run => new_last_hour_run)
  end


  def set_house_index_variables
    @pets = Pet.includes(:pet_template, :item => :item_template).where(:user_id => current_user.id)

    params[:room] ||= 0
    if params[:condensed] == 'true'
      @items=convert_items_to_histogram
    else
      @items=Item.includes(:item_template).where(:user_id=>current_user.id, location: 0, room: params[:room])
      @items= @items.to_a.sort do |x,y|
        first_element = sort_direction == :asc ? x : y
        second_element = sort_direction == :asc ? y : x
        if sort_column == :note
          first_element.sort_note <=> second_element.sort_note
        else
          first_element.item_template.send(sort_column) <=> second_element.item_template.send(sort_column)
        end
      end

    end

    @minutes_to_wait = minutes_until_hour
    @hours_to_run = hours_to_run
  end

  # def inventory_hash
  #   inventory = Item.includes(:item_template).where(user_id: current_user.id, location: 0)
  #   hash = {}
  #   inventory.each do |item|
  #     hash[item.id] = item
  #   end
  #   hash
  # end


  def check_for_badges
    # REDACTED
  end

  def convert_items_to_histogram
      items_to_convert=Item.includes(:item_template).where(:user_id=>current_user.id, :location =>0, room: params[:room])
      items_histogram={}

      items_to_convert.each do | item | 
        if items_histogram.has_key? item.item_template.name   
          items_histogram[item.item_template.name]+=1
        else
          items_histogram[item.item_template.name]=1
        end
      end

      items_histogram = items_histogram.sort_by { |name, quantity| name }

      return items_histogram
  end

  def update_allowance
    if @house.allowance_hours == 23
      ActiveRecord::Base.transaction do
        @house.update_attributes(allowance_hours: 0)
        current_user.update_attributes(money: current_user.money + 138)
      end
      "138 monies gained from allowance.<br>"
    else
      @house.update_attributes(allowance_hours: @house.allowance_hours + 1)
      ""
    end
  end

  def sort_column
    if params[:sort_by] && [:name, :value, :note].include?(params[:sort_by].to_sym)
      params[:sort_by].to_sym
    else
      :name
    end
  end

  def sort_direction
    direction = params[:direction] || :asc
    direction.to_sym
  end


  def save_hour_logs(hour_logs)
    return if hour_logs.empty?
    # pet_id, description, real_time, hour, created_at, updated_at
    db_inserts = hour_logs.map do |hour_log|
      "(#{hour_log[:pet_id]}, #{ActiveRecord::Base.connection.quote(hour_log[:description])}, #{hour_log[:real_time]}, #{hour_log[:hour]}, #{ActiveRecord::Base.connection.quote(Time.now)}, #{ActiveRecord::Base.connection.quote(Time.now)})"
    end

    sql = "INSERT INTO hour_logs (`pet_id`, `description`, `real_time`, `hour`, `created_at`, `updated_at`) VALUES #{db_inserts.join(", ")}"
    HourLog.connection.execute(sql)

    HourLog.where('created_at < ?', Time.now - 1.week).delete_all
  end

end

