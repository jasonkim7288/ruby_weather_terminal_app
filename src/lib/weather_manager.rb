require 'tty-table'

require_relative 'rest_accuweather'
require_relative 'location_manager'
require_relative 'accuweather_constant'

class WeatherManager
    def initialize
        @location = {}
        @weather_daily = []
        @headline
    end

    def request_weather_info(location)
        @location = location        
        @weather_daily = []
        # response = RestAccuweather.instance.get_weather_info(location["Key"])
        # if response.code == 200
        #     response_body = JSON.parse(response.body)
        temp = '{"Headline":{"EffectiveDate":"2020-03-14T08:00:00+13:00","EffectiveEpochDate":1584126000,"Severity":4,"Text":"Air quality will be unhealthy for sensitive groups Tuesday morning through Wednesday morning.","Category":"","EndDate":null,"EndEpochDate":null,"MobileLink":"http://m.accuweather.com/en/nz/hamilton/256405/extended-weather-forecast/256405?lang=en-us","Link":"http://www.accuweather.com/en/nz/hamilton/256405/daily-weather-forecast/256405?lang=en-us"},"DailyForecasts":[{"Date":"2020-03-14T07:00:00+13:00","EpochDate":1584122400,"Temperature":{"Minimum":{"Value":49.0,"Unit":"F","UnitType":18},"Maximum":{"Value":78.0,"Unit":"F","UnitType":18}},"Day":{"Icon":2,"IconPhrase":"Mostly sunny","HasPrecipitation":false},"Night":{"Icon":34,"IconPhrase":"Mostly clear","HasPrecipitation":false},"Sources":["AccuWeather"],"MobileLink":"http://m.accuweather.com/en/nz/hamilton/256405/daily-weather-forecast/256405?day=1&lang=en-us","Link":"http://www.accuweather.com/en/nz/hamilton/256405/daily-weather-forecast/256405?day=1&lang=en-us"},{"Date":"2020-03-15T07:00:00+13:00","EpochDate":1584208800,"Temperature":{"Minimum":{"Value":49.0,"Unit":"F","UnitType":18},"Maximum":{"Value":80.0,"Unit":"F","UnitType":18}},"Day":{"Icon":1,"IconPhrase":"Sunny","HasPrecipitation":false},"Night":{"Icon":38,"IconPhrase":"Mostly cloudy","HasPrecipitation":false},"Sources":["AccuWeather"],"MobileLink":"http://m.accuweather.com/en/nz/hamilton/256405/daily-weather-forecast/256405?day=2&lang=en-us","Link":"http://www.accuweather.com/en/nz/hamilton/256405/daily-weather-forecast/256405?day=2&lang=en-us"},{"Date":"2020-03-16T07:00:00+13:00","EpochDate":1584295200,"Temperature":{"Minimum":{"Value":59.0,"Unit":"F","UnitType":18},"Maximum":{"Value":76.0,"Unit":"F","UnitType":18}},"Day":{"Icon":4,"IconPhrase":"Intermittent clouds","HasPrecipitation":false},"Night":{"Icon":38,"IconPhrase":"Mostly cloudy","HasPrecipitation":false},"Sources":["AccuWeather"],"MobileLink":"http://m.accuweather.com/en/nz/hamilton/256405/daily-weather-forecast/256405?day=3&lang=en-us","Link":"http://www.accuweather.com/en/nz/hamilton/256405/daily-weather-forecast/256405?day=3&lang=en-us"},{"Date":"2020-03-17T07:00:00+13:00","EpochDate":1584381600,"Temperature":{"Minimum":{"Value":44.0,"Unit":"F","UnitType":18},"Maximum":{"Value":70.0,"Unit":"F","UnitType":18}},"Day":{"Icon":4,"IconPhrase":"Intermittent clouds","HasPrecipitation":false},"Night":{"Icon":35,"IconPhrase":"Partly cloudy","HasPrecipitation":false},"Sources":["AccuWeather"],"MobileLink":"http://m.accuweather.com/en/nz/hamilton/256405/daily-weather-forecast/256405?day=4&lang=en-us","Link":"http://www.accuweather.com/en/nz/hamilton/256405/daily-weather-forecast/256405?day=4&lang=en-us"},{"Date":"2020-03-18T07:00:00+13:00","EpochDate":1584468000,"Temperature":{"Minimum":{"Value":43.0,"Unit":"F","UnitType":18},"Maximum":{"Value":73.0,"Unit":"F","UnitType":18}},"Day":{"Icon":4,"IconPhrase":"Intermittent clouds","HasPrecipitation":false},"Night":{"Icon":35,"IconPhrase":"Partly cloudy","HasPrecipitation":false},"Sources":["AccuWeather"],"MobileLink":"http://m.accuweather.com/en/nz/hamilton/256405/daily-weather-forecast/256405?day=5&lang=en-us","Link":"http://www.accuweather.com/en/nz/hamilton/256405/daily-weather-forecast/256405?day=5&lang=en-us"}]}'
        if true
            response_body = JSON.parse(temp)
            return [] if !response_body.key?("Headline") || !response_body["Headline"].key?("Text")
            @headline = response_body["Headline"]["Text"]
            return [] if !response_body.key?("DailyForecasts")
            daily_forecast_list = response_body["DailyForecasts"]
            for daily_forecast in daily_forecast_list do
                temp_hash = {}
                next if !daily_forecast.key?("Date")
                temp_hash["Date"] = DateTime.parse(daily_forecast["Date"]).to_date.to_s
                next if !daily_forecast.key?("Temperature") || !daily_forecast["Temperature"].key?("Minimum")
                next if !daily_forecast["Temperature"]["Minimum"].key?("Value")
                temp_hash["MinValue"] = daily_forecast["Temperature"]["Minimum"]["Value"]
                next if !daily_forecast["Temperature"]["Minimum"].key?("Unit")
                temp_hash["MinUnit"] = daily_forecast["Temperature"]["Minimum"]["Unit"]
                temp_hash["MinValue"] = change_fahrenheit_to_celsius(temp_hash["MinValue"], temp_hash["MinUnit"])
                temp_hash["MinUnit"] = "C"
                next if !daily_forecast.key?("Temperature") || !daily_forecast["Temperature"].key?("Maximum")
                next if !daily_forecast["Temperature"]["Maximum"].key?("Value")
                temp_hash["MaxValue"] = daily_forecast["Temperature"]["Maximum"]["Value"]
                next if !daily_forecast["Temperature"]["Maximum"].key?("Unit")
                temp_hash["MaxUnit"] = daily_forecast["Temperature"]["Maximum"]["Unit"]
                temp_hash["MaxValue"] = change_fahrenheit_to_celsius(temp_hash["MaxValue"], temp_hash["MaxUnit"])
                temp_hash["MaxUnit"] = "C"
                next if !daily_forecast.key?("Day") || !daily_forecast["Day"].key?("IconPhrase")
                temp_hash["DayCondition"] = daily_forecast["Day"]["IconPhrase"]
                next if !daily_forecast.key?("Night") || !daily_forecast["Night"].key?("IconPhrase")
                temp_hash["NightCondition"] = daily_forecast["Night"]["IconPhrase"]
                @weather_daily.push(temp_hash)
            end
        end

        return @weather_daily
    end

    def to_string
        result_string = "Weather in #{@location["City"]}\n"
        for weather in @weather_daily do
            result_string += "Date: #{weather["Date"]}\n"
            result_string += "Min : #{change_fahrenheit_to_celsius(weather["MinValue"], weather["MinUnit"])}°C\n"
            result_string += "Max : #{change_fahrenheit_to_celsius(weather["MaxValue"], weather["MaxUnit"])}°C\n"
            result_string += "Day : #{weather["DayCondition"]}\n"
            result_string += "Night : #{weather["NightCondition"]}\n"
        end
        return result_string
    end

    def to_each_weather_string(index)
        result_string = "Min : #{change_fahrenheit_to_celsius(@weather_daily[index]["MinValue"], @weather_daily[index]["MinUnit"])}\n"
        result_string += "Max : #{change_fahrenheit_to_celsius(@weather_daily[index]["MaxValue"], @weather_daily[index]["MaxUnit"])}\n"
        result_string += "Day : #{@weather_daily[index]["DayCondition"]}\n"
        result_string += "Night : #{@weather_daily[index]["NightCondition"]}\n"
        return result_string
    end

    def to_tts_string
        result_string = "Welcome to Jason's Weather forecast. Now, let’s see what the weather is like today in #{@location["City"]}. "
        result_string += "#{@headline}. "
        result_string += "Today, temperature is (#{@weather_daily[0]["MinValue"]}) degree to (#{@weather_daily[0]["MaxValue"]}) degree. "
        result_string += "It will be #{@weather_daily[0]["DayCondition"]} for most of the day. "
        result_string += "And #{@weather_daily[0]["NightCondition"]} in the evening. "
        result_string += "Tomorrow, temperature is (#{@weather_daily[1]["MinValue"]}) degree to (#{@weather_daily[1]["MaxValue"]}) degree. "
        result_string += "It will be #{@weather_daily[1]["DayCondition"]} for most of the day. "
        result_string += "And #{@weather_daily[1]["NightCondition"]} in the evening. "
        return result_string
    end

    def to_table_string
        table_addr = TTY::Table.new [{value: "[ #{LocationManager.location_to_string(@location)} ]", alignment: :center}], [['']]
        addr_string = "\n" + table_addr.render(:basic, multiline: true, column_widths: [AccuweatherConstant::COLUMN_SIZE * 5 + 10]) + "\n"

        table = TTY::Table.new
        table << [{value: "#{@weather_daily[0]["Date"]}", alignment: :center}, {value: "#{@weather_daily[1]["Date"]}", alignment: :center},
                    {value: "#{@weather_daily[2]["Date"]}", alignment: :center}, {value: "#{@weather_daily[3]["Date"]}", alignment: :center},
                    {value: "#{@weather_daily[4]["Date"]}", alignment: :center}]
        table << ["#{to_each_weather_string(0)}", "#{to_each_weather_string(1)}", "#{to_each_weather_string(2)}", "#{to_each_weather_string(3)}", "#{to_each_weather_string(4)}"]
        weather_string = table.render(:unicode, column_widths: [AccuweatherConstant::COLUMN_SIZE, AccuweatherConstant::COLUMN_SIZE, AccuweatherConstant::COLUMN_SIZE, AccuweatherConstant::COLUMN_SIZE,AccuweatherConstant::COLUMN_SIZE],
                            multiline: true, padding: [0, 1]) do |renderer|
            renderer.border.separator = :each_row
        end

        return addr_string + weather_string
    end

    def change_fahrenheit_to_celsius(temp, str_type)
        return str_type == "F" ?  ((temp - 32) * 5 / 9).round(1) : temp.round(1)
    end

end