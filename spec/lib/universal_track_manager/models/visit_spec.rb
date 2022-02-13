require 'spec_helper'

describe UniversalTrackManager::Visit do

  let(:campaign) {
    UniversalTrackManager::Campaign.new({
      utm_campaign: "abc",
      utm_source: "def",
      utm_term: "ghi",
      utm_content: "jkl",
      utm_medium: "mnp"
    })
  }
  let(:visit) {
    UniversalTrackManager::Visit.new({
                                       ip_v4_address: "1.2.3.4",
                                       browser: browser,
                                       campaign: campaign
                                     })
  }

  let(:cropped_campaign) {
    UniversalTrackManager::Campaign.new({
      utm_campaign: "abc",
      utm_source: "def",
      utm_term: "ghi",
      utm_content: "jkl"
    })
  }
  let(:cropped_visit) {
    UniversalTrackManager::Visit.new({campaign: cropped_campaign})
  }

  let(:browser) {
    UniversalTrackManager::Browser.new(name: "fake")
  }

  def basic_params
    { utm_campaign: "abc",
      utm_source: "def",
      utm_term: "ghi",
      utm_content: "jkl",
      utm_medium: "mnp"}
  end

  describe "#name" do
    it "should have a name" do
      expect(visit.name).to eq("1.2.3.4 fake")
    end
  end


  describe "#matches_all_utms?" do
    it "should match when all the utms match" do
      expect(visit.matches_all_utms?(basic_params)).to be(true)
    end


    it "should NOT match if the utm campaign is different" do

      expect(visit.matches_all_utms?({ utm_campaign: "XXX",
                                       utm_source: "def",
                                       utm_term: "ghi",
                                       utm_content: "jkl",
                                       utm_medium: "mnp"
                                     })).to be(false)
    end
    it "should NOT match if the utm_source is different" do
      expect(visit.matches_all_utms?(
        { utm_campaign: "abc",
          utm_source: "XXX",
          utm_term: "ghi",
          utm_content: "jkl",
          utm_medium: "mnp"}
      )).to be(false)
    end
    it "should NOT match if the utm_term is different" do
      expect(visit.matches_all_utms?(
        { utm_campaign: "abc",
          utm_source: "def",
          utm_term: "XXX",
          utm_content: "jkl",
          utm_medium: "mnp"}
      )).to be(false)
    end
    it "should NOT match if the utm_content is different" do
      expect(visit.matches_all_utms?(
        { utm_campaign: "abc",
          utm_source: "def",
          utm_term: "ghi",
          utm_content: "XXX",
          utm_medium: "mnp"}
      )).to be(false)
    end
    it "should NOT match if the utm_medium is different" do
      expect(visit.matches_all_utms?(
        { utm_campaign: "abc",
          utm_source: "def",
          utm_term: "ghi",
          utm_content: "jkl",
          utm_medium: "XXX"}
      )).to be(false)
    end
    it "should NOT match if any of the UTMs are missing" do
      expect(visit.matches_all_utms?(
        { utm_campaign: "abc",
          utm_source: "def" }
      )).to be(false)
    end
    it "should NOT match if there are additional UTMs present" do
      expect(cropped_visit.matches_all_utms?(basic_params)).to be(false)
    end

    describe "with no campaign" do
      let(:visit_with_no_campaign) {
        UniversalTrackManager::Visit.new({campaign: nil})
      }
      it "should match if all the utms are empty" do
        expect(visit_with_no_campaign.matches_all_utms?({})).to be(true)
      end
      it "should NOT match if the utm campaign is something" do
        expect(visit_with_no_campaign.matches_all_utms?({utm_campaign: "abc"})).to be(false)
      end
      it "should NOT match if the utm_source is something" do
        expect(visit_with_no_campaign.matches_all_utms?({utm_source: "abc"})).to be(false)
      end
      it "should NOT match if the utm_term is something" do
        expect(visit_with_no_campaign.matches_all_utms?({utm_term: "abc"})).to be(false)
      end
      it "should NOT match if the utm_content is something" do
        expect(visit_with_no_campaign.matches_all_utms?({utm_content: "abc"})).to be(false)
      end
      it "should NOT match if the utm_medium is something" do
        expect(visit_with_no_campaign.matches_all_utms?({utm_medium: "abc"})).to be(false)
      end
    end



    describe "#original visit" do
      let(:original_visit) {UniversalTrackManager.new}
      subject { UniversalTrackManager::Visit.new(original_visit:
                                                   original_visit) }



      it "should have a nonstandard class name" do

        expect(UniversalTrackManager::Visit.reflect_on_association(:original_visit).class_name).to eq("UniversalTrackManager::Visit")

      end
    end
  end
end
