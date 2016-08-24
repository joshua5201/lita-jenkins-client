class Lita::Handlers::JenkinsClient < Lita::Handler  
  class BuildParam
    attr_reader :type, :name, :description, :default, :choices, :value
    def initialize(type: , name: , description: , default: '', choices: [])
      @type, @name, @description, @default, @choices = type, name, description, default, choices
      if type == 'choice'
        @default = choices[0] 
      end
      self.value = @default 
    end

    def value=(v)
      if v.nil?
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
        raise ArgumentError, "Currently available param types: 'string', 'boolean', 'choice'"
      end
    end

    def to_h
      {@name => @value}
    end
  end
end
