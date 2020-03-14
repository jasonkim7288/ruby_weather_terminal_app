require_relative 'screen_control'
require_relative '../lib/location_manager'

include ScreenControl

location_manager = LocationManager.new

loop do
    location_list = ScreenControl.ask_area(location_manager)
    if location_list != []
        selected_num = ScreenControl.ask_choose_area(location_manager, location_list) - 1
        if selected_num != location_list.length
            location_manager.add(location_list[selected_num])
            puts "You chose #{location_manager.location_to_string(location_list[selected_num])}, #{location_list[selected_num]["Latitude"]}, #{location_list[selected_num]["Longitude"]}"
        end
    end
end