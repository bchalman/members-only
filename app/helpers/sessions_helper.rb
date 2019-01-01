module SessionsHelper

  def log_in (user)
    # log user into the session
    session[:user_id] = user.id
    # give user a new remember_token each login to prevent stale/stolen tokens
    user.create_remember_digest
    # store token in browser so when visiting pages, we know if they are signed in
    cookies.permanent[:remember_token] = user.remember_token
    @current_user = user
  end

  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif cookies.permanent[:remember_token]
      @current_user ||= User.find_by(remember_digest: User.digest(cookies.permanent[:remember_token]))
    else
      @current_user = nil
    end
  end

  def current_user=(user)
    @current_user = user
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    cookies.delete(:remember_token)
    session.delete(:user_id)
    @current_user.update_attribute(:remember_digest, nil)
    @current_user = nil
  end
  
end
