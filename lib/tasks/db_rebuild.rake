namespace :db do
  desc 'create new or completely wipe database and repopulate with fake data'

  task rebuild: :environment do
    %w[db:create db:migrate db:seed].each do |task|
      $stdout.puts "running #{task}"
      Rake::Task[task].invoke
    end

    $stdout.puts 'Your databases have been successfully rebuilt.'
  end
end
