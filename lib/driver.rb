require 'pry'
require 'csv'

module Rideshare
  class Driver
    attr_reader :driver_id, :vin, :name

    def initialize(args)
      super


      @driver_id = args[:driver_id]
      @vin = args[:vin]
      @name = args[:name]
    end

    private

    def proof_data

      raise ArgumentError.new("Warning: bad VIN: #{args[:vin]}; Driver #{args[:driver_id]} data not included ") if args[:vin].length != 17

      raise ArgumentError.new("Warning: Bad driver ID: must be a number, but was reported as #{args[:driver_id]} data not included ") unless (args[:driver_id].is_a? Integer) && (args[:driver_id] > 0 )

      raise ArgumentError.new("Warning: Driver name not reported") unless (args[:name].is_a? String) && (args.length > 0)
    end

    # returns a collection of Driver instances, representing all of the drivers described in drivers.csv
    def self.all(csv_filename)
      #formats numbers properly
      CSV.read(csv_filename)[1..-1].map do |row|
        args = { driver_id: row[0].to_i, vin: row[2], name: row[1] }
        begin
          self.new(args)
        rescue
          # if I had time, I would make class ErrorLogger to write the errors to a csv file
        end
      end
    end

    def self.find_driver(csv_filename, id_to_find)
      fail = proc {
        raise ArgumentError.new("There is no driver with id #{id_to_find}.")
      }
      self.all(csv_filename).find(fail) do |driver|
        driver.driver_id == id_to_find
      end
    end
  end
end
