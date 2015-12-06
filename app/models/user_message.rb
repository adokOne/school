class UserMessage < ActsAsMessageable::Message

  def receiver
    self.received_messageable_type.constantize.find(self.received_messageable_id)
  end

  def sender( owner_id = false )
    sender = self.sent_messageable_type.constantize.find(self.sent_messageable_id)
    if owner_id && self.sent_messageable_id == owner_id
      sender = receiver
    end
    sender
  end

  def childrens
    UserMessage.where( ancestry: self.id )
  end

end
