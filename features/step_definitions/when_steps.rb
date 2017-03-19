When(/^I send a (GET|DELETE|POST|PUT) request to "(.*?)"$/) do |method, path|
  path = eval "\"#{path}\""
  options = {method: method.downcase.to_sym, params: {}}
  if @upload.present?
    options[:params][@upload[:param_name]] = Rack::Test::UploadedFile.new(@upload[:file], MIME::Types.type_for(@upload[:file]).first.content_type)
    @upload = nil
  end
  request path, options
  create_instace_variables_from_response
end

When(/^I send a (POST|PUT) request to "(.*?)" with the following:$/) do |method, path, table|
  path = eval "\"#{path}\""
  options = {method: method.downcase.to_sym}

  if table.class == Cucumber::Core::Ast::DocString
    header "Content-Type", "application/json"
    options[:input] = StringIO.new(table)
  else
    keys = table.raw[0]
    values = table.raw[1].map do |item|
      item.match(/^\[.*\]$/) ? eval(item) : ERB.new(item).result()
    end

    options[:params] = keys.zip(values).flatten(1).each_slice(2).reduce({}) do |params, pair|
      params[pair.first] = pair.last
      params
    end

    if @upload.present?
      options[:params][@upload[:param_name]] = Rack::Test::UploadedFile.new(@upload[:file], MIME::Types.type_for(@upload[:file]).first.content_type)
      @upload = nil
    end
  end

  request path, options
  create_instace_variables_from_response
end

When(/^I send a (GET|DELETE) request to "(.*?)" with the following:$/) do |method, path, table|
  path = eval "\"#{path}\""
  params = {}.tap do |items|
    table.rows_hash.keys.each do |k|
      items[k] = if table.rows_hash[k] =~ /^\[.*\]$/
                   table.rows_hash[k].gsub(/\[|\]/, "").split(",")
                 else
                   ERB.new(table.rows_hash[k]).result()
                 end
    end
  end
  request path, method: method.downcase.to_sym, params: params
  create_instace_variables_from_response
end
