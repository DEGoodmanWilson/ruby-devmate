require "dev_mate/version"

module DevMate
  class DevMate
    def self.SetToken(token)
      @@token = token
    end

    def self.Token
      @@token
    end
  end
end
