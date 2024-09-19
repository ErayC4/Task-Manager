class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]
  before_action :authenticate_user!
  before_action :correct_user, only: %i[show edit update destroy]

  # GET /tasks or /tasks.json
  def index
    @tasks = Task.where(user_id: current_user.id)
    # Sammele alle gerundeten Startzeiten in einem Array
    @get_all_starting_times = []
    
    @tasks.each do |task|
      starting_times = task.repeat_schedule["starting_time"]
      
      if starting_times.is_a?(Array)
        # Iteriere über jedes Element des Arrays und sammle die gerundeten Stunden
        starting_times.each do |start_time|
          @get_all_starting_times << roundStartingTimeToHour(start_time)
        end
      elsif starting_times.present?
        # Einzelne Zeit verarbeiten und als Array speichern
        @get_all_starting_times << roundStartingTimeToHour(starting_times)
      end
    end
    @smallest_value = smallestValueInArray(@get_all_starting_times)

  end

  def roundStartingTimeToHour(start_time)
    start_time_part = start_time.split(":").map(&:to_i)
    hour = start_time_part[0]
    hour
  end

  
  def smallestValueInArray(start_times)
    return 6 if start_times.empty?
    smallest_value = start_times[0]
    start_times.each do |i| 
        if i < smallest_value
          smallest_value = i
        end
    end
    smallest_value
  end
  # GET /tasks/1 or /tasks/1.json
  def show
    @task = Task.find(params[:id])
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks or /tasks.json
  def create
    # Suche nach einer bestehenden Task mit dem gleichen Titel
    existing_task = Task.find_by(title: task_params[:title])
  
    if existing_task
      # Kombiniere die repeat_schedule von der neuen und bestehenden Task
      merged_schedule = merge_repeat_schedules(existing_task.repeat_schedule, task_params[:repeat_schedule])
  
      # Aktualisiere die bestehende Task mit den gemergten Daten
      if existing_task.update(repeat_schedule: merged_schedule)
        respond_to do |format|
          format.html { redirect_to existing_task, notice: "Task was successfully merged." }
          format.json { render :show, status: :ok, location: existing_task }
        end
      else
        respond_to do |format|
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: existing_task.errors, status: :unprocessable_entity }
        end
      end
    else
      # Wenn keine Task existiert, erstelle eine neue Task
      #@task = Task.new(task_params)
      @task = current_user.tasks.build(task_params)
      respond_to do |format|
        if @task.save
          format.html { redirect_to @task, notice: "Task was successfully created." }
          format.json { render :show, status: :created, location: @task }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @task.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: "Task was successfully updated." }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task.destroy!

    respond_to do |format|
      format.html { redirect_to tasks_path, status: :see_other, notice: "Task was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  
  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    redirect_to tasks_path, notice: "not logged in" if @task.nil?
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    def merge_repeat_schedules(existing_schedule, new_schedule)
      {
        'ending_time' => Array(existing_schedule['ending_time']).concat([new_schedule['ending_time']]).compact,
        'starting_time' => Array(existing_schedule['starting_time']).concat([new_schedule['starting_time']]).compact,
        'repeat_on_day' => Array(existing_schedule['repeat_on_day']).concat([new_schedule['repeat_on_day']]).compact
      }
    end
    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:title, :notes, :revised, :repeat_schedule_ending_time, :repeat_schedule_starting_time, :repeat_schedule_repeat_on_day, :user_id).tap do |whitelisted|
        whitelisted[:repeat_schedule] = {
          'ending_time' => whitelisted.delete(:repeat_schedule_ending_time),
          'starting_time' => whitelisted.delete(:repeat_schedule_starting_time),
          'repeat_on_day' => whitelisted.delete(:repeat_schedule_repeat_on_day)
        }
      end
    end
    
end
