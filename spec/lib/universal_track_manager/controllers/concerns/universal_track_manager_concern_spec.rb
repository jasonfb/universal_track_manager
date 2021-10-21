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

      it "tracks the visitor and doesn't set the IP address if disabled" do
        UniversalTrackManager.configure do |config|
          config.track_ips = false
        end

        get :index
        last_visit = UniversalTrackManager::Visit.last

        expect(last_visit.ip_v4_address).to eq(nil)
      end

      it "tracks the visitor and sets the user agent" do
        get :index
        last_visit = UniversalTrackManager::Visit.last

        browser = last_visit.browser
        expect(browser.name).to eq('Fake Browser')
      end


      it "tracks the visitor and doesn't set the user agent if disabled" do
        UniversalTrackManager.configure do |config|
          config.track_user_agent = false
        end

        get :index
        last_visit = UniversalTrackManager::Visit.last
        browser = last_visit.browser
        expect(browser).to eq(nil)
      end

      it "sets the visit's first_pageload" do
        get :index

        last_visit = UniversalTrackManager::Visit.last
        expect(last_visit.first_pageload).to_not be(nil)
      end

      it "the visit's last_pageload will be nil" do
        get :index
        last_visit = UniversalTrackManager::Visit.last
        expect(last_visit.first_pageload).to_not be(nil)

        expect(last_visit.first_pageload).to eq(last_visit.last_pageload)
      end


      it "should have a count of 1" do
        get :index
        last_visit = UniversalTrackManager::Visit.last
        expect(last_visit.count).to eq(1)
      end
    end

    describe "existing visit behavior: " do
      describe "the ip address" do

        before(:each) do
          request.remote_addr = '1.2.3.4'
        end

        it "should re-attach an existing visit if the IP matches" do
          #1st attempt
          get :index
          first_visit = UniversalTrackManager::Visit.last


          #2nd attempt
          get :index
          last_visit = UniversalTrackManager::Visit.last

          expect(last_visit).to eq(first_visit)
        end

        it "should evict an existing visit if the IP address does not match" do
          get :index
          first_visit = UniversalTrackManager::Visit.last

          request.remote_addr = '5.6.7.8'

          #2nd attempt
          get :index
          last_visit = UniversalTrackManager::Visit.last
          expect(last_visit).to_not eq(first_visit)

        end

        it "should give the second visit the genesis of the first visit" do
          get :index
          first_visit = UniversalTrackManager::Visit.last

          request.remote_addr = '5.6.7.8'

          #2nd attempt
          get :index
          last_visit = UniversalTrackManager::Visit.last
          expect(last_visit.original_visit_id).to eq(first_visit.id)
        end

        it "should give the third visit the genesis of the first visit" do
          get :index
          first_visit = UniversalTrackManager::Visit.last

          request.remote_addr = '5.6.7.8'

          #2nd attempt
          get :index
          second_visit = UniversalTrackManager::Visit.last


          #3rd attempt
          get :index
          last_visit = UniversalTrackManager::Visit.last
          expect(last_visit.original_visit_id).to eq(first_visit.id)
          expect(second_visit.original_visit_id).to eq(first_visit.id)
        end
      end

      describe "the user agent" do
        before(:each) do
          request.user_agent = 'Fake Browser 1'
        end


        it "should re-attach the existing visit if the user agent matches" do
          #1st attempt
          get :index
          first_visit = UniversalTrackManager::Visit.last


          #2nd attempt
          get :index
          last_visit = UniversalTrackManager::Visit.last

          expect(last_visit).to eq(first_visit)
        end

        it "should evict the existing visit if the user agent does not match" do
          #1st attempt
          get :index
          first_visit = UniversalTrackManager::Visit.last

          request.user_agent = 'Fake Browser 2'

          #2nd attempt
          get :index
          last_visit = UniversalTrackManager::Visit.last

          expect(last_visit).to_not eq(first_visit)
        end
      end

      describe "the UTM parameters" do
        it "does NOT track any UTMs if disabled" do
          UniversalTrackManager.configure do |config|
            config.track_utms = false
          end


          get :index, params: {utm_campaign: "abc",
                               utm_medium: "def",
                               utm_source: "ghi",
                               utm_term: "jkl",
                               utm_content: "mno"}


          last_visit = UniversalTrackManager::Visit.last

          campaign = last_visit.campaign

          expect(campaign).to eq(nil)
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



        it "should keep the existing visit if the UTM parameters match the first visit" do

          get :index, params: {utm_campaign: "abc",
                               utm_medium: "def",
                               utm_source: "ghi",
                               utm_term: "jkl",
                               utm_content: "mno"}

          first_visit = UniversalTrackManager::Visit.last


          get :index, params: {utm_campaign: "abc",
                               utm_medium: "def",
                               utm_source: "ghi",
                               utm_term: "jkl",
                               utm_content: "mno"}



          second_visit = UniversalTrackManager::Visit.last

          expect(first_visit).to eq(second_visit)
        end

        it "should evict the visit if there are any new UTM parameters" do
          get :index, params: {utm_campaign: "abc",
                               utm_medium: "def",
                               utm_source: "ghi",
                               utm_term: "jkl",
                               utm_content: "mno"}

          first_visit = UniversalTrackManager::Visit.last


          get :index, params: {utm_campaign: "XXX",
                               utm_medium: "YYY",
                               utm_source: "ghi",
                               utm_term: "jkl",
                               utm_content: "mno"}

          second_visit = UniversalTrackManager::Visit.last

          expect(first_visit).to_not eq(second_visit)
        end

        it "should maintain the old visit when no new parameters are passed" do
          get :index, params: {utm_campaign: "abc",
                               utm_medium: "def",
                               utm_source: "ghi",
                               utm_term: "jkl",
                               utm_content: "mno"}

          first_visit = UniversalTrackManager::Visit.last

          get :index
          second_visit = UniversalTrackManager::Visit.last

          expect(first_visit).to eq(second_visit)
        end

      end

      it "sets the visit's first_pageload" do
        get :index
        sleep 1.1

        get :index

        last_visit = UniversalTrackManager::Visit.last
        expect(last_visit.first_pageload).to_not be(nil)
        expect(last_visit.last_pageload).to_not be(nil)
      end

      it "the visit's last_pageload will not be null and will not be the first page loads" do
        get :index

        sleep 1.1

        get :index

        last_visit = UniversalTrackManager::Visit.last
        expect(last_visit.first_pageload).to_not be(nil)
        expect(last_visit.last_pageload).to_not be(nil)
        expect(last_visit.last_pageload).to_not eq(last_visit.first_pageload)

      end
    end
  end
end
