class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]
  before_action :authenticate_user!
  before_action :correct_user, only: %i[show edit update destroy]

  # GET /tasks or /tasks.json
  def index
    @tasks = Task.where(user_id: current_user.id)
    # Sammele alle gerundeten Startzeiten in einem Array
    @rounded_starting_time_array = @tasks.map do |task|
      if task.user_id == current_user.id
        roundStartingTimeToHour(task.starting_time)
      else
        24 
        #some number over 23, because there is no time where it hits 24, thus, if the user is not the current user, 
        #it will always be bigger than anytime, which does not screw with the baseline
      end
    end

    @smallest_value = smalles_value(@rounded_starting_time_array)

  end

  def roundStartingTimeToHour(start_time)
    if start_time.is_a?(String)
      start_time_part = start_time.split(":").map(&:to_i)
      hour = start_time_part[0]
      hour
    end
    
  end

  
  def smalles_value(start_times)
    return 6 if start_times.empty? || start_times.include?(nil)
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
    #@timeblock = Timeblock.new(timeblock_params)
    @task = current_user.tasks.build(task_params)
    respond_to do |format|
      if @task.save
        format.html { redirect_to task_url(@task), notice: "Task was successfully created." }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
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

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:title, :notes, :revised, :repeat_schedule, :ending_time, :starting_time, :user_id, :subtask_id)    
    end
    
end
