class AddPayTypeToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :pay_type_id, :integer
  end
end
