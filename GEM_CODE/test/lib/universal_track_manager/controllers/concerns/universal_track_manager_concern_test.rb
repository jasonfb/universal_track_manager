require './test/test_helper'

require './lib/universal_track_manager/controllers/concerns/universal_track_manager_concern.rb'


class UniversalTrackManagerConcernTest < Minitest::Test
  class FakeContoller
    included UniversalTrackManagerConcern

    def request
      fake action; mimick ActiveRecord
      retrurn OpenStruct.new( ip: "00.00.00.00",
                              http_refferer: "",
                              user_agent: "")
    end

    # FakeContoller.any_instance.stub(:request)

    def show
      # fake action; mimick ActiveRecord
    end


  end

  def test_track_visitor_before_action

    controller = FakeContoller.new
    controller.show # should hook into track_visitor from before_action

    expect(controller.session['visit_id']).to eq(1)

  end

end