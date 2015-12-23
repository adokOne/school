class AnonimOrder
  include ::ActiveAttr::Model
  attribute :name,  type: String
  attribute :email, type: String
  attribute :phone,  type: String
  attribute :comment,  type: String

  attribute :product_id,  type: Integer


  validates :email, :name, :email, :product_id, :presence => true
  validates :email,    length: { in: 6..50 }, format:{with:/\A^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i}
  validates :name, length: { in: 5..100 }
  validates :phone, length: { in: 5..20 }



  def user_exist?
    !User.where(email: self.email ).count.zero?
  end

  def create_real
    user = User.find_by_email(self.email)
    data = {
      product_id: self.product_id,
      amount: self.product.cost,
      currency: "USD",
      comment: self.comment
    }
    user.orders.create(data)
  end

  def product
    Product.find(self.product_id)
  end

end
