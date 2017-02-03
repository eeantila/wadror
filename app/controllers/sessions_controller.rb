class SessionsController < ApplicationController
  def new
    # render�i kirjautumissivun
  end

  def create
    # haetaan usernamea vastaava k�ytt�j� tietokannasta
    user = User.find_by username: params[:username]
    # talletetaan sessioon kirjautuneen k�ytt�j�n id (jos k�ytt�j� on olemassa)
    session[:user_id] = user.id if user
    # uudelleen ohjataan k�ytt�j� omalle sivulleen
    redirect_to user
  end

  def destroy
    # nollataan sessio
    session[:user_id] = nil
    # uudelleenohjataan sovellus p��sivulle
    redirect_to :root
  end
end