file('lib/tasks/default.rake', <<-END.unindent)
  Rake::TaskManager.class_eval do
    def remove_task(task_name)
      @tasks.delete(task_name.to_s)
    end
  end

  Rake.application.remove_task(:default)

  task :default => ['test:units', 'test:functionals', 'cucumber:ok', 'cucumber:wip']
END

git(:add => 'lib/tasks/default.rake')
git(:commit => '-m "Redefine what `rake` does."')
