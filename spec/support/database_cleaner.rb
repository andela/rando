# RSpec.configure do |config|
#   config.around(:each) do |example|
#     if example.metadata[:js]
#       example.run
#       ActiveRecord::Base.connection.execute("TRUNCATE #{ActiveRecord::Base.connection.tables.join(',')} RESTART IDENTITY")
#     else
#       ActiveRecord::Base.transaction do
#         example.run
#         raise ActiveRecord::Rollback
#       end
#     end
#   end
# end

RSpec.configure do |config|

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
