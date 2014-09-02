require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'open-uri'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Terrepets
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
  end

  Random = Random.new

  class TRandom
    def initialize
      generate
    end

    def rand
      if @index >= @numbers.length
        generate
      end
      number = @numbers[@index]
      @index += 1
      number
    end

    def rand_range(min, max)
      length = max - min + 1
      number = rand
      index = ((number*length)/100.0).ceil
      result = min + (index - 1)
      result
    end

    def generate
      url = "http://www.random.org/integers?col=1&min=0&max=100&base=10&num=100&format=plain"
      uri = URI.parse(url)
      response = uri.read
      @numbers = response.split.map{ |i| i.to_i }
      @index = 0
    rescue OpenURI::HTTPError => e
      $stderr.puts "Cannot reach random.org for random numbers.  Using pseudo-random numbers."
      @numbers = (1..30).map { Random.rand(1..100) }
      @index = 0
    end
  end

  TrueRandom = TRandom.new
end
