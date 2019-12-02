require "spec_helper"

describe AbcController, :type => :controller do
  describe "GET index" do
    before(:each) do
      request.remote_addr = '1.2.3.4'
      request.user_agent = 'Fake Browser'
    end


    describe "new visit behavior" do
      it "tracks the visitor and creates a visit" do
        get :index
        last_visit = UniversalTrackManager::Visit.last

        last_visit_id = last_visit.id
        expect(@controller.session[:visit_id]).to eq(last_visit_id)
      end

      it "tracks the visitor and sets the IP address" do
        get :index
        last_visit = UniversalTrackManager::Visit.last

        expect(last_visit.ip_v4_address).to eq('1.2.3.4')
      end

      it "tracks the visitor and sets the user agent" do
        get :index
        last_visit = UniversalTrackManager::Visit.last
        browser = last_visit.browser
        expect(browser.browser_name).to eq('Fake Browser')
      end

      # it "tracks the visitor and picks up any UTMs if passed" do
      #   pending
      #   get :index
      #
      #   last_visit = UniversalTrackManager::Visit.last
      # end
    end

    describe "existing visit behavior" do

      it "should re-attach an existing visit if the IP matches" do

      end

     it "should evict an existing visit if the IP address doesn't match" do

     end
    end
  end
end