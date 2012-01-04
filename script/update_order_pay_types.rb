Order.all.each do |order|
  unless order.pay_type
    order.update_attributes({pay_type_id: 1})
  end
end