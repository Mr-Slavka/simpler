require 'logger'

class AppLogger

  def initialize(app, **options)
    @logger = Logger.new(options[:logdev] || STDOUT)
    @app = app
  end

  def call(env)
    status, headers, response = @app.call(env)
    @logger.info(message(status, headers, env))
    [status, headers, response]
  end

  def message(status, headers, env)
    if env['simpler.controller']
      "\nRequest: #{env['REQUEST_METHOD']} #{env['REQUEST_URI']}\n" \
      "Handler: #{env['simpler.controller'].class}##{env['simpler.action']}\n" \
      "Parameters: #{env['simpler.params']}\n" \
      "Response: #{status} [#{headers['Content-Type']}] #{env['simpler.template_path']}\n" \
    else
      "\nRequest: #{env['REQUEST_METHOD']} #{env['REQUEST_URI']}\n" \
    end
  end
end
