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

      it "tracks the visitor and picks up any UTMs if passed" do
        get :index, params: {utm_campaign: "abc",
                             utm_medium: "def",
                             utm_source: "ghi",
                             utm_term: "jkl",
                             utm_content: "mno"}


        last_visit = UniversalTrackManager::Visit.last

        campaign = last_visit.campaign

        expect(campaign.utm_campaign).to eq("abc")
        expect(campaign.utm_medium).to eq("def")
        expect(campaign.utm_source).to eq("ghi")
        expect(campaign.utm_term).to eq("jkl")
        expect(campaign.utm_content).to eq("mno")
      end
    end

    describe "existing visit behavior: " do
      describe "the ip address" do
        xit "should re-attach an existing visit if the IP matches" do

        end

        xit "should evict an existing visit if the IP address does not match" do

        end
      end

      describe "the user agent" do
        xit "should re-attach the existing visit if the user agent matches" do

        end

        xit "should evict the existing visit if the user agent does not match" do

        end
      end

      describe "the UTM parameters" do
        xit "should keep the existing visit if no UTM parameters are passed whatseover" do

        end

        xit "should keep the existing visit if the UTM parameters match the first visit" do

        end

        xit "should evict the visit if there are any new UTM parameters" do

        end
      end
    end
  end
end