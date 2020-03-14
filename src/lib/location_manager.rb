require 'json'
require 'fileutils'

require_relative 'rest_accuweather'

class LocationManager
    attr_reader :count_hash, :location_list
    def initialize
        @file_name_location_list = "../res/location_list.json"
        @location_list = []
        load_location_list_from_file
    end

    def load_location_list_from_file
        @location_list = JSON.parse(File.read(@file_name_location_list))
    end

    def get_location_list(location)
        result_array = []
        # response = RestAccuweather.instance.get_location(location)    
        # if response.code == 200
        #     response_body_array = JSON.parse(response.body)
        temp = '[{"Version":1,"Key":"55490","Type":"City","Rank":35,"LocalizedName":"Hamilton","EnglishName":"Hamilton","PrimaryPostalCode":"L8P","Region":{"ID":"NAM","LocalizedName":"North America","EnglishName":"North America"},"Country":{"ID":"CA","LocalizedName":"Canada","EnglishName":"Canada"},"AdministrativeArea":{"ID":"ON","LocalizedName":"Ontario","EnglishName":"Ontario","Level":1,"LocalizedType":"Province","EnglishType":"Province","CountryID":"CA"},"TimeZone":{"Code":"EDT","Name":"America/Toronto","GmtOffset":-4.0,"IsDaylightSaving":true,"NextOffsetChange":"2020-11-01T06:00:00Z"},"GeoPosition":{"Latitude":43.254,"Longitude":-79.876,"Elevation":{"Metric":{"Value":96.0,"Unit":"m","UnitType":5},"Imperial":{"Value":314.0,"Unit":"ft","UnitType":0}}},"IsAlias":false,"SupplementalAdminAreas":[{"Level":2,"LocalizedName":"Hamilton","EnglishName":"Hamilton"}],"DataSets":["AirQualityCurrentConditions","AirQualityForecasts","Alerts","ForecastConfidence","MinuteCast","Radar"]},{"Version":1,"Key":"256405","Type":"City","Rank":41,"LocalizedName":"Hamilton","EnglishName":"Hamilton","PrimaryPostalCode":"","Region":{"ID":"OCN","LocalizedName":"Oceania","EnglishName":"Oceania"},"Country":{"ID":"NZ","LocalizedName":"New Zealand","EnglishName":"New Zealand"},"AdministrativeArea":{"ID":"WKO","LocalizedName":"Waikato","EnglishName":"Waikato","Level":1,"LocalizedType":"Region","EnglishType":"Region","CountryID":"NZ"},"TimeZone":{"Code":"NZDT","Name":"Pacific/Auckland","GmtOffset":13.0,"IsDaylightSaving":true,"NextOffsetChange":"2020-04-04T14:00:00Z"},"GeoPosition":{"Latitude":-37.785,"Longitude":175.281,"Elevation":{"Metric":{"Value":27.0,"Unit":"m","UnitType":5},"Imperial":{"Value":88.0,"Unit":"ft","UnitType":0}}},"IsAlias":false,"SupplementalAdminAreas":[{"Level":2,"LocalizedName":"Hamilton City","EnglishName":"Hamilton City"}],"DataSets":["AirQualityCurrentConditions","AirQualityForecasts","Alerts"]}]'
        if true
            response_body_array = JSON.parse(temp)
            for response_body in response_body_array do
                temp_hash = {}
                next if !response_body.key?("Key")
                temp_hash["Key"] = response_body["Key"]
                next if !response_body.key?("EnglishName")
                temp_hash["City"] = response_body["EnglishName"]
                next if !response_body.key?("AdministrativeArea") || !response_body["AdministrativeArea"].key?("EnglishName")
                temp_hash["AdministrativeArea"] = response_body["AdministrativeArea"]["EnglishName"]
                next if !response_body.key?("Country") || !response_body["Country"].key?("EnglishName")
                temp_hash["Country"] = response_body["Country"]["EnglishName"]
                next if !response_body.key?("GeoPosition") || !response_body["GeoPosition"].key?("Latitude") || !response_body["GeoPosition"].key?("Longitude")
                temp_hash["Latitude"], temp_hash["Longitude"] = response_body["GeoPosition"]["Latitude"], response_body["GeoPosition"]["Longitude"]
                result_array.push(temp_hash)
            end
        end

        return result_array
    end
    
    def self.location_to_string(location_hash)
        return "#{location_hash["City"]}, #{location_hash["AdministrativeArea"]}, #{location_hash["Country"]}"
    end

    def add(location_hash)
        @location_list.push(location_hash) if !@location_list.include?(location_hash)
        File.write(@file_name_location_list, JSON.generate(@location_list), mode: 'w')
    end

    def delete(location_index)
        @location_list.delete_at(location_index)
        File.write(@file_name_location_list, JSON.generate(@location_list), mode: 'w')
    end
end

