class ApplicationController < ActionController::Base
  before_filter :authorize
  before_filter :set_logged_in_user
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
  
  private
  
    def set_logged_in_user
      @logged_in_user = User.find_by_id(session[:user_id])
    end
  
  protected
  
    def authorize
      if request.format == Mime::HTML
        unless User.find_by_id(session[:user_id]) or User.count.zero?
          redirect_to login_url, notice: "Please log in"
        end
      else
        authenticate_or_request_with_http_basic do |username, password|
          user = User.authenticate(username, password)
        end
      end
    end
    
end
