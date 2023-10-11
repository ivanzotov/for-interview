module Surveymonkey
  class Mapping
    CACHE = {}

    attr_reader :schemes

    def self.find_by(name:)
      return CACHE[name] unless CACHE[name].blank?

      path = path_by_name(name)
      return unless path

      CACHE[name] = Mapping.from_json(File.read(path))
    end

    def self.path_by_name(name)
      Dir["#{__dir__}/schemes/*"].find { |it| File.basename(it, ".json") == name }
    end

    def self.from_json(json)
      schemes_json = JSON.parse(json, symbolize_names: true)
      schemes = schemes_json.map { |it| Scheme.new(it) }
      Mapping.new(schemes)
    end

    def initialize(schemes)
      @schemes = schemes
    end
  end
end