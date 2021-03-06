class SecretsController < ApplicationController
  include ErrorConcern

  def index
    respond_to do |format|
      format.html
    end
  end

  def create
    @secret = Secret.create! create_params

    respond_to do |format|
      format.json { render json: @secret, status: :created }
    end
  end

  def show
    @secret = Secret.find_by! uuid: params[:id]

    respond_to do |format|
      format.json { render json: @secret }
    end
  end

  def update
    @secret = Secret.find_by! uuid: params[:id]

    if secret_params.key? :encrypted_data
      @secret.parts.create! encrypted_data: secret_params[:encrypted_data]
      @secret.seal!
    else
      raise NotImplementedError, 'multi part secret not implemented yet'
    end

    respond_to do |format|
      format.html
      format.json { render json: @secret }
    end
  end

  private

  def create_params
    {
      public_key: secret_params.require(:public_key)
    }.merge secret_params.permit(:message, :signature)
  end

  def secret_params
    @secret_params ||= (params[:secret] || params)
  end
end
