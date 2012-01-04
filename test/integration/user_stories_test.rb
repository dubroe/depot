require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
  fixtures :products, :carts
  
  test "buying a product" do
    LineItem.delete_all
    Order.delete_all
    ruby_book = products(:ruby)
    
    #A user goes to the store index page
    get "/"
    assert_response :success
    assert_template "index"
    
    #They select a product, adding it to their cart
    xml_http_request :post, '/line_items', product_id: ruby_book.id
    assert_response :success
    
    cart = Cart.find(session[:cart_id])
    assert_equal 1, cart.line_items.size
    assert_equal ruby_book, cart.line_items[0].product
    
    #They then check out
    get "/orders/new"
    assert_response :success
    assert_template "new"
    
    #They fill in their details on the checkout form
    post_via_redirect "/orders", order: {name: "Dave Thomas", address: "123 The Street", email: "dave@example.com", pay_type_id: pay_types(:one).id}
    assert_response :success
    assert_template "index"
    cart = Cart.find(session[:cart_id])
    assert_equal 0, cart.line_items.size
    
    #When they submit, an order is created in the database containing their information, along with a single line item corresponding to the product they added to their cart
    orders = Order.all
    assert_equal 1, orders.size
    order = orders[0]
    
    assert_equal "Dave Thomas", order.name
    assert_equal "123 The Street", order.address
    assert_equal "dave@example.com", order.email
    assert_equal "Check", order.pay_type.name
    
    assert_equal 1, order.line_items.size
    line_item = order.line_items[0]
    assert_equal ruby_book, line_item.product
    
    #Once the order has been received, an email is sent confirming their purchase
    mail = ActionMailer::Base.deliveries.last
    assert_equal ["dave@example.com"], mail.to
    assert_equal 'Sam Ruby <depot@example.com>', mail[:from].value
    assert_equal "Pragmatic Store Order Confirmation", mail.subject
    
    #Ship the product
    login_user_integration
    now = Time.now.to_date
    put_via_redirect "/orders/#{order.id}", order: {ship_date: now}
    assert_response :success
    assert_equal Order.find(order.id).ship_date.to_date, now
    mail = ActionMailer::Base.deliveries.last
    assert_equal "Pragmatic Store Order Shipped", mail.subject
  end

  test "should fail on access of sensitive data" do
    login_user_integration
    
    #look at a protected resource
    get "/carts/#{carts(:one).id}"
    assert_response :success
    assert_equal "/carts/#{carts(:one).id}", path
    
    #logout user
    delete "/logout"
    assert_response :redirect
    assert_template "/"
    
    #try to look at protected resource again, should be redirected to login page
    get "/carts/#{carts(:one).id}"
    assert_response :redirect
    follow_redirect!
    assert_equal '/login', path
  end
  
end
