Before('@cleaner') do
  DatabaseCleaner[:active_record].strategy = :transaction
  DatabaseCleaner.clean_with(:truncation)
  Rails.cache.clear
end
