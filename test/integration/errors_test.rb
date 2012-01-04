require 'test_helper'

class ErrorsTest < ActionDispatch::IntegrationTest
  fixtures :all
  
  ''' No longer applies
  test "should mail the admin when error occurs" do
      get "/carts/wibble" 
      assert_response :redirect  # should redirect to...
      assert_template "/"        # ...store index

      mail = ActionMailer::Base.deliveries.last
      assert_equal ["elan.dubrofsky@gmail.com"], mail.to
      assert_equal "Sam Ruby <depot@example.com>", mail[:from].value
      assert_equal "Application failure in Depot", mail.subject
    end
  '''
end
