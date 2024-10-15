# app/controllers/subtasks_controller.rb
class SubtasksController < ApplicationController
  before_action :set_task, only: [:edit, :update]
  def index
    @tasks = Task.where(user_id: current_user.id)

  end

  def edit
    # Diese Aktion zeigt das Formular zum Bearbeiten des Subtasks eines bestimmten Tasks
  end

  def update
    # Hier wird nur das Subtask-Feld des Tasks aktualisiert
    if @task.update(subtask_params)
      redirect_to task_path(@task), notice: 'Subtask updated successfully.'
    else
      render :edit
    end
  end

  private

  def set_task
    # Holt den spezifischen Task anhand der übermittelten ID
    @task = Task.find(params[:id])
  end

  def subtask_params
    # Erlaubt nur die Subtask-bezogenen Felder zur Aktualisierung
    params.require(:task).permit(:subtask_title, :subtask_finished)
  end
end
