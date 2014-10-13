require 'spec_helper'

describe ActiveRecord::Base::NearestNeighbor do

  let(:point) { Point.first }
  let(:all_points) { Point.all }
  let(:lat) { point.latitude }
  let(:lng) { point.longitude }
  let(:distance) { 2000 }
  let(:limit) { nil }
 
  before do
    ensure_test_data!
  end

  after do
    purge_test_data! 
  end

  shared_examples "orders query results by proximity" do
    it "returns points in the correct order" do
      (subject.length - 1).times do |i|
        next_point = (subject[i + 1])
        expect(subject[i].id).to be < next_point.id
      end
    end
  end

  shared_examples "excluding object parameter" do
    it "does not include the point with the id" do
      expect(subject).to_not include(point)
    end
  end

  shared_examples "calling the specified scope with params" do |scope_method|
    it "calls the scope method #{scope_method}" do
      expect(Point).to receive(scope_method).with(expected_params)
      subject
    end
  end

  shared_examples "returning all proximate points" do
    it "returns all points" do
      expect(subject.length).to eq(all_points.length)
    end 
  end

  shared_examples "includes expected points" do |expected_length|
    it "includes #{expected_length} points" do
      expect(subject.length).to eq(expected_length)
    end  
  end

  describe "::bounding_box_close_to" do

    subject do
      Point.bounding_box_close_to(longitude: lng, latitude: lat, distance: distance, limit: limit)
    end

    context "when bounding box includes all points" do
      include_examples "returning all proximate points"
    end

    context "when bounding box excludes points" do
      let(:distance) { 1000 }
      include_examples "includes expected points", 7 
    end

    context "when a limit of 5 is given" do
      let(:limit) { 5 }
      include_examples "includes expected points", 5
    end

    include_examples "orders query results by proximity"

    context "when an id is given" do
      subject do
        Point.bounding_box_close_to(longitude: lng, latitude: lat, distance: distance, id: point.id)
      end
      include_examples "excluding object parameter"
    end

  end

  describe "::k_nearest_neighbor_close_to" do
    subject do
      Point.k_nearest_neighbor_close_to(longitude: lng, latitude: lat, distance: distance, limit: limit)
    end

    include_examples "returning all proximate points"

    include_examples "orders query results by proximity"

    context "when a limit of 5 is given" do
      let(:limit) { 5 }
      include_examples "includes expected points", 5
    end

    context "when an id is given" do
      subject do
        Point.k_nearest_neighbor_close_to(longitude: lng, latitude: lat, id: point.id)
      end
      include_examples "excluding object parameter"
    end

  end

  describe "::close_to" do
    let(:expected_params) do
      {latitude: point.latitude, longitude: point.longitude, distance: distance, id: point.id, limit: limit}
    end

    context "when it receives an ActiveRecord object and options hash" do

      subject do
        Point.close_to(point, distance: distance)
      end

      include_examples "calling the specified scope with params", :bounding_box_close_to 

      context "when given the k_nearest_neighbor method option" do

        subject do
          Point.close_to(point, distance: distance, method: :k_nearest_neighbor)
        end

        include_examples "calling the specified scope with params", :k_nearest_neighbor_close_to

      end
    end

    context "when it receives latitude, longitude, options hash" do
      let(:expected_params) do
        {latitude: point.latitude, longitude: point.longitude, distance: distance, id: nil, limit: limit}
      end 

      subject do
        Point.close_to(lng, lat, distance:  distance)
      end

      include_examples "calling the specified scope with params", :bounding_box_close_to

      context "when given the k_nearest_neighbor method option" do
        subject do
          Point.close_to(lng, lat, distance:  distance, method: :k_nearest_neighbor)
        end
        include_examples "calling the specified scope with params", :k_nearest_neighbor_close_to
      end
    end

  end

end
