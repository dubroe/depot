require 'test_helper'

class ErrorNotifierTest < ActionMailer::TestCase
  test "application_failure" do
    mail = ErrorNotifier.application_failure
    assert_equal "Application failure", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
