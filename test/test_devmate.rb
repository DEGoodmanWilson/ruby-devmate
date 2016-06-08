gem "minitest"
require 'minitest/autorun'
require 'dev_mate'

class DevMateTest < Minitest::Test
  def test_token_setting
    DevMate::DevMate.SetToken("foobar")
    assert_equal "foobar", DevMate::DevMate.Token
  end
end