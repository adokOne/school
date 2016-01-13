module B1Admin
  module ApplicationHelper
  	def namespace
  		"admin" #request.fullpath.split("/").reject(&:empty?).first
  	end
    def url path
      path = path.to_s
      lang_url = I18n.default_locale == I18n.locale ? ["",namespace] : ["",I18n.locale,namespace]

      path = (lang_url + path.split("/").reject(&:empty?)).reject(&:empty?).join("/")

      path.empty? ? "/" : "/#{path}"
    end

    def user_can? method_name
       return true
      cls = params[:controller].split("/")
      cls.shift
      current_admin.has_access?(cls,method_name)
    end

    def parent_modules id
      B1Admin::Module.where(parent_id:0).where.not(id:id)
    end


    def main_app
      Rails.application.class.routes.url_helpers
    end

    def create_hours(parameters)
      start_time = parameters[:start_time] ? parameters[:start_time] : 0
      end_time = parameters[:end_time] ? parameters[:end_time] : 24.hours
      increment = parameters[:increment] ? parameters[:increment] : 30.minutes
      Array.new(1 + (end_time - start_time)/increment) do |i|
        (Time.now.midnight + (i*increment) + start_time).to_formatted_s(:time)
      end
    end

    # def method_missing method, *args, &block
    #   puts "LOOKING FOR ROUTES #{method}"
    #   if method.to_s.end_with?('_path') or method.to_s.end_with?('_url')
    #     if main_app.respond_to?(method)
    #       [::B1Config.get_const.admin_namespase,main_app.send(method, *args)].join
    #     else
    #       super
    #     end
    #   else
    #     super
    #   end
    # end

  end
end
