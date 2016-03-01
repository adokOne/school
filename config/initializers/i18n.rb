module ActionView
  module Helpers
    module TranslationHelper
      def t(*a)           # I don't care what params go in
        key = a.first     # just want to override behaviour based on the key

        #if my overrides contain the key
        if value = Translation.get["#{key}"]
          if a[1].kind_of?(Hash)
            value = value.dup
            a[1].each_pair do |k,v|
              value.to_s.gsub!("%{#{k.to_s}}", v.to_s)
            end
          end
          return value # return the overrided value
        end

        translate(*a) # otherwise letting i18n do its thing
      end
    end
  end
end



module I18n
  def self.t(*a)           # I don't care what params go in
    key = a.first     # just want to override behaviour based on the key
    #if my overrides contain the key
    if value = Translation.get["#{key}"]
      if a[1].kind_of?(Hash)
        value = value.dup
        a[1].each_pair do |k,v|
          value.dup.to_s.gsub!("%{#{k.to_s}}", v.to_s)
        end
      end

      return value # return the overrided value
    end

    translate(*a) # otherwise letting i18n do its thing
  end
end
