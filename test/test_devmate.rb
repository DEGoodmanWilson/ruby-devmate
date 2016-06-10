require 'coveralls'
Coveralls.wear!

gem "minitest"
require 'minitest/autorun'
require 'dev_mate'
require 'securerandom'


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

describe "When updating a customer" do
  it "should succeed when the stars align" do
    email = "#{SecureRandom.uuid}@example.com"
    customer = DevMate::DevMate.CreateCustomer(email)
    customer["last_name"].must_be_empty

    customer["last_name"] = "Foobar"
    updated_customer = DevMate::DevMate.UpdateCustomer(customer)
    updated_customer["last_name"].must_equal customer["last_name"]

    fetched_customer = DevMate::DevMate.FindCustomerById(customer["id"])
    fetched_customer["last_name"].must_equal customer["last_name"]
  end

  it "should fail with an invalid auth" do
    email = "#{SecureRandom.uuid}@example.com"
    customer = DevMate::DevMate.CreateCustomer(email)
    customer["last_name"] = "Foobar"

    DevMate::DevMate.SetToken("foobar")
    proc { DevMate::DevMate.UpdateCustomer(customer) }.must_raise DevMate::UnauthorizedError
    DevMate::DevMate.SetToken(ENV["DEVMATE_TOKEN"])
  end

  it "should fail if an email was not specified" do
    email = "#{SecureRandom.uuid}@example.com"
    customer = DevMate::DevMate.CreateCustomer(email)
    customer.delete("email")
    proc { DevMate::DevMate.UpdateCustomer(customer) }.must_raise DevMate::BadRequestError
  end

  it "should fail when the id is invalid" do
    customer = { "id" => 1000000000000, "email" => "foobar@example.com", "last_name" => "Foobar"}
    proc { DevMate::DevMate.UpdateCustomer(customer) }.must_raise DevMate::NotFoundError
  end

  it "should fail if an email was not specified" do
    email_1 = "#{SecureRandom.uuid}@example.com"
    customer_1 = DevMate::DevMate.CreateCustomer(email_1)

    email_2 = "#{SecureRandom.uuid}@example.com"
    customer_2 = DevMate::DevMate.CreateCustomer(email_2)

    customer_2["email"] = email_1
    proc { DevMate::DevMate.UpdateCustomer(customer_2) }.must_raise DevMate::ConflictError
  end

end

describe "When creating a license" do
  it "should succeed when the stars align" do
    email = "#{SecureRandom.uuid}@example.com"
    customer = DevMate::DevMate.CreateCustomer(email)
    license = DevMate::DevMate.CreateLicense(customer, 1)
    license["activation_key"].wont_be_empty
  end

  it "should fail with an invalid auth" do
    email = "#{SecureRandom.uuid}@example.com"
    customer = DevMate::DevMate.CreateCustomer(email)

    DevMate::DevMate.SetToken("foobar")
    proc { DevMate::DevMate.CreateLicense(customer, 1) }.must_raise DevMate::UnauthorizedError
    DevMate::DevMate.SetToken(ENV["DEVMATE_TOKEN"])
  end

  it "should fail with an invalid license id" do
    email = "#{SecureRandom.uuid}@example.com"
    customer = DevMate::DevMate.CreateCustomer(email)

    proc { DevMate::DevMate.CreateLicense(customer, 100) }.must_raise DevMate::BadRequestError
  end


  it "should fail with an invalid customer id" do
    customer = { "id" => 1000000000000, "email" => "foobar@example.com", "last_name" => "Foobar"}

    proc { DevMate::DevMate.CreateLicense(customer, 1) }.must_raise DevMate::BadRequestError
  end
end