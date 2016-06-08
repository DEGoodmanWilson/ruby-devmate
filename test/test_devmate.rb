gem "minitest"
require 'minitest/autorun'
require 'dev_mate'

class DevMateTest < Minitest::Test

  ##
  # Setup and test token
  #

  DevMate::DevMate.SetToken(ENV["DEVMATE_TOKEN"])

  def test_env
    assert ENV["DEVMATE_TOKEN"]
  end

  def test_token_setting
    assert_equal ENV["DEVMATE_TOKEN"], DevMate::DevMate.Token
  end

  ##
  # Test customer object
  #

  def test_customer_creation_success
    assert DevMate::DevMate.CreateCustomer("foo@example.com")
  end

end