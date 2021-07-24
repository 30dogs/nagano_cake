class Admin::CustomersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]

  def index
  end

  def show
  end

  def edit
  end

  def update
  end
end
