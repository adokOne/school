class Message
  include ::ActiveAttr::Model
  attribute :topic,  type: String
  attribute :body,  type: String
  attribute :reciver_id,    type: Integer
  attribute :message_id,    type: Integer

 # validates_presence_of :topic,  if: ->{ !self.message_id.present?}
  validates :body,:reciver_id, presence: true

  validate :reciver_exist?


  def reciver
    User.find(self.reciver_id)
  end

  def reciver_exist?
    !User.count(id: self.reciver_id).zero?
  end


end
