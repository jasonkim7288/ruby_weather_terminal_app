require 'singleton'
require 'rest-client'

class RestAccuweather
    include Singleton

    def initialize
        # @accuweather_key = File.read("../res/accuweather_key.db")
        @accuweather_key = "A91us5Ma0sfbbrVA8SVYBGVpS5ryg156"
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
        p str_get
        return RestClient.get(str_get)
    end
end

# rest = RestAccuweather.instance
# p rest.get_location("Hamilton")