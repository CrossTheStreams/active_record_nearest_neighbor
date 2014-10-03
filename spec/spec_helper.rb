require 'pry'
require 'rails'
require 'active_record'
require_relative '../lib/active_record_nearest_neighbor'

ActiveRecord::Base.establish_connection(
  adapter:  'postgis',
  database: 'arnn_dummy_test',
  encoding: 'unicode',
  pool: 5,
  host:     'localhost'
)

class Point < ActiveRecord::Base
  include ActiveRecordNearestNeighbor
  before_save :set_lonlat!

  def set_lonlat!
    self.lonlat = "POINT(#{longitude} #{latitude})"
  end

end

TEST_COOR = [
  [-122.339801, 47.665127],
  [-122.347054, 47.665127],
  [-122.347183, 47.661254],
  [-122.339286, 47.661485],
  [-122.331991, 47.661456],
  [-122.331991, 47.665502],
  [-122.332205, 47.670242],
  [-122.339715, 47.670329],
  [-122.347311, 47.670271]
]

REF_LAT = TEST_COOR[0][1]
REF_LNG = TEST_COOR[0][0]

TEST_DATA_COUNT = TEST_COOR.length
TEST_MODEL_CLASS = Point

def prepare_test_data!
  TEST_COOR.each do |coor|
    Point.create(latitude: coor[1], longitude: coor[0])
  end
end

def ensure_test_data! 
  prepare_test_data! unless test_data_ready?
end

def purge_test_data! 
  Point.delete_all
end

def test_data_ready? 
  Point.count == TEST_DATA_COUNT
end

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  # rspec-expectations config goes here. You can use an alternate
  # assertion/expectation library such as wrong or the stdlib/minitest
  # assertions if you prefer.
  config.expect_with :rspec do |expectations|
    # This option will default to `true` in RSpec 4. It makes the `description`
    # and `failure_message` of custom matchers include text for helper methods
    # defined using `chain`, e.g.:
    # be_bigger_than(2).and_smaller_than(4).description
    #   # => "be bigger than 2 and smaller than 4"
    # ...rather than:
    #   # => "be bigger than 2"
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.formatter = 'NyanCatWideFormatter'

  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended, and will default to
    # `true` in RSpec 4.
    mocks.verify_partial_doubles = true
  end

end
