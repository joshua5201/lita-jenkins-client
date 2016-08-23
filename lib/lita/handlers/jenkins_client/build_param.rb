class Lita::Handlers::JenkinsClient < Lita::Handler  
  class BuildParam
    attr_reader :type, :name, :description, :default, :choices, :value
    def initialize(type: , name: , description: , default: , choices: [])
      @type, @name, @description, @default, @choices = type, name, description, default, choices
      self.value = default
    end

    def value=(v)
      if v.nil?
        return
      end

      case @type
      when 'string'
        @value = v
      when 'bool'
        if v == 'true'
          @value = true
        elsif v == 'false'
          @value = false
        else
          raise ArgumentError, "#{@name} should be true or false"
        end
      when 'choices'
        if @choices.includes? (v)
          @value = v
        else
          raise ArgumentError, "#{@name} should be one of #{@choice.inspect}"
        end
      else
        raise ArgumentError, "Currently available param types: 'string', 'bool', 'choices'"
      end
    end

    def to_h
      {@name => @value}
    end
  end
end
