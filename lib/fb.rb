class Fb
  def initialize
    @client = Koala::Facebook::API.new(Settings.fb_token)
  end

  def get_school_posts
    @client.get_connection("1400772563573220","posts")
  end

  def get_club_posts
    @client.get_connection("when.I.speak.I.learn","posts")
  end
end
