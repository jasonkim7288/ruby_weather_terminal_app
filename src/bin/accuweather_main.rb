require_relative 'screen_control'
require_relative '../lib/location_manager'
require_relative '../lib/weather_manager'

include ScreenControl

location_manager = LocationManager.new
weather_manager = WeatherManager.new

loop do
    system("clear")
    puts ScreenControl.welcome_message
    selected_city = ScreenControl.ask_select_city(location_manager)
    end_index_selected_city = location_manager.location_list.length
    begin
        case selected_city
        when end_index_selected_city # Add a new city
            location_list = ScreenControl.ask_new_city(location_manager)
            if location_list != []
                selected_candidate_city_index = ScreenControl.ask_choose_area(location_list)
                if selected_candidate_city_index != location_list.length
                    location_manager.add(location_list[selected_candidate_city_index])
                    weather_manager.request_weather_info(location_list[selected_candidate_city_index])
                    puts weather_manager.to_table_string
                    ScreenControl.tts_run(weather_manager.to_tts_string)
                    ScreenControl.press_any_key
                end
            else
                ScreenControl.show_invalid_city
            end
        when end_index_selected_city + 1 # Delete a city
            puts "Here"
            gets
            selected_del_city_index = ScreenControl.ask_delete_city(location_manager)
            if selected_del_city_index != -1
                location_manager.delete(selected_del_city_index)
                show_deleted
            end
        when end_index_selected_city + 2 # Exit
            exit
        else # Select existing city
            location = location_manager.location_list[selected_city]
            weather_manager.request_weather_info(location)
            puts weather_manager.to_table_string
            ScreenControl.tts_run(weather_manager.to_tts_string)
            ScreenControl.press_any_key
        end
    rescue RestClient::ServiceUnavailable
        ScreenControl.show_service_unavailable
    end
end