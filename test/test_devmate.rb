gem "minitest"
require 'minitest/autorun'
require 'dev_mate'
require 'securerandom'
require 'coveralls'

Coveralls.wear!

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
    email = "#{SecureRandom.uuid}@example.com"
    DevMate::DevMate.CreateCustomer(email).wont_be_nil
  end

  it "should fail when we create a new account with the same email address twice" do
    email = "#{SecureRandom.uuid}@example.com"
    DevMate::DevMate.CreateCustomer(email).wont_be_nil
    proc { DevMate::DevMate.CreateCustomer(email) }.must_raise DevMate::ConflictError
  end

  it "should fail when the an invalid token is provided" do
    DevMate::DevMate.SetToken("foobar")
    proc { DevMate::DevMate.CreateCustomer("foo@example.com") }.must_raise DevMate::UnauthorizedError
    DevMate::DevMate.SetToken(ENV["DEVMATE_TOKEN"])
  end
end

describe "When looking up a customer" do
  it "should succeed when we use a valid email address" do
    email = "#{SecureRandom.uuid}@example.com"
    customer = DevMate::DevMate.CreateCustomer(email)

    customer_list = DevMate::DevMate.FindCustomerWithFilters(email: email)
    customer_list[0]["email"].must_equal customer["email"]
  end

  it "should succeed when we use a valid customer id" do
    email = "#{SecureRandom.uuid}@example.com"
    customer = DevMate::DevMate.CreateCustomer(email)

    found_customer = DevMate::DevMate.FindCustomerById(customer["id"])

    found_customer.wont_be_nil
    found_customer["id"].must_equal customer["id"]
  end

  it "should fail when invalid authorization is provided" do
    DevMate::DevMate.SetToken("foobar")
    proc { DevMate::DevMate.FindCustomerById(1) }.must_raise DevMate::UnauthorizedError
    DevMate::DevMate.SetToken(ENV["DEVMATE_TOKEN"])
  end

  it "should fail when the user doesn't exist" do
    #this is just a guess at a user id that is too big to exist. This is contingent and not the right thing to do
    DevMate::DevMate.FindCustomerById(1000000000000).must_be_nil
  end
end