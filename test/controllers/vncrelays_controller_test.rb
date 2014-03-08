require 'test_helper'

class VncrelaysControllerTest < ActionController::TestCase
  setup do
    @vncrelay = vncrelays(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:vncrelays)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create vncrelay" do
    assert_difference('Vncrelay.count') do
      post :create, vncrelay: { external_ip: @vncrelay.external_ip, host: @vncrelay.host, internal_ip: @vncrelay.internal_ip, lastseen: @vncrelay.lastseen, port: @vncrelay.port, serialnumber: @vncrelay.serialnumber }
    end

    assert_redirected_to vncrelay_path(assigns(:vncrelay))
  end

  test "should show vncrelay" do
    get :show, id: @vncrelay
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @vncrelay
    assert_response :success
  end

  test "should update vncrelay" do
    patch :update, id: @vncrelay, vncrelay: { external_ip: @vncrelay.external_ip, host: @vncrelay.host, internal_ip: @vncrelay.internal_ip, lastseen: @vncrelay.lastseen, port: @vncrelay.port, serialnumber: @vncrelay.serialnumber }
    assert_redirected_to vncrelay_path(assigns(:vncrelay))
  end

  test "should destroy vncrelay" do
    assert_difference('Vncrelay.count', -1) do
      delete :destroy, id: @vncrelay
    end

    assert_redirected_to vncrelays_path
  end
end
