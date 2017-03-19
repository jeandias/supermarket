Then(/^the response status should be "(.*?)"$/) do |status|
  expect(last_response.status).to eq(status.to_i)
end

Then(/^the response type should be "(.*?)"$/) do |content_type|
  expect(last_response.headers["Content-Type"]).to eq(content_type)
end

Then(/^the JSON response should be:$/) do |json|
  json_expect_eq?(json)
end

Then(/^the JSON response should be "(.*?)"$/) do |text|
  expect(last_response.body).to eq(text.to_json)
end

Then(/^the JSON response should be equal to the corresponding file of this scenario$/) do
  filename = @current_scenario[:file].gsub(%r{features\/modules\/|\.feature}, "")
  file_path = File.join("features/json/", filename, "scenario-#{@current_scenario[:title].parameterize}.json")
  puts file_path.green
  json = File.read(File.join(Rails.root, file_path))
  json_expect_eq?(json)
end

Then(/^should responds with the queue number$/) do
  expect(/[a-zA-Z0-9]{24}/).to match(last_response.body)
end

Then(/^should responds with the queue from worker process$/) do
  expect(/[a-zA-Z0-9]{4,12}/).to match(last_response.body)
end

Then(/^the response should be "(.*?)"$/) do |text|
  expect(last_response.body).to eq(text)
end
