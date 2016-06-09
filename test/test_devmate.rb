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
    DevMate::DevMate.SetToken(ENV["DEVMATE_TOKEN"])
  end
end

describe "When looking up a customer" do
  it "should succeed when we use a valid email address" do
    customer_list = DevMate::DevMate.FindCustomer(email: "foo@example.com")
    customer_list[0]["email"].must_equal "foo@example.com"
  end

  it "should succeed when we use a valid customer id" do
    dummy_customer_list = DevMate::DevMate.FindCustomer(email: "foo@example.com")
    customer_list = DevMate::DevMate.FindCustomer(id: dummy_customer_list[0]["id"])
    customer_list[0]["id"].must_equal dummy_customer_list[0]["id"]
  end

  it "should fail when invalid authorization is provided" do
    DevMate::DevMate.SetToken("foobar")
    proc { DevMate::DevMate.FindCustomer(email: "foo@example.com") }.must_raise DevMate::UnauthorizedError
    DevMate::DevMate.SetToken(ENV["DEVMATE_TOKEN"])
  end

  it "should fail when the user doesn't exist" do
    DevMate::DevMate.FindCustomer(email: "foo2@example.com").must_be_empty
  end
end