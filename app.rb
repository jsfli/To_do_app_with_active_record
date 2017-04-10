require('sinatra')
require('sinatra/reloader')
require('sinatra/activerecord')
also_reload('lib/**/*.rb')
require('./lib/task')
require('./lib/list')
require('pg')
require('pry')

get('/') do
  @tasks = Task.all()
  @lists = List.all()
  erb(:index)
end

delete('/database_reset') do
  @tasks=Task.all()
  @lists=List.all()
  @tasks.each() do |task|
    task.destroy()
  end
  @lists.each() do |list|
    list.destroy()
  end
  redirect to ('/')
end

post('/tasks') do
  description = params.fetch("description")
  list = List.find(params.fetch("list_id").to_i())
  task = list.tasks.create({:description => description, :done => false})
  @list = List.find(list.id().to_i())
  redirect to ("/lists/#{@list.id()}")
end

post('/lists') do
  description = params.fetch('description')
  list = List.create({:description => description})
  redirect to ('/')
end

get('/lists/:id/add_task') do
  @list = List.find(params.fetch("id").to_i())
  erb(:list_add)
end

post('/lists/:id/add') do
  description = params.fetch('description')
  @list = List.find(params.fetch("id").to_i())
  task = @list.tasks.create({:description => description, :done => false})
  redirect to ("/lists/#{@list.id()}")
end

get('/tasks/:id/edit') do
  @task = Task.find(params.fetch("id").to_i())
  erb(:task_edit)
end

get('/lists/:id/edit') do
  @list = List.find(params.fetch("id").to_i())
  erb(:list_edit)
end

patch('/tasks/:id') do
  @task = Task.find(params.fetch("id").to_i())
  description = params.fetch("description", @task.description())
  done = params.fetch("done", @task.done())
  @task.update({:description => description, :done => done})
  @list = @task.list()
  redirect to ("/lists/#{@list.id()}")
end

delete('/tasks/:id') do
  @task=Task.find(params.fetch("id").to_i())
  @list=@task.list()
  @task.destroy()
  redirect to ("/lists/#{@list.id()}")
end

delete('/lists/:id') do
  @list=List.find(params.fetch("id").to_i())
  @list.destroy()
  redirect to ("/")
end

patch('/lists/:id') do
  description = params.fetch("description")
  @list = List.find(params.fetch("id").to_i())
  @list.update({:description => description})
  redirect to ("/lists/#{@list.id()}")
end

get('/lists/:id') do
  @list = List.find(params.fetch("id").to_i())
  erb(:list)
end
