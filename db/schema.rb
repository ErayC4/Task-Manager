# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_10_09_094234) do
  create_table "subtasks", force: :cascade do |t|
    t.string "title"
    t.string "left_of_at"
    t.boolean "finished"
    t.json "make_later"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "task_id"
    t.index ["task_id"], name: "index_subtasks_on_task_id"
  end

  create_table "subtasks_tasks", id: false, force: :cascade do |t|
    t.integer "subtask_id", null: false
    t.integer "task_id", null: false
    t.index ["subtask_id", "task_id"], name: "index_subtasks_tasks_on_subtask_id_and_task_id"
    t.index ["task_id", "subtask_id"], name: "index_subtasks_tasks_on_task_id_and_subtask_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "title"
    t.text "notes"
    t.boolean "revised"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.string "starting_time"
    t.string "ending_time"
    t.boolean "is_revision"
    t.string "repeat_schedule"
    t.integer "subtask_id"
    t.index ["subtask_id"], name: "index_tasks_on_subtask_id"
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
