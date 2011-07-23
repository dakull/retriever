module CustomLogger
  def log_error( error_body = "none" ) 
    open('errors.log', 'a') do |log|
      error = {
                :timestamp  =>  Time.now,
                :message    =>  error_body,
              }
      YAML.dump(error, log)      
    end
  end
end
