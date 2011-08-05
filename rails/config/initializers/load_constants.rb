NewsRack = {}

CONSTANTS_BASE_PATH = "#{RAILS_ROOT}/config/settings/"
module AppConstants
  def self.load_constants
    Dir.entries(CONSTANTS_BASE_PATH).reject{ |fn| fn =~ /^\./ }.each do |fn|
      NewsRack.update(YAML.load(File.read(CONSTANTS_BASE_PATH + fn)))
    end
  end
end

AppConstants::load_constants
