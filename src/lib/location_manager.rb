require 'json'
require 'fileutils'

require_relative 'rest_accuweather'

class LocationManager
    attr_reader :count_hash
    def initialize
        @file_name_location_list = "../res/location_list.json"
        @location_list = {}
        # load_location_list_from_file

        # if !File.exist?(@file_name_app_property)
        #     @count_hash = {count: 0}
        #     File.write(@file_name_app_property, JSON.generate(@count_hash), mode: 'w')
        # else
        #     @count_hash = JSON.parse(File.read(@file_name_app_property))
        # end
    end

    def load_location_list_from_file
        JSON.parse(File.read(@file_name_location_list)).each do |key, value|
            @location_list.push(value)
        end
    end

    def add_location(location)
        # response = RestAccuweather.instance.get_location(location)
        # if response.code ==200
        if true
            temp = '[{"Version":1,"Key":"13854","Type":"City","Rank":65,"LocalizedName":"Toowong","EnglishName":"Toowong","PrimaryPostalCode":"","Region":{"ID":"OCN","LocalizedName":"Oceania","EnglishName":"Oceania"},"Country":{"ID":"AU","LocalizedName":"Australia","EnglishName":"Australia"},"AdministrativeArea":{"ID":"QLD","LocalizedName":"Queensland","EnglishName":"Queensland","Level":1,"LocalizedType":"State","EnglishType":"State","CountryID":"AU"},"TimeZone":{"Code":"AEST","Name":"Australia/Brisbane","GmtOffset":10.0,"IsDaylightSaving":false,"NextOffsetChange":null},"GeoPosition":{"Latitude":-27.483,"Longitude":152.983,"Elevation":{"Metric":{"Value":41.0,"Unit":"m","UnitType":5},"Imperial":{"Value":134.0,"Unit":"ft","UnitType":0}}},"IsAlias":false,"ParentCity":{"Key":"24741","LocalizedName":"Brisbane","EnglishName":"Brisbane"},"SupplementalAdminAreas":[],"DataSets":["AirQualityCurrentConditions","AirQualityForecasts","Alerts","MinuteCast","Radar"]}]'
            my_hash = JSON.parse(temp)
            p my_hash[0]["Type"], my_hash[0]["LocalizedName"]
            location_list_length = @location_list.length
            # @location_list[location_list_length] = 
            # put response.body
        end

        return false
    end
end

a = LocationManager.new
a.add_location("Indooroopilly")