class Login
  include ::ActiveAttr::Model
  attribute :email,  type: String
  attribute :name,  type: String
  attribute :phone,  type: String
  attribute :password_confirmation,  type: String
  attribute :password,    type: String
end
