require "spec_helper"

describe AbcController, :type => :controller do
  describe "GET index" do
    it "tracks the visitor and creates a visit" do
      get :index
      last_visit = UniversalTrackManager::Visit.last

      last_visit_id = last_visit.id

      assert_equal @controller.session[:visit_id], last_visit_id
    end


    it "tracks the visitor and sets the IP address" do
      get :index

      last_visit = UniversalTrackManager::Visit.last
    end

    it "tracks the visitor and sets the user agent" do
      get :index

      last_visit = UniversalTrackManager::Visit.last
    end

    it "tracks the visitor and picks up any UTMs if passed" do
      get :index

      last_visit = UniversalTrackManager::Visit.last
    end
  end
end