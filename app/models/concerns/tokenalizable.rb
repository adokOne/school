module Tokenalizable
  extend ActiveSupport::Concern

  included do
    validates :access_token, length: { in: 30..50},  if: -> (o) { o.respond_to?(:access_token) }
    before_validation :generate_token
  end

  private

  def generate_token
    self.access_token = SecureRandom.hex  if self.respond_to?(:access_token) && self.access_token.nil?  
  end

end