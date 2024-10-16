# app/controllers/subtasks_controller.rb
class SubtasksController < ApplicationController
  before_action :set_task, only: [:edit, :update]
  def index
    @tasks = Task.where(user_id: current_user.id)

  end

  def toggle_finished
    @task = Task.find(params[:id])
    if @task.update(subtask_finished: !@task.subtask_finished)
      respond_to do |format|
        format.html { redirect_to subtasks_path, notice: 'Subtask status updated.' }
        format.js   # Optional für AJAX
      end
    else
      respond_to do |format|
        format.html { redirect_to subtasks_path, alert: 'Error updating subtask.' }
      end
    end
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
