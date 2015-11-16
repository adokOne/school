class Fb
  def initialize
    @client = Koala::Facebook::API.new(Settings.fb_token)
  end

  def get_school_posts
    @client.get_connection("1400772563573220","posts")
  end

  def get_club_posts
    begin
      @client.get_connection("when.I.speak.I.learn","posts").map do |item|
        p  item['message']
        if item['message'] =~ /#speaking_club_speak‬/
          item
        else
          nil
        end
      end.compact
    rescue Exception => e
      []
    end

  end
end
