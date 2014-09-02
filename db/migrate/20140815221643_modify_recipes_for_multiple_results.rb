class ModifyRecipesForMultipleResults < ActiveRecord::Migration
  def up
    add_column :recipes, :results, :string

    Recipe.all.each do |recipe|
      recipe.update_attributes(results: "#{recipe.item_template_id}|#{recipe.quantity}")
    end

    change_column :recipes, :results, :string, null: false
    remove_column :recipes, :quantity
    remove_column :recipes, :item_template_id
  end

  def down
    add_column :recipes, :quantity, :integer
    add_column :recipes, :item_template_id, :integer

    Recipe.all.each do |recipe|
      result = recipe.results.split(',')[0]
      result = result.split('|')
      recipe.update_attributes(item_template_id: result[0], quantity: result[1])
    end

    remove_column :recipes, :results
  end
end
