require 'test_helper'

class ArtsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:arts)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_art
    assert_difference('Art.count') do
      post :create, :art => { }
    end

    assert_redirected_to art_path(assigns(:art))
  end

  def test_should_show_art
    get :show, :id => arts(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => arts(:one).id
    assert_response :success
  end

  def test_should_update_art
    put :update, :id => arts(:one).id, :art => { }
    assert_redirected_to art_path(assigns(:art))
  end

  def test_should_destroy_art
    assert_difference('Art.count', -1) do
      delete :destroy, :id => arts(:one).id
    end

    assert_redirected_to arts_path
  end
end
