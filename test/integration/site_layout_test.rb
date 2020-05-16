# frozen_string_literal: true

require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test 'layout links' do
    # Before login
    get root_path
    assert_template 'static_pages/home'
    assert_select 'a[href=?]', root_path, count: 2
    assert_select 'a[href=?]', help_path
    assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]', about_path
    assert_select 'a[href=?]', contact_path
    assert_select 'a[href=?]', signup_path

    get help_path
    assert_select 'title', full_title('Help')

    get about_path
    assert_select 'title', full_title('About')

    get contact_path
    assert_select 'title', full_title('Contact')

    get signup_path
    assert_template 'users/new'
    assert_select 'title', full_title('Sign up')

    get login_path
    assert_template 'sessions/new'
    assert_select 'title', full_title('Log in')
    assert_select 'a[href=?]', signup_path

    get users_path
    assert_redirected_to login_path

    get user_path(@user.id)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)

    get edit_user_path(@user.id)
    assert_redirected_to login_path


    # After login
    log_in_as(@user)
    get root_path
    assert_template 'static_pages/home'
    assert_select 'a[href=?]', root_path, count: 2
    assert_select 'a[href=?]', help_path
    assert_select 'a[href=?]', users_path
    assert_select 'a[href=?]', user_path(@user.id)
    assert_select 'a[href=?]', edit_user_path(@user.id)
    assert_select 'a[href=?]', logout_path
    assert_select 'a[href=?]', about_path
    assert_select 'a[href=?]', contact_path
    assert_select '#following', text: /.*#{@user.following.count.to_s}.*/
    assert_select '#follower', text: /.*#{@user.followers.count.to_s}.*/

    get help_path
    assert_select 'title', full_title('Help')

    get about_path
    assert_select 'title', full_title('About')

    get contact_path
    assert_select 'title', full_title('Contact')

    get signup_path
    assert_template 'users/new'
    assert_select 'title', full_title('Sign up')

    get login_path
    assert_template 'sessions/new'
    assert_select 'title', full_title('Log in')
    assert_select 'a[href=?]', signup_path

    get users_path
    assert_template 'users/index'
    assert_select 'title', full_title('All users')
    assert_select 'a[href=?]', user_path(@user.id), count: 2

    get user_path(@user.id)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)

    get edit_user_path(@user.id)
    assert_template 'users/edit'
    assert_select 'title', full_title('Edit user')
    
  end
end
