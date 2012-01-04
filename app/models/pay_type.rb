class PayType < ActiveRecord::Base
  has_many :orders
  
  def self.names_ids_list
    all.map {|pay_type| [pay_type.name, pay_type.id]}
  end
end
