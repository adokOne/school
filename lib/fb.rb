class Fb
  def initialize( token )
    @client = Koala::Facebook::API.new(token)
  end

  def get_school_posts
    begin
      data =  @client.get_connection("xbox.in.ua","ratings").map do |item|
        item["link"] = "https://www.facebook.com/1400772563573220/reviews"
        item['review_text'].present? ? item : nil
      end.compact
    rescue Exception => e
      []
    end
    return data
  end

  def get_club_posts
    begin
      data =  @client.get_connection("xbox.in.ua","ratings").map do |item|
        item["link"] = "https://www.facebook.com/when.I.speak.I.learn/reviews"
        item['review_text'].present? ? item : nil
      end.compact
    rescue Exception => e
      []
    end
    return data
  end
end
