module Helpers
  module User
    module Achiever
      def self.included(base)
        base.class_eval <<-METHOD
          def awarded? achievement
            !bitstring.is_zero?(achievement.id - 1)
          end

          def award achievement
            if bitstring.is_zero?(achievement.id - 1)
              bitstring.toggle(achievement.id - 1)
              self.achievement_bits = bitstring.string
              self.save
            end
          end

          def achievements
            indices = bitstring.indices.map {|index| index + 1}
            Achievement.where(:id => indices)
          end

          def bitstring
            @bitstring ||= BitString.new achievement_bits
          end
        METHOD
      end
    end
  end

  class BitString
    def initialize str
      self.string = str || ''
    end

    def string= str
      @string = str.dup
    end

    def string
      @string.dup
    end

    def is_zero? index
      char_index = index / 8
      char_offset = index % 8
      if string.length <= char_index
        true
      else
        string[char_index].ord & 0b1 << char_offset == 0
      end
    end

    def toggle index
      char_index = index / 8
      char_offset = index % 8
      if string.length <= char_index
        @string += 0.chr * (char_index - string.length + 1)
      end
      @string[char_index] = (string[char_index].ord ^ 0b1 << char_offset).chr
      @indices = nil
    end

    def indices
      unless @indices
        @indices = []
        byte_index = 0
        string.each_byte do |byte|
          offset = 0
          while byte != 0
            if byte & 0b1 == 1
              @indices << byte_index * 8 + offset
            end
            byte >>= 1
            offset += 1
          end
          byte_index += 1
        end
      end
      @indices
    end
  end
end
