# frozen_string_literal: true

module Relay::Models
  class User < Sequel::Model
    include Relay::Model

    set_dataset :users
    one_to_many :contexts
    one_to_many :mcps, class: "Relay::Models::MCP"

    ##
    # Hashes and stores the given password.
    # @param [String] value
    def password=(value)
      @password = value
      self.password_digest = BCrypt::Password.create(value)
    end

    ##
    # Authenticates the given plaintext password.
    # @param [String] value
    # @return [Relay::Models::User,false]
    def authenticate(value)
      return false if password_digest.to_s.empty?

      BCrypt::Password.new(password_digest) == value && self
    rescue BCrypt::Errors::InvalidHash
      false
    end
  end
end
