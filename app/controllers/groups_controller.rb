class GroupsController < ApplicationController
  before_action :set_note, only: %i[show update destroy]
  before_action :authorized

  # GET /groups
  def index
    @groups = Group.all
    render json: @groups
  end

  # GET /groups/1
  def show
    @group = Group.find(params[:id])
    if current_user.root? || (current_user.admin? && @group.users.include?(current_user))
      render json: @group
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  # POST /groups
  def create
    if current_user.root?
      @group = Group.new(group_params)
      if @group.save
        render json: @group, status: :created
      else
        render json: @group.errors, status: :unprocessable_entity
      end
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  # PATCH/PUT /groups/1
  def update
    @group = Group.find(params[:id])
    if current_user.root?
      if @group.update(group_params)
        render json: @group, status: :ok
      else
        render json: @group.errors, status: :unprocessable_entity
      end
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  # DELETE /groups/1
  def destroy
    @group = Group.find(params[:id])
    if current_user.root?
      @group.destroy
      render json: { notice: 'Group was successfully destroyed.' }, status: :ok
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  private

  def authorize_user
    if current_user.client?
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def group_params
    params.require(:group).permit(:name, :user_id, user_ids: [])
  end
end
