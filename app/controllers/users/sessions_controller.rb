module Users
class SessionsController < Devise::SessionsController

protected

  def after_sign_in_path_for(resource)
    if resource.is_a?(User) && resource.banned?
      sign_out resource
      flash[:error] = "This account has been suspended for violating the site rules."
      root_path
    else
      super
    end
  end

end
end
