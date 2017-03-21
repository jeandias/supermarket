if ENV["DEBUG"].present?

  After('@dev') do |scenario|
    if scenario.failed?
      body = ignore_default_attributes(last_response.body)
      begin
        pretty = JSON.pretty_generate(JSON.parse(body)).gsub(/"(.*)":\s\[\n\s*\]/, %("\\1": []))
      rescue
        pretty = body
      end
      File.open(File.join(Rails.root, "tmp", "endpoint-response-#{@current_scenario[:name].parameterize}.json"), "w") { |file| file.write(pretty) }
      print "\n\n\e[33mDEBUG: The last response was written in \"last_response-*.json\"\e[0m"
    end
  end

  Before('@cleaner') do
    Dir["tmp/endpoint-response-*.json"].map { |f| File.delete(f) }
  end

end
