class Order < ActiveRecord::Base
  has_many :line_items, dependent: :destroy
  belongs_to :pay_type
  
  validates :name, :address, :email, presence: true
  validates :pay_type_id, presence: true
  
  def add_line_items_from_cart(cart)
    cart.line_items.each do |line_item|
      line_item.cart_id = nil #Because we will be destroying the cart and it is dependent destroy
      line_items.push line_item
    end
  end
end
