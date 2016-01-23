module ActionView
  module Helpers
    module TranslationHelper
      def t(*a)           # I don't care what params go in
        key = a.first     # just want to override behaviour based on the key

        #if my overrides contain the key
        if value = Translation.get["#{key}"]
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
      return value # return the overrided value
    end

    translate(*a) # otherwise letting i18n do its thing
  end
end
