#It’s convenient to model sessions as a RESTful resource: visiting the login page will render a form for new sessions, logging in will create a session, and logging out will destroy it.
class SessionsController < ApplicationController
  
  def new
  end

  def create
    # params[:session][:email] is how to access the email submitted in the form 
    user = User.find_by(email: params[:session][:email].downcase)
    # params[:session][:email] is how to access the password submitted in the form
    if user && user.authenticate(params[:session][:password])
    # If u find the user and their password is correct ,log the user in and redirect to the user's show page.
    ## predefined method in helper 
      log_in user 
      # checks if the checkbox in the loging form is checked or not,1 = checked 
      #if checked use the remember(user) method else forget(user)
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)     
      redirect_back_or user_path(user)
    else
      #render new and display a vague error message that explains why
      flash.now[:danger] = "Invalid email/password combination"
      render 'new'
    end  
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end


end
