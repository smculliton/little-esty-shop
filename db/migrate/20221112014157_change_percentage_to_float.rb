class ChangePercentageToFloat < ActiveRecord::Migration[5.2]
  def change
    change_column :bulk_discounts, :percentage, :float
  end
end
