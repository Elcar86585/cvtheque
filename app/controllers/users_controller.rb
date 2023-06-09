class UsersController < ApplicationController
  before_action :set_user, only: %i[ show update destroy ]

  # GET /users
  def index
    @users = User.all.reorder('id DESC')

    render json: @users
  end

  # GET /users/1
  def show
    @entretien = @user.entretiens.reorder('id DESC').limit(15)
    @favoris = @user.favorites.reorder('id DESC')
    @comment = @user.comment_ids
    render json: {user: @user, entretien: @entretien, favo: @favoris, comment: @comment}
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      token = encode_token({user_id: @user.id})
      date = @user.expire
      if date === nil
        if @user.role === 'Utilisateur'
          @user.update(expire: 7.days.from_now)
        end
      end
      if @user.role === 'Utilisateur'
        UsermailerMailer.with(user: @user ).welcome_email.deliver_later
      end
      render json: {user: @user, token: token, authentication_token: @user.authentication_token, id: @user.id, message: 'Créer avec succèes', color: 'alert alert-success'}, status: :created, location: @user
    else
      render json: {message: 'Une erreur est survenue lors de la validation', color: 'alert alert-waring'}, status: :unprocessable_entity
    end
  end

  #users Search
  def search 
    @user = User.where("id || name LIKE ?", "%#{params[:id] || params[:name]}%")

    if @user && @user.exists?
      render json: {search: @user}, status: 200
    else
      render json: {message: "Aucune resultat"}, status: 202
    end

  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  # LOGGING IN
  def login
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
          if @user.expire.present? && @user.expire < Time.now
            errors.add(:base, "Oops, Votre compte est expirer !")
          else
            token = encode_token({user_id: @user.id})
            render json: {user: @user, token: token, message: 'Vous êtes connecter !', color: 'alert alert-success'}, status: 202
          end
    else
        render json: {message: "E-mail ou mot de passe incorrect", color: 'alert alert-danger'}, status: 203
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.permit(:name, :email, :role, :expire, :password, :authentication_token, :pass, :phone, :societe)
    end
end
