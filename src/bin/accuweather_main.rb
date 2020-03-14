require_relative 'screen_control'
require_relative '../lib/location_manager'
require_relative '../lib/weather_manager'

include ScreenControl

location_manager = LocationManager.new
weather_manager = WeatherManager.new

loop do
    location_list = ScreenControl.ask_area(location_manager)
    if location_list != []
        selected_num = ScreenControl.ask_choose_area(location_manager, location_list) - 1
        if selected_num != location_list.length
            location_manager.add(location_list[selected_num])
            weather_manager.request_weather_info(location_list[selected_num])
            puts weather_manager.to_string
        end
    end
end