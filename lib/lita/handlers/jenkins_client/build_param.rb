class Lita::Handlers::JenkinsClient < Lita::Handler  
  class BuildParam
    attr_reader :type, :name, :description, :default, :choices, :value
    def self.supported_types
      ['boolean', 'string', 'choice'].freeze
    end

    def self.print_supported_types
      "Currently available param types: #{self.supported_types.join(' ')}"
    end

    def initialize(type: , name: , description: , default: '', choices: [])
      @type, @name, @description, @default, @choices = type, name, description, default, choices
      if type == 'choice'
        @default = choices[0] 
      end

      if wrong_type? 
        raise ArgumentError, self.class.print_supported_types
      end

      self.value = @default 
    end

    def value=(v)
      if v.nil?
        @value = nil
      end

      unless v.is_a? (String)
        return
      end

      case @type
      when 'string'
        @value = v
      when 'boolean'
        if v == 'true'
          @value = true
        elsif v == 'false'
          @value = false
        else
          raise ArgumentError, "#{@name} should be true or false"
        end
      when 'choice'
        if @choices.include? (v)
          @value = v
        else
          raise ArgumentError, "#{@name} should be one of #{@choices.inspect}"
        end
      else
        raise ArgumentError, self.class.print_supported_types 
      end
    end

    def to_h
      {@name => @value}
    end

    private
    def wrong_type?
      not self.class.supported_types.include? @type
    end
  end
end
