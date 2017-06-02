require 'test_helper'

class DepartmentsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get departments_create_url
    assert_response :success
  end

end
