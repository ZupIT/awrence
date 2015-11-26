module CoreExtensions
  refine Hash do
    def to_camel_keys(options = {})
      opts = { first_upper: false, ignore_slash: false }.merge(options)
      camelize_keys(self, opts)
    end

    private
      def camelize_keys(value, options)
        case value
          when Array
            value.map { |v| camelize_keys(v, options) }
          when Hash
            Hash[value.map { |k, v| [camel_case_key(k, options), camelize_keys(v, options)] }]
          else
            value
        end
      end

      def camel_case_key(k, options)
        if k.is_a? Symbol
          camelize(k.to_s, options).to_sym
        elsif k.is_a? String
          camelize(k, options)
        else
          k # Awrence can't camelize anything except strings and symbols
        end
      end

      def camelize(snake_word, options)
        word = snake_word.gsub(/(^|_)(.)/) { $2.upcase }
        word = snake_word.chars.first + word[1..-1] unless options[:first_upper]
        word.gsub!(/\/(.?)/) { "::" + $1.upcase } unless options[:ignore_slash]
        word
      end
  end

end
