require 'test_helper'

class ErrorNotifierTest < ActionMailer::TestCase
  test "application_failure" do
    mail = ErrorNotifier.application_failure(nil)
    assert_equal "Application failure in Depot", mail.subject
    assert_equal ["elan.dubrofsky@gmail.com"], mail.to
    assert_equal ["depot@example.com"], mail.from
    assert_match "Hello", mail.body.encoded
  end

end
