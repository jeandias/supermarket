Given(/^the following "(.*?)":$/) do |model, table|
  PaperTrail.enabled = false
  create_ast_table(model, table)
  PaperTrail.enabled = true
end

Given(/^the current user is:$/) do |table|
  rows = table.rows_hash
  rows.each { |key, value| rows[key] = (value.match(/^\[.*\]$/) ? eval(value) : value) }
  command = AuthenticateUser.call(rows[:email], rows[:password])
  header "Authorization", command.result
end

Given(/^the following fake "(.*?)":$/) do |model, table|
  factory_girl(model, table.hashes)
end

Given(/^the following fake "(.*?)" with id "(.*?)"$/) do |model, id|
  factory_girl(model, [ { id: id } ])
end

Given(/^that I update the "(.*?)" id "(.*?)" with the following:$/) do |model_name, id, table|
  object = model_name.classify.constantize.find(id)
  expect(object.update(table.rows_hash)).to eq(true), object.errors.full_messages.to_sentence
end

Given(/^I wait a few seconds$/) do
  sleep 3
end
