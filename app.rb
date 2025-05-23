# Require Sinatra to create the web application
require "sinatra"
require "json"

# Set the path to your task storage file
TASK_FILE = "tasks.json"

# Helper method to load tasks from the file
def load_tasks
  if File.exist?(TASK_FILE)
    JSON.parse(File.read(TASK_FILE))
  else
    []  # If the file doesn't exist yet, return an empty list
  end
end

# Helper method to save tasks to the file
def save_tasks(tasks)
  File.write(TASK_FILE, JSON.pretty_generate(tasks))
end

# Route: Home page showing all tasks
get "/" do
  @tasks = load_tasks
  erb :index  # Render the index.erb view template
end

# Route: Handle form submission to add a new task
post "/add" do
  tasks = load_tasks
  new_task = {
    "id" => Time.now.to_i,
    "description" => params["description"],
    "status" => "incomplete"
  }
  tasks << new_task
  save_tasks(tasks)
  redirect "/"  # Go back to the homepage
end

# Route: Mark a task as complete
post "/complete/:id" do
  tasks = load_tasks
  task = tasks.find { |t| t["id"] == params["id"].to_i }
  task["status"] = "complete" if task
  save_tasks(tasks)
  redirect "/"
end

# Route: Delete a task
post "/delete/:id" do
  tasks = load_tasks.reject { |t| t["id"] == params["id"].to_i }
  save_tasks(tasks)
  redirect "/"
end
