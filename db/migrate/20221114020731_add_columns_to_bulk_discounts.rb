class AddColumnsToBulkDiscounts < ActiveRecord::Migration[5.2]
  def change
    add_column :bulk_discounts, :name, :string
    add_column :bulk_discounts, :holiday, :string
  end
end
