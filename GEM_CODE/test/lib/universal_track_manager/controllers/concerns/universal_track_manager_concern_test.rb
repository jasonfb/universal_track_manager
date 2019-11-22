require './test/test_helper'
require './lib/universal_track_manager/controllers/concerns/universal_track_manager_concern.rb'


class UniversalTrackManagerConcernTest < UniversalTrackManager::ControllerTestCase
  # class FakeContoller < ApplictionController
  #
  #
  # end

  setup do
    request.env["ip_address"] = "00.00.00.00"
    request.env["ip_address"] = "00.00.00.00"

    # set_contoller_method(:@controller, FakeController.new)
  end


  def test_track_visitor_during_a_show

    # TOOD: access the rails controller
    @controller.show
    assert @controller
    expect(@controller.session['visit_id']).to eq(1)
  end

end


