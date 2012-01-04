class ErrorNotifier < ActionMailer::Base
  default from: 'Sam Ruby <depot@example.com>'

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.error_notifier.application_failure.subject
  #
  def application_failure(error)
    @error = error

    mail to: "elan.dubrofsky@gmail.com", subject: "Application failure in Depot"
  end
end
