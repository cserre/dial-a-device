require 'test_helper'

class LibraryEntriesControllerTest < ActionController::TestCase
  setup do
    @library_entry = library_entries(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:library_entries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create library_entry" do
    assert_difference('LibraryEntry.count') do
      post :create, library_entry: { library_id: @library_entry.library_id, molecule_id: @library_entry.molecule_id, position: @library_entry.position }
    end

    assert_redirected_to library_entry_path(assigns(:library_entry))
  end

  test "should show library_entry" do
    get :show, id: @library_entry
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @library_entry
    assert_response :success
  end

  test "should update library_entry" do
    patch :update, id: @library_entry, library_entry: { library_id: @library_entry.library_id, molecule_id: @library_entry.molecule_id, position: @library_entry.position }
    assert_redirected_to library_entry_path(assigns(:library_entry))
  end

  test "should destroy library_entry" do
    assert_difference('LibraryEntry.count', -1) do
      delete :destroy, id: @library_entry
    end

    assert_redirected_to library_entries_path
  end
end
