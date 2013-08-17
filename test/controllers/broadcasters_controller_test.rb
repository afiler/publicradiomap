require 'test_helper'

class BroadcastersControllerTest < ActionController::TestCase
  setup do
    @broadcaster = broadcasters(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:broadcasters)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create broadcaster" do
    assert_difference('Broadcaster.count') do
      post :create, broadcaster: {  }
    end

    assert_redirected_to broadcaster_path(assigns(:broadcaster))
  end

  test "should show broadcaster" do
    get :show, id: @broadcaster
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @broadcaster
    assert_response :success
  end

  test "should update broadcaster" do
    patch :update, id: @broadcaster, broadcaster: {  }
    assert_redirected_to broadcaster_path(assigns(:broadcaster))
  end

  test "should destroy broadcaster" do
    assert_difference('Broadcaster.count', -1) do
      delete :destroy, id: @broadcaster
    end

    assert_redirected_to broadcasters_path
  end
end
