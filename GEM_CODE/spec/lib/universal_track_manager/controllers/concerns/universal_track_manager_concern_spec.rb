require "spec_helper"

describe AbcController, :type => :controller do
  describe "GET index" do
    it "tracks the visitor" do
      get :index

      # last_visit = UniversalTrackManager::Visit.last.id

      assert_equal @controller.session['visit_it'], 0
    end
  end
end