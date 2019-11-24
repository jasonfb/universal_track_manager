require "spec_helper"

describe AbcController, :type => :controller do
  describe "GET index" do
    it "tracks the visitor" do
      get :index

      last_visit = UniversalTrackManager::Visit.last

      last_visit_id = last_visit.id
      assert_equal @controller.session['visit_it'], 0
    end
  end
end