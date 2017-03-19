module Helpers
  module Json
    def json_expect_eq?(string)
      expect(json_actual).to eq(json_expected(string))
    end

    def json_actual
      JSON.parse(ignore_default_attributes(last_response.body))
    end

    def json_expected(string)
      JSON.parse(scan_regex(string))
    end

    def ignore_default_attributes(string)
      [
          /"(id|__rn|_id)":([0-9]*|"[0-9]*"|"[a-z0-9]{24}"),/,
          /"_id":\{.*?}\,/,
          /"token":"[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}",/,
          /"(latitude|longitude)":("-?\d{2}\.\d{7}"|null),/,
          /,"(latitude|longitude)":("-?\d{2}\.\d{7}"|null)/,
          /"(updated_at|created_at|saved_on)":"\d{4}-\d{2}-\d{2}(T\d{2}:\d{2}:\d{2}.\d{3}Z",|",)/,
          /,"(updated_at|created_at|saved_on|last_used)":"(\d{4}-\d{2}-\d{2}|\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}.\d{3}Z)"/,
          /\"(created_at|updated_at)\":\[.*\,"\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}.\d{3}Z"\]\,/,
          /\,\"(created_at|updated_at)\":\[.*\,"\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}.\d{3}Z"\]/,
          /\,\"id\":\[.*\,\d{1,10}\]/,
          /\"id\":\[.*\,\d{1,10}\]\,/
      ].each do |regex|
        string.gsub!(regex, "")
      end
      string
    end

    def scan_regex(string)
      numbers_of_occurrences = Hash.new(0)
      string.scan(/"([a-z_]*)":\s"*\%r{(.*?)\}"*/).each do |field, regex|
        numbers_of_occurrences[field] += 1
        replacement = last_response.body.scan(/"#{field}":"*#{regex}"*/)[numbers_of_occurrences[field] - 1]
        string.sub!(%("#{field}": %r{#{regex}}), replacement) if replacement
      end
      string.scan(/([a-z_]*)":\s"\%r{(.*?)\}"/).each do |field, regex|
        string.sub!(%("#{field}": "%r{#{regex}}"), last_response.body[/"#{field}":"#{regex}"/])
      end
      string
    end
  end
end
