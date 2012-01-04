class ApplicationController < ActionController::Base
  before_filter :authorize
  protect_from_forgery
  
  private
  
    # Accessible to all controllers
    def current_cart
      Cart.find(session[:cart_id])
    rescue ActiveRecord::RecordNotFound
      cart = Cart.create
      session[:cart_id] = cart.id
      cart
    end
    
    before_filter :instantiate_controller_and_action_names

    def instantiate_controller_and_action_names
        @current_action = action_name
        @current_controller = controller_name
    end
  
  protected
  
    def authorize
      unless User.find_by_id(session[:user_id])
        redirect_to login_url, notice: "Please log in"
      end
    end
    
end
