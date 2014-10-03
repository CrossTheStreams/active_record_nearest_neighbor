require 'spec_helper'

describe ActiveRecordNearestNeighbor do

  let(:lat) { REF_LAT }
  let(:lng) { REF_LNG }
  let(:distance) { 1000 }

  subject do
    Point
  end
 
  before do
    ensure_test_data!
  end

  after do
    purge_test_data! 
  end

  describe "::bounding_box_close_to" do    
    it "finds returns points that are params[:distance].to_i away from a location" do
      expect(subject.bounding_box_close_to(longitude: lng, latitude: lat, distance: distance).length).to eq(9)
    end
  end

  describe "::k_nearest_neighbor_close_to" do
    it "returns points, in order of proximity to a location" do
      expect(subject.k_nearest_neighbor_close_to(longitude: lng, latitude: lat, distance: distance).length).to eq(9) 
    end
  end

  describe "::close_to" do
    it "defaults to using the ::bounding_box_close_to scope" do
      expect(subject).to receive(:bounding_box_close_to) 
      subject.close_to(lng, lat, distance:  distance)
    end
    context "when given the k_nearest_neighbor method option" do
      it "uses the k_nearest_neighbor_close_to scope" do
        expect(subject).to receive(:k_nearest_neighbor_close_to) 
        subject.close_to(lng, lat, {distance:  distance, method: :k_nearest_neighbor})
      end
    end
  end

end
