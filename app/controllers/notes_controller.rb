class NotesController < ApplicationController
  before_action :set_note, only: %i[show update destroy]
  before_action :authorized

  # GET /notes
  def index
    if current_user.role == 'admin'
      @notes = Note.all
    else
      @notes = Note.where(user: current_user.id)
    end

    render json: @notes
  end

  # GET /notes/1
  def show
    render json: @note
  end

  # POST /notes
  def create
    @note = Note.new(note_params)
    @note.user = current_user

    if @note.save
      render json: @note, status: :created, location: @note
    else
      render json: @note.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /notes/1
  def update
    if current_user.role == 'admin' || @note.user == current_user
      if @note.update(note_params)
        render json: @note
      else
        render json: @note.errors, status: :unprocessable_entity
      end
    else
      render json: { error: "Not authorized" }, status: :forbidden
    end
  end

  # DELETE /notes/1
  def destroy
    if current_user.role == 'admin' || @note.user == current_user
      @note.destroy!
    else
      render json: { error: "Not authorized" }, status: :forbidden
    end
  end

  private

  def set_note
    @note = Note.find(params[:id])
  end

  def note_params
    params.require(:note).permit(:title, :body)
  end
end
