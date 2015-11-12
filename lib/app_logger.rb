class AppLogger

  class << self
    %w(exception success warninig error).each do |meth|
      define_method(meth) { |system,action,body,session_id=nil|
        session_id = session_id.nil? ? $session_id : session_id
        row = {
          status: SystemLog::STATUS[meth.to_sym],
          time: Time.now.to_i,
          session_id: $session_id,
          description: {
              body: SystemLogFile.encode(body.to_s),
              compress: true
          },
          log_system: SystemLog::SYSTEM[system.to_sym] ,
          action: action
        }
        SystemLog.activity( row )
      }
    end
  end

end
