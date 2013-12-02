require 'test_helper'

class BeaglebonesControllerTest < ActionController::TestCase
  setup do
    @beaglebone = beaglebones(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:beaglebones)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create beaglebone" do
    assert_difference('Beaglebone.count') do
      post :create, beaglebone: { external_ip: @beaglebone.external_ip, internal_ip: @beaglebone.internal_ip, last_seen: @beaglebone.last_seen, serialnumber: @beaglebone.serialnumber, version: @beaglebone.version }
    end

    assert_redirected_to beaglebone_path(assigns(:beaglebone))
  end

  test "should show beaglebone" do
    get :show, id: @beaglebone
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @beaglebone
    assert_response :success
  end

  test "should update beaglebone" do
    patch :update, id: @beaglebone, beaglebone: { external_ip: @beaglebone.external_ip, internal_ip: @beaglebone.internal_ip, last_seen: @beaglebone.last_seen, serialnumber: @beaglebone.serialnumber, version: @beaglebone.version }
    assert_redirected_to beaglebone_path(assigns(:beaglebone))
  end

  test "should destroy beaglebone" do
    assert_difference('Beaglebone.count', -1) do
      delete :destroy, id: @beaglebone
    end

    assert_redirected_to beaglebones_path
  end
end
