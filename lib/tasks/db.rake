namespace :db do
	task :release do
		Rake::Task["db:drop"].invoke
		Rake::Task["db:create"].invoke
		Rake::Task["db:migrate"].invoke
		Rake::Task["db:seed"].invoke
	end

	desc "Dumps the database to garage/expenze_development-{today}.dump"
	task :backup do
    cmd = 'mysqldump -u root -p expenze_development > ~/projects/expenze/garage/expenze_development-"$(date +%F)".sql'
    puts cmd
    exec cmd
	end
end
