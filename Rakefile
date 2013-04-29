# load rake tasks
Dir["./lib/tasks/**/*.rake"].sort.each { |ext| load ext }

desc "generate secrete.rb"
task :secret do
  if File.exist?('config/secret.rb')
    puts 'config/secret.rb already exists'
  else
    puts 'Writing config/secret.rb'
    File.open 'config/secret.rb', 'w' do |f|
      f.puts "# GENERATED BY `rake secret`"
      f.puts "set :session_secret, '#{rand(2**256).to_s 36}'"
    end
  end
end
