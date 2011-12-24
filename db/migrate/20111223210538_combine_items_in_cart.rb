class CombineItemsInCart < ActiveRecord::Migration
  def up
    #Combine line items for same product
    Cart.all.each do |cart|
      sums = cart.line_items.group(:product_id).sum(:quantity)
      sums.each do |product_id, quantity|
        if quantity > 1
          cart.line_items.where(product_id: product_id).delete_all
          cart.line_items.create(product_id: product_id, quantity: quantity)
        end
      end
    end
  end

  def down
    #Split combined line items into seperate ones
    LineItem.where("quantity > 1").each do |line_item|
      line_item.quantity.times do
        line_item.cart.line_items.create(product_id: line_item.product.id)
      end
      line_item.destroy
    end
  end
end
