require 'tty-font'
require 'tty-prompt'
require 'colorize'
require 'tty-table'
require_relative '../lib/location_manager'
require_relative '../lib/accuweather_constant'

module ScreenControl
    @@prompt = TTY::Prompt.new
    @@font_standard = TTY::Font.new(:doom)

    def welcome_message
        return (@@font_standard.write("AccuWeather", letter_spacing: 4)).colorize(:blue) + " by Jason"
    end

    def ask_select_city(location_manager)
        return @@prompt.select(AccuweatherConstant::STR_ASK_CITY) do |menu|
            count = 0
            for location in location_manager.location_list do
                str_location = LocationManager.location_to_string(location)
                menu.choice(str_location, count)
                count += 1
            end
            menu.choice("Add a new city", count)
            menu.choice("Delete a city", count + 1)
            menu.choice("Exit", count + 2)
        end
    end

    def ask_delete_city(location_manager)
        return @@prompt.select(AccuweatherConstant::STR_ASK_DELETE_CITY) do |menu|
            count = 0
            for location in location_manager.location_list do
                str_location = LocationManager.location_to_string(location)
                menu.choice(str_location, count)
                count += 1
            end
            menu.choice("Cancel", -1)
        end
    end

    def ask_new_city(location_manager)
        print AccuweatherConstant::STR_ASK_CITY
        area = gets.chomp
        return location_manager.get_location_list(area)
    end

    def ask_choose_area(location_list)
        return @@prompt.select(AccuweatherConstant::STR_ASK_SELECT_CITY) do |menu|
            count = 0
            for location in location_list do
                str_location = LocationManager.location_to_string(location)
                menu.choice(str_location, count)
                count += 1
            end
            menu.choice("None of those", count)
        end
    end

    def show_invalid_city
        puts "Invalid city!"
        press_any_key
    end

    def press_any_key
        @@prompt.keypress("\nPress any key to continue")
    end

    def show_deleted
        puts "Deleted!"
        press_any_key
    end

    def show_service_unavailable
        puts AccuweatherConstant::STR_SERVICE_UNAVAILABLE
        press_any_key
    end
end
