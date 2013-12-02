require 'test_helper'

class FolderWatchersControllerTest < ActionController::TestCase
  setup do
    @folder_watcher = folder_watchers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:folder_watchers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create folder_watcher" do
    assert_difference('FolderWatcher.count') do
      post :create, folder_watcher: { device_id: @folder_watcher.device_id, pattern: @folder_watcher.pattern, rootfolder: @folder_watcher.rootfolder, scanfilter: @folder_watcher.scanfilter, serialnumber: @folder_watcher.serialnumber }
    end

    assert_redirected_to folder_watcher_path(assigns(:folder_watcher))
  end

  test "should show folder_watcher" do
    get :show, id: @folder_watcher
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @folder_watcher
    assert_response :success
  end

  test "should update folder_watcher" do
    patch :update, id: @folder_watcher, folder_watcher: { device_id: @folder_watcher.device_id, pattern: @folder_watcher.pattern, rootfolder: @folder_watcher.rootfolder, scanfilter: @folder_watcher.scanfilter, serialnumber: @folder_watcher.serialnumber }
    assert_redirected_to folder_watcher_path(assigns(:folder_watcher))
  end

  test "should destroy folder_watcher" do
    assert_difference('FolderWatcher.count', -1) do
      delete :destroy, id: @folder_watcher
    end

    assert_redirected_to folder_watchers_path
  end
end
