require 'tty-prompt'
require_relative '../lib/location_manager'
require_relative '../lib/accuweather_constant'

module ScreenControl
    @@prompt = TTY::Prompt.new

    def ask_area(location_manager)
        print AccuweatherConstant::STR_ASK_CITY
        area = gets.chomp
        return location_manager.get_location_list(area)
    end

    def ask_choose_area(location_manager, location_list)
        return @@prompt.select(AccuweatherConstant::STR_ASK_SELECT_CITY) do |menu|
            count = 1
            for location in location_list do
                str_location = location_manager.location_to_string(location)
                menu.choice(str_location, count)
                count += 1
            end
            menu.choice("None of those", count)
        end
    end
end
