# frozen_string_literal: true

require "test_helper"

class ApplicationBootTest < ActiveSupport::TestCase
  test "Rails base classes are loaded for coverage" do
    assert_equal "ApplicationCable::Channel", ApplicationCable::Channel.name
    assert_equal "ApplicationCable::Connection", ApplicationCable::Connection.name
    assert_equal "ApplicationJob", ApplicationJob.name
    assert_equal "ApplicationMailer", ApplicationMailer.name
    assert_equal "from@example.com", ApplicationMailer.default[:from]
    assert_equal "mailer", ApplicationMailer._layout
  end
end
