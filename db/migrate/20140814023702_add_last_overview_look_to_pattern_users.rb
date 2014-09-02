class AddLastOverviewLookToPatternUsers < ActiveRecord::Migration
  def change
    add_column :pattern_users, :last_overview_look, :datetime
    PatternUser.update_all(last_overview_look: (Time.now - 24.hours))
  end
end
