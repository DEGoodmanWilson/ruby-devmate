gem "minitest"
require 'minitest/autorun'
require 'dev_mate'

DevMate::DevMate.SetToken(ENV["DEVMATE_TOKEN"])

describe "When creating a token" do
  it "should be set in the environment" do
    ENV["DEVMATE_TOKEN"].wont_be_nil
  end

  it "should be set in the DevMate object" do
    DevMate::DevMate.Token.must_equal ENV["DEVMATE_TOKEN"]
  end
end

describe "When creating a user" do
  it "should succeed when the stars align" do
    DevMate::DevMate.CreateCustomer("foo@example.com").wont_be_nil
  end

  it "should fail when we create a new account with the same email address twice" do
    proc { DevMate::DevMate.CreateCustomer("foo@example.com") }.must_raise DevMate::ConflictError
  end

  it "should fail when the an invalid token is provided" do
    DevMate::DevMate.SetToken("foobar")
    proc { DevMate::DevMate.CreateCustomer("foo@example.com") }.must_raise DevMate::UnauthorizedError
  end
end