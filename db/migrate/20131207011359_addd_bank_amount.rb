class AdddBankAmount < ActiveRecord::Migration
  def change
	add_column :users, :savings, :double
  end
end
