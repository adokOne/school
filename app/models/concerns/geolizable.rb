module Geolizable
  extend ActiveSupport::Concern

  def popular_cities
    unless @popular_cities
      item = self.kind_of?(City) ? self.country : self
      ids = item.cities.where(show_as_popular: true).pluck(:id).shuffle
      @popular_cities = item.cities.includes(:country).where("id IN (?)",ids).to_a
    end
    @popular_cities
  end
  def best_routes city_code = false
    if city_code
      Avia::Stat.get_best_prices_from city_code
    else
      Avia::Stat.get_best_prices_to self.code
    end
  end

  def best_geo_routes( city_code )
    if self.kind_of?(Country)
      Avia::Stat.get_best_prices_from_to_airports( city_code, self.cities.map(&:code) )
    elsif self.kind_of?(Continent)
      Avia::Stat.get_best_prices_from_to_airports( city_code, self.countries.map(&:cities).flatten.map(&:code) )
    else
      []
    end
  end

end
