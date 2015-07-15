module GitCompound
  module Logger
    # Colors module
    #
    module Colors
      def self.included(parent_class)
        parent_class.extend ClassMethods
        parent_class.class_eval { create_color_methods }
      end

      def colorize(params)
        return self if colors_unavailable?
        scan_colors.inject('') do |str, match|
          set_colors(match, params)
          str << "\033[#{match[0]};#{match[1]};#{match[2]}m#{match[3]}\033[0m"
        end
      end

      private

      def colors_unavailable?
        self.class.disable_colors || RUBY_VERSION < '2.0.0' || RUBY_PLATFORM =~ /win32/
      end

      def scan_colors
        scan(/\033\[([0-9;]+)m(.+?)\033\[0m|([^\033]+)/m).map do |match|
          colors = (match[0] || '').split(';')
          Array.new(4).tap do |array|
            array[0], array[1], array[2] = colors if colors.length == 3
            array[3] = match[1] || match[2]
          end
        end
      end

      def set_colors(match, params)
        default_colors(match)

        mode = mode(params[:mode])
        color = color(params[:color])
        bgcolor = bgcolor(params[:bgcolor])

        match[0] = mode    if mode
        match[1] = color   if color
        match[2] = bgcolor if bgcolor
      end

      def default_colors(match)
        match[0] ||= mode(:default)
        match[1] ||= color(:default)
        match[2] ||= bgcolor(:default)
      end

      def color(color)
        self.class.colors[color] + 30 if self.class.colors[color]
      end

      def bgcolor(color)
        self.class.colors[color] + 40 if self.class.colors[color]
      end

      def mode(mode)
        self.class.modes[mode] if self.class.modes[mode]
      end
    end

    # Class methods core ext for String
    #
    module ClassMethods
      def disable_colors=(value)
        @disable_colors = value && true
      end

      def disable_colors
        @disable_colors ||= false
      end

      def colors
        {
          black:   0,
          red:     1,
          green:   2,
          yellow:  3,
          blue:    4,
          magenta: 5,
          cyan:    6,
          white:   7,
          default: 9
        }
      end

      def modes
        {
          default: 0,
          bold:    1
        }
      end

      private

      def create_color_methods
        colors.keys.each do |key|
          next if key == :default

          define_method key do
            colorize(color: key)
          end

          define_method "on_#{key}" do
            colorize(bgcolor: key)
          end
        end

        modes.keys.each do |key|
          next if key == :default

          define_method key do
            colorize(mode: key)
          end
        end
      end
    end
  end
end
