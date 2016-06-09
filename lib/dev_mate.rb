require "dev_mate/version"
require "json"
require "httparty"

module DevMate

  class BadRequestError < StandardError
  end

  class UnauthorizedError < StandardError
  end

  class ConflictError < StandardError
  end

  class NotFoundError < StandardError
  end

  class UnknownError < StandardError
  end

  class DevMate
    include HTTParty

    base_uri 'https://public-api.devmate.com/v2'

    def self.SetToken(token) @@token = token
    @@auth_header = "Token #{token}"
    end

    def self.Token
      @@token
    end

    def self.CreateCustomer(email, last_name: nil, first_name: nil, note: nil) data = { :email => email }
    data[last_name] = last_name if last_name
    data[first_name] = first_name if first_name
    data[note] = note if note
    body = { :data => data }

    options = { :body => body.to_json, :headers => { "Authorization" => @@auth_header } }
    response = self.post('/customers/', options)

    #TODO handle timeouts!
    response_object = JSON.parse response.body

    unless response.code == 201
      #sad path
      errors = response_object["errors"]

      case response.code
      when 400
        raise BadRequestError, "#{errors[0]["title"]} #{errors[0]["detail"]}"
      when 401
        raise UnauthorizedError, errors[0]["title"]
      when 409
        raise ConflictError, "#{errors[0]["title"]} #{errors[0]["detail"]}"
      else raise UnknownError
      end
    end

    # return response.body on success
    response_object = JSON.parse response.body
    return response_object['data']
    end

    def self.FindCustomerById(id) response = self.get("/customers/#{id}", :headers => { "Authorization" => @@auth_header })

    #TODO handle timeouts!
    response_object = JSON.parse response.body

    unless response.code == 201
      #sad path
      errors = response_object["errors"]

      case response.code
      when 401
        raise UnauthorizedError, errors[0]["title"]
      when 404
        return nil
      end
    end

    # return response.body on success
    response_object = JSON.parse response.body
    return response_object['data']
    end

    def self.FindCustomerWithFilters(email: nil, first_name: nil, last_name: nil, license_key: nil, identifier: nil, order_id: nil, activation_id: nil, invoice: nil, offset: nil, limit: nil, with: nil)

      query = {}
      query["filter[email]"] = email if email
      query["filter[first_name]"] = first_name if first_name
      query["filter[last_name]"] = last_name if last_name
      query["filter[license_key]"] = license_key if license_key
      query["filter[identifier]"] = identifier if identifier
      query["filter[order_id]"] = order_id if order_id
      query["filter[activation_id]"] = activation_id if activation_id
      query["filter[invoice]"] = invoice if invoice
      query["offset"] = offset if offset
      query["limit"] = limit if limit
      query["with"] = with if with

      response = self.get("/customers", :query => query, :headers => { "Authorization" => @@auth_header })

      #TODO handle timeouts!
      response_object = JSON.parse response.body

      unless response.code == 201
        #sad path
        errors = response_object["errors"]

        case response.code
        when 401
          raise UnauthorizedError, errors[0]["title"]
        when 404
          return []
        end
      end

      # return response.body on success
      response_object = JSON.parse response.body
      return response_object['data']
    end
  end
end
