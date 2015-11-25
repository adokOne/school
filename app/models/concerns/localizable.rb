module Localizable
  extend ActiveSupport::Concern

  included do
    # B1Config.get_const.all_langs.each do |l|
    #   #validates :"name_#{l}", length: { in: 3..50},format: {with:/\A^[^`!@#\$%\^&*+=]+\z/i},  if: -> (o) { o.respond_to?(:"name_#{l}") }
    #   #validates :"title_#{l}", length: { in: 3..255},format: {with:/\A^[^`!@#\$%\^&*+=]+\z/i},  if: -> (o) { o.respond_to?(:"title_#{l}") }
    # end
    before_validation :set_names
    before_validation :generate_seo

  end

  %w(name title desc anons meta_title meta_desc meta_keys).each do |meth|
    define_method meth do
      read_attribute("#{meth}_#{I18n.locale}")
    end
  end

  private

  def generate_seo
    self.seo_name = self.name.russian_translit  if self.respond_to?(:seo_name) && !self.name.nil? && self.seo_name.nil?
    self.seo_name = self.title.russian_translit if self.respond_to?(:seo_name) && !self.title.nil? && self.seo_name.nil?
  end

  def set_names
    name_string = false
    I18n.available_locales.each do |l|
      name_string = self.send(:"name_#{l}")  if self.respond_to?(:"name_#{l}") && !self.send(:"name_#{l}").nil?
      name_string = self.send(:"title_#{l}") if self.respond_to?(:"title_#{l}")   && !self.send(:"title_#{l}").nil?
    end
    I18n.available_locales.each do |l|
      self.send(:"name_#{l}=",name_string)  if name_string && self.respond_to?(:"name_#{l}") && self.send(:"name_#{l}").nil?
      self.send(:"title_#{l}=",name_string) if name_string && self.respond_to?(:"title_#{l}")  && self.send(:"title_#{l}").nil?
    end
  end
end
