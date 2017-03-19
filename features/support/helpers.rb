module Helpers

  def create_ast_table(model_name, table)
    table.hashes.each do |hash|
      attributes = Rack::Utils.parse_nested_query(hash.to_query)

      begin
        object = model_name.classify.constantize.new
      rescue NameError => exception
        puts exception.message
        create_database_record model_name, table
        return
      end

      attributes.keys.each do |key|
        begin
          class_name = attributes[key].class.name

          if class_name == "Hash"
            object.send(key.pluralize).new(attributes[key])
          elsif class_name == "Array"
            attributes[key].each do |attr|
              association = object.send(key).new(attr)
              expect(association.valid?).to eq(true), "#{association.class.name} => #{association.errors.full_messages.to_sentence}"
              object.send(key) << association
            end
          else
            # to_i used because of Mongoid
            value = ERB.new(attributes[key]).result()

            if %w(false true).include?(value)
              value = value.to_b
            elsif key.end_with?("_id") && value.present?
              value = value.to_i
            end

            begin
              object[key] = value
            rescue ActiveModel::MissingAttributeError
              object.send("#{key}=", value)
            end
          end
        rescue => e
          raise "Error on trying set value '#{attributes[key]}' to attribute '#{key}'.\n#{e.inspect}"
        end
      end

      object.save!
    end

    def create_instace_variables_from_response
      begin
        last_response_json = JSON.parse last_response.body
        if last_response_json.kind_of?(Hash)
          last_response_json.each do |key, value|
            instance_variable_set("@#{key}", value)
          end
        elsif last_response_json.kind_of?(Array)
          last_response_json.each do |object|
            if object.kind_of?(Hash)
              object.each do |key, value|
                instance_variable_set("@#{key}", value)
              end
            end
          end
        end
      rescue Exception => exception
        Rails.logger.error exception.class
        Rails.logger.error exception.message
        Rails.logger.error exception.backtrace
      end
    end
  end

  private

  def create_database_record(model_name, table)
    db_table = model_name.underscore
    db_connection = ActiveRecord::Base.connection

    table.hashes.each do |hash|
      attributes = Rack::Utils.parse_nested_query(hash.to_query)
      sql = "insert into #{db_table} (#{attributes.keys.join(', ')}) values (#{attributes.values.join(', ')});"
      db_connection.execute sql
    end
  end

end
