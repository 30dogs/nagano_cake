class ChangeDeriveriesToDeliveries < ActiveRecord::Migration[5.2]
  def change
    rename_table :deriveries, :deliveries
  end
end
