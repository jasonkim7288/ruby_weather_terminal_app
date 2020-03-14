require 'singleton'
require 'rest-client'

class RestAccuweatherService
    include Singleton

    def initialize
        @accuweather_key = File.read("../res/accuweather_key.db")
    end

    def self._load(str)
        instance.keep = Marshal.load(str)
        instance
    end

    def get_location(location)
        str_get = "http://dataservice.accuweather.com/locations/v1/search?apikey=#{@accuweather_key}&q=#{location}"
        return  RestClient.get(str_get)
    end

    def get_weather_info(location_key)
        str_get = "http://dataservice.accuweather.com/forecasts/v1/daily/5day/#{location_key}?apikey=#{@accuweather_key}"
        return RestClient.get(str_get)
    end
end
