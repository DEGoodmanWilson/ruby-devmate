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

  class DevMate
    include HTTParty
    base_uri 'https://public-api.devmate.com/v2'

    def self.SetToken(token)
      @@token = token
      @@auth_header = "Token #{token}"
    end

    def self.Token
      @@token
    end

    def self.CreateCustomer(email, last_name: nil, first_name: nil, note: nil)
      data = {:email => email}
      data[last_name] = last_name if last_name
      data[first_name] = first_name if first_name
      data[note] = note if note
      body = {:data => data}

      options = { :body => body.to_json, :headers => {"Authorization" => @@auth_header }}
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
        end
      end

      # return response.body on success
      return JSON.parse response.body
    end
  end
end
