class User < ActiveRecord::Base


  acts_as_messageable dependent: :destroy,
                      class_name: "UserMessage"

  after_save :clear_cache

  COOKIE_NAME = :user_token
  has_secure_password

  signinable expiration: ::B1Config.get_const.sign_in_expiration

  #Validates
  validates :name,:email, presence: true
  validates :password, presence: true, on: :create
  validates :name,     length: { in: 3..50 }, format: {with:/\A^[^0-9`!@#\$%\^&*+_=]+\z/i}
  validates :email,    length: { in: 6..50 }, uniqueness: true,format:{with:/\A^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i}
  validates :password, length: { in: 5..20 }, on: :create
  validates :active, inclusion:{ in: [true,false] }
  #End validates

  #Relations
  has_many :contacts
  has_many :pages
  has_many :transactions
  has_many :orders

  accepts_nested_attributes_for :contacts
  #End Relations


  scope :by_rating, -> { order('created_at DESC') }
  scope :by_category, ->(id) { where(category_id: id) }
  scope :active, -> { where(active: true) }

  has_attached_file :avatar, styles: { medium: "300x300>",thumb: "100x100>" }, default_url: "/img/avatar-missing.png"

  validates_attachment_file_name :avatar, :matches => [/png\Z/, /jpe?g\Z/, /gif\Z/]




  # Authenticate current user by password, block user if wrong password auth attempts greather of maximum
  # @note That method use gem "signinable"
  # @see https://github.com/novozhenets/signinable
  # @param  [String] User password
  # @param  [String] Current  user IP address
  # @param  [String] Requested action in class
  # @param  [String] User Agent e.g "Mozilla 12.05"
  # @retrun [Nil]
  def sign_in(password, ip, referer, user_agent)
    if authenticate(password)
      update!(blocked: false, blocked_until: nil, wrong_password_attempts: 0, signins_count: (self.signins_count + 1) )
      signin(ip, user_agent, referer)
    else
      increment!(:wrong_password_attempts)
      if wrong_password_attempts >= ::B1Config.get_const.max_password_attempts
        update!(blocked: true, blocked_until: Time.now + ::B1Config.get_const.block_time)
      end
      nil
    end
  end

  #TODO
  def unread_messages_count
    3
  end

  def message_to_show(user)
    self.messages.where(ancestry: nil).are_from(user) + self.messages.where(ancestry: nil).are_to(user)
  end


  def distinct_messages
    messages = {}
    self.messages.each do |message|
      key = [message.sent_messageable_id, message.received_messageable_id].sort.join
      messages[key] = message if messages[key].nil?
    end
    messages.values
  end

  #TODO
  def messages_count
    self.messages.count
  end

  def balance
    [self.transactions.for_balance.map(&:amount).sum, "UAH"].join(" ")
  end

  def total_payed
    [self.transactions.payed.map(&:amount).sum, "UAH"].join(" ")
  end

  def self.password
    (0...8).map { (65 + rand(26)).chr }.join
  end


  Contact::TYPES.each do |type|
    define_method(type.pluralize) do
      self.contacts.where(contact_type: type).map(&:value)
    end
    define_method("#{type}_contacts") do
      self.contacts.where(contact_type: type).all
    end
  end

  def is_vip
    [true,false].sample
  end

  private

  def clear_cache
  end

end
